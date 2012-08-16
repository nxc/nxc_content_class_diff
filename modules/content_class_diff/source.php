<?php
/**
 * @package nxcContentClassDiff
 * @author  Serhey Dolgushev <serhey.dolgushev@nxc.no>
 * @date    16 Aug 2012
 **/

$dom = nxcContentClassDiffHelper::getAllClassesXML();

header( 'Content-Type: text/xml' );
echo $dom->saveXML();

eZExecution::cleanExit();
?>
