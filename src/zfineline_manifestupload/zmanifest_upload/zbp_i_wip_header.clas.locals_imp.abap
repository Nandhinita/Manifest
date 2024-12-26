CLASS lhc_zi_supplier_conf DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS Generate_Item_ID FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_supplier_conf~Generate_Item_ID.

ENDCLASS.

CLASS lhc_zi_supplier_conf IMPLEMENTATION.

  METHOD Generate_Item_ID.
********************************************************************** Create the Supplier conf Item ID (unique key)   **********************************************************************

*    DATA(keys_count) = 'https://my418605.s4hana.cloud.sap/sap/bc/adt/businessservices/odatav4/feap/C%C2%87u%C2%84C%C2%83%C2%84%C2%89C%C2%83xu%C2%88uHC%C2%87u%C2%84C%C2%8E%C2%87vs%C2%8B%7D%C2%84%7Cyuxy%C2%86C%C2%87%C2%86%C2%8AxC%C2%87u%C2%84C%C2%8E%C2%87
*"xs%C2%8B%7D%C2%84%7Cyuxy%C2%86CDDDEC77nWsk%5Dds%5CYUXYf77su%C2%88%C2%88TTs%7D%C2%88%C2%81TTs%C2%86y%C2%87%C2%80%C2%83%7B77nWsUhhUW%5CaYbhshV%60TTnWsgidd%60%5DYfsWcbZTTnWsfYgdcbgY%60c%5B77ngXsk%5Dd%5CYUXYf77DDDE77ngVsk%5Dd%5CYUXYf/index.html?sap-ui-xx-vi
*"ewCache=false&sap-ui-language=EN&sap-client=080'.

    DATA lv_hdr_uuid TYPE zi_wip_header-zuuid.
    READ ENTITIES OF zi_wip_header IN LOCAL MODE
    ENTITY zi_supplier_conf
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_supp).
    LOOP AT lt_supp INTO DATA(ls_supp).
      IF ls_supp-zuuid IS NOT INITIAL.
        lv_hdr_uuid = ls_supp-zuuid.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_hdr_uuid IS NOT INITIAL.


      DATA(keys_count) = 0.
      LOOP AT keys INTO DATA(ls_key).

        "Select the Attachment table row count
        SELECT COUNT( * ) FROM zi_supplier_conf WHERE ZUuid = @lv_hdr_uuid  INTO @DATA(lv_last_suppid).
        lv_last_suppid = lv_last_suppid + 1 + keys_count.
        keys_count = keys_count + 1.




        MODIFY ENTITIES OF zi_wip_header IN LOCAL MODE
        ENTITY zi_supplier_conf
        UPDATE SET FIELDS WITH VALUE #( ( %tky = ls_key-%tky ZItmID = lv_last_suppid
        ) )
         REPORTED DATA(update_reported).
        reported = CORRESPONDING #( DEEP update_reported ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_WIP_HEADER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      main_method IMPORTING iv_datevalue     TYPE string
                  RETURNING VALUE(rv_result) TYPE string,
      helper_method IMPORTING iv_value TYPE sysuuid_x16.

    .
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_wip_header RESULT result.

    METHODS check_consistency FOR MODIFY
      IMPORTING keys FOR ACTION zi_wip_header~check_consistency.

    METHODS import_file FOR MODIFY
      IMPORTING keys FOR ACTION zi_wip_header~import_file.

    METHODS refresh FOR MODIFY
      IMPORTING keys FOR ACTION zi_wip_header~refresh.

    METHODS upload_orders FOR MODIFY
      IMPORTING keys FOR ACTION zi_wip_header~upload_orders.

    METHODS Generate_Header_ID FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_wip_header~Generate_Header_ID.

ENDCLASS.

CLASS lhc_ZI_WIP_HEADER IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD check_consistency.

    LOOP AT keys INTO DATA(ls_key).
      DATA: lv_hdr_uuid TYPE zi_wip_header-zuuid,
            sts         TYPE zi_wip_header-ZStatus.
****************************************************************************** Read the Root Table ******************************************************************************
      READ ENTITIES OF zi_wip_header IN LOCAL MODE
      ENTITY zi_wip_header
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(lt_wip_header).

      IF lt_wip_header IS NOT INITIAL.
        LOOP AT lt_wip_header INTO DATA(ls_wip_header).
          IF ls_wip_header-zuuid IS NOT INITIAL.
            lv_hdr_uuid = ls_wip_header-zuuid.
            sts = ls_wip_header-ZStatus.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
****************************************************************************** Read the Supplier Conf table ******************************************************************************
      IF lv_hdr_uuid IS NOT INITIAL.
        SELECT FROM zi_supplier_conf
          FIELDS SupplierconfUuid, ZPoid, ZPoitmId, ZPOConfdate,ZAttuuid
          WHERE zuuid = @lv_hdr_uuid

          INTO TABLE @DATA(lt_supp_confirm).

        LOOP AT lt_supp_confirm INTO DATA(ls_supp_confirm).
          DATA: lv_status  TYPE string,
                lv_comment TYPE string.
          lv_status  = 'Consistent'.
          lv_comment = 'Consistent'.

          " Check PO/PO Item
          IF ls_supp_confirm-ZPoid IS NOT INITIAL.
            SELECT SINGLE PurchaseOrder, PurchaseOrderItem
              FROM i_purchaseorderitemapi01
              WHERE PurchaseOrder = @ls_supp_confirm-ZPoid
                AND PurchaseOrderItem = @ls_supp_confirm-ZPoitmId
              INTO @DATA(ls_podata).

            IF sy-subrc <> 0.
              lv_status  = 'In-Consistent'.
              lv_comment = 'PO/PO Item ID is unavailable'.
            ENDIF.
          ENDIF.

          " Check Delivery Date
          IF ls_supp_confirm-ZPOConfdate IS NOT INITIAL AND

   ls_supp_confirm-ZPOConfdate < cl_abap_context_info=>get_system_date( ).                       " Check if ZPOConfdate is in the future
            "cl_abap_context_info=>get_system_date( ) - current  date
            lv_status  = 'In-Consistent'.
            lv_comment = COND #( WHEN lv_comment = 'Consistent'
                                 THEN 'Delivery Date format is incorrect'
                                 ELSE lv_comment && ', Delivery Date format is incorrect' ).
          ENDIF.
****************************************************************************** Update the Supplier Conf Table Status and Comment field ******************************************************************************
          " Update Supplier Confirmation
          MODIFY ENTITIES OF zi_wip_header IN LOCAL MODE
            ENTITY zi_supplier_conf
            UPDATE SET FIELDS WITH VALUE #(
              ( SupplierconfUuid = ls_supp_confirm-SupplierconfUuid
                ZStatus = lv_status
                Z_Status = lv_status
                ZComment = lv_comment ) )
            REPORTED DATA(update_reported).
        ENDLOOP.
      ENDIF.


    ENDLOOP.

    DATA: lv_row_count      TYPE i,
          lv_consistent_cnt TYPE i,
          lt_supp_confirm_1 TYPE TABLE OF zi_supplier_conf,
          ls_supp_conf      TYPE zi_supplier_conf.

    " Step 1: Get the total count of records for the given ZUuid
    SELECT COUNT( * )

      FROM zi_supplier_conf
     WHERE zuuid = @ls_key-ZUuid  INTO @lv_row_count .
    me->helper_method( iv_value = lv_hdr_uuid ).
  ENDMETHOD.

  METHOD import_file.

****************************************************************************** Read the Root table ******************************************************************************
    DATA: lv_hdr_uuid TYPE zi_wip_header-zuuid,
          sts         TYPE zi_wip_header-ZStatus.

    READ ENTITIES OF zi_wip_header IN LOCAL MODE
    ENTITY zi_wip_header
    ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_wip_header).

    IF lt_wip_header IS NOT INITIAL.
      LOOP AT lt_wip_header INTO DATA(ls_wip_header).
        IF ls_wip_header-zuuid IS NOT INITIAL.
          lv_hdr_uuid = ls_wip_header-zuuid.
          sts = ls_wip_header-ZStatus.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
****************************************************************************** Delete the Old data ******************************************************************************
    IF lv_hdr_uuid IS NOT INITIAL.
      SELECT  FROM zi_supplier_conf FIELDS SupplierconfUuid WHERE zuuid = @lv_hdr_uuid INTO TABLE @DATA(lt_supp_confirm).
      IF sy-subrc = 0 AND lt_supp_confirm IS NOT INITIAL.
        LOOP AT lt_supp_confirm INTO DATA(ls_supp_confirm).
          IF ls_supp_confirm-SupplierconfUuid IS NOT INITIAL.
            MODIFY ENTITIES OF zi_wip_header
              ENTITY zi_supplier_conf
                DELETE FROM VALUE #( ( SupplierconfUuid = ls_supp_confirm-SupplierconfUuid
                                       %is_draft  = if_abap_behv=>mk-off ) )
                MAPPED mapped
                FAILED failed
                REPORTED reported.

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lt_wip_header IS NOT INITIAL AND lv_hdr_uuid IS NOT INITIAL.
****************************************************************************** Read the Attachment Table ******************************************************************************
      SELECT FROM zi_attachment_tbl FIELDS ZFile,ZAttUuid WHERE zuuid = @lv_hdr_uuid INTO TABLE @DATA(lt_att_tbl).

      IF lt_att_tbl IS NOT INITIAL.
        LOOP AT lt_att_tbl INTO DATA(ls_att_tbl).
          IF ls_att_tbl-ZFile IS NOT INITIAL.



****************************************************************************** Define the excel column fields ******************************************************************************

            TYPES: BEGIN OF ls_excel,
                     ex_polineid         TYPE string,
                     ex_poid             TYPE string,
                     ex_openqty          TYPE string,
                     ex_attuuid          TYPE string,
                     ex_deliverydate     TYPE string,
                     ex_delayreason      TYPE string,
                     ex_wipsts           TYPE string,
                     ex_wipprevioussts   TYPE string,
                     ex_vendorpn         TYPE string,
                     ex_plant            TYPE string,
                     ex_act1desc         TYPE string,
                     ex_act1reqdate      TYPE string,
                     ex_act1remainddate  TYPE string,
                     ex_act4desc         TYPE string,
                     ex_act4reqdate      TYPE string,
                     ex_act4remainddate  TYPE string,
                     ex_lasteqstartdate  TYPE string,
                     ex_lasteqenddate    TYPE string,
                     ex_lastcqstartdate  TYPE string,
                     ex_lastcqenddate    TYPE string,
                     ex_noofcrmeq        TYPE string,
                     ex_multipleitmmatch TYPE string,
                     ex_xforreviewed     TYPE string,
                     ex_logremainddate   TYPE string,
                     ex_logremaindnote   TYPE string,
                     ex_eqengname        TYPE string,
                     ex_cqownername      TYPE string,
                     ex_material         TYPE string,
                     ex_firstagent       TYPE string,
                     ex_firstcustomer    TYPE string,
                   END OF ls_excel,
                   lt_excel_row TYPE STANDARD TABLE OF ls_excel.
            DATA lt_excel TYPE lt_excel_row.
            DATA lwa_excel LIKE LINE OF lt_excel.
            CLEAR lt_excel.
            CLEAR lwa_excel.


            DATA(lo_read) = xco_cp_xlsx=>document->for_file_content( ls_att_tbl-ZFile )->read_access( ).
            DATA(lo_worksheet) = lo_read->get_workbook( )->worksheet->at_position( 1 ).

            DATA(lo_cursor) = lo_worksheet->cursor(
                                                 io_column = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
                                                 io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 2 )
                                                 ).
            DATA(lo_cursor_name) = lo_worksheet->cursor(
                                            io_column = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
                                            io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
                                            ).

            DATA(lv_col_i) = 1.
            DATA(lv_row_i) = 2.


****************************************************************************** Run the Excel file and separate the columns ******************************************************************************
            WHILE lv_col_i <= 29.   "lo_cursor->has_cell( ) EQ abap_true AND
              TRY.


                  " Retrieve the current cell
                  DATA(lo_cell) = lo_cursor->get_cell( ).
                  DATA(lo_cell_name) = lo_cursor_name->get_cell( ).
                  DATA(lv_string_value) = ``.
                  DATA(lv_string_value_n) = ``.
                  " Check if the cell exists and retrieve its value if available
                  IF lo_cell IS BOUND.
                    IF lo_cell->has_value( ) = abap_true.
                      lo_cell->get_value(
                      )->set_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
                      )->write_to( REF #( lv_string_value ) ).
                    ELSE.
                      lv_string_value = ''. " Assign empty string for empty cells
                    ENDIF.
                  ENDIF.

                  IF lo_cell_name IS BOUND.
                    IF lo_cell_name->has_value( ) = abap_true.
                      lo_cell_name->get_value(
                      )->set_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
                      )->write_to( REF #( lv_string_value_n ) ).
                    ELSE.
                      lv_string_value_n = ''. " Assign empty string for empty cells
                    ENDIF.
                  ENDIF.

                  IF lv_col_i EQ 1 AND lv_string_value EQ ''.       "Last Row Exit code
****************************************************************************** Update the Root Table status field ******************************************************************************
                    IF sts EQ 'Not Started'.                                                                           "Inpreparation status
                      MODIFY ENTITIES OF zi_wip_header IN LOCAL MODE                                                        "Update the root fields
                    ENTITY zi_wip_header
                    UPDATE SET FIELDS WITH VALUE #( ( ZUuid = lv_hdr_uuid ZStatus = 'Imported' ) )
                    REPORTED DATA(update_reported_hdr).
                      reported = CORRESPONDING #( DEEP update_reported_hdr ).
                    ENDIF.
                    EXIT.
                  ENDIF.
****************************************************************************** Separate the column using move command ******************************************************************************
                  IF lv_col_i = 1.                                                 "Lot ID (PO Line ID)
                    lwa_excel-ex_polineid = lv_string_value.
                    lo_cursor->move_right( 11 ).
                  ENDIF.
                  IF lv_col_i = 2.                                                  "Purchase order
                    lwa_excel-ex_poid = lv_string_value.
                    lo_cursor->move_right( 3 ).
                  ENDIF.
                  IF lv_col_i = 3.                                                  "Deliver remainder
                    lwa_excel-ex_openqty = lv_string_value.
                    lo_cursor->move_right( 3 ).
                  ENDIF.
                  IF lv_col_i = 4. "Purchase Confirmed Delivery Date


                    lwa_excel-ex_deliverydate =  me->main_method( iv_datevalue = lv_string_value ).

                    lo_cursor->move_right( ).
                  ENDIF.

                  IF lv_col_i = 5.                                                  "Delay Reason
                    lwa_excel-ex_delayreason = lv_string_value.
                    lo_cursor->move_right( 2 ).

                  ENDIF.
                  IF lv_col_i = 6.                                                  "Wip Status
                    lwa_excel-ex_wipsts = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 7.                                                  "Wip Previous Status
                    lwa_excel-ex_wipprevioussts = lv_string_value.
                    lo_cursor->move_right( 3 ).
                  ENDIF.
                  IF lv_col_i = 8.                                                  "Vendor P.N
                    lwa_excel-ex_vendorpn = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 9.                                                  "Plant
                    lwa_excel-ex_plant = lv_string_value.
                    lo_cursor->move_right( 5 ).
                  ENDIF.
                  IF lv_col_i = 10.                                                 "Activity 1 Description
                    lwa_excel-ex_act1desc = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 11.                                                 "Activity 1 Required Date
                    lwa_excel-ex_act1reqdate = me->main_method( iv_datevalue = lv_string_value ).
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 12.                                                 "Activity 1 Reminder Date
                    lwa_excel-ex_act1remainddate = me->main_method( iv_datevalue = lv_string_value ).
                    lo_cursor->move_right( 7 ).
                  ENDIF.
                  IF lv_col_i = 13.                                                 "Activity 4 Description
                    lwa_excel-ex_act4desc = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 14.                                                 "Activity 4 Required Date
                    lwa_excel-ex_act4reqdate = me->main_method( iv_datevalue = lv_string_value ).
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 15.                                                "Activity 4 Reminder Date
                    lwa_excel-ex_act4remainddate = me->main_method( iv_datevalue = lv_string_value ).
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 16.                                               "Last EQ Start Date
                    lwa_excel-ex_lasteqstartdate = me->main_method( iv_datevalue = lv_string_value ).
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 17.                                                "Last EQ End Date
                    lwa_excel-ex_lasteqenddate = me->main_method( iv_datevalue = lv_string_value ).
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 18.                                                "Last CQ Start Date
                    lwa_excel-ex_lastcqstartdate = me->main_method( iv_datevalue = lv_string_value ).
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 19.                                                "Last Cq End Date
                    lwa_excel-ex_lastcqenddate = me->main_method( iv_datevalue = lv_string_value ).
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 20.                                                 "Number Of CRM EQ
                    lwa_excel-ex_noofcrmeq = lv_string_value.
                    lo_cursor->move_right( 15 ).
                  ENDIF.

                  IF lv_col_i = 21.                                                 "Multiple item match
                    lwa_excel-ex_multipleitmmatch = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 22.                                                 "X - For Reviewed
                    lwa_excel-ex_xforreviewed = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 23.                                                 "Logistic Reminder Date
                    lwa_excel-ex_logremainddate = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 24.                                                 "Logistic Reminder Note
                    lwa_excel-ex_logremaindnote = lv_string_value.
                    lo_cursor->move_right( 2 ).
                  ENDIF.
                  IF lv_col_i = 25.                                                 "Eq Engineer Name
                    lwa_excel-ex_eqengname = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 26.                                                 "CQ Owner Name
                    lwa_excel-ex_cqownername = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.
                  IF lv_col_i = 27.                                                 "Material
                    lwa_excel-ex_material = lv_string_value.
                    lo_cursor->move_right( 2 ).
                  ENDIF.
                  IF lv_col_i = 28.                                                 "First Agent
                    lwa_excel-ex_firstagent = lv_string_value.
                    lo_cursor->move_right( ).
                  ENDIF.


                  IF lv_col_i = 29.                                                  "First Customer "Last field in the excel

                    lwa_excel-ex_firstcustomer = lv_string_value.
                    lwa_excel-ex_attuuid =   ls_att_tbl-ZAttUuid.               " Write the Attachment uuid for each supplier conf
                    lv_row_i = lv_row_i + 1.
                    lv_col_i = 0.
                    "Move the next row
                    lo_cursor = lo_worksheet->cursor(
                                                      io_column = xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
                                                      io_row    = xco_cp_xlsx=>coordinate->for_numeric_value( lv_row_i )
                                                      ).

                    APPEND lwa_excel TO lt_excel.
                    CLEAR lwa_excel.
                  ENDIF.

                  lv_col_i = lv_col_i + 1.


                CATCH cx_root INTO DATA(lx_exception). " Handle any runtime exception
                  CONTINUE.
              ENDTRY.
            ENDWHILE.
          ENDIF.
****************************************************************************** Create the Suppleir Conf Table ******************************************************************************
          IF lt_excel IS NOT INITIAL.

            DATA lv_previous_order_no TYPE string.
            DATA lv_current_order_no TYPE string.


            CLEAR: lv_previous_order_no, lv_current_order_no.

            LOOP AT lt_excel INTO lwa_excel.

              lv_current_order_no = lwa_excel-ex_poid.

*              IF lv_current_order_no <> lv_previous_order_no.
              "New Order

              lv_previous_order_no  = lv_current_order_no.

              IF lwa_excel-ex_poid IS NOT INITIAL.
                MODIFY ENTITIES OF zi_wip_header ENTITY zi_wip_header CREATE BY \_itm
                FROM VALUE #( ( zuuid = lv_hdr_uuid
                      %target = VALUE #( (  %cid = 'read'
                                            ZPoitmId = lwa_excel-ex_polineid
                                            ZPoid = lwa_excel-ex_poid
                                            ZConfirmedqty = lwa_excel-ex_openqty
                                           ZPOConfdate = lwa_excel-ex_deliverydate
                                             ZDelayreason = lwa_excel-ex_delayreason
                                             ZWipstatus = lwa_excel-ex_wipsts
                                              ZWippreviousstatus = lwa_excel-ex_wipprevioussts
                                              ZVendorPn = lwa_excel-ex_vendorpn
                                               ZPlant = lwa_excel-ex_plant
                                               ZActivity1Desc = lwa_excel-ex_act1desc
                                              ZAct1reqdate = lwa_excel-ex_act1reqdate
                                             ZAct1remainddate = lwa_excel-ex_act1remainddate
                                             ZActivity4Desc = lwa_excel-ex_act4desc
                                             ZAct4Reqdate = lwa_excel-ex_act4reqdate
                                              ZAct4Remainddate = lwa_excel-ex_act4remainddate
                                              ZLasteqStartdate = lwa_excel-ex_lasteqstartdate
                                               ZLasteqEnddate = lwa_excel-ex_lasteqenddate
                                                ZLastcqStartdate = lwa_excel-ex_lastcqstartdate
                                                ZLastcqEnddate = lwa_excel-ex_lastcqenddate
                                                 ZNoofCrmEq = lwa_excel-ex_noofcrmeq
                                                 ZMultipleitmmatch = lwa_excel-ex_multipleitmmatch
                                                  ZXforReviewed = lwa_excel-ex_xforreviewed
                                                  ZLogisticRemainddate = lwa_excel-ex_logremainddate
                                                  ZLogisticRemaindnote = lwa_excel-ex_logremaindnote
                                                  ZEqEngineername = lwa_excel-ex_eqengname
                                                 ZCqOwnername = lwa_excel-ex_cqownername
                                                 ZMaterial = lwa_excel-ex_material
                                                 ZFirstagent = lwa_excel-ex_firstagent
                                                 ZFirstcustomer = lwa_excel-ex_firstcustomer
                                              ZAttuuid = lwa_excel-ex_attuuid
                                              ZStatus = 'File Imported'
                                              Z_Status = 'File Imported'

                                            %control = VALUE #( ZPoitmId = if_abap_behv=>mk-on
                                                                ZPoid = if_abap_behv=>mk-on
                                                                ZConfirmedqty = if_abap_behv=>mk-on
                                                                ZPOConfdate = if_abap_behv=>mk-on
                                                                ZDelayreason = if_abap_behv=>mk-on
                                                                ZWipstatus = if_abap_behv=>mk-on
                                                               ZWippreviousstatus = if_abap_behv=>mk-on
                                                               ZVendorPn = if_abap_behv=>mk-on
                                                               ZPlant = if_abap_behv=>mk-on
                                                               ZActivity1Desc = if_abap_behv=>mk-on
                                                               ZAttuuid = if_abap_behv=>mk-on
                                                                 ZAct1reqdate = if_abap_behv=>mk-on
                                                               ZAct1remainddate = if_abap_behv=>mk-on
                                                                ZActivity4Desc = if_abap_behv=>mk-on
                                                               ZAct4reqdate = if_abap_behv=>mk-on
                                                               ZAct4remainddate = if_abap_behv=>mk-on
                                                               ZLasteqStartdate = if_abap_behv=>mk-on
                                                               ZLasteqEnddate = if_abap_behv=>mk-on
                                                               ZLastcqStartdate = if_abap_behv=>mk-on
                                                              ZLastcqEnddate = if_abap_behv=>mk-on
                                                              ZNoofCrmEq = if_abap_behv=>mk-on
                                                              ZMultipleitmmatch = if_abap_behv=>mk-on
                                                              ZXforReviewed = if_abap_behv=>mk-on
                                                              ZLogisticRemainddate = if_abap_behv=>mk-on
                                                              ZLogisticRemaindnote = if_abap_behv=>mk-on
                                                              ZEqEngineername = if_abap_behv=>mk-on
                                                              ZCqOwnername = if_abap_behv=>mk-on
                                                              ZMaterial = if_abap_behv=>mk-on
                                                              ZFirstagent = if_abap_behv=>mk-on
                                                              ZFirstcustomer = if_abap_behv=>mk-on
                                                              ZStatus = if_abap_behv=>mk-on
                                                              Z_Status = if_abap_behv=>mk-on
                                                              )
                                          )
                                       )
                    )
                  )
                  MAPPED mapped
                  FAILED failed
                  REPORTED reported.



              ENDIF.
*              ENDIF.
            ENDLOOP.
          ENDIF.


        ENDLOOP.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD refresh.
  ENDMETHOD.

  METHOD upload_orders.

*****************************************************GET API***********************************************************************************************************



*
*DATA:
*  ls_entity_key    TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty,
*  ls_business_data TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty,
*  lo_http_client   TYPE REF TO if_web_http_client,
*  lo_resource      TYPE REF TO /iwbep/if_cp_resource_entity,
*  lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*  lo_request       TYPE REF TO /iwbep/if_cp_request_read,
*  lo_response      TYPE REF TO /iwbep/if_cp_response_read,
*  lo_web_http_post_request  TYPE REF TO if_web_http_request.
*
*
*
*     TRY.
*     " Create http client
*TRY.
*    data(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                                 comm_scenario  = 'ZCS_SUPPLIERCONFIRM'
*                                                   ).
*  CATCH cx_http_dest_provider_error.
*    "handle exception
*ENDTRY.
*
**   DATA(http_destination) = cl_http_destination_provider=>create_by_url( i_url = 'https://my405551-api.s4hana.cloud.sap' ).
*
**    http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = http_destination ).
*
*lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
* lo_web_http_post_request = lo_http_client->get_http_request( ).
*
**            lo_web_http_post_request->set_header_fields( VALUE #( ( name = 'x-csrf-token' value = lv_csrf_token ) ) ).
*
*            lo_web_http_post_request->set_content_type( content_type = 'application/json; charset=utf-8' ).
*          lo_web_http_post_request->set_header_fields( VALUE #( ( name = 'Accept' value = 'application/json; charset=utf-8' ) ) ).
*
*     lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
*       EXPORTING
*          is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
*                                              proxy_model_id      = 'ZSCM_SUPPLIERCONFIRM'
*                                              proxy_model_version = '0001' )
*         io_http_client             = lo_http_client
*
*         iv_relative_service_root   = '/sap/opu/odata4/sap/api_supplierconfirmation/srvd_a2x/sap/supplierconfirmation/0001/' ).
*
*     ASSERT lo_http_client IS BOUND.
*
*
*" Set entity key
*ls_entity_key = VALUE #(
*          supplier_confirmation  = '5900000002' ).
*
*" Navigate to the resource
*lo_resource = lo_client_proxy->create_resource_for_entity_set( 'CONFIRMATION' )->navigate_with_key( ls_entity_key ).
*
*
*" Execute the request and retrieve the business data
*lo_response = lo_resource->create_request_for_read( )->execute( ).
*
*lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).
*
*  CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
*" Handle remote Exception
*" It contains details about the problems of your http(s) connection
*
*CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
*" Handle Exception
*DATA(x) = lx_gateway.
*DATA(y) = 0.
*CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
*" Handle Exception
* RAISE SHORTDUMP lx_web_http_client_error.
*
*
*ENDTRY.
******************************************************************************************POST API**********************************************************************
*    DATA:
*      ls_business_data      TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty,
*      lt_confirmation_items TYPE zscm_supplierconfirm=>tyt_a_supplier_confirmation_it, " Table for confirmation items
*      ls_confirmation_item  TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_it, " Single confirmation item
*      lt_confirmation_lines TYPE zscm_supplierconfirm=>tyt_a_supplier_confirmation_li, " Table for confirmation lines
*      ls_confirmation_line  TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_li,
*      lo_http_client        TYPE REF TO if_web_http_client,
*      lo_client_proxy       TYPE REF TO /iwbep/if_cp_client_proxy,
*      lo_request            TYPE REF TO /iwbep/if_cp_request_create,
*      lo_response           TYPE REF TO /iwbep/if_cp_response_create,
*      lo_create_request     TYPE REF TO /iwbep/if_cp_request_create.
*
*
*
*    TRY.
*        " Create http client
*        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                                     comm_scenario  = 'ZCS_SUPPLIERCONFIRM'
*                                                    ).
*        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
*        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
*          EXPORTING
*             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
*                                                 proxy_model_id      = 'ZSCM_SUPPLIERCONFIRM'
*                                                 proxy_model_version = '0001' )
*            io_http_client             = lo_http_client
*            iv_relative_service_root   = '/sap/opu/odata4/sap/api_supplierconfirmation/srvd_a2x/sap/supplierconfirmation/0001/' ).
*
*        ASSERT lo_http_client IS BOUND.
*
*
*        TYPES: BEGIN OF tys_entity_data,
*                 suplr_conf_ref_purchase_or TYPE string,
*                 suplr_conf_processing_stat TYPE string,
*                 suplr_conf_external_refere TYPE string,
*                 creation_date              TYPE string,
*               END OF tys_entity_data.
*
*        " Prepare nested child entity (Confirmation Line)
*        ls_confirmation_line = VALUE #(
*          supplier_confirmation_item = '10'
*          delivery_date = '20241216'
*          confirmed_quantity = '1.00'
*          purchase_order_quantity_un = 'EA'
*          document_currency = 'EUR'
*         ).
*        APPEND ls_confirmation_line TO lt_confirmation_lines.
*
*        ls_confirmation_item = VALUE #(
*          suplr_conf_ref_purchase_or = '4500000001'
*          supplier_confirmation_item = '10'
*
*         ).
*
*
*        APPEND ls_confirmation_item TO lt_confirmation_items.
*
*        ls_business_data = VALUE #(
*        "          supplier_confirmation       = 'SupplierConfirmation'
*                  suplr_conf_ref_purchase_or  = '4500000001'
*                  suplr_conf_processing_stat  = '01'            "Accepted
*                  suplr_conf_external_refere  = 'PO-4500000001'
*        "          last_change_date_time       = 20170101123000
*                  creation_date               = '20241216' ).
*
*
*
*
*
*        DATA:
*          lo_data_des_node_root   TYPE REF TO /iwbep/if_cp_data_desc_node,
*          lo_data_desc_node_child TYPE REF TO /iwbep/if_cp_data_desc_node,
*          ls_deep_busi_data       TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty,
*          ls_response_data        TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty.
*        lo_data_des_node_root = lo_create_request->create_data_descripton_node( ).
*        lo_data_des_node_root->set_properties( VALUE #( ( |SUPLR_CONF_REF_PURCHASE_OR| ) ( |SUPLR_CONF_PROCESSING_STAT| ) ) ).
*
*        lo_data_desc_node_child = lo_data_des_node_root->add_child( 'VALUES_CONTROL' ).
*        lo_data_desc_node_child->set_properties( VALUE #( ( |SUPPLIER_CONFIRMATION_ITEM| ) ) ).
*
*
*
*        " Prepare request for the create operation
*        lo_request = lo_client_proxy->create_resource_for_entity_set( 'CONFIRMATION'  )->create_request_for_create( ).
*
*        " Set the business data for the created entity
*        lo_request->set_business_data( ls_business_data ).
*
**lo_request->set_business_data( is_business_data = ls_business_data
**                It_provided_property = VALUE #( ( |SUPLR_CONF_REF_PURCHASE_OR| )
**
**                ( |SUPLR_CONF_PROCESSING_STAT| )
**                ( |SUPLR_CONF_EXTERNAL_REFERE| )
**                ( |CREATION_DATE| ) ) ).
*        " Execute the request
*        lo_response = lo_request->execute( ).
*
*
*        " Get the after image
*        lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).
*
*      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
*        " Handle remote Exception
*        " It contains details about the problems of your http(s) connection
*
*
*      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
*        " Handle Exception
*
*      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
*        " Handle Exception
*        RAISE SHORTDUMP lx_web_http_client_error.
*
*      CATCH cx_http_dest_provider_error.
*        "handle exception
*    ENDTRY.


    DATA:
*  ls_business_data TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty,
      lo_http_client            TYPE REF TO if_web_http_client,
      lo_client_proxy           TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request                TYPE REF TO /iwbep/if_cp_request_create,
      lo_response               TYPE REF TO /iwbep/if_cp_response_create,
      lo_data_desc_node_root    TYPE REF TO /iwbep/if_cp_data_desc_node,
      lo_data_desc_node_child_1 TYPE REF TO /iwbep/if_cp_data_desc_node,
      lo_data_desc_node_child_2 TYPE REF TO /iwbep/if_cp_data_desc_node.

    TYPES: BEGIN OF ty_item.
             INCLUDE TYPE  zscm_supplierconfirm=>tys_a_supplier_confirmation_it AS item.
    TYPES:       confirm TYPE zscm_supplierconfirm=>tyt_a_supplier_confirmation_li,
           END OF ty_item.

    TYPES: tt_deep TYPE STANDARD TABLE OF ty_item.

    DATA: BEGIN OF ls_data.
            INCLUDE TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty.
    DATA: _SupplierConfirmationItemTP TYPE tt_deep,
          END OF ls_data.



    DATA: BEGIN OF ls_apiStructure.
            INCLUDE TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty.
    DATA:   _SupplierConfirmationItemTP TYPE  zscm_supplierconfirm=>tyt_a_supplier_confirmation_it,
            _SupplierConfirmationLineTP TYPE zscm_supplierconfirm=>tyt_a_supplier_confirmation_li,
          END OF ls_apiStructure.

    ls_apiStructure = VALUE #(
              suplr_conf_ref_purchase_or  = '4500000001'
              suplr_conf_processing_stat  = '02'            "Accepted
              suplr_conf_external_refere  = 'PO-4500000001'
    "          last_change_date_time       = 20170101123000
              creation_date               = '20241216'
              _SupplierConfirmationItemTP = VALUE #( (  suplr_conf_ref_purchase_or  = '4500000001' suplr_conf_ref_purchase__2 = '10'  ) )
                    _SupplierConfirmationLineTP = VALUE #(
        ( delivery_date = '20241216'
        confirmed_quantity = '1.00'
        purchase_order_quantity_un = 'EA'
        document_currency = 'EUR' ) ) ).

    ls_data =  VALUE #(
              suplr_conf_ref_purchase_or  = '4500000001'
              suplr_conf_processing_stat  = '02'            "Accepted
              suplr_conf_external_refere  = 'PO-4500000001'
    "          last_change_date_time       = 20170101123000
              creation_date               = '20241216'
              _supplierconfirmationitemtp = VALUE #( (  supplier_confirmation_item = '0010'
              suplr_conf_item_external_r = 'PO-4500000001_00010'
              document_currency = 'EUR'
               suplr_conf_ref_purchase_or  = '4500000001' suplr_conf_ref_purchase__2 = '00010'
                confirm = VALUE #(
        (
        supplier_confirmation_ext = 'PO-4500000001_00010_0001'
        supplier_confirmation_item =  '0010'
        supplier_confirmation_line = '0001'
        delivery_date = '20241216'
        confirmed_quantity = '1'
        purchase_order_quantity_un = 'EA'
        document_currency = 'EUR' ) ) ) ) ).


DATA it_property TYPE STANDARD TABLE OF String.
APPEND 'SUPLR_CONF_REF_PURCHASE_OR' TO  it_property.
APPEND 'SUPLR_CONF_PROCESSING_STAT' TO it_property.
APPEND 'SUPLR_CONF_EXTERNAL_REFERE' TO it_property.
APPEND 'CREATION_DATE' TO it_property.

DATA it_deep_property TYPE STANDARD TABLE OF String.
APPEND 'SUPPLIER_CONFIRMATION_ITEM' TO it_deep_property.
APPEND 'SUPLR_CONF_ITEM_EXTERNAL_R' TO it_deep_property.
APPEND 'DOCUMENT_CURRENCY' TO it_deep_property.
APPEND 'SUPLR_CONF_REF_PURCHASE_OR' TO it_deep_property.
APPEND 'SUPLR_CONF_REF_PURCHASE__2' TO it_deep_property.


DATA it_deep_lineproperty TYPE STANDARD TABLE OF String.
APPEND 'SUPPLIER_CONFIRMATION_EXT' TO it_deep_lineproperty.
APPEND 'SUPPLIER_CONFIRMATION_ITEM' TO it_deep_lineproperty.
APPEND 'SUPPLIER_CONFIRMATION_LINE' TO it_deep_lineproperty.
APPEND 'DELIVERY_DATE' TO it_deep_lineproperty.
APPEND 'CONFIRMED_QUANTITY' TO it_deep_lineproperty.
APPEND 'PURCHASE_ORDER_QUANTITY_UN' TO it_deep_lineproperty.
APPEND 'DOCUMENT_CURRENCY' TO it_deep_lineproperty.


    TRY.
        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                                     comm_scenario  = 'ZCS_SUPPLIERCONFIRM'
                                                    ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZSCM_SUPPLIERCONFIRM'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata4/sap/api_supplierconfirmation/srvd_a2x/sap/supplierconfirmation/0001/' ).

        ASSERT lo_http_client IS BOUND.



* Prepare business data
*ls_business_data = VALUE #(
*          supplier_confirmation       = 'SupplierConfirmation'
*          suplr_conf_ref_purchase_or  = 'SuplrConfRefPurchaseOr'
*          suplr_conf_processing_stat  = 'SuplrConfProcessingStat'
*          suplr_conf_external_refere  = 'SuplrConfExternalRefere'
*          last_change_date_time       = 20170101123000
*          creation_date               = '20170101' ).

        " Navigate to the resource and create a request for the create operation
*lo_request = lo_client_proxy->create_resource_for_entity_set( 'CONFIRMATION' )->create_request_for_create( ).
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'CONFIRMATION' )->create_request_for_create( ).

* lo_data_desc_node_root = lo_request->create_data_descripton_node( )->set_properties( VALUE #( ( |SUPLR_CONF_REF_PURCHASE_OR| )
*                                     ( |SUPLR_CONF_PROCESSING_STAT| )
*                                     ( |SUPLR_CONF_EXTERNAL_REFERE| )
*                                     ( |CREATION_DATE| ) ) ).
*    lo_data_desc_node_child_1 = lo_data_desc_node_root->add_child( 'SUPPLIER_CONFIRMATION_ITEM' )->set_properties( VALUE #( ( |SUPLR_CONF_REF_PURCHASE__2| ) ) ).
*    lo_data_desc_node_child_2 = lo_data_desc_node_child_1->add_child( 'EMPLOYEE_2_MANAGER' )->set_properties( lt_property_path_2 ).
        " Set the business data for the created entity
        lo_request->set_business_data( ls_data ).

DATA(lo_data_description_node) = lo_request->create_data_descripton_node( ).
lo_data_description_node->set_properties( it_property  ).
lo_data_description_node->add_child( 'SUPPLIER_CONFIRMATION_ITEM' )->set_properties( it_deep_property ).
**lo_data_description_node->add_child( 'SUPPLIER_CONFIRMATION_LINE' )->set_properties( it_deep_property_1 ).
lo_request->set_deep_business_data(
is_business_data    = ls_data
io_data_description = lo_data_description_node ).

        " Execute the request
        lo_response = lo_request->execute( ).

        " Get the after image
*lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).
      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection


      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.

      CATCH cx_http_dest_provider_error.
        "handle exception
    ENDTRY.

********************************************************************** Start **********************************************************************
*TYPES: tt_soi_deep_create TYPE STANDARD TABLE OF zscm_supplierconfirm=>tys_a_supplier_confirmation_it WITH NON-UNIQUE DEFAULT KEY.
*TYPES: BEGIN OF ty_s_deep_create.
*INCLUDE TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty AS so.
*TYPES: _item TYPE  tt_soi_deep_create,
*END OF ty_s_deep_create.
*
*
*
*DATA: ls_so_business_data TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty,
*          lsi_business_data   TYPE tt_soi_deep_create,
**          lsi_business_data_1   TYPE tt_soi_deep_create_1,
*          lo_http_client      TYPE REF TO if_web_http_client,
*          lo_client_proxy     TYPE REF TO /iwbep/if_cp_client_proxy,
*          lo_request          TYPE REF TO /iwbep/if_cp_request_create,
*          lo_response         TYPE REF TO /iwbep/if_cp_response_create,
*          it_property_path    TYPE /iwbep/if_cp_runtime_types=>ty_t_property_path,
*          ls_business_data    TYPE ty_s_deep_create,
*          ls_deep_data        TYPE ty_s_deep_create,
*           ls_deep_data_1        TYPE ty_s_deep_create.
*
*
*TRY.
*" Create http client
*DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                             comm_scenario  = 'ZCS_SUPPLIERCONFIRM'
*                                            ).
*lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
*lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
*  EXPORTING
*     is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
*                                         proxy_model_id      = 'ZSCM_SUPPLIERCONFIRM'
*                                         proxy_model_version = '0001' )
*    io_http_client             = lo_http_client
*    iv_relative_service_root   = '/sap/opu/odata4/sap/api_supplierconfirmation/srvd_a2x/sap/supplierconfirmation/0001/' ).
*
*ASSERT lo_http_client IS BOUND.
*
*ls_so_business_data = VALUE #(
*"          supplier_confirmation       = 'SupplierConfirmation'
*          suplr_conf_ref_purchase_or  = '4500000001'
*          suplr_conf_processing_stat  = '02'            "Accepted
*          suplr_conf_external_refere  = 'PO-4500000001'
*"          last_change_date_time       = 20170101123000
*          creation_date               = '20241216'
*          ).
*
*
*lsi_business_data = VALUE tt_soi_deep_create( ( suplr_conf_ref_purchase_or = '4500000001' suplr_conf_ref_purchase__2 = '10' ) ).
*
*MOVE-CORRESPONDING ls_so_business_data TO ls_deep_data.
*
*ls_deep_data-_item = lsi_business_data.
*
*
*DATA it_property TYPE STANDARD TABLE OF String.
*APPEND 'SUPLR_CONF_REF_PURCHASE_OR' TO  it_property.
*APPEND 'SUPLR_CONF_PROCESSING_STAT' TO it_property.
*APPEND 'SUPLR_CONF_EXTERNAL_REFERE' TO it_property.
*APPEND 'CREATION_DATE' TO it_property.
*
*DATA it_deep_property TYPE STANDARD TABLE OF String.
**APPEND 'SUPLR_CONF_REF_PURCHASE_OR' TO it_deep_property.
*APPEND 'SUPLR_CONF_REF_PURCHASE__2' TO it_deep_property.
*
*
*lo_request = lo_client_proxy->create_resource_for_entity_set( 'CONFIRMATION' )->create_request_for_create( ).
*
*DATA(lo_data_description_node) = lo_request->create_data_descripton_node( ).
*lo_data_description_node->set_properties( it_property  ).
*lo_data_description_node->add_child( 'SUPPLIER_CONFIRMATION_ITEM' )->set_properties( it_deep_property ).
***lo_data_description_node->add_child( 'SUPPLIER_CONFIRMATION_LINE' )->set_properties( it_deep_property_1 ).
*lo_request->set_deep_business_data(
*is_business_data    = ls_deep_data
*io_data_description = lo_data_description_node ).
*
*lo_request->execute( )->get_business_data( IMPORTING es_business_data = ls_deep_data ).
*lo_request->check_execution( ).
*
*CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
*" Handle remote Exception
*" It contains details about the problems of your http(s) connection
*
*
*CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
*" Handle Exception
*
*CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
*" Handle Exception
*RAISE SHORTDUMP lx_web_http_client_error.
*
*  CATCH cx_http_dest_provider_error.
*    "handle exception
*ENDTRY.
********************************************************************** End **********************************************************************

********************************************************************** START **********************************************************************

*DATA:
*  ls_business_data TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_ty,
*lt_confirmation_items  TYPE zscm_supplierconfirm=>tyt_a_supplier_confirmation_it, " Table for confirmation items
*  ls_confirmation_item   TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_it, " Single confirmation item
*  lt_confirmation_lines  TYPE zscm_supplierconfirm=>tyt_a_supplier_confirmation_li, " Table for confirmation lines
*  ls_confirmation_line   TYPE zscm_supplierconfirm=>tys_a_supplier_confirmation_li,
*  lo_http_client   TYPE REF TO if_web_http_client,
*  lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*  lo_request       TYPE REF TO /iwbep/if_cp_request_create,
*  lo_response      TYPE REF TO /iwbep/if_cp_response_create.
*
*
*
*  TRY.
*" Create http client
*DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                             comm_scenario  = 'ZCS_SUPPLIERCONFIRM'
*                                            ).
*lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
*lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
*  EXPORTING
*     is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
*                                         proxy_model_id      = 'ZSCM_SUPPLIERCONFIRM'
*                                         proxy_model_version = '0001' )
*    io_http_client             = lo_http_client
*    iv_relative_service_root   = '/sap/opu/odata4/sap/api_supplierconfirmation/srvd_a2x/sap/supplierconfirmation/0001/' ).
*
*ASSERT lo_http_client IS BOUND.
*
*
*
*" Declare types for confirmation lines (child entity)
*TYPES:
*  BEGIN OF supplier_confirmation_line,
*    supplier_confirmation_item TYPE string,
*    delivery_date TYPE string,
*    confirmed_quantity TYPE string,
*    purchase_order_quantity_un TYPE string,
*    document_currency TYPE string,
*  END OF supplier_confirmation_line.
*
*" Declare types for confirmation items (root entity) with reference to the child entity
*TYPES:
*  BEGIN OF tys_a_supplier_confirmation_it,
*    suplr_conf_ref_purchase_or TYPE string,
*    supplier_confirmation_item TYPE string,
*    value_controls TYPE REF TO data,  " Reference to a table for child entities
*  END OF tys_a_supplier_confirmation_it.
*
*" Declare types for the root entity (business data)
*TYPES:
*  BEGIN OF tys_a_supplier_confirmation,
*    suplr_conf_ref_purchase_or TYPE string,
*    suplr_conf_processing_stat TYPE string,
*    suplr_conf_external_refere TYPE string,
*    creation_date TYPE string,
*    value_controls TYPE REF TO data,  " Reference to confirmation items (root data)
*  END OF tys_a_supplier_confirmation.
*
*" Declare internal tables to hold the data
*DATA:
*  lt_confirmation_lines TYPE TABLE OF supplier_confirmation_line,  " Table for confirmation lines (child entities)
*  ls_confirmation_line TYPE supplier_confirmation_line,           " Single confirmation line (child entity)
*  lt_confirmation_items TYPE TABLE OF tys_a_supplier_confirmation_it,  " Table for confirmation items (root entity)
*  ls_confirmation_item TYPE tys_a_supplier_confirmation_it,        " Single confirmation item (root entity)
*  lv_ref_to_lines TYPE REF TO data,  " Reference to the confirmation lines table
*  lv_ref_to_items TYPE REF TO data,  " Reference to the confirmation items table
*  ls_business_data TYPE tys_a_supplier_confirmation. " Root entity for the business data
*
*" Prepare the child entity (Confirmation Line)
*CLEAR ls_confirmation_line.
*ls_confirmation_line-supplier_confirmation_item = '10'.
*ls_confirmation_line-delivery_date = '20241216'.
*ls_confirmation_line-confirmed_quantity = '1.00'.
*ls_confirmation_line-purchase_order_quantity_un = 'EA'.
*ls_confirmation_line-document_currency = 'EUR'.
*APPEND ls_confirmation_line TO lt_confirmation_lines.
*
*" Create a reference to a new table that will point to lt_confirmation_lines
*"CREATE DATA lv_ref_to_lines TYPE TABLE OF supplier_confirmation_line.
*"ASSIGN lv_ref_to_lines->* TO FIELD-SYMBOL(<fs_lines>).
*
*" Assign the lines data to the field symbol (i.e., the reference)
*"<fs_lines> = lt_confirmation_lines.
*
*" Prepare the root entity (Confirmation Item)
*CLEAR ls_confirmation_item.
*ls_confirmation_item-suplr_conf_ref_purchase_or = '4500000001'.
*ls_confirmation_item-supplier_confirmation_item = '10'.
*ls_confirmation_item-value_controls = lv_ref_to_lines.  " Assign the reference to the confirmation lines
*
*" Append the confirmation item to the table
*APPEND ls_confirmation_item TO lt_confirmation_items.
*
*" Create a reference to a new table that will point to lt_confirmation_items (Root entity)
*CREATE DATA lv_ref_to_items TYPE TABLE OF tys_a_supplier_confirmation_it.
*ASSIGN lv_ref_to_items->* TO FIELD-SYMBOL(<fs_items>).
*
*" Assign the items data to the field symbol (i.e., the reference)
*<fs_items> = lt_confirmation_items.
*
*" Prepare the root entity business data (supplier confirmation)
*ls_business_data-suplr_conf_ref_purchase_or = '4500000001'.
*ls_business_data-suplr_conf_processing_stat = '02'.  " Accepted
*ls_business_data-suplr_conf_external_refere = 'PO-4500000001'.
*ls_business_data-creation_date = '20241216'.
*ls_business_data-value_controls = lv_ref_to_items.  " Assign the reference to the confirmation items
*
*" Now the business data (root entity) contains the confirmation item with value controls (confirmation lines and items)
*
*" Prepare request for the create operation
*lo_request = lo_client_proxy->create_resource_for_entity_set( 'CONFIRMATION' )->create_request_for_create( ).
*
*" Set the business data for the created entity
*lo_request->set_business_data( ls_business_data ).
*
*" Execute the request
*lo_response = lo_request->execute( ).
*
*
*" Get the after image
*lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).
*
*CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
*" Handle remote Exception
*" It contains details about the problems of your http(s) connection
*
*
*CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
*" Handle Exception
*
*CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
*" Handle Exception
*RAISE SHORTDUMP lx_web_http_client_error.
*
*  CATCH cx_http_dest_provider_error.
*    "handle exception
*ENDTRY.

********************************************************************** END **********************************************************************
  ENDMETHOD.

  METHOD Generate_Header_ID.



********************************************************************** Create the Manifest ID & Status **************************************************************************************
    LOOP AT keys INTO DATA(ls_key).
      SELECT FROM zwip_header FIELDS COUNT( z_manifest_id ) INTO @DATA(lv_max_manifest_id).
      lv_max_manifest_id = lv_max_manifest_id + 1.
      MODIFY ENTITIES OF zi_wip_header IN LOCAL MODE
      ENTITY zi_wip_header
      UPDATE SET FIELDS WITH VALUE #( ( %tky = ls_key-%tky ZManifestId = lv_max_manifest_id
      ZStatus = 'Not Started' ) )
       REPORTED DATA(update_reported).
      reported = CORRESPONDING #( DEEP update_reported ).
    ENDLOOP.
********************************************************************************************************************************************

  ENDMETHOD.
********************************************************************** Custom Method to check the consistent data in the Supplier conf table **********************************************************************
  METHOD helper_method.

    DATA(x) = iv_value.               "Root key

    DATA: lv_count            TYPE i,
          lv_count_consistent TYPE i.
    " Step 1: Get the weight tolerance data based on ZUuid
    READ ENTITY zi_wip_header
      BY \_itm
      ALL FIELDS
      WITH VALUE #( ( %key-ZUuid = iv_value ) )
      RESULT DATA(lt_weight_tol)
      FAILED DATA(failed_rba_weight_tol).

********************************************************************** Group the Attachment **********************************************************************
    " Step 2: Get the distinct ZAttuuid values with the required information
    SELECT ZAttuuid,
           MAX( SupplierconfUuid ) AS SupplierconfUuid,
           MAX( ZPoid ) AS ZPoid,
           MAX( ZPoitmId ) AS ZPoitmId,
           MAX( ZStatus ) AS ZStatus
      FROM zi_supplier_conf
      WHERE ZUuid = @iv_value
      GROUP BY ZAttuuid
      INTO TABLE @DATA(lt_att).


    LOOP AT lt_att INTO DATA(ls_att).
      lv_count_consistent = 0.
      lv_count = 0.

      LOOP AT lt_weight_tol INTO DATA(ls_weight_tol1) WHERE ZAttuuid = ls_att-ZAttuuid AND ZStatus = 'Consistent'.        "Get the Consistent count
        lv_count_consistent = lv_count_consistent + 1.
      ENDLOOP.

      LOOP AT lt_weight_tol INTO DATA(ls_weight_tol_count) WHERE ZAttuuid = ls_att-ZAttuuid.              "Overall attachment data count
        lv_count = lv_count + 1.
      ENDLOOP.

      " If the counts match, update the entity
      IF lv_count = lv_count_consistent.
        MODIFY ENTITIES OF zi_wip_header IN LOCAL MODE
          ENTITY zi_wip_header
          UPDATE SET FIELDS WITH VALUE #(
            ( %tky-ZUuid = iv_value
              ZStatus = 'Consistent'
            ) )
          REPORTED DATA(update_reported_att).
      ELSE.
        MODIFY ENTITIES OF zi_wip_header IN LOCAL MODE
     ENTITY zi_wip_header
     UPDATE SET FIELDS WITH VALUE #(
       ( %tky-ZUuid = iv_value
         ZStatus = 'In-Consistent'
     ) )
     REPORTED DATA(update_reported_inatt).
      ENDIF.

      " Reset counts for the next ZAttuuid
      CLEAR: lv_count, lv_count_consistent.

    ENDLOOP.

  ENDMETHOD.


  METHOD main_method.
    DATA(x) = iv_datevalue.

    DATA: lv_integer        TYPE i,
          lv_numeric_date   TYPE i,
          lv_base_date      TYPE d VALUE '19000101',
          lv_date           TYPE d,
          lv_converted_date TYPE string.

    " Convert string to integer and calculate numeric date
    lv_integer = CONV i( iv_datevalue ).
    lv_numeric_date = lv_integer.
    lv_date = lv_base_date + ( lv_numeric_date - 2 ).

    " Format date into YYYY-MM-DD
    lv_converted_date = |{ lv_date+0(4) }{ lv_date+4(2) }{ lv_date+6(2) }|.

    rv_result = lv_converted_date.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_ATTACHMENT_TBL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS Generate_Itm_ID FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_attachment_tbl~Generate_Itm_ID.

ENDCLASS.

CLASS lhc_ZI_ATTACHMENT_TBL IMPLEMENTATION.

  METHOD Generate_Itm_ID.
********************************************************************** Read the Attachment Table ********************************************************************
    DATA lv_att_uuid TYPE zi_attachment_tbl-zuuid.
    "Read the Attachment tbl
    READ ENTITIES OF zi_wip_header IN LOCAL MODE
    ENTITY zi_attachment_tbl
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_att_tbl).
    LOOP AT lt_att_tbl INTO DATA(ls_att_tbl).
      IF ls_att_tbl-zuuid IS NOT INITIAL.
        lv_att_uuid = ls_att_tbl-zuuid.                 "Store the UUID
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_att_uuid IS NOT INITIAL.
      DATA(keys_count) = 0.
      LOOP AT keys INTO DATA(ls_key).

        "Select the Attachment table row count
        SELECT COUNT( * ) FROM zi_attachment_tbl WHERE zuuid = @lv_att_uuid INTO @DATA(lv_last_attid).
        lv_last_attid = lv_last_attid + 1 + keys_count.
        keys_count = keys_count + 1.
****************************************************************************** Update the file id, status, consistent ******************************************************************************
        MODIFY ENTITIES OF zi_wip_header IN LOCAL MODE
        ENTITY zi_attachment_tbl
        UPDATE SET FIELDS WITH VALUE #( ( zattuuid = ls_key-zattuuid zattid = 'File-'
        && lv_last_attid zconsistencystatus = 'In-Consistent' zstatus = 'Not Started' ) )
        REPORTED DATA(update_reported).
        reported = CORRESPONDING #( DEEP update_reported ).
****************************************************************************** Update the Root Table Status field ******************************************************************************
*        SELECT SINGLE FROM zi_wip_header FIELDS ZStatus WHERE zuuid = @lv_att_uuid INTO @DATA(lv_sts).        "Read the Root table
*        IF ls_att_tbl-ZFilename IS NOT INITIAL.      "lv_sts eq 'In Preparation' or lv_sts eq ''                                                                     "Inpreparation status
*          MODIFY ENTITIES OF zi_wip_header IN LOCAL MODE                                                        "Update the root fields
*        ENTITY zi_wip_header
*        UPDATE SET FIELDS WITH VALUE #( ( ZUuid = ls_att_tbl-ZUuid ZStatus = 'Document Uploaded' ) )
*        REPORTED DATA(update_reported_hdr).
*          reported = CORRESPONDING #( DEEP update_reported_hdr ).
*        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_WIP_HEADER DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_WIP_HEADER IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
