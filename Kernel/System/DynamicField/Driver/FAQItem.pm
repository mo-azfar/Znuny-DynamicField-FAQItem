# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# Copyright (C) 2024 mo-azfar, https://github.com/mo-azfar/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DynamicField::Driver::FAQItem;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::DynamicField::Driver::BaseSelect);

use Kernel::System::DynamicField::Driver::Multiselect;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::DynamicField::Driver::FAQItem

=head1 DESCRIPTION

DynamicFields FAQItem Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 1,
        'IsNotificationEventCondition' => 1,
        'IsSortable'                   => 1,
        'IsFiltrable'                  => 1,
        'IsStatsCondition'             => 1,
        'IsCustomerInterfaceCapable'   => 1,
        'IsLikeOperatorCapable'        => 1,
    };

    # get the Dynamic Field Backend custom extensions
    my $DynamicFieldDriverExtensions
        = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Extension::Driver::FAQItem');

    EXTENSION:
    for my $ExtensionKey ( sort keys %{$DynamicFieldDriverExtensions} ) {

        # skip invalid extensions
        next EXTENSION if !IsHashRefWithData( $DynamicFieldDriverExtensions->{$ExtensionKey} );

        # create a extension config shortcut
        my $Extension = $DynamicFieldDriverExtensions->{$ExtensionKey};

        # check if extension has a new module
        if ( $Extension->{Module} ) {

            # check if module can be loaded
            if (
                !$Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass( $Extension->{Module} )
                )
            {
                die "Can't load dynamic fields backend module"
                    . " $Extension->{Module}! $@";
            }
        }

        # check if extension contains more behaviors
        if ( IsHashRefWithData( $Extension->{Behaviors} ) ) {

            %{ $Self->{Behaviors} } = (
                %{ $Self->{Behaviors} },
                %{ $Extension->{Behaviors} }
            );
        }
    }

    return $Self;
}

sub ValueGet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::ValueGet(%Param);
    }

    return $Self->SUPER::ValueGet(%Param);
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::ValueSet(%Param);
    }

    return $Self->SUPER::ValueSet(%Param);
}

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::ValueValidate(%Param);
    }

    return $Self->SUPER::ValueValidate(%Param);
}

sub FieldValueValidate {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::FieldValueValidate(%Param);
    }

    return $Self->SUPER::FieldValueValidate(%Param);
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::SearchSQLGet(%Param);
    }

    return $Self->SUPER::SearchSQLGet(%Param);
}

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::SearchSQLOrderFieldGet(%Param);
    }

    return $Self->SUPER::SearchSQLOrderFieldGet(%Param);
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # add class
    $Param{Class} = 'DynamicFieldFAQItem';

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::EditFieldRender(%Param);
    }

    return $Self->SUPER::EditFieldRender(%Param);
}

sub EditFieldValueGet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::EditFieldValueGet(%Param);
    }

    return $Self->SUPER::EditFieldValueGet(%Param);
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::EditFieldValueValidate(%Param);
    }

    return $Self->SUPER::EditFieldValueValidate(%Param);
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    # set HTMLOutput as default if not specified
    if ( !defined $Param{HTMLOutput} ) {
        $Param{HTMLOutput} = 1;
    }

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {

        # set Value and Title variables
        my $Value         = '';
        my $Title         = '';
        my $ValueMaxChars = $Param{ValueMaxChars} || '';
        my $TitleMaxChars = $Param{TitleMaxChars} || '';

        # check value
        my @Values;
        if ( ref $Param{Value} eq 'ARRAY' ) {
            @Values = @{ $Param{Value} };
        }
        else {
            @Values = ( $Param{Value} );
        }

        # get real values
        my $PossibleValues     = $Param{DynamicFieldConfig}->{Config}->{PossibleValues};
        my $TranslatableValues = $Param{DynamicFieldConfig}->{Config}->{TranslatableValues};

        my @ReadableValues;
        my @ReadableTitles;

        my $ShowValueEllipsis;
        my $ShowTitleEllipsis;

        VALUEITEM:
        for my $Item (@Values) {
            next VALUEITEM if !$Item;

            my $ReadableValue = $Item;

            if ( $PossibleValues->{$Item} ) {
                $ReadableValue = $PossibleValues->{$Item};
                if ($TranslatableValues) {
                    $ReadableValue = $Param{LayoutObject}->{LanguageObject}->Translate($ReadableValue);
                }
            }

            # set title equal value
            my $ReadableTitle = $ReadableValue;

# ---
            # mo.azfar: only display FAQ number from value
# ---
            if ( $ReadableValue =~ /(FAQ#\d+)/ ) {
                $ReadableValue = $1;
            }

# ---

            my $ReadableLength = length $ReadableValue;

            # cut strings if needed
            if ( $ValueMaxChars ne '' ) {

                if ( length $ReadableValue > $ValueMaxChars ) {
                    $ShowValueEllipsis = 1;
                }
                $ReadableValue = substr $ReadableValue, 0, $ValueMaxChars;

                # decrease the max parameter
                $ValueMaxChars = $ValueMaxChars - $ReadableLength;
                if ( $ValueMaxChars < 0 ) {
                    $ValueMaxChars = 0;
                }
            }

            if ( $TitleMaxChars ne '' ) {

                if ( length $ReadableTitle > $ValueMaxChars ) {
                    $ShowTitleEllipsis = 1;
                }
                $ReadableTitle = substr $ReadableTitle, 0, $TitleMaxChars;

                # decrease the max parameter
                $TitleMaxChars = $TitleMaxChars - $ReadableLength;
                if ( $TitleMaxChars < 0 ) {
                    $TitleMaxChars = 0;
                }
            }

            # HTMLOutput transformations
            if ( $Param{HTMLOutput} ) {

                $ReadableValue = $Param{LayoutObject}->Ascii2Html(
                    Text => $ReadableValue,
                );

                $ReadableTitle = $Param{LayoutObject}->Ascii2Html(
                    Text => $ReadableTitle,
                );
            }

            if ( length $ReadableValue ) {
                push @ReadableValues, $ReadableValue;
            }
            if ( length $ReadableTitle ) {
                push @ReadableTitles, $ReadableTitle;
            }
        }

        # get specific field settings
        my $FieldConfig = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Driver')->{Multiselect} || {};

        # set new line separator
        my $ItemSeparator = $FieldConfig->{ItemSeparator} || ', ';

        $Value = join( $ItemSeparator, @ReadableValues );
        $Title = join( $ItemSeparator, @ReadableTitles );

        if ($ShowValueEllipsis) {
            $Value .= '...';
        }
        if ($ShowTitleEllipsis) {
            $Title .= '...';
        }

        # this field type does not support the Link Feature
        my $Link;

        # create return structure
        my $Data = {
            Value => $Value,
            Title => $Title,
            Link  => $Link,
        };

        return $Data;
    }

    #single selection
    else {

        # get raw Value strings from field value
        my $Value = defined $Param{Value} ? $Param{Value} : '';

        # get real value
        if ( $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value} ) {

            # get readable value
            $Value = $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value};
        }

        # check is needed to translate values
        if ( $Param{DynamicFieldConfig}->{Config}->{TranslatableValues} ) {

            # translate value
            $Value = $Param{LayoutObject}->{LanguageObject}->Translate($Value);
        }

        # set title as value after update and before limit
        my $Title = $Value;

        # HTMLOutput transformations
        if ( $Param{HTMLOutput} ) {
            $Value = $Param{LayoutObject}->Ascii2Html(
                Text => $Value,
                Max  => $Param{ValueMaxChars} || '',
            );

            $Title = $Param{LayoutObject}->Ascii2Html(
                Text => $Title,
                Max  => $Param{TitleMaxChars} || '',
            );
        }
        else {
            if ( $Param{ValueMaxChars} && length($Value) > $Param{ValueMaxChars} ) {
                $Value = substr( $Value, 0, $Param{ValueMaxChars} ) . '...';
            }
            if ( $Param{TitleMaxChars} && length($Title) > $Param{TitleMaxChars} ) {
                $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
            }
        }

        my $Link;
        my $LinkPreview;

# ---
        # mo.azfar: only display FAQ number from value
# ---
        if ( $Value =~ /(FAQ#\d+)/ ) {
            $Value = $1;
        }

# ---

        my $Data = {
            Value       => $Value,
            Title       => $Title,
            Link        => $Link,
            LinkPreview => $LinkPreview,
        };

        return $Data;
    }
}

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::SearchFieldRender(%Param);
    }

    return $Self->SUPER::SearchFieldRender(%Param);
}

sub SearchFieldValueGet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::SearchFieldValueGet(%Param);
    }

    return $Self->SUPER::SearchFieldValueGet(%Param);
}

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::SearchFieldParameterBuild(%Param);
    }

    return $Self->SUPER::SearchFieldParameterBuild(%Param);
}

sub StatsFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::StatsFieldParameterBuild(%Param);
    }

    return $Self->SUPER::StatsFieldParameterBuild(%Param);
}

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::StatsSearchFieldParameterBuild(%Param);
    }

    return $Self->SUPER::StatsSearchFieldParameterBuild(%Param);
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::ReadableValueRender(%Param);
    }

    return $Self->SUPER::ReadableValueRender(%Param);
}

sub TemplateValueTypeGet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::TemplateValueTypeGet(%Param);
    }

    return $Self->SUPER::TemplateValueTypeGet(%Param);
}

sub ObjectMatch {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::ObjectMatch(%Param);
    }

    return $Self->SUPER::ObjectMatch(%Param);
}

sub HistoricalValuesGet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::HistoricalValuesGet(%Param);
    }

    return $Self->SUPER::HistoricalValuesGet(%Param);
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::ValueLookup(%Param);
    }

    return $Self->SUPER::ValueLookup(%Param);
}

sub BuildSelectionDataGet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::BuildSelectionDataGet(%Param);
    }

    return $Self->SUPER::BuildSelectionDataGet(%Param);
}

sub ColumnFilterValuesGet {
    my ( $Self, %Param ) = @_;

    $Param{DynamicFieldConfig}->{Config}->{PossibleValues} = $Self->PossibleValuesGet(%Param);

    if ( $Param{DynamicFieldConfig}->{Config}->{Multiple} ) {
        return $Self->Kernel::System::DynamicField::Driver::Multiselect::ColumnFilterValuesGet(%Param);
    }

    return $Self->SUPER::ColumnFilterValuesGet(%Param);
}

sub PossibleValuesGet {
    my ( $Self, %Param ) = @_;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $Config      = $Param{DynamicFieldConfig}->{Config} || {};
    my $CacheKey    = $Param{DynamicFieldConfig}->{Name};

    if ( $Config->{Cache} )
    {
        my $CacheValue = $CacheObject->Get(
            Type => 'DynamicFieldValues',
            Key  => $CacheKey,
        );

        return $CacheValue if $CacheValue;
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');
    my $FAQStates = $Config->{FAQStates};

    #get list of FAQ States Type
    my $StateTypeHashRef = $FAQObject->StateTypeList(
        UserID => 1,
    );

    my %SearchStates;

    #compare against selected faq state type
    STATE_TYPE:
    for my $State ( sort @{$FAQStates} ) {
        next STATE_TYPE if !$StateTypeHashRef->{$State};
        $SearchStates{$State} = $StateTypeHashRef->{$State};
    }

    #search faq
    my @FAQIDs = $FAQObject->FAQSearch(
        States => \%SearchStates,
        UserID => 1,
    );

    my %FAQList = ( '' => '-' );

    FAQ:
    for my $FAQID ( sort @FAQIDs ) {
        my %FAQ = $FAQObject->FAQGet(
            ItemID     => $FAQID,
            ItemFields => 0,
            UserID     => 1,
        );

        $FAQList{$FAQID} = 'FAQ#' . $FAQ{Number} . ' - ' . $FAQ{Title};
    }

    if ( $Config->{Cache} )
    {
        $CacheObject->Set(
            Type  => 'DynamicFieldValues',
            Key   => $CacheKey,
            Value => \%FAQList,
            TTL   => 60 * 60 * 24 * 1,
        );
    }

    return \%FAQList;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
