{if is_set( $compare_options['name'] )}
<div class="block">
    <label>{'Name'|i18n( 'extension/nxc_content_class_diff' )}:</label>
    {$attribute['name']}
</div>
{/if}

{if is_set( $compare_options['placement'] )}
<div class="block">
    <label>{'Placement'|i18n( 'extension/nxc_content_class_diff' )}:</label>
    {$attribute['placement']}
</div>
{/if}

{if is_set( $compare_options['datatype'] )}
<div class="block">
    <label>{'Datatype'|i18n( 'extension/nxc_content_class_diff' )}:</label>
    {$attribute['datatype']}
</div>
{/if}

{if is_set( $compare_options['required'] )}
<div class="block">
    <label>{'Is required'|i18n( 'extension/nxc_content_class_diff' )}:</label>
    {if $attribute['required']}{'Yes'|i18n( 'extension/nxc_content_class_diff' )}{else}{'No'|i18n( 'extension/nxc_content_class_diff' )}{/if}
</div>
{/if}

{if is_set( $compare_options['searchable'] )}
<div class="block">
    <label>{'Is searchable'|i18n( 'extension/nxc_content_class_diff' )}:</label>
    {if $attribute['searchable']}{'Yes'|i18n( 'extension/nxc_content_class_diff' )}{else}{'No'|i18n( 'extension/nxc_content_class_diff' )}{/if}
</div>
{/if}

{if is_set( $compare_options['information_collector'] )}
<div class="block">
    <label>{'Is information collector'|i18n( 'extension/nxc_content_class_diff' )}:</label>
    {if $attribute['information_collector']}{'Yes'|i18n( 'extension/nxc_content_class_diff' )}{else}{'No'|i18n( 'extension/nxc_content_class_diff' )}{/if}
</div>
{/if}

{if is_set( $compare_options['translatable'] )}
<div class="block">
    <label>{'Is translatable'|i18n( 'extension/nxc_content_class_diff' )}:</label>
    {if $attribute['translatable']}{'Yes'|i18n( 'extension/nxc_content_class_diff' )}{else}{'No'|i18n( 'extension/nxc_content_class_diff' )}{/if}
</div>
{/if}

{if is_set( $compare_options['datatype_parameters'] )}
<div class="block">
    <label>{'Datatype parameters'|i18n( 'extension/nxc_content_class_diff' )}:</label>
    {if gt( $attribute['datatype_parameters']|count(), 0 )}
    <ul>
    	{foreach $attribute['datatype_parameters'] as $key => $value}
   		<li>{$key}: {$value}</li>
    	{/foreach}
    </ul>
    {/if}
</div>
{/if}