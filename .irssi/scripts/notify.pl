use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '1.00';
%IRSSI = (
    authors     => 'A. U. Thor',
    contact     => 'author@far.away',
    name        => 'My First Script',
    description => 'This script allows ' .
                   'you to print Hello ' .
                   'World using a command.',
    license     => 'Public Domain',
);

Irssi::signal_add('window activity', 'sig_window_activity');

sub sig_window_activity {
    my @windows = Irssi::windows();
    my $status;
    foreach my $window (@windows)
    {
        my $level = $window->{data_level};
        if ($level >= 2) {
            foreach my $item ($window->items())
            {
                my $name = $item->{name};
                $name =~ s/^#+//;
                my $info = "";
                if ($level > 2)
                {
                    $info = "!";
                }
                $info = $info.$window->{refnum}.":".$name;
                if (defined($status)) {
                    $status = $status." ".$info;
                } else {
                    $status = $info;
                }
            }
        }
    }
    open(STATUS, ">$ENV{'HOME'}/.irssi/state");
    if (defined($status)) {
        print STATUS $status;
    }
    close(STATUS);
    my @args = ('sh', './.dwm.update');
    system(@args);
}

