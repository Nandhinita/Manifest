@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Supplier Confirmation'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZC_SUPPLIER_CONF as projection on ZI_SUPPLIER_CONF

{
    key SupplierconfUuid,
    ZPoid,
    ZExternalref,
    ZPoitmId,
  
    ZConfirmedqtyunit,
    @Semantics.quantity.unitOfMeasure : 'ZConfirmedqtyunit'  
    ZConfirmedqty,
    ZUuid,
  ZComment,
  Z_Status,
  ZItmID,
  ZPOConfdate,
   @Aggregation.default: #NONE
  ZStatus,
  ZAttuuid,
    ZDelayreason,
    ZWipstatus,
    ZWippreviousstatus,
    ZVendorPn,
    ZPlant,
    ZActivity1Desc,
  ZAct1remainddate,
  ZAct1reqdate,
    ZActivity4Desc,
   ZAct4remainddate,
   ZAct4reqdate,
   ZLastcqenddate,
   ZLastcqstartdate,
   ZLasteqenddate,
   ZLasteqstartdate,
    ZNoofCrmEq,
    ZMultipleitmmatch,
    ZXforReviewed,
    ZLogisticRemainddate,
    ZLogisticRemaindnote,
    ZEqEngineername,
    ZCqOwnername,
  ZMaterial,
    ZFirstagent,
    ZFirstcustomer,
   

    ZCreatedBy,
    ZCreatedAt,
    ZLastChangedBy,
    ZLastChangedAt,
    ZLocalLastChangedAt,
    /* Associations */
    _hdr: redirected to parent ZC_WIP_HEADER
   
}
