"""Quvi is a media url parser from several hosts (youtube, dailymotion,
vimeo...)
See http://quvi.sourceforge.net/

You can use the class to parse an url from youtube, dailymotion... like this:
>> import quvi
>> q = quvi.Quvi()
>> q.parse("http://....")
>> print q.getproperties()

"""
__author__="Patrice FERLET <metal3d@gmail.com>"
__license__="LGPLv2.1+."
__version__ = "$Revision: 00f8e3bb1197 $"
# $Source$

cimport cquvi

cdef class Quvi:
    """Main class that parse media url
    """
    #those handles ctypes from quvi.h
    cdef cquvi.quvi_t _c_quvi
    cdef cquvi.quvi_media_t _c_m


    def __cinit__ (self):
        """Initialize quvi handles"""
        cquvi.quvi_init(&self._c_quvi)

    def parse(self, url):
        """Parse given url parameters"""
        cdef char* _url = url
        rc = cquvi.quvi_parse(self._c_quvi, _url, &self._c_m);
        if rc != cquvi.QUVI_OK:
            raise "Exception occured, next media error"

    def getproperties(self):
        """Return a dict with title and media url"""
        cdef char* media_title
        cdef char* media_url
        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_PAGETITLE, &media_title)
        cquvi.quvi_getprop(self._c_m, cquvi.QUVIPROP_MEDIAURL, &media_url)
        t= media_title
        u= media_url
        return {
            'url': u,
            'title': t
            }
        
    def next(self):
        """Jumps to next media"""
        rc = cquvi.quvi_next_media_url(&self._c_m)
        if rc != cquvi.QUVI_OK:
            return False

        return True
        
    def __del__(self):
        """Cleanup media handles"""
        cquvi.quvi_parse_close(&self._c_m);
        cquvi.quvi_close(&self._c_quvi)
        cquvi.quvi_free(&self._c_quvi)

