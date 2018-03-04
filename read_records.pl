#!/usr/bin/perl


use strict;

use records;
use DateTime;


my %sortFunctions = (
    # sort by gender, f - m
    gender => sub {
        return $a->{gender} cmp $b->{gender} or
            $b->{lastName} cmp $a->{lastName} or
            $b->{firstName} cmp $a->{firstName};
    },
    
    # sort by birthdate ascending
    birth => sub {
        # uses the fault UTC print format - easily sorted by string representation
        return $a->{birthDate} cmp $b->{birthDate};
    },
    
    # sort by last name, then first name
    name => sub {
        return $b->{lastName} cmp $a->{lastName} or
            $a->{firstName} cmp $b->{firstName};
    }
);



my ($fileName, $delimiter, $outputType) = @ARGV;

open(my $fileHandle, '<', $fileName);
my $people = records::parsePeople($fileHandle, $delimiter);
close $fileHandle;

my $sortFunction = $sortFunctions{$outputType};

my @sortedPeople = sort $sortFunction values(%$people);

foreach my $record (@sortedPeople) {
    print records::recordToString($record) . "\n";
}



