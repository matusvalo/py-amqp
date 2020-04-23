import cython

cdef object SIGNED_INT_MAX
cdef bytes EMPTY_BUFFER

cdef class _AbstractTransport():
    cdef bint connected
    cdef object sock
    cdef bytes _read_buffer

    cpdef bytes _read(self, n, initial=*)

cdef class SSLTransport(_AbstractTransport):
    cdef object _quick_recv

    @cython.locals(result=bytes, s=bytes)
    cpdef bytes _read(self, n, initial=*)

cdef class TCPTransport(_AbstractTransport):
    cdef object _quick_recv

    @cython.locals(result=bytes, s=bytes)
    cpdef bytes _read(self, n, initial=*)

