@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Consumption - WIP HEADER'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_WIPHEADER
  provider contract transactional_query
  as projection on ZI_WIPHEADER
{
    key ZUuid,
    ZManifestId,
    ZStatus,
    ZDocType,
    ZCreatedBy,
    ZCreatedAt,
    ZLastChangedBy,
    ZLastChangedAt,
    ZLocalLastChangedAt,
    /* Associations */
    _att: redirected to composition child ZC_ATTACHMENTTBL
}
