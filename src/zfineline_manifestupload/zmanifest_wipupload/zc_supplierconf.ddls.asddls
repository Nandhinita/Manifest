@EndUserText.label: 'Consumption - Supplier Confirmation'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_SUPPLIERCONF 
provider contract transactional_query
as projection on ZI_SUPPLIERCONF
{
    key SupplierconfUuid,
    ZPoid,
    ZExternalref,
    ZPoitmId,
    ZDeliverydate,
    ZConfirmedqtyunit,
    ZConfirmedqty,
    ZAttUuid,
    ZCreatedBy,
    ZCreatedAt,
    ZLastChangedBy,
    ZLastChangedAt,
    ZLocalLastChangedAt,
    /* Associations */
    _att: redirected to ZC_ATTACHMENTTBL
}
