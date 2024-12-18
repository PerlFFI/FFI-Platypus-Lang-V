use warnings;
use 5.020;
use experimental qw( signatures );
use stable qw( postderef );
use true;

package FFI::Platypus::Lang::V {

    # ABSTRACT: Documentation and tools for using Platypus with the V programming language

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 native_type_map

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
        };
    }

}
