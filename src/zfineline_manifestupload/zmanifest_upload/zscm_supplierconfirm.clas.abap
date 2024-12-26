"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>com.sap.gateway.srvd_a2x.api_supplierconfirmation.v0001</em>
CLASS zscm_supplierconfirm DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">Types for primitive collection fields</p>
      BEGIN OF tys_types_for_prim_colls,
        "! additionalTargets
        "! Used for TYS_SAP_MESSAGE-ADDITIONAL_TARGETS
        additional_targets TYPE string,
      END OF tys_types_for_prim_colls.

    TYPES:
      "! <p class="shorttext synchronized">Value Control Structure of SAP_MESSAGE</p>
      BEGIN OF tys_value_controls_1,
        "! TARGET
        target       TYPE /iwbep/v4_value_control,
        "! LONGTEXT_URL
        longtext_url TYPE /iwbep/v4_value_control,
      END OF tys_value_controls_1.

    TYPES:
      "! <p class="shorttext synchronized">SAP__Message</p>
      BEGIN OF tys_sap_message,
        "! <em>Value Control Structure</em>
        value_controls     TYPE tys_value_controls_1,
        "! code
        code               TYPE string,
        "! message
        message            TYPE string,
        "! target
        target             TYPE string,
        "! additionalTargets
        additional_targets TYPE STANDARD TABLE OF tys_types_for_prim_colls-additional_targets WITH DEFAULT KEY,
        "! transition
        transition         TYPE abap_bool,
        "! numericSeverity
        numeric_severity   TYPE int1,
        "! longtextUrl
        longtext_url       TYPE string,
      END OF tys_sap_message,
      "! <p class="shorttext synchronized">List of SAP__Message</p>
      tyt_sap_message TYPE STANDARD TABLE OF tys_sap_message WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">Value Control Structure of A_SUPPLIER_CONFIRMATION_TY</p>
      BEGIN OF tys_value_controls_2,
        "! LAST_CHANGE_DATE_TIME
        last_change_date_time      TYPE /iwbep/v4_value_control,
        "! CREATION_DATE
        creation_date              TYPE /iwbep/v4_value_control,
        "! SUPPLIER_CONFIRMATION_ITEM
        supplier_confirmation_item TYPE /iwbep/v4_value_control,
      END OF tys_value_controls_2.

    TYPES:
      "! <p class="shorttext synchronized">Value Control Structure of A_SUPPLIER_CONFIRMATION_LI</p>
      BEGIN OF tys_value_controls_3,
        "! DELIVERY_DATE
        delivery_date              TYPE /iwbep/v4_value_control,
        "! PERFORMANCE_PERIOD_START_D
        performance_period_start_d TYPE /iwbep/v4_value_control,
        "! PERFORMANCE_PERIOD_END_DAT
        performance_period_end_dat TYPE /iwbep/v4_value_control,
        "! HANDOVER_DATE
        handover_date              TYPE /iwbep/v4_value_control,
        "! SUPPLIER_CONFIRMATION_TP
        supplier_confirmation_tp   TYPE /iwbep/v4_value_control,
      END OF tys_value_controls_3.

    TYPES:
      "! <p class="shorttext synchronized">Value Control Structure of A_SUPPLIER_CONFIRMATION_IT</p>
      BEGIN OF tys_value_controls_4,
        "! SUPPLIER_CONFIRMATION_LINE
        supplier_confirmation_line TYPE /iwbep/v4_value_control,
      END OF tys_value_controls_4.

    TYPES:
      "! <p class="shorttext synchronized">A_SupplierConfirmationItem_Type</p>
      BEGIN OF tys_a_supplier_confirmation_it,
        "! <em>Value Control Structure</em>
        value_controls             TYPE tys_value_controls_4,
        "! <em>Key property</em> SupplierConfirmation
        supplier_confirmation      TYPE c LENGTH 10,
        "! <em>Key property</em> SupplierConfirmationItem
        supplier_confirmation_item TYPE c LENGTH 5,
        "! SuplrConfRefPurchaseOrder
        suplr_conf_ref_purchase_or TYPE c LENGTH 10,
        "! SuplrConfRefPurchaseOrderItem
        suplr_conf_ref_purchase__2 TYPE c LENGTH 5,
        "! SuplrConfItemExternalReference
        suplr_conf_item_external_r TYPE c LENGTH 70,
        "! SupplierConfirmedNetPrice
        supplier_confirmed_net_pri TYPE decfloat16,
        "! DocumentCurrency
        document_currency          TYPE c LENGTH 3,
        "! ItemIsRejectedBySupplier
        item_is_rejected_by_suppli TYPE abap_bool,
        "! SupplierOrderAcknNumber
        supplier_order_ackn_number TYPE c LENGTH 20,
        "! SuplrConfNetPriceQuantity
        suplr_conf_net_price_quant TYPE p LENGTH 3 DECIMALS 0,
        "! SuplrConfOrderPriceUnit
        suplr_conf_order_price_uni TYPE c LENGTH 3,
        "! SAP__Messages
        sap_messages               TYPE tyt_sap_message,
        "! odata.etag
        etag                       TYPE string,
      END OF tys_a_supplier_confirmation_it,
      "! <p class="shorttext synchronized">List of A_SupplierConfirmationItem_Type</p>
      tyt_a_supplier_confirmation_it TYPE STANDARD TABLE OF tys_a_supplier_confirmation_it WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_SupplierConfirmationLine_Type</p>
      BEGIN OF tys_a_supplier_confirmation_li,
        "! <em>Value Control Structure</em>
        value_controls             TYPE tys_value_controls_3,
        "! <em>Key property</em> SupplierConfirmation
        supplier_confirmation      TYPE c LENGTH 10,
        "! <em>Key property</em> SupplierConfirmationItem
        supplier_confirmation_item TYPE c LENGTH 5,
        "! <em>Key property</em> SupplierConfirmationLine
        supplier_confirmation_line TYPE c LENGTH 4,
        "! DeliveryDate
        delivery_date              TYPE datn,
        "! DelivDateCategory
        deliv_date_category        TYPE c LENGTH 1,
        "! DeliveryTime
        delivery_time              TYPE timn,
        "! ConfirmedQuantity
        confirmed_quantity         TYPE p LENGTH 7 DECIMALS 3,
        "! PurchaseOrderQuantityUnit
        purchase_order_quantity_un TYPE c LENGTH 3,
        "! SupplierConfirmationExtNumber
        supplier_confirmation_ext  TYPE c LENGTH 35,
        "! PerformancePeriodStartDate
        performance_period_start_d TYPE datn,
        "! PerformancePeriodEndDate
        performance_period_end_dat TYPE datn,
        "! ServicePerformer
        service_performer          TYPE c LENGTH 10,
        "! ExpectedOverallLimitAmount
        expected_overall_limit_amo TYPE decfloat16,
        "! DocumentCurrency
        document_currency          TYPE c LENGTH 3,
        "! ManufacturerMaterial
        manufacturer_material      TYPE c LENGTH 18,
        "! StockSegment
        stock_segment              TYPE c LENGTH 40,
        "! HandoverDate
        handover_date              TYPE datn,
        "! HandoverTime
        handover_time              TYPE timn,
        "! SAP__Messages
        sap_messages               TYPE tyt_sap_message,
        "! odata.etag
        etag                       TYPE string,
      END OF tys_a_supplier_confirmation_li,
      "! <p class="shorttext synchronized">List of A_SupplierConfirmationLine_Type</p>
      tyt_a_supplier_confirmation_li TYPE STANDARD TABLE OF tys_a_supplier_confirmation_li WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">A_SupplierConfirmation_Type</p>
      BEGIN OF tys_a_supplier_confirmation_ty,
        "! <em>Value Control Structure</em>
        value_controls             TYPE tys_value_controls_2,
        "! <em>Key property</em> SupplierConfirmation
        supplier_confirmation      TYPE c LENGTH 10,
        "! SuplrConfRefPurchaseOrder
        suplr_conf_ref_purchase_or TYPE c LENGTH 10,
        "! SuplrConfProcessingStatus
        suplr_conf_processing_stat TYPE c LENGTH 2,
        "! SuplrConfExternalReference
        suplr_conf_external_refere TYPE c LENGTH 70,
        "! LastChangeDateTime
        last_change_date_time      TYPE timestampl,
        "! CreationDate
        creation_date              TYPE datn,
        "! SAP__Messages
        sap_messages               TYPE tyt_sap_message,
        "! odata.etag
        etag                       TYPE string,
      END OF tys_a_supplier_confirmation_ty,
      "! <p class="shorttext synchronized">List of A_SupplierConfirmation_Type</p>
      tyt_a_supplier_confirmation_ty TYPE STANDARD TABLE OF tys_a_supplier_confirmation_ty WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! Confirmation
        "! <br/> Collection of type 'A_SupplierConfirmation_Type'
        confirmation      TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'CONFIRMATION',
        "! ConfirmationItem
        "! <br/> Collection of type 'A_SupplierConfirmationItem_Type'
        confirmation_item TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'CONFIRMATION_ITEM',
        "! ConfirmationLine
        "! <br/> Collection of type 'A_SupplierConfirmationLine_Type'
        confirmation_line TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'CONFIRMATION_LINE',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for complex types</p>
      BEGIN OF gcs_complex_type,
        "! <p class="shorttext synchronized">Internal names for SAP__Message</p>
        "! See also structure type {@link ..tys_sap_message}
        BEGIN OF sap_message,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF sap_message,
      END OF gcs_complex_type.

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for A_SupplierConfirmationItem_Type</p>
        "! See also structure type {@link ..tys_a_supplier_confirmation_it}
        BEGIN OF a_supplier_confirmation_it,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! _SupplierConfirmationLineTP
            supplier_confirmation_line TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'SUPPLIER_CONFIRMATION_LINE',
            "! _SupplierConfirmationTP
            supplier_confirmation_tp   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'SUPPLIER_CONFIRMATION_TP',
          END OF navigation,
        END OF a_supplier_confirmation_it,
        "! <p class="shorttext synchronized">Internal names for A_SupplierConfirmationLine_Type</p>
        "! See also structure type {@link ..tys_a_supplier_confirmation_li}
        BEGIN OF a_supplier_confirmation_li,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! _SupplierConfirmationItemTP
            supplier_confirmation_it_2 TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'SUPPLIER_CONFIRMATION_IT_2',
            "! _SupplierConfirmationTP
            supplier_confirmation_tp   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'SUPPLIER_CONFIRMATION_TP',
          END OF navigation,
        END OF a_supplier_confirmation_li,
        "! <p class="shorttext synchronized">Internal names for A_SupplierConfirmation_Type</p>
        "! See also structure type {@link ..tys_a_supplier_confirmation_ty}
        BEGIN OF a_supplier_confirmation_ty,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! _SupplierConfirmationItemTP
            supplier_confirmation_item TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'SUPPLIER_CONFIRMATION_ITEM',
          END OF navigation,
        END OF a_supplier_confirmation_ty,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define SAP__Message</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_sap_message RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_SupplierConfirmationItem_Type</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_supplier_confirmation_it RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_SupplierConfirmationLine_Type</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_supplier_confirmation_li RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define A_SupplierConfirmation_Type</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_a_supplier_confirmation_ty RAISING /iwbep/cx_gateway.

ENDCLASS.


CLASS zscm_supplierconfirm IMPLEMENTATION.

  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'com.sap.gateway.srvd_a2x.api_supplierconfirmation.v0001' ) ##NO_TEXT.

    def_sap_message( ).
    def_a_supplier_confirmation_it( ).
    def_a_supplier_confirmation_li( ).
    def_a_supplier_confirmation_ty( ).

  ENDMETHOD.


  METHOD def_sap_message.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_complex_type        TYPE REF TO /iwbep/if_v4_pm_cplx_type,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_complex_type = mo_model->create_complex_type_by_struct(
                                    iv_complex_type_name      = 'SAP_MESSAGE'
                                    is_structure              = VALUE tys_sap_message( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_complex_type->set_edm_name( 'SAP__Message' ) ##NO_TEXT.
    lo_complex_type->create_complex_prop_for_vcs( 'VALUE_CONTROLS' ).


    lo_primitive_property = lo_complex_type->get_primitive_property( 'CODE' ).
    lo_primitive_property->set_edm_name( 'code' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.

    lo_primitive_property = lo_complex_type->get_primitive_property( 'MESSAGE' ).
    lo_primitive_property->set_edm_name( 'message' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.

    lo_primitive_property = lo_complex_type->get_primitive_property( 'TARGET' ).
    lo_primitive_property->set_edm_name( 'target' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->create_vcs_value_control( ).

    lo_primitive_property = lo_complex_type->get_primitive_property( 'ADDITIONAL_TARGETS' ).
    lo_primitive_property->set_edm_name( 'additionalTargets' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_is_collection( ).

    lo_primitive_property = lo_complex_type->get_primitive_property( 'TRANSITION' ).
    lo_primitive_property->set_edm_name( 'transition' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.

    lo_primitive_property = lo_complex_type->get_primitive_property( 'NUMERIC_SEVERITY' ).
    lo_primitive_property->set_edm_name( 'numericSeverity' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.

    lo_primitive_property = lo_complex_type->get_primitive_property( 'LONGTEXT_URL' ).
    lo_primitive_property->set_edm_name( 'longtextUrl' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->create_vcs_value_control( ).

  ENDMETHOD.


  METHOD def_a_supplier_confirmation_it.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_SUPPLIER_CONFIRMATION_IT'
                                    is_structure              = VALUE tys_a_supplier_confirmation_it( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_SupplierConfirmationItem_Type' ) ##NO_TEXT.
    lo_entity_type->create_complex_prop_for_vcs( 'VALUE_CONTROLS' ).


    lo_entity_set = lo_entity_type->create_entity_set( 'CONFIRMATION_ITEM' ).
    lo_entity_set->set_edm_name( 'ConfirmationItem' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPPLIER_CONFIRMATION' ).
    lo_primitive_property->set_edm_name( 'SupplierConfirmation' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPPLIER_CONFIRMATION_ITEM' ).
    lo_primitive_property->set_edm_name( 'SupplierConfirmationItem' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPLR_CONF_REF_PURCHASE_OR' ).
    lo_primitive_property->set_edm_name( 'SuplrConfRefPurchaseOrder' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPLR_CONF_REF_PURCHASE__2' ).
    lo_primitive_property->set_edm_name( 'SuplrConfRefPurchaseOrderItem' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPLR_CONF_ITEM_EXTERNAL_R' ).
    lo_primitive_property->set_edm_name( 'SuplrConfItemExternalReference' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 70 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPPLIER_CONFIRMED_NET_PRI' ).
    lo_primitive_property->set_edm_name( 'SupplierConfirmedNetPrice' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 11 ) ##NUMBER_OK.
    lo_primitive_property->set_scale_variable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DOCUMENT_CURRENCY' ).
    lo_primitive_property->set_edm_name( 'DocumentCurrency' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ITEM_IS_REJECTED_BY_SUPPLI' ).
    lo_primitive_property->set_edm_name( 'ItemIsRejectedBySupplier' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPPLIER_ORDER_ACKN_NUMBER' ).
    lo_primitive_property->set_edm_name( 'SupplierOrderAcknNumber' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 20 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPLR_CONF_NET_PRICE_QUANT' ).
    lo_primitive_property->set_edm_name( 'SuplrConfNetPriceQuantity' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 5 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPLR_CONF_ORDER_PRICE_UNI' ).
    lo_primitive_property->set_edm_name( 'SuplrConfOrderPriceUnit' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.

    lo_complex_property = lo_entity_type->create_complex_property( 'SAP_MESSAGES' ).
    lo_complex_property->set_edm_name( 'SAP__Messages' ) ##NO_TEXT.
    lo_complex_property->set_complex_type( 'SAP_MESSAGE' ).
    lo_complex_property->set_is_collection( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ETAG' ).
    lo_primitive_property->set_edm_name( 'ETAG' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->use_as_etag( ).
    lo_primitive_property->set_is_technical( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'SUPPLIER_CONFIRMATION_LINE' ).
    lo_navigation_property->set_edm_name( '_SupplierConfirmationLineTP' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_SUPPLIER_CONFIRMATION_LI' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).
    lo_navigation_property->create_vcs_value_control( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'SUPPLIER_CONFIRMATION_TP' ).
    lo_navigation_property->set_edm_name( '_SupplierConfirmationTP' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_SUPPLIER_CONFIRMATION_TY' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

  ENDMETHOD.


  METHOD def_a_supplier_confirmation_li.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_SUPPLIER_CONFIRMATION_LI'
                                    is_structure              = VALUE tys_a_supplier_confirmation_li( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_SupplierConfirmationLine_Type' ) ##NO_TEXT.
    lo_entity_type->create_complex_prop_for_vcs( 'VALUE_CONTROLS' ).


    lo_entity_set = lo_entity_type->create_entity_set( 'CONFIRMATION_LINE' ).
    lo_entity_set->set_edm_name( 'ConfirmationLine' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPPLIER_CONFIRMATION' ).
    lo_primitive_property->set_edm_name( 'SupplierConfirmation' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPPLIER_CONFIRMATION_ITEM' ).
    lo_primitive_property->set_edm_name( 'SupplierConfirmationItem' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPPLIER_CONFIRMATION_LINE' ).
    lo_primitive_property->set_edm_name( 'SupplierConfirmationLine' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DELIVERY_DATE' ).
    lo_primitive_property->set_edm_name( 'DeliveryDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->create_vcs_value_control( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DELIV_DATE_CATEGORY' ).
    lo_primitive_property->set_edm_name( 'DelivDateCategory' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DELIVERY_TIME' ).
    lo_primitive_property->set_edm_name( 'DeliveryTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'TimeOfDay' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CONFIRMED_QUANTITY' ).
    lo_primitive_property->set_edm_name( 'ConfirmedQuantity' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 13 ) ##NUMBER_OK.
    lo_primitive_property->set_scale( 3 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PURCHASE_ORDER_QUANTITY_UN' ).
    lo_primitive_property->set_edm_name( 'PurchaseOrderQuantityUnit' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPPLIER_CONFIRMATION_EXT' ).
    lo_primitive_property->set_edm_name( 'SupplierConfirmationExtNumber' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 35 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PERFORMANCE_PERIOD_START_D' ).
    lo_primitive_property->set_edm_name( 'PerformancePeriodStartDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->create_vcs_value_control( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PERFORMANCE_PERIOD_END_DAT' ).
    lo_primitive_property->set_edm_name( 'PerformancePeriodEndDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->create_vcs_value_control( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SERVICE_PERFORMER' ).
    lo_primitive_property->set_edm_name( 'ServicePerformer' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EXPECTED_OVERALL_LIMIT_AMO' ).
    lo_primitive_property->set_edm_name( 'ExpectedOverallLimitAmount' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 13 ) ##NUMBER_OK.
    lo_primitive_property->set_scale_variable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DOCUMENT_CURRENCY' ).
    lo_primitive_property->set_edm_name( 'DocumentCurrency' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MANUFACTURER_MATERIAL' ).
    lo_primitive_property->set_edm_name( 'ManufacturerMaterial' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 18 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'STOCK_SEGMENT' ).
    lo_primitive_property->set_edm_name( 'StockSegment' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'HANDOVER_DATE' ).
    lo_primitive_property->set_edm_name( 'HandoverDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->create_vcs_value_control( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'HANDOVER_TIME' ).
    lo_primitive_property->set_edm_name( 'HandoverTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'TimeOfDay' ) ##NO_TEXT.

    lo_complex_property = lo_entity_type->create_complex_property( 'SAP_MESSAGES' ).
    lo_complex_property->set_edm_name( 'SAP__Messages' ) ##NO_TEXT.
    lo_complex_property->set_complex_type( 'SAP_MESSAGE' ).
    lo_complex_property->set_is_collection( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ETAG' ).
    lo_primitive_property->set_edm_name( 'ETAG' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->use_as_etag( ).
    lo_primitive_property->set_is_technical( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'SUPPLIER_CONFIRMATION_IT_2' ).
    lo_navigation_property->set_edm_name( '_SupplierConfirmationItemTP' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_SUPPLIER_CONFIRMATION_IT' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'SUPPLIER_CONFIRMATION_TP' ).
    lo_navigation_property->set_edm_name( '_SupplierConfirmationTP' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_SUPPLIER_CONFIRMATION_TY' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one_optional ).
    lo_navigation_property->create_vcs_value_control( ).

  ENDMETHOD.


  METHOD def_a_supplier_confirmation_ty.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'A_SUPPLIER_CONFIRMATION_TY'
                                    is_structure              = VALUE tys_a_supplier_confirmation_ty( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'A_SupplierConfirmation_Type' ) ##NO_TEXT.
    lo_entity_type->create_complex_prop_for_vcs( 'VALUE_CONTROLS' ).


    lo_entity_set = lo_entity_type->create_entity_set( 'CONFIRMATION' ).
    lo_entity_set->set_edm_name( 'Confirmation' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPPLIER_CONFIRMATION' ).
    lo_primitive_property->set_edm_name( 'SupplierConfirmation' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPLR_CONF_REF_PURCHASE_OR' ).
    lo_primitive_property->set_edm_name( 'SuplrConfRefPurchaseOrder' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPLR_CONF_PROCESSING_STAT' ).
    lo_primitive_property->set_edm_name( 'SuplrConfProcessingStatus' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUPLR_CONF_EXTERNAL_REFERE' ).
    lo_primitive_property->set_edm_name( 'SuplrConfExternalReference' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 70 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LAST_CHANGE_DATE_TIME' ).
    lo_primitive_property->set_edm_name( 'LastChangeDateTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->create_vcs_value_control( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATION_DATE' ).
    lo_primitive_property->set_edm_name( 'CreationDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->create_vcs_value_control( ).

    lo_complex_property = lo_entity_type->create_complex_property( 'SAP_MESSAGES' ).
    lo_complex_property->set_edm_name( 'SAP__Messages' ) ##NO_TEXT.
    lo_complex_property->set_complex_type( 'SAP_MESSAGE' ).
    lo_complex_property->set_is_collection( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ETAG' ).
    lo_primitive_property->set_edm_name( 'ETAG' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->use_as_etag( ).
    lo_primitive_property->set_is_technical( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'SUPPLIER_CONFIRMATION_ITEM' ).
    lo_navigation_property->set_edm_name( '_SupplierConfirmationItemTP' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'A_SUPPLIER_CONFIRMATION_IT' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).
    lo_navigation_property->create_vcs_value_control( ).

  ENDMETHOD.


ENDCLASS.
