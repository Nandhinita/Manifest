@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Response Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_RESPONSELOG as select from zresponselog
association to parent ZI_WIP_HEADER as _hdr
    on $projection.ZUuid = _hdr.ZUuid
{
    key z_log_uuid as ZLogUuid,
    z_log_id as ZLogId,
    z_log_text as ZLogText,
   zuuid as ZUuid,
    z_log_createdon as ZLogCreatedon,
    z_created_by as ZCreatedBy,
    z_created_at as ZCreatedAt,
    z_last_changed_by as ZLastChangedBy,
    z_last_changed_at as ZLastChangedAt,
    z_local_last_changed_at as ZLocalLastChangedAt,
    _hdr
}
