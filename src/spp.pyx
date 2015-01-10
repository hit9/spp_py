# coding=utf8

cdef extern from 'hbuf.h':
    ctypedef struct hbuf_t:
        size_t size

cdef extern from 'spp.h':

    ctypedef enum spp_error_t:
        SPP_OK = 0
        SPP_ENOMEM = -1
        SPP_EBADFMT = -2
        SPP_EUNFINISH = -3

    ctypedef struct spp_t:
        hbuf_t *buf
        void *priv
        void (*handler)(spp_t *, char *, size_t, int)

    spp_t *spp_new()
    int spp_feed(spp_t *, char *)
    void *spp_free(spp_t *)
    int spp_parse(spp_t *)
    void spp_clear(spp_t *)


class SPPException(Exception):
    pass


class NoMemoryError(SPPException):
    pass


class BadFormatError(SPPException):
    pass


cdef void handler(spp_t *parser, char *data, size_t size, int index):
    values = <object>(parser[0].priv)
    cdef bytes py_string = data[:size]
    values.append(py_string)


cdef class Parser:

    cdef spp_t *parser
    cdef public object values

    def __init__(self):
        cdef spp_t *parser = spp_new()
        self.parser = parser
        self.values = []
        self.parser[0].priv = <void *>(self.values)
        self.parser[0].handler = &handler

    def feed(self, text):
        cdef bytes btext

        if hasattr(text, 'encode'):
            btext = text.encode('utf8', 'strict')
        else:
            btext = text  # assumed utf8 string

        cdef char *data = btext
        cdef int res = spp_feed(self.parser, data)

        if res == SPP_OK:
            return <object>(self.parser[0].buf[0].size)
        raise NoMemoryError

    def get(self):
        self.values[:] = []
        cdef int res = spp_parse(self.parser)

        if res == SPP_OK:
            return self.values
        elif res == SPP_EBADFMT:
            raise BadFormatError
        return None

    def clear(self):
        spp_clear(self.parser)
        return <object>(self.parser[0].buf[0].size)

    def __dealloc__(self):
        cdef spp_t *parser = self.parser
        spp_free(parser)
