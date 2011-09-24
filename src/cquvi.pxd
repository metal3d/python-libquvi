"""
This is the pxd file used to define needed functions/types from
libquvi
"""
__author__="Patrice FERLET <metal3d@gmail.com>"
__license__="LGPLv2.1+."

cdef extern from "quvi/quvi.h":
    
    ctypedef struct quvi_t:
        pass
    
    ctypedef void* quvi_media_t
    ctypedef void* quvi_video_t
    ctypedef void* quvi_ident_t
    ctypedef void* quvi_callback_status
    ctypedef enum QUVIcode:
        QUVI_OK  = 0x00

    ctypedef enum QUVIversion:
        pass
    ctypedef enum QUVIidentProperty:
        pass
    ctypedef enum QUVIproperty:
        QUVIPROP_NONE = 0x00
        QUVIPROP_HOSTID = 0x100000 + 1
        QUVIPROP_PAGEURL = 0x100000 + 2
        QUVIPROP_PAGETITLE = 0x100000 + 3
        QUVIPROP_MEDIAID = 0x100000 + 4
        QUVIPROP_MEDIAURL = 0x100000 + 5
        QUVIPROP_MEDIACONTENTLENGTH = 0x300000 + 6
        QUVIPROP_MEDIACONTENTTYPE = 0x100000 + 7
        QUVIPROP_FILESUFFIX = 0x100000 + 8
        QUVIPROP_RESPONSECODE = 0x200000   + 9
        QUVIPROP_FORMAT = 0x100000 + 10
        QUVIPROP_STARTTIME = 0x100000 + 11
        QUVIPROP_MEDIATHUMBNAILURL = 0x100000 + 12
        QUVIPROP_MEDIADURATION = 0x300000 + 13
        QUVIPROP_VIDEOID = 0x100000 + 4
        QUVIPROP_VIDEOURL = 0x100000 + 5
        QUVIPROP_VIDEOFILELENGTH = 0x300000 + 6
        QUVIPROP_VIDEOFILECONTENTTYPE = 0x100000 + 7
        QUVIPROP_VIDEOFILESUFFIX = 0x100000 + 8
        QUVIPROP_HTTPCODE = 0x200000   + 9
        QUVIPROP_VIDEOFORMAT = 0x100000 + 10
        _QUVIPROP_LAST = 13

    ctypedef enum QUVIoption:
        pass
    ctypedef enum QUVIinfo:
        pass
    ctypedef int quvi_word
    ctypedef int quvi_byte

    QUVIcode quvi_init(quvi_t *quvi)
    QUVIcode quvi_getinfo(quvi_t quvi, QUVIinfo info, ...)
    QUVIcode quvi_setopt(quvi_t quvi, QUVIoption opt, ...)
    size_t quvi_write_callback_default(void *ptr, size_t size, size_t nmemb, void *stream)
    void quvi_close(quvi_t* quvi)
    QUVIcode quvi_parse(quvi_t quvi, char *url, quvi_media_t *media)
    QUVIcode quvi_getprop(quvi_media_t media, QUVIproperty prop, ...)
    QUVIcode quvi_next_media_url(quvi_media_t media)
    QUVIcode quvi_next_videolink(quvi_video_t video)
    void quvi_parse_close(quvi_media_t *media)
    QUVIcode quvi_supported(quvi_t quvi, char *url)
    QUVIcode quvi_supported_ident(quvi_t quvi, char *url, quvi_ident_t *ident)
    QUVIcode quvi_ident_getprop(quvi_ident_t handle, QUVIidentProperty property, ...)
    void quvi_supported_ident_close(quvi_ident_t *ident)
    QUVIcode quvi_next_supported_website(quvi_t quvi, char **domain, char **formats)
    QUVIcode quvi_next_host(char **domain, char **formats)
    char *quvi_strerror(quvi_t quvi, QUVIcode code)
    char *quvi_version(QUVIversion type)
    void quvi_free(void *ptr)
    QUVIcode quvi_query_formats(quvi_t session, char *url, char **formats)

