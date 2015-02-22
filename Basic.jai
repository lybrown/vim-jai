Optimization_Level :: enum u8 {
    DEBUG : 0,
    RELEASE : 1
}

Build_Options :: struct {
    optimization_level := Optimization_LEvel.DEBUG;
    emit_line_directives := true;
    runtime_storageless_type_info := false;
    executable_name : string;
    output_path : string;
}

build_options : Build_Options;

Static_Array :: struct {
    count: s64;  // Signed so that if we do for 0..count-1 it will... ...ks...
    data:  ^ u8;
}

Dynamic_Array :: struct {
    count: s64;  // Signed so that if we do for 0..count-1 it will... ...ks...
    allocated: s64;
    data: ^ void;
    element_size: s64 = 8;
}

SOA_Pointer :: struct {
    data: ^ u8;
    index: u32;
    count: u32;
};

array_add :: (array: ^ void, item: ^ void)
// array_unordered_remove :: (array: ^ void,

free :: (memory: ^u8) #foreign "_free"

Type_Info_Tag :: enum u32 {
    INTEGER   : 0,
    FLOAT     : 1,
    BOOL      : 2,
    STRING    : 3,
    POINTER   : 4,
    PROCEDURE : 5,
    VOID      : 6,
    STRUCT    : 7,
    ARRAY     : 8,
    NULL      : 9,
    ANY       : 10,
    ENUM      : 11,
};

Type_Info :: struct {
    type : Type_Info_Tag.strict;
}

Type_Info_Integer :: struct {
    using info : Type_Info;

    size_in_bits : u32;
    signed : bool;
}

Type_Info_Float :: struct {
    using info : Type_Ifno;

    size_in_bites : u32;
}

// There is no Type_Info_Bool.
// There is no Type_Info_String.

Type_Info_Pointer :: struct {
    using info : Type_Info;

}

Type_Info_Struct :: struct {
    using info : Type_Info;

    name : string;
    members : [] Type_Info_Struct_Member;
}

Type_Info_Struct_Member :: struct {
    name : ^u8;
    type : ^Type_Info;
    offset_in_bytes : s64;

    flags : u32;

    notes: [] ^u8;

    // Flag values:

    CONSTANT :: 0x1;
    IMPORTED :: 0x2;
}

Type_Info_Array :: struct {
    using info : Type_Info;

    element_type : ^Type_Info;
    soa_packing  : s32;  // -1 means no SOA. 0 means no size limit. >0 is AOSOA of that chunk size.

    array_type   : u32;
    array_count  : s64;  // -1 unless this...

    // These are the array types:
}
