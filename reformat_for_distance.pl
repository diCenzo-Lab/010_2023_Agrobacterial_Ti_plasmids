#!/usr/bin/perl
use 5.010;

while(<>) {
    @line = split("\t", $_);
    $distance = (1 - @line[2]) * 100;
    say("@line[0]\t@line[1]\t$distance");
}