use warnings;
use 5.020;
use experimental qw( signatures );
use stable qw( postderef );
use true;

package FFI::Build::File::VMod {

    # ABSTRACT: Class to track V source in FFI::Build

    use parent qw( FFI::Build::File::Base );
    use constant default_suffix => '.mod';
    use constant default_encoding => ':utf8';
    use Path::Tiny ();
    use File::chdir;

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 native_type_map

=cut

    sub accept_suffix {
        (qr/\/v\.mod$/)
    }

    sub build_all ($self) {
        $self->build_item;
    }

    sub build_item ($self) {
    }

}
