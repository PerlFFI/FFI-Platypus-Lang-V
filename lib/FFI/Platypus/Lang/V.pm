use warnings;
use 5.020;
use experimental qw( signatures );
use stable qw( postderef );
use true;

package FFI::Platypus::Lang::V {

    # ABSTRACT: Documentation and tools for using Platypus with the V programming language

=head1 SYNOPSIS

V:

 module foo
 
 pub fn add(a i32, b i32) i32 {
     return a + b
 }

Perl:

 use FFI::Platypus 2.00;
 my $ffi = FFI::Platypus->new( api => 2, lang => 'V', lib => 'foo.so' );
 $ffi->mangle(sub ($sym) { "foo__$sym" });
 $ffi->attach( add => ['i32','i32'] => 'i32');
 
 say add(1,2);

Prints:

 3

=head1 DESCRIPTION

This module provides types and documentation for using the V
programming language with L<FFI::Platypus>.  For details on
bundling a V project with your Perl distribution see
L<FFI::Build::File::VMod>.

=head1 METHODS

=head2 native_type_map

 my $hashref = FFI::Platypus::Lang::V->native_type_map;

Returns a mapping of V primitive types to Platypus types.

=head1 SEE ALSO

=over 4

=item L<https://vlang.io/>

=item L<FFI::Platypus>

=item L<FFI::Build::File::VMod>

=back

=cut

    # https://docs.vlang.io/v-types.html#primitive-types
    sub native_type_map {
        state $map;
        return $map //= {
            u8  => 'uint8',
            u16 => 'uint16',
            u32 => 'uint32',
            u64 => 'uint64',
            i8  => 'sint8',
            i16 => 'sint16',
            i32 => 'sint32',
            i64 => 'sint64',
            f32 => 'float',
            f64 => 'double',
        };
    }
}
