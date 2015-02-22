Vector3 :: struct {
    x : float = 1;
    y : float = 4;
    z : float = 9;
}

print_position_test :: () {

    Entity :: struct {
        position: Vector3;
    }

    print_position_a :: (entity : ^Entity) {
        printf("print_position_a: (%f, %f, %f)\n", entity.position.x, entity.position.y entity.position.z);
    }

    print_position_b :: (entity : ^Entity) {
        using entity;
        printf("print_position_a: (%f, %f, %f)\n", position.x, position.y position.z);
    }

    print_position_c :: (using entity : ^Entity) {
        printf("print_position_a: (%f, %f, %f)\n", position.x, position.y position.z);
    }

    print_position_b :: (entity : ^Entity) {
        using entity.position;
        printf("print_position_a: (%f, %f, %f)\n", x, y, z);
    }

    e : Entity;

    print_position_a(^e);
    print_position_b(^e);
    print_position_c(^e);
    print_position_d(^e);

    printf("\n");
}

// Sort of like having a 'this pointer' in C++,
// but fits more naturally info a UFCS-style syntax.


// A simple relationship: Door is an Entity.
// This is the C way, where you explicitly say entity.position.x.

door_test_1 :: () {
    Entity :: struct {
        position: Vector3;
    }

    Door :: struct {
        entity : Entity;

        openness_current : float = 0;
        openness_target : float = 0;
    }

    door : Door;

    printf("door_test_1: door.entity.position is (%f, %f, %f)\n",
           door.entity.position.x, door.entity.position.y, door.entity.position.z);
}

// Like the previous example,
// but we designate the entity with 'using',
// so we no longer need to explicitly access that sub-field:
door_test_2 :: () {
    Entity :: struct {
        position: Vector3;
    }

    Door :: struct {
        using entity : Entity;  // 'entity' is both named *and* anonymous.

        openness_current : float = 0;
        openness_target : float = 0;
    }

    door : Door;

    printf("door_test_2: door.entity.position is (%f, %f, %f)\n",
           door.position.x, door.position.y, door.position.z);


    // We can also implicitly cast from Door to Entity, like you would
    // get with C++ subclassing:

    print_position :: (using entity : Entity) {
        printf("door_test_2: door.entity.position is (%f, %f, %f)\n", position.x, position.y, position.z);
    }

    print_position(door.entity);
    print_position(door);

    // This kind of 'using' is like an anonymous struct in C,
    // but it can also be non-anonymous, because it is named!
    // (For example, when passing door.entity above).

    // Anonymous:
    printf("door.position.x is %f\n", door.position.x);

    // Non-anonymous:
    printf("door.entity.position.x is %f\n", door.entity.position.x);

    e : ^Entity = ^door.entity;   // Can easily take a pointer to this anonymous struct.
    printf("e.position.x is %f\n", e.position.x);
}



// Now instead of 'using' an entity by value, we do it by pointer!
door_test_3 :: () {
    Entity :: struct {
        position: Vector3;
    }

    Door :: struct {
        using entity : ^ Entity;

        openness_current : float = 0;
        openness_target : float = 0;
    }

    door : Door;
    door.entity = new Entity;

    printf("door_test_3: door.entity.position is (%f, %f, %f)\n",
           door.position.x, door.position.y, door.position.z);

    //
    // Implicit case also works in the pointer case:
    //

    print_position :: (using entity : Entity) {
        printf("door_test_2: door.entity.position is (%f, %f, %f)\n", position.x, position.y, position.z);
    }

    print_position(door.entity);
    print_position(^door);
}


// Now that we can 'subclass' from something elsewhere in memory,
// we can store Entities in an efficient manner.
door_test_4 :: () {
    Entity :: struct {
        position: Vector3;
    }

    Door :: struct {
        using entity : ^ Entity;

        openness_current : float = 0;
        openness_target : float = 0;
    }



    MAX_ENTITIES :: 100;
    num_entities : int = 0;

    entities : [MAX_ENTITIES] Entity;

    get_next_entity :: (entities : [] Entity, num_entities : ^ int) -> ^ Entity {
        result := ^entities[*num_entities];
        *num_entities += 1;
        return result;
    }


    door : Door;
    door.entity = get_next_entity(entities, ^num_entities);

    printf("door_test_4: door.entity.position is (%f, %f, %f)\n", door.position.x, door.position.y, door.position.z);
}



/*

Why do this 'using' stuff just for convenient names?
Is it really so bad just to say door.entity.position everywhere?
(C programmers would say it isn't).

But 'using' gives us flexibility with names that means we
can reformat our data without rewriting our code.


In reality, an Entity is going to be more complicated:

    Entity :: struct {
        position: Vector3;
        orientation: Quaternion;
        scale: float = 1;

        flags : u32;

        id : int;
        label : ^ u8;
        group : ^ Group;

        bounding_radius : float;
        bounding_center : Vector3;

        mesh : ^ Mesh;

        mount_parent_id : int
        mount_position : Vector3;
        mount_orientation : Quaternion;
        mount_scale : float;
        mount_bone_index : int;

        runtime_only_flags : u32;
        lod_distance : float;
    }

(The Entity in The Witness has more stuff than this, and
The Witness is simpler than a AAA game.)

Some of this you want to be able to visit in tight loops
and do stuff. (Check all entities that have a certain flag
set, or do something to every entity's position, etc).

We *could* break this into multiple structs and 'inherit'
from both, and store one in a hot array and one in a cold
array.

    Entity_Hot :: struct {
        position: Vector3;
        orientation: Quaternion;
        scale: float = 1;
        flags : u32;
    };

    Entity_Cold :: struct {
        label : ^ u8;
        group : ^ Group;

        mount_parent_id : int
        mount_position : Vector3;
        mount_orientation : Quaternion;
        mount_scale : float;
        mount_bone_index : int;
        ...
    };

    Entity :: struct {
        using hot  : ^ Entity_Hot;
        using cold : ^ Entity_Cold;
    };

    Door :: struct {
        using entity : Entity;  // By value, so we don't jump through an extra pointer here.

        float openness_current;
    };

Now we can change our mind during development about what is 'hot'
and what is 'cold', without having to rewrite the code that uses
those members.

*/
