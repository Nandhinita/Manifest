@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Attachment Table'

@Metadata.allowExtensions: true
define view entity ZC_ATTACHMENT_TBL as projection on ZI_ATTACHMENT_TBL
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
    /* Associations */
    _hdr : redirected to parent ZC_WIP_HEADER
}
