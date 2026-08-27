<?php
define( 'WP_ADMIN', true );
require_once getenv( 'PLAYGROUND_DOCROOT' ) . '/wp-load.php';

wp_set_current_user( 1 );
switch_theme( 'astra' );

if ( wp_get_theme()->get_stylesheet() !== 'astra' ) {
	fwrite( STDERR, "Failed to activate Astra theme.\n" );
	exit( 1 );
}

echo "Astra theme activated.\n";
