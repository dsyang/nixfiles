#!/usr/bin/perl

# URL that generated this code:
# http://txt2re.com/index.php3?s=-InternalBattery-0%20%20%20%20%2009%;%20discharging;%200:22%20remaining&9&-70&5&8

#$txt='-InternalBattery-0     09%; discharging; 0:22 remaining';

$txt = <STDIN>;

$re1='.*?';# Non-greedy match on filler
$re2='\\d+';# Uninteresting: int
$re3='.*?';# Non-greedy match on filler
$re4='(\\d+)';# Integer Number 1
$re5='(%)';# Any Single Character 1
$re6='.*?';# Non-greedy match on filler
$re7='((?:(?:[0-1][0-9])|(?:[2][0-3])|(?:[0-9])):(?:[0-5][0-9])(?::[0-5][0-9])?(?:\\s?(?:am|AM|pm|PM))?)';# HourMinuteSec 1
$re8='.*?';# Non-greedy match on filler
$re9='((?:[a-z][a-z]+))';# Word 1

$re=$re1.$re2.$re3.$re4.$re5.$re6.$re7.$re8.$re9;
if ($txt =~ m/$re/is)
{
    $int1=$1;
    $c1=$2;
    $time1=$3;
#    $word1=$4;
    print "Batt: $int1$c1 ($time1)\n";
}

#-----
# Paste the code into a new perl file. Then in Unix:
# $ perl x.pl
#-----
