# OTOBO is a web-based ticketing system for service organisations.
# --
# Kernel/Output/HTML/FilterContent/PopupSize.pm
# Copyright (C) 2017 Daniel Hoffend, http://www.dotlan.net/
# Copyright (C) 2022 GH-Informatik GmbH https://wotan-monitoring.com
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --


package Kernel::Output::HTML::FilterContent::PopupSize;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # load config items
    my $Width = $ConfigObject->Get('PopupSize::Width') || 1040;
    my $Height = $ConfigObject->Get('PopupSize::Height') || 700;
    my $Top = $ConfigObject->Get('PopupSize::Top') || 100;
    my $Left = $ConfigObject->Get('PopupSize::Left') || 100;
    my $Center = $ConfigObject->Get('PopupSize::Center') || 0;

    # sanatize input
    $Width =~ s/[^0-9%]//;
    $Height =~ s/[^0-9%]//;
    $Top =~ s/[^0-9]//;
    $Left =~ s/[^0-9]//;

    # prepare js output
    my $JSOutput = '
<script type="text/javascript">//<![CDATA[
"use strict";
Core.App.Ready(function () {

    var setPopupSize = function() {
        var popup = Core.UI.Popup.ProfileList()["Default"];

        // set window size
        popup["Width"] = "'.$Width.'";
        popup["Height"] = "'.$Height.'";

        // support percentage
        if (popup["Width"].match(/%$/)) {
            popup["Width"] = window.screen.availWidth * (parseInt(popup["Width"]) / 100);
        }else{
            popup["Width"] = parseInt( popup["Width"] );
        }
        if (popup["Height"].match(/%$/)) {
            popup["Height"] = window.screen.availHeight * (parseInt(popup["Height"]) / 100);
        }else{
            popup["Height"] = parseInt( popup["Height"] );
        }
    ';
    if ($Center) {
        $JSOutput .= '
        // set position
        popup["Left"] = window.screenY + (window.screen.availWidth/2 - parseInt(popup["Width"])/2);
        popup["Top"] = window.screenX + (window.screen.availHeight/2 - parseInt(popup["Height"])/2);
        ';
    }
    else {
        $JSOutput .= '
        // set position
        popup["Left"] = parseInt("'.$Left.'");
        popup["Top"] = parseInt("'.$Top.'");
        ';
    }

    $JSOutput .= '
        // override default profile
        Core.UI.Popup.ProfileAdd("Default", popup);
    };

    setPopupSize();

    /* recalc when the mouse leaves the window (hopefully we\'ll catch
    when the window gets moved (to a different screen). */
    $(window).on("mouseout", setPopupSize);

});
//]]></script>
    ';

    ${ $Param{Data} } =~ s{</body>}{$JSOutput\n\t</body>}smx;

    return ${ $Param{Data} };
}

1;
