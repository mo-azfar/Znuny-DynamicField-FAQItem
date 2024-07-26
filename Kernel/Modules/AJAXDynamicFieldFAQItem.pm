# --
# Copyright (C) 2024 mo-azfar, https://github.com/mo-azfar/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AJAXDynamicFieldFAQItem;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LogObject       = $Kernel::OM->Get('Kernel::System::Log');
    my $LayoutObject    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject     = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $FAQObject       = $Kernel::OM->Get('Kernel::System::FAQ');
    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    if ( $Self->{Subaction} ne 'GetFAQItemData' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Subaction is missing or invalid.',
        );

        return;
    }

    my @SelectedIDs = $ParamObject->GetArray(
        Param => 'SelectedIDs[]',
        Raw   => 1,
    );

    my $Data;

    ID:
    for my $ID ( sort @SelectedIDs ) {

        next ID if !$ID;

        my %FAQ = $FAQObject->FAQGet(
            ItemID     => $ID,
            ItemFields => 1,
            UserID     => 1,
        );

        #Solution
        my $SolutionHTMLString = $HTMLUtilsObject->ToHTML(
            String             => $FAQ{Field3},
            ReplaceDoubleSpace => 0,
        );

        $SolutionHTMLString = $HTMLUtilsObject->DocumentStrip(
            String => $SolutionHTMLString,
        );

        $SolutionHTMLString = $HTMLUtilsObject->DocumentCleanup(
            String => $SolutionHTMLString,
        );

        my %SafeSolution = $HTMLUtilsObject->Safety(
            String       => $SolutionHTMLString,
            NoApplet     => 1,
            NoObject     => 1,
            NoEmbed      => 1,
            NoSVG        => 1,
            NoImg        => 1,
            NoIntSrcLoad => 1,
            NoExtSrcLoad => 1,
            NoJavaScript => 1,
            ReplacementStr =>
                '[REPLACED]',    # optional, string to show instead of applet, object, embed, svg and img tags
        );

        $Data->{FAQ}->{$ID} = {
            Number   => $FAQ{Number},
            Title    => $FAQ{Title},
            Solution => $SafeSolution{String} || '',
        };
    }

    my $JSON = $LayoutObject->JSONEncode(
        Data => $Data,
    );

    return $LayoutObject->Attachment(
        Type        => 'inline',
        ContentType => 'application/json',
        Charset     => 'utf-8',
        Content     => $JSON // '[]',
        NoCache     => 1,
    );
}

1;
