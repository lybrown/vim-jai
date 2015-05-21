// Recalled from memory of 2015-03-09 Twitch Demo.

foo :: (a : string = "hello", b : int = 1) -> z : int = 1 {
    if b == 1 return; // Returns 1?
    return 5;
}

z = foo();
z = foo("goodbye");
z = foo(b = 42);
z = foo("unamed", b = 99);
z = foo(b = 99, a = "outoforder");
// z = foo("unamed here", b = 7, a = "named dupe here"); // issues helpful error msg


baz :: (a : int = 1, b : int = 2) -> (c : int = 3, d : int = 4) {
    return d = 5; // returns 3, 5
}

x, y := baz();

qux :: (a : int = 1, b : string = "foo", v : ..) -> string {
    if type_info(v[0]) == string.type_info {
        printf("String: %s", v[0]);
    }
    return "success";
}

qux(a = 34, b = 56, v = "hello", 1, 4.4); // varargs separated with commas
qux(b = 56, v = "hello", 1, 4.4, a = 34); // named arguments can come after varargs

// Something about spreading...?

Vector3 :: struct {
    x, y, z : float;
}

get :: (a := 1, b := 2) -> (a : ^Vector3 #must, b : ^Vector3 #must, count : int) {
    a : ^Vector3 = new Vector3;
    a.x, a.y, a.z = 1; // Applies = 1 to each thing on LHS
    a.x, a.y, a.z += 1; // Applies += 1 to each thing on LHS

    b : ^Vector3 = new Vector3;
    *b = *a;

    return a, b, 2;
}

// get(); // Error since #must arguments not captured
// a = get(); // Still an error

a, b := get(); // OK
a, b, c = get(); // OK

// Answers to questions:

// Cannot use multiple assigment for swapping:

s, t := 17, 29;

s, t = t, s;

// Expands to either:
//   s = t;
//   t = s;
// Or:
//   t = s;
//   s = t;
// Neither of which will swap values

// Default arguments must be constant. No computation, (math, allocation, etc.)
// allowed.

// foo :: () -> a : int = globalcount + 1 {} // Illegal
// foo :: () -> a := new int {} // Illegal
