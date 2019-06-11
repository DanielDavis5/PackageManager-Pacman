use strict;
use warnings;

package PackageManager::Pacman;
use Carp;
use IPC::Cmd qw(can_run run);
use Moose;

has 'bin' => ( is => 'rw' );

sub BUILD {
    my $self = shift;
    $self->bin( can_run('pacman') or confess 'pacman is not installed!' );
}

sub list {
    my ( $self, $verbose ) = @_;
    my $cmd = [ $self->bin, '-Q' ];
    my ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf ) =
      run( command => $cmd, verbose => $verbose );

    return map { { name => @$_[0], version => @$_[1] } }
      grep { @$_ == 2 }
      map  { [ $_ =~ m/(.+) +(.*)/ ] }
      split( /\n/, join( '', @$stdout_buf ) );
}

sub install {
    die 'not implemented';
}

sub remove {
    die 'not implemented';
}

with 'PackageManager::Base';

1;
