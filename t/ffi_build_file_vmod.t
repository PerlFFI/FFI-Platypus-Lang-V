use 5.020;
use Test2::V0 -no_srand => 1;
use Data::Section::Pluggable 0.04;
use Path::Tiny ();
use Capture::Tiny qw( capture_merged );
use File::Glob qw( bsd_glob );

my $lib = Path::Tiny->new('lib')->absolute;
my $root = Path::Tiny->tempdir;
Data::Section::Pluggable->new->extract("$root");

foreach my $test (bsd_glob "$root/t/*.t") {
    my @command = ($^X, "-I$lib", "-I$root/lib", $test);
    my($out, $ret) = capture_merged {
        say "+@command";
        system @command;
    };
    is $ret, 0;
    if($ret == 0) {
        note $out;
    } else {
        diag $out;
    }
}

done_testing;

__DATA__

@@ Makefile.PL
use strict;
use warnings;
use ExtUtils::MakeMaker;
use FFI::Build::MM;

my $fbmm = FFI::Build::MM->new;

WriteMakefile($fbmm->mm_args(
    ABSTRACT => 'Perl/V Extension',
    DISTNAME => 'V-FFI',
    NAME => "V::FFI",
    VERSION => '1.00',
));

sub MY::postamble {
  $fbmm->mm_postamble;
}

@@ ffi/v.mod
Module {
    name: 'libfoo'
    description: 'Gah'
    version: '0.0.0'
    license: 'MIT'
    dependencies: []
}


@@ ffi/src/libfoo.v
module libfoo

pub fn add(a, b i32) i32 {
    return a + b
}

@@ lib/V/FFI.pm
use warnings;
use 5.020;
use experimental qw( signatures );
use true;

package V::FFI {

    use FFI::Platypus 2.00;
    use Exporter qw( import );

    our @EXPORT = qw( add );

    my $ffi = FFI::Platypus->new( api => 2, lang => 'V' );
    $ffi->bundle;
    $ffi->mangler(sub ($sym) { return "libfoo__$sym" });

    $ffi->attach(add => ['i32','i32'] => 'i32');
}

@@ t/v_ffi.t
use Test2::V0 -no_srand => 1;
use V::FFI;

is(add(1,2), 3);

done_testing;
