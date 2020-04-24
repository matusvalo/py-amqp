import cython

cdef object SIGNED_INT_MAX
cdef bytes EMPTY_BUFFER

cdef class _AbstractTransport():
    cdef bint connected
    cdef object sock
    cdef object raise_on_initial_eintr
    cdef bytes _read_buffer
    cdef object host
    cdef object port
    cdef object connect_timeout
    cdef object read_timeout
    cdef object write_timeout
    cdef object socket_settings

    cpdef bytes _read(self, n, initial=*)

cdef class SSLTransport(_AbstractTransport):
    cdef object _quick_recv
    cdef public object sslopts

    @cython.locals(result=bytes, s=bytes)
    cpdef bytes _read(self, n, initial=*)

cdef class TCPTransport(_AbstractTransport):
    cdef object _quick_recv
    cdef public object _write

    @cython.locals(result=bytes, s=bytes)
    cpdef bytes _read(self, n, initial=*)
