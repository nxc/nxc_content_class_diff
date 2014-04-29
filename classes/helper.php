<?php
/**
 * @package nxcContentClassDiff
 * @author  Serhey Dolgushev <serhey.dolgushev@nxc.no>
 * @date    16 Aug 2012
 * */
class nxcContentClassDiffHelper
{

    private function __construct()
    {

    }
    public static $userAgent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1';

    public static function getAllClassesXML()
    {
        $dom               = new DOMDocument('1.0', 'utf-8');
        $dom->formatOutput = true;

        $root = $dom->createElement('classes');
        $dom->appendChild($root);

        $classes = eZContentClass::fetchList();
        foreach ($classes as $class) {
            $classNode = eZContentClassPackageHandler::classDOMTree($class);
            $classNode = $dom->importNode($classNode, true);

            $root->appendChild($classNode);
        }

        return $dom;
    }

    public static function isValidClassesDefinition($xml)
    {
        $dom = @DOMDocument::loadXML($xml);
        if ($dom instanceof DOMDocument) {
            if ((int) $dom->getElementsByTagName('content-class')->length > 0) {
                return true;
            }
        }

        return false;
    }

    public static function parseClassesDefinition(DOMDocument $dom, array $options = null)
    {
        $classes = array();

        $classNodes = $dom->getElementsByTagName('content-class');
        foreach ($classNodes as $classNode) {
            $serializedNameListNode = $classNode->getElementsByTagName('serialized-name-list')->item(0);
            $serializedNameList     = $serializedNameListNode ? $serializedNameListNode->textContent : false;

            $classNameList = new eZContentClassNameList($serializedNameList);
            $classNameList->validate();

            $class = array(
                'name'               => $classNameList->name(),
                'identifier'         => $classNode->getElementsByTagName('identifier')->item(0)->textContent,
                'object_name_patter' => is_object($classNode->getElementsByTagName('object-name-pattern')->item(0)) ? $classNode->getElementsByTagName('object-name-pattern')->item(0)->textContent : null,
                'is_container'       => $classNode->getAttribute('is-container') ==
                'true',
                'attributes'         => array()
            );

            $classAttributesNode = $classNode->getElementsByTagName('attributes')->item(0);
            $classAttributeList  = $classAttributesNode->getElementsByTagName('attribute');
            foreach ($classAttributeList as $classAttributeNode) {
                $attributeSerializedNameListNode    = $classAttributeNode->getElementsByTagName('serialized-name-list')->item(0);
                $attributeSerializedNameListContent = $attributeSerializedNameListNode ? $attributeSerializedNameListNode->textContent : false;
                $attributeSerializedNameList        = new eZSerializedObjectNameList($attributeSerializedNameListContent);
                $attributeSerializedNameList->validate();

                $datatypeParameters     = array();
                $datatypeParameterNodes = $classAttributeNode->getElementsByTagName('datatype-parameters')->item(0)->childNodes;
                if ($datatypeParameterNodes->length > 0) {
                    foreach ($datatypeParameterNodes as $datatypeParameterNode) {
                        if ($datatypeParameterNode instanceof DOMText) {
                            $value = trim($datatypeParameterNode->textContent);
                            if (strlen($value) > 0) {
                                $datatypeParameters[] = $datatypeParameterNode->textContent;
                            }
                        } else {
                            if ($datatypeParameterNode->tagName == 'class-constraints') {
                                $tmp              = array();
                                $classIdentifiers = $classAttributeNode->getElementsByTagName('class-constraint');
                                foreach ($classIdentifiers as $classIdentifier) {
                                    if ($classIdentifier->hasAttribute('class-identifier')) {
                                        $tmp[] = $classIdentifier->getAttribute('class-identifier');
                                    }
                                }
                                asort($tmp);
                                $value = implode(',', $tmp);
                            } else {
                                $value = trim($datatypeParameterNode->textContent);
                            }

                            $datatypeParameters[$datatypeParameterNode->tagName] = $value;
                        }
                    }
                }

                $attribute = array(
                    'name'                  => $attributeSerializedNameList->name(),
                    'identifier'            => $classAttributeNode->getElementsByTagName('identifier')->item(0)->textContent,
                    'placement'             => $classAttributeNode->getElementsByTagName('placement')->item(0)->textContent,
                    'datatype'              => $classAttributeNode->getAttribute('datatype'),
                    'required'              => strtolower($classAttributeNode->getAttribute('required')) ==
                    'true',
                    'searchable'            => strtolower($classAttributeNode->getAttribute('searchable')) ==
                    'true',
                    'information_collector' => strtolower($classAttributeNode->getAttribute('information-collector')) ==
                    'true',
                    'translatable'          => strtolower($classAttributeNode->getAttribute('translatable')) ==
                    'true',
                    'datatype_parameters'   => $datatypeParameters
                );

                if (
                    is_array($options)
                    && count($options) > 0
                ) {
                    foreach ($attribute as $key => $value) {
                        if ($key == 'identifier') {
                            continue;
                        }

                        if (isset($options[$key]) === false) {
                            unset($attribute[$key]);
                        }
                    }
                }

                $class['attributes'][$attribute['identifier']] = $attribute;
            }

            ksort($class['attributes']);

            $classes[$class['identifier']] = $class;
        }

        return $classes;
    }
}
?>
