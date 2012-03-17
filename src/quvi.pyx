"""Quvi is a media url parser supporting several hosts (youtube, dailymotion,
vimeo...)
See http://quvi.sourceforge.net/

You can use this module to parse an url from youtube, dailymotion... like this:
>> import quvi
>> q = Quvi()
>> q.parse("http://....")
>> print q.get_properties()

"""
__author__="Patrice FERLET <metal3d@gmail.com>", "Raphaël VINOT <raphael.vinot@gmail.com>"
__license__="LGPLv2.1+."

cimport cquvi

cdef class Quvi:
    #those handles ctypes from quvi.h
    cdef cquvi.quvi_t _c_quvi
    cdef cquvi.quvi_media_t _c_m

    def __cinit__ (self):
        """Initialize quvi handle"""
        cquvi.quvi_init(&self._c_quvi)
        self._c_m = NULL

    cdef cquvi.QUVIcode _c_parse(self, char* url):
        """Parses given url parameters"""
        rc = cquvi.quvi_parse(self._c_quvi, url, &self._c_m)
        return rc

    cdef cquvi.QUVIcode _c_setopt(self, cquvi.QUVIoption option_id, \
            void* parameter):
        """Set an option"""
        rc = cquvi.quvi_setopt(self._c_quvi, option_id, parameter)
        return rc

    def get_error_message(self, code):
        """Get the error string from the library"""
        return cquvi.quvi_strerror(self._c_quvi, code)

    def get_version(self):
        """Get the version(s), only QUVI_VERSION is known by the C library"""
        version = cquvi.quvi_version(cquvi.QUVI_VERSION)
        return version

    def get_supported_ident_properties(self, char* url):
        """Get a few properties for an URL, does not needs connectivity."""
        cdef char* resc = NULL
        cdef cquvi.quvi_ident_t _c_ident = NULL
        rc = cquvi.quvi_supported_ident(self._c_quvi, url, &_c_ident)

        if rc != cquvi.QUVI_OK:
            cquvi.quvi_supported_ident_close(&_c_ident)
            error = QuviError()
            msg = self.get_error_message(rc)
            error.return_code_error(self.get_response_code.__name__, rc, msg)
            raise error
        else:
            res = {}

            cquvi.quvi_ident_getprop(_c_ident, \
                    cquvi.QUVI_IDENT_PROPERTY_URL, &resc)
            res['url'] = resc

            cquvi.quvi_ident_getprop(_c_ident, \
                    cquvi.QUVI_IDENT_PROPERTY_DOMAIN, &resc)
            res['domain'] = resc

            cquvi.quvi_ident_getprop(_c_ident, \
                    cquvi.QUVI_IDENT_PROPERTY_FORMATS, &resc)
            res['formats'] = resc

            #NOTE: cquvi.QUVI_IDENT_PROPERTY_CATEGORIES does not work,
            #      segfault
            #cquvi.quvi_ident_getprop(self._c_ident, \
            #        cquvi.QUVI_IDENT_PROPERTY_CATEGORIES, &resc)
            #res['categories'] = resc

            cquvi.quvi_supported_ident_close(&_c_ident)

            return res


    def is_supported(self, char* url):
        """Is the URL supported ? True/False/Unknown"""

        rc = cquvi.quvi_supported(self._c_quvi, url)
        if rc == cquvi.QUVI_OK:
            return True
        elif rc == cquvi.QUVI_NOSUPPORT:
            return False
        else:
            error = QuviError()
            msg = self.get_error_message(rc)
            error.return_code_error(self.get_response_code.__name__, rc, msg)
            raise error

    def _get_info(self, info):
        """Get a particular info after trying to fetch properties"""
        cdef long _c_session_info = -1
        rc = cquvi.quvi_getinfo(self._c_quvi, info, &_c_session_info)
        if rc != cquvi.QUVI_OK:
            error = QuviError()
            msg = self.get_error_message(rc)
            error.return_code_error(self.get_response_code.__name__, rc, msg)
            raise error
        else:
            return _c_session_info

    def get_curl_session_handle(self):
        """Get the latest curl session handle"""
        return self._get_info(cquvi.QUVIINFO_CURL)

    def get_response_code(self):
        """Get the latest HTTP response code"""
        return self._get_info(cquvi.QUVIINFO_RESPONSECODE)

    def get_formats(self, char* url):
        """Return an array with the available formats"""
        cdef char *_c_formats = NULL
        rc = cquvi.quvi_query_formats(self._c_quvi, url, &_c_formats)
        if rc != cquvi.QUVI_OK:
            error = QuviError()
            msg = self.get_error_message(rc)
            error.return_code_error(self.get_formats.__name__, rc, msg)
            raise error
        else:
            return _c_formats.split("|")

    def set_format(self, char* c_format):
        """Set a format

        :param c_format: format to use (ex.: fmt45_720p)
        """
        rc = self._c_setopt(cquvi.QUVIOPT_FORMAT, c_format)
        if rc != cquvi.QUVI_OK:
            error = QuviError()
            msg = self.get_error_message(rc)
            error.return_code_error(self.set_format.__name__, rc, msg)
            raise error

    def parse(self, char *url):
        """Parses given url parameters

        :param url: media webpage url (in form http://...)
        """
        rc = self._c_parse(url)
        if rc != cquvi.QUVI_OK:
            error = QuviError()
            msg = self.get_error_message(rc)
            error.return_code_error(self.parse.__name__, rc, msg)
            raise error

    def get_properties(self):
        """Returns a dict with media properties

        returned properties are:
            - hostid
            - pageurl
            - pagetitle
            - mediaid
            - mediaurl
            - mediacontentlength
            - mediacontenttype
            - filesuffix
            - responsecode
            - format
            - starttime
            - mediathumbnail
            - mediaduration

        """
        res = {}
        cdef char* resc = NULL
        cdef int   resi = -1
        cdef long resl = -1
        cdef double resd = -1

        if self._c_m is NULL:
            error = QuviError()
            error.custom_error("Parse an url before trying to get the properties")
            raise error

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_HOSTID, &resc)
        res['hostid'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_PAGEURL, &resc)
        res['pageurl'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_PAGETITLE, &resc)
        res['pagetitle'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_MEDIAID, &resc)
        res['mediaid'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_MEDIAURL, &resc)
        res['mediaurl'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_MEDIACONTENTLENGTH, &resl)
        res['mediacontentlength'] = resl;

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_MEDIACONTENTTYPE, &resc)
        res['mediacontenttype'] = resc;

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_FILESUFFIX, &resc)
        res['filesuffix'] = resc;

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_RESPONSECODE, &resl)
        res['responsecode'] = resl

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_FORMAT, &resc)
        res['format'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_STARTTIME, &resc)
        res['starttime'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_MEDIATHUMBNAILURL, &resc)
        res['mediathumbnail'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_MEDIADURATION, &resd)
        res['mediaduration'] = resd

        return res

    def nextmediaurl(self):
        """Jumps to next media

        :returns Boolean True if other media is found, False either
        Raise an exception on error"""

        rc = cquvi.quvi_next_media_url(self._c_m)

        if rc == cquvi.QUVI_LAST:
            return False

        if rc != cquvi.QUVI_OK:
            error = QuviError()
            msg = self.get_error_message(rc)
            error.return_code_error(self.nextmediaurl.__name__, rc, msg)
            raise error

        return True

    def __del__(self):
        """Cleanup media handles"""
        cquvi.quvi_parse_close(&self._c_m);
        cquvi.quvi_close(&self._c_quvi)
        cquvi.quvi_free(&self._c_quvi)

def get_properties_best_quality(url):
    """Get the properties of the best available format of a video"""
    q = Quvi()
    if q.is_supported(url):
        formats = q.get_formats(url)
        best_format = formats[-1]
        q.set_format(best_format)
        q.parse(url)
        properties = q.get_properties()
        return properties
    return None

class QuviError(Exception):
    """Exception to raise on QuviErrors"""
    def __init__(self):
        self.error_msg = ""

    def custom_error(self, msg):
        """Set a custom error message"""
        self.error_msg = "An error occurred: " + msg

    def return_code_error(self, function_name, value, msg):
        """Set an error message defined by the C library"""
        self.error_msg = "An error occurred in function \"{fct}\": {detail} ({code})"\
                .format(fct = function_name, detail = msg, code = value)

    def __str__(self):
        return repr(self.error_msg)
