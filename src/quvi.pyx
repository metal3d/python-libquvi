"""Quvi is a media url parser supporting several hosts (youtube, dailymotion,
vimeo...)
See http://quvi.sourceforge.net/

You can use this module to parse an url from youtube, dailymotion... like this:
>> import quvi
>> q = Quvi()
>> q.parse("http://....")
>> print q.getproperties()

"""
__author__="Patrice FERLET <metal3d@gmail.com>"
__license__="LGPLv2.1+."

cimport cquvi



return_codes = {\
        cquvi.QUVI_MEM : "Memory allocation error",
        cquvi.QUVI_BADHANDLE : "Bad handle",
        cquvi.QUVI_INVARG: "Invalid function argument",
        cquvi.QUVI_CURLINIT: "libcurl initialization failure",
        cquvi.QUVI_LAST : "Last element in list",
        cquvi.QUVI_ABORTEDBYCALLBACK : "Aborted by callback function",
        cquvi.QUVI_LUAINIT : "liblua initialization failure",
        cquvi.QUVI_NOLUAWEBSITE : "Failed to find any webscripts",
        cquvi.QUVI_NOLUAUTIL : "Failed to find the utility scripts",
        cquvi.QUVI_NOSUPPORT : "libquvi cannot handle the URL",
        cquvi.QUVI_CALLBACK : "Network callback error occurred",
        cquvi.QUVI_ICONV : "libiconv error occurred",
        cquvi.QUVI_LUA : "liblua (or webscript) error occurred"
        }

cdef class Quvi:
    #those handles ctypes from quvi.h
    cdef cquvi.quvi_t _c_quvi
    cdef cquvi.quvi_media_t _c_m
    cdef char *_c_formats

    def __cinit__ (self):
        """Initialize quvi handle"""
        cquvi.quvi_init(&self._c_quvi)

    cdef cquvi.QUVIcode _c_parse(self, char* url):
        """Parses given url parameters"""
        rc = cquvi.quvi_parse(self._c_quvi, url, &self._c_m)
        return rc

    cdef cquvi.QUVIcode _c_query_formats(self, char* url):
        """Get the available formats for the URL"""
        rc = cquvi.quvi_query_formats(self._c_quvi, url, &self._c_formats)
        return rc

    cdef cquvi.QUVIcode _c_setopt(self, cquvi.QUVIoption option_id, \
            void* parameter):
        """Set an option"""
        rc = cquvi.quvi_setopt(self._c_quvi, option_id, parameter)
        return rc

    def query_formats(self, char* url):
        """Query the server to get all the formats availables.

        :param url: media webpage url (in form http://...)
        """
        rc = self._c_query_formats(url)
        if rc != cquvi.QUVI_OK:
            raise QuviError(self.query_formats.__name__, rc)

    def get_formats(self):
        """Return an array with the available formats"""
        return self._c_formats.split("|")

    def set_format(self, char* c_format):
        """Set a format

        :param c_format: format to use (ex.: fmt45_720p)
        """
        rc = self._c_setopt(cquvi.QUVIOPT_FORMAT, c_format)
        if rc != cquvi.QUVI_OK:
            raise QuviError(self.set_format.__name__, rc)

    def parse(self, char *url):
        """Parses given url parameters

        :param url: media webpage url (in form http://...)
        """
        rc = self._c_parse(url)
        if rc != cquvi.QUVI_OK:
            raise QuviError(self.parse.__name__, rc)

    def getproperties(self):
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
        cdef char* resc
        cdef int   resi
        cdef long resl
        cdef double resd


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
            raise QuviError(self.nextmediaurl.__name__, rc)

        return True

    def __del__(self):
        """Cleanup media handles"""
        cquvi.quvi_parse_close(&self._c_m);
        cquvi.quvi_close(&self._c_quvi)
        cquvi.quvi_free(&self._c_quvi)


class QuviError(Exception):
    """Exception to raise on QuviErrors"""
    def __init__(self, function_name, value):
        self.function_name = function_name
        self.value = value

    def detailed_error(self):
        return "An error occurred in function \"{fct}\": {detail} ({code})"\
                .format(fct = self.function_name, detail = \
                    return_codes[self.value], code = self.value)

    def __str__(self):
        return repr(self.detailed_error())
