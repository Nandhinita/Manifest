@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SUPPLIERCONF as select from zsupplierconf
association [1..1] to ZI_ATTACHMENTTBL as _att
on $projection.ZAttUuid = _att.ZAttUuid
{
   key supplierconf_uuid as SupplierconfUuid,
    
   z_poid as ZPoid,
 
   z_externalref as ZExternalref,
  
   z_poitm_id as ZPoitmId,
  
   z_deliverydate as ZDeliverydate,
  
   z_confirmedqtyunit as ZConfirmedqtyunit,
@Semantics.quantity.unitOfMeasure : 'ZConfirmedqtyunit'  
 @EndUserText.label: 'Confirmed Quantity' 
   z_confirmedqty as ZConfirmedqty,
   z_att_uuid as ZAttUuid,
   z_created_by as ZCreatedBy,
   z_created_at as ZCreatedAt,
   z_last_changed_by as ZLastChangedBy,
   z_last_changed_at as ZLastChangedAt,
   z_local_last_changed_at as ZLocalLastChangedAt,
   _att
}
