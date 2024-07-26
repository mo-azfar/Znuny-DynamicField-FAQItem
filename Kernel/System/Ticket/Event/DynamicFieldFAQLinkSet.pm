# --
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# Copyright (C) 2024 mo-azfar, https://github.com/mo-azfar/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::DynamicFieldFAQLinkSet;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::FAQ',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $FAQObject          = $Kernel::OM->Get('Kernel::System::FAQ');
    my $LinkObject         = $Kernel::OM->Get('Kernel::System::LinkObject');
    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    NEEDED:
    for my $Needed (qw( Data Event Config UserID )) {
        next NEEDED if $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Need $Needed!"
        );
        return;
    }

    if ( !$Param{Data}->{TicketID} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Need TicketID in Data!",
        );
        return;
    }

    #define valid dynamic field types for this event module
    my %ValidDynamicFieldTypes = (
        FAQItem => 1,
    );

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => $Param{Data}->{FieldName}
    );

    # Skip, if dynamic field type is not valid.
    return if !$ValidDynamicFieldTypes{ $DynamicField->{FieldType} };

    # Skip, if dynamic field object type is not Ticket.
    return if $DynamicField->{ObjectType} ne 'Ticket';

    my $TicketID = $Param{Data}->{TicketID};

    #get previous data
    my @OldValues;
    if ( $Param{Data}->{OldValue} && ref $Param{Data}->{OldValue} eq 'ARRAY' ) {
        @OldValues = @{ $Param{Data}->{OldValue} };
    }
    elsif ( $Param{Data}->{OldValue} ) {
        @OldValues = $Param{Data}->{OldValue};
    }

    #get new data
    my @NewValues;
    if ( ref $Param{Data}->{Value} eq 'ARRAY' ) {
        @NewValues = @{ $Param{Data}->{Value} };
    }
    else {
        @NewValues = $Param{Data}->{Value};
    }

    if (@OldValues) {
        my @RemoveIDs;

        FAQItemID:
        for my $FAQItemID ( sort @OldValues ) {

            #get the intersection of the old and new values
            my $ValueStill = grep { $_ eq $FAQItemID } @NewValues;
            next FAQItemID if $ValueStill;

            #allocated the FAQ item that need to remove
            push @RemoveIDs, $FAQItemID;
        }

        RemoveFAQItemID:
        for my $RemoveFAQItemID ( sort @RemoveIDs ) {

            #remove the FAQ item from the ticket
            $LinkObject->LinkDelete(
                Object1 => 'Ticket',
                Key1    => $TicketID,
                Object2 => 'FAQ',
                Key2    => $RemoveFAQItemID,
                Type    => 'Normal',
                UserID  => 1,
            );

            next RemoveFAQItemID;
        }
    }

    #add link to FAQ item
    AddFAQItemID:
    for my $AddFAQItemID ( sort @NewValues ) {
        $LinkObject->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $TicketID,
            TargetObject => 'FAQ',
            TargetKey    => $AddFAQItemID,
            Type         => 'Normal',
            State        => 'Valid',
            UserID       => 1,
        );

        next AddFAQItemID;
    }

    return 1;
}

1;
