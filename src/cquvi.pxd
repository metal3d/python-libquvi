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
    ctypedef enum QUVIversion:
        QUVI_VERSION

    ctypedef enum QUVIcode:
        QUVI_OK  = 0x00
        QUVI_MEM
        QUVI_BADHANDLE
        QUVI_INVARG
        QUVI_CURLINIT
        QUVI_LAST
        QUVI_ABORTEDBYCALLBACK
        QUVI_LUAINIT
        QUVI_NOLUAWEBSITE
        QUVI_NOLUAUTIL
        _INTERNAL_QUVI_LAST

        QUVI_NOSUPPORT
        QUVI_CALLBACK
        QUVI_ICONV
        QUVI_LUA

    ctypedef enum QUVIstatus:
        QUVISTATUS_FETCH
        QUVISTATUS_VERIFY
        QUVISTATUS_RESOLVE

    ctypedef enum QUVIstatusType:
        QUVISTATUSTYPE_PAGE
        QUVISTATUSTYPE_CONFIG
        QUVISTATUSTYPE_PLAYLIST
        QUVISTATUSTYPE_DONE

    ctypedef enum QUVIoption:
        QUVIOPT_FORMAT
        QUVIOPT_NOVERIFY
        QUVIOPT_STATUSFUNCTION
        QUVIOPT_NORESOLVE
        QUVIOPT_CATEGORY
        QUVIOPT_FETCHFUNCTION
        QUVIOPT_RESOLVEFUNCTION
        QUVIOPT_VERIFYFUNCTION

    ctypedef enum QUVIcategory:
        QUVIPROTO_HTTP
        QUVIPROTO_MMS
        QUVIPROTO_RTSP
        QUVIPROTO_RTMP
        QUVIPROTO_ALL

    ctypedef enum QUVIinfo:
        QUVIINFO_NONE
        QUVIINFO_CURL
        QUVIINFO_RESPONSECODE

    ctypedef enum QUVIproperty:
        QUVIPROP_NONE
        QUVIPROP_HOSTID
        QUVIPROP_PAGEURL
        QUVIPROP_PAGETITLE
        QUVIPROP_MEDIAID
        QUVIPROP_MEDIAURL
        QUVIPROP_MEDIACONTENTLENGTH
        QUVIPROP_MEDIACONTENTTYPE
        QUVIPROP_FILESUFFIX
        QUVIPROP_RESPONSECODE
        QUVIPROP_FORMAT
        QUVIPROP_STARTTIME
        QUVIPROP_MEDIATHUMBNAILURL
        QUVIPROP_MEDIADURATION
        _QUVIPROP_LAST

    ctypedef enum QUVIidentProperty:
        QUVI_IDENT_PROPERTY_URL
        QUVI_IDENT_PROPERTY_DOMAIN
        QUVI_IDENT_PROPERTY_FORMATS

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

