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
        (qr/\/v\.mod\z/)
    }

    sub build_all ($self, $) {
        $self->build_item;
    }

    sub build_item ($self) {

        my $vmod = Path::Tiny->new($self->path);

        my $platform;
        my $buildname;
        my $lib;

        if($self->build) {
            $platform = $self->build->platform;
            $buildname = $self->build->buildname;
            $lib = $self->build->file;
        } else {
            $platform = FFI::Build::Platform->new;
            $buildname = "_build";

            my($name) = map { /name:\s*'(.*)'/ ? ($1) : () } $vmod->lines_utf8;
            die "unable to find name in $vmod" unless defined $name;

            $lib = FFI::Build::File::Library->new(
                $vmod->parent->child("$name" . scalar($platform->library_suffix))->stringify,
                platform => $self->platform,
            );
        }

        return $lib if -f $lib->path && !$lib->needs_rebuild($self->_deps($vmod->parent));

        {
            my $lib_path = Path::Tiny->new($lib->path)->relative($vmod->parent);
            say "+cd @{[ $vmod->parent ]}";
            local $CWD = $vmod->parent;
            say "+mkdir -p @{[ $lib_path->parent->mkdir ]}";
            $lib_path->parent->mkdir;
            $platform->run('v', '-prod', '-shared', -o => "$lib_path", '.');
            die "command failed" if $?;
            die "no shared library" unless -f $lib_path;
            say "+cd -";
        }

        return $lib;

    }

    sub _deps ($self, $path)
    {
        my @ret;
        foreach my $path ($path->children) {
            next if -l $path;  # skip symlinks to avoid recursion
            push @ret, $self->_deps($path) if -d $path;
            push @ret, $path->stringify if $path->basename =~ /^(.*\.(v|c|h)|v\.mod)\z/;
        }
        return @ret;
    }

}
