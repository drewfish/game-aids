#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw/sum/;

my $COLOR_GREEN = '[32;1m';
my $COLOR_GREY  = '[30;1m';
my $COLOR_END   = '[0m';

sub usage
{
    print("USAGE:  $0 {sum} {count}\n");
    exit(1);
}
sub main
{
    my $a_sum = shift @ARGV || usage();
    my $a_cnt = shift @ARGV || usage();
    my $a_have = shift @ARGV;
    my %a_have;
    %a_have = map { $_ => 1 } split(//, $a_have) if $a_have;

    my %strings;
    @{$strings{1}}{qw/ 1 2 3 4 5 6 7 8 9 /} = (1) x 9;
    for my $count ( 2 .. $a_cnt )
    {
        $strings{$count} = {};
        foreach my $p ( keys %{$strings{$count-1}} )
        {
            foreach my $x ( 1 .. 9 )
            {
                next unless -1 == index($p,$x);
                my $n = $x.$p;
                $strings{$count}{$n} = 1;
            }
        }
    }
    my %unique;
    STRING:
    foreach my $string ( keys %{$strings{$a_cnt}} )
    {
        my @opt = split //, $string;
        my $sum = sum(@opt);
        next unless $sum == $a_sum;
        @opt = sort { $a <=> $b } @opt;
        my $s = join(',', @opt);
        $unique{$s} = 1;
    }
    foreach my $s ( sort keys %unique )
    {
        my $color_line_S = '';
        my $color_line_P = '';
        if ( $a_have )
        {
            my @opt = split ',', $s;
            my %opt = map { $_ => 1 } @opt;
            my $skip = 0;
            foreach my $h ( keys %a_have )
            {
                unless ( $opt{$h} )
                {
                    $skip = 1;
                    last;
                }
            }
            if ( $skip )
            {
                $color_line_S = $COLOR_GREY;
                $color_line_P = $COLOR_END;
            }
            else
            {
                # color restricting digits
                @opt = map {
                    $_ = $COLOR_GREEN . $_ . $COLOR_END if $a_have{$_};
                    $_;
                } @opt;
            }
            $s = join(',', @opt);
        }
        print($color_line_S, $s, $color_line_P, "\n");
    }
}
main();

