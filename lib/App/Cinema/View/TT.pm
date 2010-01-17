###########################
# Author : Jeff Mo
# Date : 01/04/2009
# Version : 1.0
###########################
package App::Cinema::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    CATALYST_VAR => 'Catalyst',
    INCLUDE_PATH => [
        App::Cinema->path_to( 'root', 'src' ),
        App::Cinema->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0,
    TEMPLATE_EXTENSION => '.tt2',
});

1;

