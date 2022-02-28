PopupSize Output Filter
=======================

Introduction
------------

This plugin overrides the hardcoded popup window dimensions and positions
using Sys::Config variables.

You can set width/height in pixel or percentage and the absolute position or
center the popup window on the current screen.

Install
-------

Create module

    git clone git@<hostname>:dhoffend/otobo-popupsize
    cd /opt/otobo
    bin/otobo.Console.pl Dev::Package::Build ~/otobo-popupsize/PopupSize.sopm ~/
    Building package...
    Done.

After that you can install the package using the build in package mananger.

    PopupSize-0.0.1.opm

