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

		<div class="box-ml"><div class="box-mr"><div class="box-content">

			<div class="context-attributes">
				<label>{'Login URL'|i18n( 'extension/nxc_content_class_diff' )}:</label>
				<input type="text" name="url" value="http://example.com/user/login" size="128" />
			</div>

			<div class="context-attributes">
				<label>{'Login'|i18n( 'extension/nxc_content_class_diff' )}:</label>
				<input type="text" name="login" value="admin" />
			</div>

			<div class="context-attributes">
				<label>{'Passowrd'|i18n( 'extension/nxc_content_class_diff' )}:</label>
				<input type="text" name="password" value="publish" />
			</div>

		</div></div></div>

	</div>

	<div class="controlbar">
		<div class="box-bc"><div class="box-ml"><div class="block">
			<input class="button" type="submit" value="{'Update'|i18n( 'extension/nxc_content_class_diff' )}" name="UpdateSourceButton" />
		</div></div></div>
	</div>

</form>

{if eq( $compare, false() )}
<form method="post" action="{'/content_class_diff/view'|ezurl( 'no' )}">

	<div class="context-block">
		<div class="box-header"><div class="box-ml">
			<h1 class="context-title">{'Compare classes'|i18n( 'extension/nxc_content_class_diff' )}</h1>
			<div class="header-mainline"></div>
		</div></div>
	</div>

	<div class="controlbar">
		<div class="box-bc"><div class="box-ml"><div class="block">
			<input class="button" type="submit" value="{'Compare'|i18n( 'extension/nxc_content_class_diff' )}" name="CopmareButton" />
		</div></div></div>
	</div>

</form>
{/if}

{if and( $compare, eq( $error, false() ) )}
<div class="context-block">

	<div class="box-header"><div class="box-ml">
		<h1 class="context-title">{'Compare results'|i18n( 'extension/nxc_content_class_diff' )}</h1>
		<div class="header-mainline"></div>
	</div></div>

	<div class="box-bc"><div class="box-ml"><div class="box-content">

		{foreach $diff as $identifier => $classInfo}
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
					    <td>{$attributeInfo['name']} ({$attributeInfo['identifier']})</td>
					    <td></th>
					</tr>
					<tr class="bgdark">
						<td>
							{include
								uri='design:class_attribute_info.tpl'
								attribute=$current_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ]
							}
						</td>
						<td>
							{if eq( is_set( $source_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ] ), false() )}
							{'Does not contain this attribute'|i18n( 'extension/nxc_content_class_diff' )}
							{else}
							{include
								uri='design:class_attribute_info.tpl'
								attribute=$source_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ]
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
					    <td>{$attributeInfo['name']} ({$attributeInfo['identifier']})</td>
					    <td></th>
					</tr>
					<tr class="bgdark">
						<td>
							{if eq( is_set( $current_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ] ), false() )}
							{'Does not contain this attribute'|i18n( 'extension/nxc_content_class_diff' )}
							{else}
							{include
								uri='design:class_attribute_info.tpl'
								attribute=$current_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ]
							}
							{/if}
						</td>
						<td>
							{include
								uri='design:class_attribute_info.tpl'
								attribute=$source_classes_info[ $classInfo['identifier'] ]['attributes'][ $attr_identifier ]
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

<form method="post" action="{'/content_class_diff/view'|ezurl( 'no' )}">
	<div class="controlbar">
		<div class="box-bc"><div class="box-ml"><div class="block">
			<input class="button" type="submit" value="{'Compare again'|i18n( 'extension/nxc_content_class_diff' )}" name="CopmareButton" />
		</div></div></div>
	</div>
</form>
{/if}