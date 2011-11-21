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

cdef class Quvi:
    #those handles ctypes from quvi.h
    cdef cquvi.quvi_t _c_quvi
    cdef cquvi.quvi_media_t _c_m

    def __cinit__ (self):
        """Initialize quvi handle"""
        cquvi.quvi_init(&self._c_quvi)

    cdef cquvi.QUVIcode _c_parse(self, char* url):
        """Parses given url parameters"""
        rc = cquvi.quvi_parse(self._c_quvi, url, &self._c_m);
        return rc

    def parse(self, char *url):
        """Parses given url parameters

        :param url: media webpage url (in form http://...)
        """
        rc = self._c_parse(url)
        if rc != cquvi.QUVI_OK:
            raise QuviError("Exception occured, next media error with code %d" % rc)

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
            - videoid
            - videourl
            - videofilelength
            - videofilesuffix
            - videoformat
            - httpcode

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

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_MEDIAID, &resc) 
        res['videoid'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_MEDIAURL, &resc) 
        res['videourl'] = resc

        #cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_FILELENGTH, &resd) 
        #res['videofilelength'] = resd

        #cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_FILECONTENTTYPE, &resc) 
        #res['videfilecontenttype'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_FILESUFFIX, &resc) 
        res['videofilesuffix'] = resc

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_RESPONSECODE, &resl) 
        res['httpcode'] = resl

        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_FORMAT, &resc) 
        res['videoformat'] = resc

        return res

    def nextmediaurl(self):
        """Jumps to next media

        :returns Boolean True if other media is found, False either
        Raise an exception on error"""

        rc = cquvi.quvi_next_media_url(self._c_m)

        if rc == cquvi.QUVI_LAST:
            return False

        if rc != cquvi.QUVI_OK:
            raise QuviError("Error occured while fetching next media url with code %d" % rc)

        return True

    def __del__(self):
        """Cleanup media handles"""
        cquvi.quvi_parse_close(&self._c_m);
        cquvi.quvi_close(&self._c_quvi)
        cquvi.quvi_free(&self._c_quvi)


class QuviError(Exception):
    """Exception to rais on QuviErrors"""
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)
