# PlugAuth::Plugin::WebUI [![Build Status](https://secure.travis-ci.org/clustericious/PlugAuth-Plugin-WebUI.png)](http://travis-ci.org/clustericious/PlugAuth-Plugin-WebUI)

Embed a web user interface into your PlugAuth server

# SYNOPSIS

Your PlugAuth.conf

    ---
    url: http://localhost:3000
    plugins:
     - PlugAuth::Plugin::WebUI: {}

Start [PlugAuth](https://metacpan.org/pod/PlugAuth)

    % plugauth daemon

and then navigate to the PlugAuth WebUI:

    http://localhost:3000/ui

# DESCRIPTION

This plugin embeds the [PlugAuth WebUI](https://metacpan.org/pod/PlugAuth::WebUI) into your PlugAuth server,
which can be accessed via the url `/ui`.

# AUTHOR

Graham Ollis &lt;gollis@sesda3>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by NASA GSFC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
