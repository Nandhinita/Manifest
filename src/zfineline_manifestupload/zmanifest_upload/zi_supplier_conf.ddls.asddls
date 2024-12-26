@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Supplier Confirmation'
@Metadata.ignorePropagatedAnnotations: true


define view entity ZI_SUPPLIER_CONF as select from zsupplier_conf
association to parent ZI_WIP_HEADER as _hdr
    on $projection.ZUuid = _hdr.ZUuid

{
   key supplierconf_uuid as SupplierconfUuid,
    
    z_poid  as ZPoid,
 
    z_externalref  as ZExternalref,
  
    z_poitm_id  as ZPoitmId,
  
z_poconfdate as ZPOConfdate,
    z_status_c as Z_Status,                     //Group Field

    z_confirmedqtyunit  as ZConfirmedqtyunit,
@Semantics.quantity.unitOfMeasure : 'ZConfirmedqtyunit'  
 @EndUserText.label: 'Confirmed Quantity' 
    z_confirmedqty  as ZConfirmedqty,
   z_uuid  as ZUuid,
 z_attuuid as ZAttuuid,

z_itmid as ZItmID,
   z_delayreason  as ZDelayreason,
   z_wipstatus  as ZWipstatus,
   z_wippreviousstatus  as ZWippreviousstatus,
   z_vendor_pn  as ZVendorPn,
   z_plant  as ZPlant,
   z_activity1_desc  as ZActivity1Desc,
 z_activity1_remainddate as ZAct1remainddate,
 z_activity1_reqdate as ZAct1reqdate,
   z_activity4_desc  as ZActivity4Desc,
z_activity4_remainddate as ZAct4remainddate,
z_activity4_reqdate as ZAct4reqdate,
z_lasteq_startdate as ZLasteqstartdate,
z_lasteq_enddate as ZLasteqenddate,
z_lastcq_startdate as ZLastcqstartdate,
z_lastcq_enddate as ZLastcqenddate,
   z_noof_crm_eq as ZNoofCrmEq,
   z_multipleitmmatch as ZMultipleitmmatch,
   z_xfor_reviewed as ZXforReviewed,
   z_logistic_remainddate as ZLogisticRemainddate,
   z_logistic_remaindnote as ZLogisticRemaindnote,
   z_eq_engineername as ZEqEngineername,
   z_cq_ownername as ZCqOwnername,
   z_material as ZMaterial,
   z_firstagent as ZFirstagent,
   z_firstcustomer as ZFirstcustomer,

   @Aggregation.default: #NONE
  
z_status as ZStatus,
   @Aggregation.default: #NONE
z_comment as ZComment,

       @Semantics.user.createdBy: true
     z_created_by  as ZCreatedBy,
    @Semantics.systemDateTime.createdAt: true
     z_created_at  as ZCreatedAt,
    @Semantics.user.localInstanceLastChangedBy: true
     z_last_changed_by  as ZLastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
     z_last_changed_at  as ZLastChangedAt,
@Semantics.systemDateTime.lastChangedAt: true 
 z_local_last_changed_at  as ZLocalLastChangedAt,
   _hdr
}

