cdef extern tuple unpack_from(char *format, char *buf, int offset)
cdef extern bytes pack(char *format, object val)
