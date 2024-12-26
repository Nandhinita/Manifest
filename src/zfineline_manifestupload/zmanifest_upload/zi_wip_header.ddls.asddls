@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - WIP HEADER'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_WIP_HEADER as select from zwip_header
  composition [0..*] of ZI_ATTACHMENT_TBL as _att
  composition [0..*] of ZI_SUPPLIER_CONF as _itm
  composition [0..*] of ZI_RESPONSELOG as _reslog
{
    key z_uuid as ZUuid,

    z_manifest_id as ZManifestId,
    z_status as ZStatus,
   
    z_doc_type as ZDocType,
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

    cast(
      case
        when z_doc_type = 'SUPPLIER CONFIRMATION' then ''
        else 'X'
      end as abap_boolean
    ) as DerivedField,
   _att,
   _itm,
   _reslog
}
