package PlugAuth::Plugin::WebUI;

use strict;
use warnings;
use v5.10;
use PlugAuth::WebUI;
use Role::Tiny::With;

with 'PlugAuth::Role::Plugin';
with 'PlugAuth::Role::Welcome';

# ABSTRACT: Embed a web user interface into your PlugAuth server
# VERSION

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

=cut

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
