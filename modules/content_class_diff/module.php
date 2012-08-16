<?php
/**
 * @package nxcContentClassDiff
 * @author  Serhey Dolgushev <serhey.dolgushev@nxc.no>
 * @date    16 Aug 2012
 **/

$Module = array(
	'name'            => 'Copmare content classes',
 	'variable_params' => true
);

$ViewList = array(
	'view' => array(
		'functions'               => array( 'view' ),
		'script'                  => 'view.php',
		'params'                  => array(),
		'default_navigation_part' => 'ezsetupnavigationpart',
		'single_post_actions'     => array(
			'UpdateSourceButton' => 'UpdateSource',
			'CopmareButton'      => 'Copmare'
		)
	),
	'source' => array(
		'functions' => array( 'source' ),
		'script'    => 'source.php'
	)
);

$FunctionList = array(
	'view'   => array(),
	'source' => array()
);
?>
