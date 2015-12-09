package PlugAuth::Plugin::WebUI;

use strict;
use warnings;
use 5.010001;
use experimental qw( switch );
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
    # FIXME: this comes out wrong when using an ssh tunnel.
    #        woraround was to set to '/' instead
    $data->{plugauth_webui_data}->{api_url} = $c->url_for('index')->to_abs->to_string;
    $data->{plugauth_webui_data}->{requires_authentic_credentials} = ($app->config->simple_auth(default => '') || $app->config->plug_auth(default => '')) ? 1 : 0;
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
  
  if($self->plugin_config->test(default => ''))
  {
    $app->routes->route('/t/:test')->name('plugauth_webui_test')->get(sub {
      my($c) = @_;
      my $test = $c->param('test');
      my $file = $share_dir->file( 't', "$test.js" );
      return $c->render_not_found unless -r $file;
      
      $data->{plugauth_webui_data}->{api_url} = $c->url_for('index')->to_abs;
      $data->{plugauth_webui_data}->{requires_authentic_credentials} = ($app->config->simple_auth(default => '') || $app->config->plug_auth(default => '')) ? 1 : 0;
      $c->stash($data);
      
      $c->stash->{test} = $test;
      if($c->stash->{format} eq 'js')
      {
        $c->res->headers->content_type('application/x-javascript');
        my $data = $file->slurp;
        $c->render(data => $data);
      }
      else
      {
        $c->render( template => 'plugauth_webui_test' );
      }
    });
    
    $app->routes->route('/t')->name('plugauth_webui_test_list')->get(sub {
      my($c) = @_;
      $c->stash->{list} = [ grep { s/\.js$// } map { $_->basename } $share_dir->subdir('t')->children(no_hidden => 1) ];
      $c->render( template => 'plugauth_webui_test_list' );
    });
  }
}

sub welcome
{
  my($self, $c) = @_;
  $c->redirect_to($c->url_for('plugauth_webui'));
}

1;
