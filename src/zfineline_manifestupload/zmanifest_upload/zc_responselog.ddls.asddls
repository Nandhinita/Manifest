@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Response Log'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_RESPONSELOG as projection on ZI_RESPONSELOG

{
    key ZLogUuid,
    ZLogId,
    ZLogText,
 ZUuid,
    ZLogCreatedon,
    ZCreatedBy,
    ZCreatedAt,
    ZLastChangedBy,
    ZLastChangedAt,
    ZLocalLastChangedAt,
    _hdr: redirected to parent ZC_WIP_HEADER
    }
