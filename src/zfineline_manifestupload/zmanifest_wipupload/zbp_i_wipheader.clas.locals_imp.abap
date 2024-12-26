CLASS lhc_ZI_WIPHEADER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_wipheader RESULT result.

    METHODS check_consistency FOR MODIFY
      IMPORTING keys FOR ACTION zi_wipheader~check_consistency.

    METHODS import_file FOR MODIFY
      IMPORTING keys FOR ACTION zi_wipheader~import_file.

    METHODS refresh FOR MODIFY
      IMPORTING keys FOR ACTION zi_wipheader~refresh.

    METHODS upload_orders FOR MODIFY
      IMPORTING keys FOR ACTION zi_wipheader~upload_orders.

ENDCLASS.

CLASS lhc_ZI_WIPHEADER IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD check_consistency.
  ENDMETHOD.

  METHOD import_file.
  ENDMETHOD.

  METHOD refresh.
  ENDMETHOD.

  METHOD upload_orders.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_ATTACHMENTTBL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS Generate_File_ID FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_attachmenttbl~Generate_File_ID.

ENDCLASS.

CLASS lhc_ZI_ATTACHMENTTBL IMPLEMENTATION.

  METHOD Generate_File_ID.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_WIPHEADER DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_WIPHEADER IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
