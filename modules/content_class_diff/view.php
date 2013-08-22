<?php
/**
 * @package nxcContentClassDiff
 * @author  Serhey Dolgushev <serhey.dolgushev@nxc.no>
 * @date    16 Aug 2012
 **/

$module  = $Params['Module'];
$error   = false;
$compare = false;
$http    = eZHTTPTool::instance();

$isSourceUpdated = false;
$compareOptions  = array();

$currentClassesInfo = array();
$sourceClassesInfo  = array();
$diff               = array();

if( $module->isCurrentAction( 'UpdateSource' ) ) {
	$url = $http->postVariable( 'url' );
	// Extracting htaccess login and password
	preg_match( '|//(.*):(.*)@|', $url, $auth );

	$data = array(
		'Login'       => $http->postVariable( 'login' ),
		'Password'    => $http->postVariable( 'password' ),
		'RedirectURI' => '/content_class_diff/source',
		'LoginButton' => 1
	);
	$params = null;
	foreach( $data as $key => $value ) {
		$params .= $key .'='. urlencode( $value ) . '&';
	}
	$params = rtrim( $params, '&' );

	$cookie = tempnam( '/tmp', 'CURLCOOKIE' );
	$curl   = curl_init();
	curl_setopt( $curl, CURLOPT_RETURNTRANSFER, true );
	curl_setopt( $curl, CURLOPT_FOLLOWLOCATION, true );
	curl_setopt( $curl, CURLOPT_HEADER, true );
	curl_setopt( $curl, CURLOPT_COOKIEJAR, $cookie );
	curl_setopt( $curl, CURLOPT_COOKIEFILE, $cookie );
	curl_setopt( $curl, CURLOPT_USERAGENT, nxcContentClassDiffHelper::$userAgent );
	curl_setopt( $curl, CURLOPT_SSL_VERIFYHOST, false );
	curl_setopt( $curl, CURLOPT_SSL_VERIFYPEER, false );
	curl_setopt( $curl, CURLOPT_CONNECTTIMEOUT, 30 );
	curl_setopt( $curl, CURLOPT_POSTFIELDS, $params );
	curl_setopt( $curl, CURLOPT_URL, $url );
	curl_setopt( $curl, CURLOPT_POST, true );
	if( count( $auth ) > 0 ) {
		curl_setopt( $curl, CURLOPT_USERPWD, $auth[1] . ':' . $auth[2] );
	}

	$response   = curl_exec( $curl );
	$headerSize = curl_getinfo( $curl, CURLINFO_HEADER_SIZE );
	$headers    = substr( $response, 0, $headerSize - 1 );
	$body       = trim( substr( $response, $headerSize ) );

	$doc = @DOMDocument::loadXML( $body );
	if( nxcContentClassDiffHelper::isValidClassesDefinition( $body ) ) {
		$file = eZClusterFileHandler::instance( 'var/class_diff_source.xml' );
		$file->storeContents( $body );

		$isSourceUpdated = true;
	} else {
		$error = ezpI18n::tr( 'extension/nxc_content_class_diff', 'Compare source is not available or does not contain any class definitions' );
	}

	@unlink( $cookie );
} elseif( $module->isCurrentAction( 'Copmare' ) ) {
	$compare        = true;
	$compareOptions = (array) $http->postVariable( 'compare_options' );

	$file = eZClusterFileHandler::instance( 'var/class_diff_source.xml' );
	$sourceClassesDefinition = $file->fetchContents();
	if( nxcContentClassDiffHelper::isValidClassesDefinition( $sourceClassesDefinition ) ) {
		$currentDom = nxcContentClassDiffHelper::getAllClassesXML();
		$sourceDom  = new DOMDocument( '1.0', 'utf-8' );
		$sourceDom->loadXML( $sourceClassesDefinition );

		$currentClassesInfo = nxcContentClassDiffHelper::parseClassesDefinition( $currentDom, $compareOptions );
		$sourceClassesInfo  = nxcContentClassDiffHelper::parseClassesDefinition( $sourceDom, $compareOptions );

		foreach( $currentClassesInfo as $identifier => $classInfo ) {
			if(
				isset( $compareOptions['class_ids'] )
				&& in_array( -1, $compareOptions['class_ids'] ) === false
			) {
				$class = eZContentClass::fetchByIdentifier( $identifier, false );
				if( in_array( $class['id'], $compareOptions['class_ids'], false ) === false ) {
					continue;
				}
			}

			if( isset( $sourceClassesInfo[ $identifier ] ) === false ) {
				$diff[ $identifier ] = $classInfo;
			} elseif( serialize( $classInfo['attributes'] ) != serialize( $sourceClassesInfo[ $identifier ]['attributes'] ) ) {
				$diff[ $identifier ] = $classInfo;
			}
		}
		foreach( $sourceClassesInfo as $identifier => $classInfo ) {
			if(
				isset( $compareOptions['class_ids'] )
				&& in_array( -1, $compareOptions['class_ids'] ) === false
			) {
				$class = eZContentClass::fetchByIdentifier( $identifier, false );
				if( in_array( $class['id'], $compareOptions['class_ids'], false ) === false ) {
					continue;
				}
			}

			if( isset( $currentClassesInfo[ $identifier ] ) === false ) {
				$diff[ $identifier ] = $classInfo;
			} elseif( serialize( $classInfo['attributes'] ) != serialize( $currentClassesInfo[ $identifier ]['attributes'] ) ) {
				$diff[ $identifier ] = $classInfo;
			}
		}
	} else {
		$error = ezpI18n::tr( 'extension/nxc_content_class_diff', 'Could not fetch compare source or it does not contain any class definitions. Please update compare source.' );
	}
}

$tpl = eZTemplate::factory();
$tpl->setVariable( 'classes', eZContentClass::fetchAllClasses( false ) );
$tpl->setVariable( 'compare', $compare );
$tpl->setVariable( 'compare_options', $compareOptions );
$tpl->setVariable( 'error', $error );
$tpl->setVariable( 'is_source_updated', $isSourceUpdated );
if( $compare ) {
	$tpl->setVariable( 'current_classes_info', $currentClassesInfo );
	$tpl->setVariable( 'source_classes_info', $sourceClassesInfo );
	$tpl->setVariable( 'diff', $diff );
}

$Result = array();
$Result['content'] = $tpl->fetch( 'design:compare_classes.tpl' );
$Result['path']    = array(
	array(
		'text' => ezpI18n::tr( 'extension/nxc_content_class_diff', 'Compare content classes' ),
		'url'  => false
	)
);
?>
