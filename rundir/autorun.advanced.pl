#!/usr/bin/perl -w
use strict;
use warnings;
#my $rundir=shift;
#my $resdir=shift;

#my $resultFile=shift;
my $treeFile="";#shift;

die "@ARGV;Usage:perl $0 POP resultFile\n" unless @ARGV==2;

my $pop = shift;
my $resultFile=shift;

my $currentModel;
my $initialModel="A:B:C:D:E:F";
my %cladeModel;
 $cladeModel{'A'}="A\\*";
 $cladeModel{'B'}="B\\*";
 $cladeModel{'C'}="C\\*";
 $cladeModel{'D'}="D\\*";

 #$cladeModel{'C'}="C1:C2:C3:C4:C5";
 #$cladeModel{'C1'}="C1\\*";
 #$cladeModel{'C2'}="C2\\*";
 #$cladeModel{'C3'}="C3\\*";
 #$cladeModel{'C4'}="C4\\*";
 #$cladeModel{'C5'}="C5\\*";

 $cladeModel{'E'}="E1a:E1b:E2";
 $cladeModel{'E1a'}="E1a\\*";
 $cladeModel{'E1b'}="E1b\\*";
 $cladeModel{'E2'}="E2\\*";
 
 $cladeModel{'F'}="G:H:I:J:K";
 $cladeModel{'G'}="G\\*";
# $cladeModel{'H'}="H\\*";
 $cladeModel{'H'}="H1:H2:H3";
 $cladeModel{'H1'}="H1\\*";
 $cladeModel{'H2'}="H2\\*";
 $cladeModel{'H3'}="H3\\*";
 
 $cladeModel{'I'}="I\\*";
 #$cladeModel{'J'}="J\\*";
 $cladeModel{'J'}="J1:J2";
 $cladeModel{'J1'}="J1\\*";
 $cladeModel{'J2'}="J2\\*"; 

 $cladeModel{'K'}="LT:NO:S:M:P";
 $cladeModel{'LT'}="L:T";
 $cladeModel{'L'}="L\\*";
 $cladeModel{'T'}="T\\*";
 $cladeModel{'NO'}="N:O";
 $cladeModel{'N'}="N\\*";
# $cladeModel{'O'}="O\\*";
 $cladeModel{'S'}="S\\*";
 $cladeModel{'M'}="M\\*";
 $cladeModel{'P'}="Q:R";
 $cladeModel{'Q'}="Q\\*";
 
 $cladeModel{'O'}="O1:O2:O3";
 $cladeModel{'O1'}="O1\\*";
 $cladeModel{'O2'}="O2\\*";
 $cladeModel{'O3'}="O3\\*";

 $cladeModel{'R'}="R1a:R1b:R2a:R2b";
 $cladeModel{'R1a'}="R1a\\*";
 $cladeModel{'R1b'}="R1b\\*";
 $cladeModel{'R2a'}="R2a\\*";
 $cladeModel{'R2b'}="R2b\\*";


my %treeHash;
sub makeTree()
{
    open IN,"$treeFile" or die $!;
    while (<IN>)
    {
        my ($child,$parent) = split;
        if ( exists $treeHash{$parent})
        {
            push @{$treeHash{$parent}},$child;
        }
        else
        {
            my @children;
            push @children, $child;
            $treeHash{$parent}=\@children;
        }
    }
}

sub getChildren()
{
    my $parent=@_;
    return $treeHash{$parent};
}



sub parseResult()
{
    my %sample2Group;
    my %group2Sample;
    my $resultFile=shift;
    my $usedModel=shift;
    open IN,$resultFile or (print $!," from sample $pop under $usedModel\n" and return (-1,-1));
    <IN>;
    <IN>;    
    while(<IN>)#each sample
    {
        chomp;
        my @tokens=split /\t/,$_;

        print STDERR "$tokens[0]\t$pop\t$tokens[1]\n";         
        my @assignments=split ";",$tokens[1];
        my %group2prob;
        foreach my $item (@assignments)#each assignment
        {
            $item=~/(\w+)=(.+)/g;
            $group2prob{$1}=$2;
        }
        my @groups = sort { $group2prob{$b} <=> $group2prob{$a} } keys(%group2prob);#sort descendingly
        #print "inParse:",$tokens[0],"\t",$groups[0],"\n";
	$sample2Group{$tokens[0]}=$groups[0];
        if(exists $group2Sample{$groups[0]})
	{
		push @{$group2Sample{$groups[0]}},$tokens[0];
	}
	else
	{
		my @a;
		push @a, $tokens[0];
		$group2Sample{$groups[0]}=\@a;
	}
    }
    return \%sample2Group, \%group2Sample;
}

sub runJava()
{
    my ($model)=@_;
    my $cmdline="nohup sh ../../runYhap.sh ".$pop." ".$model." 1>&2 "." 2>>".$pop.".e.log";
    print STDERR "executing $cmdline ...\n";
    return system($cmdline);
}

###main part
#&makeTree();


##debug
#&parseResult($resultFile);
#exit 42;


#top level
my $ret=0;
$ret=&runJava($initialModel);
if($ret!=0) {die "Initial Level failed, fatal error!\n";}

my ($Sample2Group,$Group2Sample)=&parseResult($resultFile, $initialModel);
print STDERR "Initial Level Done!\n";

&autoRun();



=cut
#second level

$currentModel = "";

my (%SndSample2Group,%SndGroup2Sample);

for my $curGroup (sort { $a cmp $b} keys %{$Group2Sample})#A,B,C,D,E,F 
{
    $currentModel=$cladeModel{$curGroup};
    $ret=&runJava($currentModel);
    if($ret!=0) 
	{
		print STDERR "error happens at Second Level, but I will write down assignment so far we've got.\n";
		&WriteResult();
		exit 1;
	}
    my ($tmpSample2Group,$tmpGroup2Sample)=&parseResult($resultFile, $currentModel);
	if($tmpSample2Group <0) {next;}
    for my $sample (@{$$Group2Sample{$curGroup}})
    {
#	print $curGroup,"\t",$sample,"\n";
        $$Sample2Group{$sample}=$$tmpSample2Group{$sample};
        if($curGroup eq 'F')
        {
            $SndSample2Group{$sample}=$$tmpSample2Group{$sample};
        }
    }
}

while(my($k, $v) = each %SndSample2Group)
{
    if(exists $SndGroup2Sample{$v})
    {
        push @{$SndGroup2Sample{$v}}, $k;
    }
    else
    {
        my @a;
        push @a, $k;
        $SndGroup2Sample{$v}=\@a;#only subclade of F needed
    }
}


print STDERR "Second Level Done!\n";
if(not exists $$Group2Sample{'F'})
{ 
    &WriteResult();
    exit 0;
}
=cut
#####develop area
sub singleRound()
{
	my ($ReceiveSample2Group,$ReceiveGroup2Sample,$FurtherClade)=@_;
	my (%DeliverSample2Group,%DeliverGroup2Sample);
    my %FurtherCladeSet;
    if(defined $FurtherClade)
    {
        %FurtherCladeSet= map { $_ => 1 } (split /:/,$FurtherClade);
    }
	for my $curGroup (sort { $a cmp $b} keys %{$ReceiveGroup2Sample})#A,B,C,D,E,F
	{
		$currentModel=$cladeModel{$curGroup};
		$ret=&runJava($currentModel);
		if($ret!=0)
		{
			print STDERR "error happens at $currentModel, but I will write down assignment so far we've got.\n";
			&WriteResult();
			exit 1;
		}
		my ($tmpSample2Group,$tmpGroup2Sample)=&parseResult($resultFile, $currentModel);
		if($tmpSample2Group <0) {next;}
		for my $sample (@{$$ReceiveGroup2Sample{$curGroup}})
		{
			$$Sample2Group{$sample}=$$tmpSample2Group{$sample};
			if((defined $FurtherClade) and (exists $FurtherCladeSet{$curGroup}))
			{
				$DeliverSample2Group{$sample}=$$tmpSample2Group{$sample};
			}
		}
	}
	
	while(my($k, $v) = each %DeliverSample2Group)
	{
		if(exists $DeliverGroup2Sample{$v})
		{
			push @{$DeliverGroup2Sample{$v}}, $k;
		}
		else
		{
			my @a;
			push @a, $k;
			$DeliverGroup2Sample{$v}=\@a;#only subclade of FurtherClade needed
		}
	}
	
	if(defined $FurtherClade)
	{
		for my $k (keys %FurtherCladeSet)
		{
			if( exists $$ReceiveGroup2Sample{$k})
			{
				goto END;
			}
		}
		&WriteResult();
		exit 0;
	}
END:
	return \%DeliverSample2Group,\%DeliverGroup2Sample;
}

sub autoRun()
{
 my $lvl=0;
 my @InternalClade = ('E:F','H:J:K','LT:NO:P','O:R');
 my ($tmpDeliverSample2Group,$tmpDeliverGroup2Sample) = ($Sample2Group,$Group2Sample);
 while($lvl <= @InternalClade)
 {
    ($tmpDeliverSample2Group,$tmpDeliverGroup2Sample) = &singleRound($tmpDeliverSample2Group,$tmpDeliverGroup2Sample,$InternalClade[$lvl]); 
    $lvl++;
 }

 print STDERR "Finish AutoRun!\n";
 &WriteResult();
 exit 0;
}


sub WriteResult()
{
	print STDERR  "Assignment Done!\n";

	open OUT,">YHap.assignment.$pop.txt" or die $!;

	foreach (sort keys %{$Sample2Group}) {
    		print OUT "$_\t$$Sample2Group{$_}\n";
	}
}

