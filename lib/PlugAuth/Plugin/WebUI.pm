package PlugAuth::Plugin::WebUI;

use strict;
use warnings;
use v5.10;
use PlugAuth::WebUI;
use Role::Tiny::With;

with 'PlugAuth::Role::Plugin';
with 'PlugAuth::Role::Welcome';

# ABSTRACT: Embed a web user interface into your PlugAuth server
our $VERSION = '0.02'; # VERSION


sub init
{
  my($self) = @_;
  
  my $app = $self->app;
  
  my $share_dir = PlugAuth::WebUI->share_dir;
  my $data      = PlugAuth::WebUI->get_data;
  
  push @{ $app->renderer->paths}, $share_dir->subdir('tmpl')->stringify;
  
  $app->routes->route('/ui')->name('plugauth_webui')->get(sub {
    my($c) = @_;
    $data->{plugauth_webui_data}->{api_url} = $c->url_for('index')->to_abs;
    $data->{plugauth_webui_data}->{requires_authentic_credentials} = $app->config->simple_auth(default => '') ? 1 : 0;
    $c->stash($data);
    $c->render( template => 'plugauth_webui' );
  });
  
  $app->routes->route('/ui/:type/#file')->name('plugauth_webui_static')->get(sub {
    my($c) = @_;
    
    my $content_type;
    
    my $type = $c->param('type');
    
    given($type)
    {
      when('css') { $content_type = 'text/css'                 }
      when('js')  { $content_type = 'application/javascript'   }
      when('ico') { $content_type = 'image/vnd.microsoft.icon' }
      when('img') { $content_type = 'image/png';               }
      default { return $c->render_not_found }
    }
    
    my $file = $share_dir->file( $type, $c->param('file') );
    
    if(-r $file)
    {
      $c->res->headers->content_type($content_type);
      my $data = $file->slurp;
      $c->render(data => $data);
    }
    else
    {
      $c->render_not_found;
    }
  });
}

sub welcome
{
  my($self, $c) = @_;
  $c->redirect_to($c->url_for('plugauth_webui'));
}

1;

__END__
=pod

=head1 NAME

PlugAuth::Plugin::WebUI - Embed a web user interface into your PlugAuth server

=head1 VERSION

version 0.02

=head1 SYNOPSIS

Your PlugAuth.conf

 ---
 url: http://localhost:3000
 plugins:
  - PlugAuth::Plugin::WebUI: {}

Start L<PlugAuth>

 % plugauth daemon

and then navigate to the PlugAuth WebUI:

 http://localhost:3000/ui

=head1 DESCRIPTION

This plugin embeds the L<PlugAuth WebUI|PlugAuth::WebUI> into your PlugAuth server,
which can be accessed via the url C</ui>.

=head1 AUTHOR

Graham Ollis <gollis@sesda3>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by NASA GSFC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

