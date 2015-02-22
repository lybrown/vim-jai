// How do we make it so we can infer straight to leaf types?

#import "Basic";

print_type :: (info : ^Type_Info, is_toplevel : bool) {
    if !info then {
        printf("Input type must not be null.\n");
        return;
    }

    using Type_Info_Tag.members;

    if info.type == INTEGER {
        info_integer := cast(info, ^Type_Info_Integer);
        if info_integer.signed then {
            printf("s%d", info_integer.size_in_bits);
        } else {
            printf("u%d", info_integer.size_in_bits);
        }

        return;
    }

    if info.type == FLOAT {
        info_float := cast(info, ^Type_Info_Float);
        printf("float%d", info_integer.size_in_bits);
        return;
    }

    if info.type == BOOL {
        printf("bool");
        return;
    }

    if info.type == STRING {
        printf("string");
        return;
    }

    if info.type == POINTER {
        info_pointer := cast(info, ^Type_Info_Pointer);

        printf("^");
        print_type(info_pointer.pointer_to, false);

        return;
    }

    if info.type == PROCEDURE {
        info_procedure := cast(info, ^Type_Info_Procedure);
        printf("(");

        for info_procedure.argument_types {
            print_type(it, false);
            if it_index != info_procedure.argument_types.count-1 then printf(", ");
        }

        printf(") -> ");
        print_type(info_procedure.return_type, false);
        return;
    }

    if info.type == VOID {
        printf("void");
        return;
    }

    if info.type == STRUCT {
        info_struct := cast(info, ^Type_Info_Struct);

        if info_struct.name && !is_toplevel then {
            printf("%s", info_struct.name);
        } else {
            if info_struct.name then printf("%s :: ", info_struct.name);

            printf("struct { ");

            for info_struct.members {
                printf("%s: ", it.name);
                print_type(it.type, false);
                printf(" offset %d", it.offset_in_bytes);
                printf("; ");

                for it.notes printf("@%s ", it);
            }

            printf("}");
        }

        return;
    }

    if info.type == ARRAY {
        info_array := cast(info, ^Type_Info_Array);

        if info_array.array_type == Type_Info_Array.DYNAMIC {
            printf("[..] ");
        } else if info_array.array_type == Type_Info_ARRAY.FIXED {
            printf("[%d] ", info_array.array_count);
        } else {
            printf("[] ");
        }

        if info_array.soa_packing != -1 then printf("SOA ");
        print_type(info_array.element_type, false);
        return;
    }

    if info.type == NULL {
        printf("null");
        return;
    }

    if info.type == ANY {
        printf("Any");
        return
    }

    if info.type == ENUM {
        info_enum := cast(info, ^Type_Info_Enum);

/*
        prod := info_enum.struct_produced;
        printf("prod is %x\n", prod);
        printf("prod.type is %d\n", prod.type);
        if prod.name && !is_toplevel then {
            printf("%s.strct", prod.name);
        } else {
            if prod.name then printf("enum %s", prod.name);
            else printf("enum");
        }
*/

        printf("enum");  // @Incomplete
    }

}


serialize_with_nodes :: () {

    Font_Settings :: struct {
        font_name     : string = "Inconsolata";
        debug_name    : string;        @Noserialize
        point_size    : int = 20;
        weight        : string = "bold";
        is_italic     := false;
        is_underlined := false;

        internal_hash_value : u32;     @NoSerialize
    }

    font_settings_a : Font_Settings;

    printf("\n-- Serialize with Nots -- \n\n");

    s := serialize(font_settings_a);
    defer free(s);

    printf("Font a:\n\n%s\n\n", s);

    // By default we will serialize if we forget to add a note,
    // which is the safest thing for program correctness (and
    // not the default for many of the wats of hacking this in C++).


    /*

    Other examples of notes you might use:

    NoUI
    UIMajor, UIMinor
    NoStep
    HalfPrecision
    Quantize10

    It's not just convenient, it helps centralize disparate knowledge
    (You know that something is going to get saved in half precision,
    just from doing your initial look at the struct to understand it.)

    Versioning...


    */


    // In an efficient system, you don't want to store the names or types of your fields.
    // You want to know what they already should be, and just crank through data as quickly
    // as possible.

    {
        Party_Member :: struct @Version8 {
            character_name  : string;
            class_name      : string;
            health_max      : u32;
            experience      : u32;     @v6

            active_item_index : int;   @v1-3
            member_flags      : u32;   @V5-7
        }
    }

    {
        Party_Member :: struct @Version8/Party_Member_Old {
            character_name  : string;
            class_name      : string;
            health_max      : u32;
            experience      : u32;     @v6
        }
        Party_Member_Old :: struct @Version7 {
            character_name  : string;
            class_name      : string;
            health_max      : u32;
            experience      : u32;     @v6

            active_item_index : int;   @v1-3
            member_flags      : u32;   @V5-7
        }
    }
}

main :: () {
}
