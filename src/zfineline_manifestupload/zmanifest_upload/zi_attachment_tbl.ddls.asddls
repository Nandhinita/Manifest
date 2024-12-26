@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Attachment Table'
define view entity ZI_ATTACHMENT_TBL as select from zattachment_tbl
association to parent ZI_WIP_HEADER as _hdr
    on $projection.ZUuid = _hdr.ZUuid
{
    key z_att_uuid as ZAttUuid,
    z_uuid as ZUuid,
    z_att_id as ZAttId,
    @Semantics.largeObject: 
    { 
        mimeType: 'ZMimetype', 
        fileName: 'ZFilename', 
        acceptableMimeTypes: [ 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ],
        contentDispositionPreference: #INLINE 
    }
    z_file as ZFile,
    z_filename as ZFilename,
    @Semantics.mimeType: true
    z_mimetype as ZMimetype,    
    z_consistency_status as Zconsistencystatus,
    z_status as Zstatus,
    @Semantics.user.createdBy: true
    z_created_by as ZCreatedBy,
    @Semantics.systemDateTime.createdAt: true
    z_created_at as ZCreatedAt,
    @Semantics.user.localInstanceLastChangedBy: true
    z_last_changed_by as ZLastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    z_last_changed_at as ZLastChangedAt,
@Semantics.systemDateTime.lastChangedAt: true 
z_local_last_changed_at as ZLocalLastChangedAt,
    _hdr
}
