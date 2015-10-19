{ezcss_require( array( 'nxc_content_class_diff.css' ) )}

{if $error}
<div class="message-error">
	<h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {$error}</h2>
</div>
{/if}
{if $is_source_updated}
<div class="message-feedback">
	<h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Compare source is updated.'|i18n( 'extension/nxc_content_class_diff' )}</h2>
</div>
{/if}


<form method="post" action="{'/content_class_diff/view'|ezurl( 'no' )}">

	<div class="context-block">

		<div class="box-header"><div class="box-ml">
			<h1 class="context-title">{'Update compare source'|i18n( 'extension/nxc_content_class_diff' )}</h1>
			<div class="header-mainline"></div>
		</div></div>

		<div class="box-ml"><div class="box-mr"><div class="box-content compare-forms">

			<div class="context-attributes">
				<label>{'Login URL'|i18n( 'extension/nxc_content_class_diff' )}:</label>
				<input type="text" name="url" value="http://example.com/user/login" size="128" />
			</div>
			<div class="compare-column-wrapper">
				<div class="context-attributes compare-column">
					<label>{'Login'|i18n( 'extension/nxc_content_class_diff' )}:</label>
					<input type="text" name="login" value="admin" />
				</div>

				<div class="context-attributes compare-column">
					<label>{'Passowrd'|i18n( 'extension/nxc_content_class_diff' )}:</label>
					<input type="text" name="password" value="publish" />
				</div>

                                <div class="context-attributes compare-column">
                                        <label>{'Siteaccess'|i18n( 'extension/nxc_content_class_diff' )}:</label>
                                        <input type="text" name="siteaccess" value="" />
                                </div>
			</div>


		</div></div></div>

	</div>

	<div class="controlbar">
		<div class="box-bc"><div class="box-ml"><div class="block">
			<input class="button" type="submit" value="{'Update'|i18n( 'extension/nxc_content_class_diff' )}" name="UpdateSourceButton" />
		</div></div></div>
	</div>

</form>

{def $default_options = hash(
	'name', 'Name',
	'placement', 'Placement',
	'datatype', 'Datatype',
	'required', 'Is required',
	'searchable', 'Is searchable',
	'information_collector', 'Is information collector',
	'translatable', 'Is translatable',
	'datatype_parameters', 'Datatype parameters'
)}
<form method="post" action="{'/content_class_diff/view'|ezurl( 'no' )}">

	<div class="context-block">
		<div class="box-header"><div class="box-ml">
			<h1 class="context-title">{'Compare classes'|i18n( 'extension/nxc_content_class_diff' )}</h1>
		</div></div>
		<div class="compare-column-wrapper">
			<div class="compare-column">
				<p><b>{'Classes to compare'|i18n( 'extension/nxc_content_class_diff' )}:</b></p>
				<select name="compare_options[class_ids][]" multiple="multiple" size="10">
					<option value="-1" {if and( eq( $compare, true() ), $compare_options['class_ids']|contains( -1 ) )}selected="$class['id']"{/if}>{'All'|i18n( 'extension/nxc_content_class_diff' )}</option>
					{foreach $classes as $class}
					<option value="{$class['id']}" {if and( eq( $compare, true() ), $compare_options['class_ids']|contains( $class['id'] ) )}selected="$class['id']"{/if}>{$class['name']}</option>
					{/foreach}
				</select>
			</div>
			<div class="compare-column">
				<p><b>{'Options'|i18n( 'extension/nxc_content_class_diff' )}:</b></p>
				<ul style="list-style: none;">
					{foreach $default_options as $option => $name}
					<li><input type="checkbox" name="compare_options[{$option}]" value="1" {if or( eq( $compare, false() ), is_set( $compare_options[ $option ] ) )}checked="checked"{/if}/>{$name|i18n( 'extension/nxc_content_class_diff' )}</li>
					{/foreach}
				</ul>
			</div>
		</div>
	</div>

	<div class="controlbar">
		<div class="box-bc"><div class="box-ml"><div class="block">
			<input class="button" type="submit" value="{'Compare'|i18n( 'extension/nxc_content_class_diff' )}" name="CopmareButton" />
		</div></div></div>
	</div>

</form>
{undef $default_options}

{if and( $compare, eq( $error, false() ) )}
<div class="context-block">

	<div class="box-header"><div class="box-ml">
		<h1 class="context-title">{'Compare results'|i18n( 'extension/nxc_content_class_diff' )}</h1>
		<div class="header-mainline"></div>
	</div></div>

	<div class="box-bc compare-results"><div class="box-ml"><div class="box-content">

		{foreach $diff as $identifier => $classInfo}
        {if false()}
            {continue}
        {/if}
		<table class="list cache" cellspacing="0">

			<tr>
			    <th width="50%">{$classInfo['name']} ({$classInfo['identifier']})</th>
			    <th width="50%"></th>
			</tr>

			{if eq( is_set( $current_classes_info[ $classInfo['identifier'] ] ), false() )}
			<tr class="bglight">
			    <td>{'Does not exist at the current installation'|i18n( 'extension/nxc_content_class_diff' )}</td>
			    <td></td>
			</tr>
			{elseif eq( is_set( $source_classes_info[ $classInfo['identifier'] ] ), false() )}
			<tr class="bglight">
			    <td>{'Does not exist at the source installation'|i18n( 'extension/nxc_content_class_diff' )}</td>
			    <td></td>
			</tr>
			{else}
				{foreach $current_classes_info[ $classInfo['identifier'] ]['attributes'] as $attr_identifier => $attributeInfo}
					{if ne(
						serialize( $current_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ] ),
						serialize( $source_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ] )
					)}
					<tr class="bglight">
					    <td class="attribute-name" colspan="2">{if is_set( $attributeInfo['name'] )}{$attributeInfo['name']}{/if} ({$attributeInfo['identifier']})</td>
					</tr>
					<tr class="bgdark">
						<td>
							{include
								uri='design:class_attribute_info.tpl'
								attribute=$current_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ]
								compare_options=$compare_options
							}
						</td>
						<td>
							{if eq( is_set( $source_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ] ), false() )}
							{'Does not contain this attribute'|i18n( 'extension/nxc_content_class_diff' )}
							{else}
							{include
								uri='design:class_attribute_info.tpl'
								attribute=$source_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ]
								compare_options=$compare_options
							}
							{/if}
						</td>
					</tr>
					{/if}
				{/foreach}

				{foreach $source_classes_info[ $classInfo['identifier'] ]['attributes'] as $attr_identifier => $attributeInfo}
					{if and(
						eq( is_set( $current_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ] ), false() ),
						ne(
							serialize( $current_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ] ),
							serialize( $source_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ] )
						)
					)}
					<tr class="bglight">
					    <td class="attribute-name" colspan="2">{if is_set( $attributeInfo['name'] )}{$attributeInfo['name']}{/if} ({$attributeInfo['identifier']})</td>
					</tr>
					<tr class="bgdark">
						<td>
							{if eq( is_set( $current_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ] ), false() )}
							{'Does not contain this attribute'|i18n( 'extension/nxc_content_class_diff' )}
							{else}
							{include
								uri='design:class_attribute_info.tpl'
								attribute=$current_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ]
								compare_options=$compare_options
							}
							{/if}
						</td>
						<td>
							{include
								uri='design:class_attribute_info.tpl'
								attribute=$source_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ]
								compare_options=$compare_options
							}
						</td>
					</tr>
					{/if}
				{/foreach}

			{/if}

		</table>
		<div class="break"></div>
		{/foreach}

	</div></div></div>
</div>
{/if}
