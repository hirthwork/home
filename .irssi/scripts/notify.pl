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
    my $status = "";
    foreach my $window (@windows)
    {
        if ($window->{data_level} == 2)
        {
            $status = $status." ".$window->{refnum};
        }
        if ($window->{data_level} > 2)
        {
            $status = $status." !".$window->{refnum};
        }
    }
    open(STATUS, ">$ENV{'HOME'}/.irssi/state");
    print STATUS $status;
    close(STATUS);
    my @args = ('sh', './.dwm.update');
    system(@args);
}

