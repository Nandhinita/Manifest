CLASS lhc_ZI_SUPPLIERCONF DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_supplierconf RESULT result.

ENDCLASS.

CLASS lhc_ZI_SUPPLIERCONF IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
