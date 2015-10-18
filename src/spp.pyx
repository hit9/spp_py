# coding=utf8

import sys

if sys.version > '3':
    # binary: cast str to bytes
    binary = lambda string: bytes(string, 'utf8')
    # string: cast bytes to native string
    string = lambda binary: binary.decode('utf8')
else:
    binary = str
    string = str

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
    int spp_feed(spp_t *, char *, size_t)
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
    cdef bytes value = data[:size]
    values.append(string(value))


cdef class Parser:

    cdef spp_t *parser

    def __init__(self):
        cdef spp_t *parser = spp_new()
        self.parser = parser
        self.parser[0].handler = &handler

    def feed(self, string):
        cdef bytes value = binary(string)
        cdef char *data = value
        cdef size_t size = len(value)
        cdef int res = spp_feed(self.parser, data, size)

        if res == SPP_OK:
            return <object>(self.parser[0].buf[0].size)
        raise NoMemoryError

    def get(self):
        values = []
        self.parser[0].priv = <void *>(values)
        cdef int res = spp_parse(self.parser)

        if res == SPP_OK:
            return values
        elif res == SPP_EBADFMT:
            raise BadFormatError
        return None

    def clear(self):
        spp_clear(self.parser)
        return <object>(self.parser[0].buf[0].size)

    def __dealloc__(self):
        cdef spp_t *parser = self.parser
        spp_free(parser)
