#!/usr/bin/perl -w
use strict;
use warnings;

die "perl $0 dataDirLoc dataAlias softenOrNot[y/n]\n" unless @ARGV==3 or @ARGV==2;
my $dataDirLoc=shift;
my $dataAlias=shift;

my $soften=shift;

if(defined($soften) and $soften=~/y|Y/)
{
    $soften = 1;
}
else
{
    $soften = 0;
}


my $tmplate="../../data/Template.csv";
open TPL, "$tmplate" or die $!;
while(my $line = <TPL>) 
{
    my @cells = csvsplit($line); # or csvsplit($line, $my_custom_seperator)
    #print @cells,"\n";
    #next;
    if($cells[0] =~/inputDirLoc/)
    {
        push @cells, "\"\"\"$dataDirLoc\"\"\"";print join(",",@cells),"\n";
    }
    elsif(defined $soften and $cells[0] =~/softenHapMap/)
    {
        push @cells, 1.00E-004 ;print join(",",@cells),"\n";
    }
    elsif($cells[0] =~/phenoToInclude/||$cells[0] =~/toInclude/)
    {
        push @cells, "\"\"\"all\"\"\"";print join(",",@cells),"\n";
    }
    else
    {
        if($cells[0] =~ /inputDir/){push @cells, "\"\"\"$dataAlias\"\"\"";print join(",",@cells),"\n";}
        elsif( $cells[0] =~ /emissionGroup/) {push @cells, "\"\"\"".$dataAlias."Y\"\"\"";print join(",",@cells),"\n";}
        else {push @cells, $cells[-1];print join(",",@cells),"\n";}
    }
}



sub csvsplit {
        my $line = shift;
        my $sep = (shift or ',');

        return () unless $line;

        my @cells;
        $line =~ s/\r?\n$//;
=cut
        my $re = qr/(?:^|$sep)(?:"([^"]*)"|([^$sep]*))/;

        while($line =~ /$re/g) {
                my $value = defined $1 ? $1 : $2;
                push @cells, (defined $value ? $value : '');
        }
=cut
        @cells = split /,/,$line;
        return @cells;
}


