@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZR_YSO_ATT_E022'
define view entity ZI_ATTACHMENTTBL as select from zattachmenttable
association to parent ZI_WIPHEADER as _hdr
    on $projection.ZUuid = _hdr.ZUuid    
association [0..*] to ZI_SUPPLIERCONF as _orderdetails
on $projection.ZAttUuid = _orderdetails.ZAttUuid
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
    z_created_by as ZCreatedBy,
    z_created_at as ZCreatedAt,
    z_last_changed_by as ZLastChangedBy,
    z_last_changed_at as ZLastChangedAt,
    z_local_last_changed_at as ZLocalLastChangedAt,
    _hdr,
    _orderdetails
}
