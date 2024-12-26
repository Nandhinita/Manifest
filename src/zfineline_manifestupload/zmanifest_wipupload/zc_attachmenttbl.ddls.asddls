@EndUserText.label: 'ZC_YSO_ATT_E022'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_ATTACHMENTTBL
 as projection on ZI_ATTACHMENTTBL
{
    key ZAttUuid,
    ZUuid,
    ZAttId,
    ZFile,
    ZFilename,
    ZMimetype,
    Zconsistencystatus,
    Zstatus,
    ZCreatedBy,
    ZCreatedAt,
    ZLastChangedBy,
    ZLastChangedAt,
    ZLocalLastChangedAt,
     _hdr: redirected to parent ZC_WIPHEADER,
    _orderdetails: redirected to ZC_SUPPLIERCONF
}
