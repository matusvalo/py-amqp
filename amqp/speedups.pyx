from libc.stdint cimport uint64_t, int64_t,uint32_t, int32_t, uint16_t, int16_t
from libc.string cimport memcpy, strcmp

# https://stackoverflow.com/questions/4878781/signed-integer-network-and-host-conversion
# https://stackoverflow.com/questions/18276527/byte-order-conversion-for-signed-integer

cdef extern from "<endian.h>":
    uint16_t be16toh(uint16_t host_16bits)
    uint32_t be32toh(uint32_t host_32bits)
    uint64_t be64toh(uint64_t host_64bits)

    uint16_t htobe16(uint16_t host_16bits);
    uint32_t htobe32(uint32_t host_32bits);
    uint64_t htobe64(uint64_t host_64bits);

cdef inline float ReverseFloat( const float inFloat ):
    # https://stackoverflow.com/questions/2782725/converting-float-values-from-big-endian-to-little-endian
    cdef float retVal;
    cdef char *floatToConvert = < char* > & inFloat;
    cdef char *returnFloat = < char* > & retVal;
    
    # swap the bytes into a temporary buffer
    returnFloat[0] = floatToConvert[3];
    returnFloat[1] = floatToConvert[2];
    returnFloat[2] = floatToConvert[1];
    returnFloat[3] = floatToConvert[0];
    
    return retVal;


cdef union UnpackedVals:
    uint64_t uint64
    int64_t int64
    uint32_t uint32
    int32_t int32
    uint16_t uint16
    int16_t int16
    float float

cdef tuple unpack_from(char *format, char *buf, int offset):
    cdef UnpackedVals ret
    assert format[0] == b'>'
    if strcmp(format, b'>I') == 0:
        # uint32
        memcpy(&ret.uint32, buf + offset, 4)
        return (be32toh(ret.uint32),)
    elif format[1] == b'i':
        # int32
        memcpy(&ret.int32, buf + offset, 4)
        return (<int32_t> be32toh(<uint32_t> ret.int32),)
    elif format[1] == b'B':
        # uchar
        return (<unsigned char> buf[offset],)
    elif format[1] == b'b':
        # char
        return (<char> buf[offset],)
    elif format[1] == b'H':
        # uint16
        memcpy(&ret.uint16, buf + offset, 2)
        return (be16toh(ret.uint16),)
    elif format[1] == b'h':
        # int16
        memcpy(&ret.int16, buf + offset, 2)
        return (<int16_t> be16toh(<uint16_t> ret.int16),)
    elif format[1] == b'Q':
        # uint64
        memcpy(&ret.uint64, buf + offset, 8)
        return (be64toh(<uint64_t> ret.uint64),)
    elif format[1] == b'q':
        # int64
        memcpy(&ret.int64, buf + offset, 8)
        return (<int64_t> be64toh(<uint64_t> ret.int64),)
    elif format[1] == b'f':
        # float
        # FIXME
        memcpy(&ret.float, buf + offset, 4)
        return (ReverseFloat(ret.float),)

def py_unpack(format, buf, offset):
    return unpack_from(format, buf, offset)
