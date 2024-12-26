@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface - WIP HEADER'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_WIPHEADER as select from zwipheader_tbl
composition [0..*] of ZI_ATTACHMENTTBL as _att
{
    key z_uuid as ZUuid,
  
    z_manifest_id as ZManifestId,
    
    z_status as ZStatus,
   
    z_doc_type as ZDocType,
    z_created_by as ZCreatedBy,
    z_created_at as ZCreatedAt,
    z_last_changed_by as ZLastChangedBy,
    z_last_changed_at as ZLastChangedAt,
    z_local_last_changed_at as ZLocalLastChangedAt,
    _att
}
