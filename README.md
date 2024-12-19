# FFI::Platypus::Lang::V ![static](https://github.com/PerlFFI/FFI-Platypus-Lang-V/workflows/static/badge.svg) ![linux](https://github.com/PerlFFI/FFI-Platypus-Lang-V/workflows/linux/badge.svg)

Documentation and tools for using Platypus with the V programming language

# SYNOPSIS

V:

```
module foo

pub fn add(a, b i32) i32 {
    return a + b
}
```

Perl:

```perl
use FFI::Platypus 2.00;
my $ffi = FFI::Platypus->new( api => 2, lang => 'V', lib => 'foo.so' );
$ffi->mangle(sub ($sym) { "foo__$sym" });
$ffi->attach( add => ['i32','i32'] => 'i32');

say add(1,2);
```

Prints:

```
3
```

# DESCRIPTION

This module provides types and documentation for using the V
programming language with [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus).

# METHODS

## native\_type\_map

```perl
my $hashref = FFI::Platypus::Lang::V->native_type_map;
```

Returns a mapping of V primitive types to Platypus types.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2024 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
