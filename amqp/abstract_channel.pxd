import cython
from .basic_message cimport Message
from .serialization cimport loads, dumps

cdef object AMQP_LOGGER
cdef object IGNORED_METHOD_DURING_CHANNEL_CLOSE

cdef class AbstractChannel():
    cdef public bint is_closing
    cdef public object connection
    cdef readonly object channel_id
    cdef public bint auto_decode
    cdef dict _pending
    cdef public dict _callbacks

    cpdef dispatch_method(self, method_sig, payload, Message content)
