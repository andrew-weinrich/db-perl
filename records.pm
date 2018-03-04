#!/usr/bin/perl

use strict;
use warnings;

use DateTime;
use DateTime::Format::DateParse;


package records;

# for the moment, don't validate color names
sub normalizeColor {
    my $colorText = shift;
    return $colorText;
}

# for the moment, don't validate genders
sub normalizeGender {
    my $genderText = shift;
    return $genderText;
}

# parse dates into an object
sub normalizeDate {
    my $dateText = shift;
    return DateTime::Format::DateParse->parse_datetime($dateText);
}

# makes a hash key for a record
sub getKey {
    my $record = shift;
    
    return $record->{lastName} . "-" . $record->{firstName};
}


# parses a single record
sub parseLine {
    my ($line, $delimiter) = @_;
    my $escapedDelimiter = quotemeta $delimiter;
    
    my @fields = split /$escapedDelimiter/, $line;
    my ($lastName, $firstName, $genderText, $colorText, $birthText) = @fields;
    
    # normalize dates
    my $birthDate = normalizeDate($birthText);
    my $favoriteColor = normalizeColor($colorText);
    my $gender = normalizeGender($genderText);
    
    my $record = {
        firstName => $firstName,
        lastName => $lastName,
        gender => $gender,
        favoriteColor => $favoriteColor,
        birthDate => $birthDate,
        key => ''
    };
    
    $record->{key} = getKey($record);
    
    return $record;
}

# parses a file of last/firstname/gender/color/birthdate, with a specified delimiter
# returns data with the key "$firstname-$lastname"
sub parsePeople {
    my ($fileHandle, $delimiter) = @_;
    
    # collection of persons
    my $people = {};
    
    while (my $line = <$fileHandle>) {
        chomp $line;
        
        # skip blank lines
        next unless $line;
        
        my $record = parseLine($line, $delimiter);
        
        $people->{$record->{key} } = $record;
    }
    
    return $people;
}


sub recordToString {
    my ($record) = @_;
    return "lastName: '$record->{lastName}'; firstName: '$record->{firstName}'; " . 
        "gender: '$record->{gender}'; color: '$record->{favoriteColor}'; " .
        "birthDate: '" . DateTime::strftime($record->{birthDate}, '%m/%d/%Y') . "'";
}



#sub recordToJson {
#}


1;
