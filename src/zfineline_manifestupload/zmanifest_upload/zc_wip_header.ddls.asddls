@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - WIP HEADER'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_WIP_HEADER 
  provider contract transactional_query
  as projection on ZI_WIP_HEADER
{
    key ZUuid,
    ZManifestId,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZI_MANIFESTSTATUS', element: 'text'} }]
    ZStatus,   
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZI_DOCUMENTTYPE', element: 'text'} }]
    ZDocType,
    ZCreatedBy,
    ZCreatedAt,
    ZLastChangedBy,
    ZLastChangedAt,
    ZLocalLastChangedAt,

          
DerivedField,
    /* Associations */
   _att: redirected to composition child ZC_ATTACHMENT_TBL,
  _itm: redirected to composition child ZC_SUPPLIER_CONF,
  _reslog: redirected to composition child ZC_RESPONSELOG
}
