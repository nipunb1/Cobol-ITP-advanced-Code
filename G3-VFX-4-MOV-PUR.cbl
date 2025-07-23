      ******************************************************************
      *PROGRAM:  Vuflix TITLES PURCHASED PAGE
      *AUTHOR:   Jarrod Lee
      *DATE:     4/9/2014   
      *ABSTRACT: 
      ******************************************************************
       PROGRAM-ID. G3-VFX-4-MOV-PUR IS INITIAL.
      ******************************************************************
       ENVIRONMENT DIVISION.
       COPY SELECT-VFX-PUR.
       COPY SELECT-VFX-MOV.
       COPY SELECT-VFX-MBR.
       COPY SELECT-ZIP.
      ******************************************************************
       DATA DIVISION.
       FILE SECTION.
       COPY FD-VFX-PUR.
       COPY FD-VFX-MOV.
       COPY FD-VFX-MBR.
       COPY FD-ZIP.
       
       WORKING-STORAGE SECTION.
       COPY WS-VFX.
       
       SCREEN SECTION.
       COPY SCREEN-VFX-4-MOV-PUR.
      ******************************************************************
       PROCEDURE DIVISION.
       000-MAIN.
       MOVE FUNCTION CURRENT-DATE TO WS-TSTAMP.
       MOVE 'G3-VFX-4-MOV-PUR' TO VFX-M-PROG.
       OPEN INPUT  VTP-FILE
                   VML-FILE
                   VM-FILE
                   ZIP-MST-OUT.
       PERFORM 100-CHECK.
       DISPLAY PTSCREEN-HEADER.
       DISPLAY PTSCREEN-LABEL.
       DISPLAY SPACES.
       
       MOVE VFX-4-SEARCH-ID TO VTP-VM-ID-KEY.
       START VTP-FILE KEY NOT LESS THAN VTP-VM-ID-KEY                                      
           INVALID KEY
               DISPLAY 'OOPS'
               ACCEPT VFX-4-RESP
           NOT INVALID KEY
               READ VTP-FILE NEXT RECORD
                   
               PERFORM 100-DISPLAY
       END-START.
       PERFORM UNTIL VFX-4-CHECK = 'Q'
           READ VTP-FILE NEXT RECORD
               AT END
                   MOVE 'Q' TO VFX-4-CHECK
               NOT AT END
                   PERFORM 100-DISPLAY
           END-READ
       END-PERFORM.
       CLOSE   VTP-FILE
               VML-FILE
               VM-FILE
               ZIP-MST-OUT.
       ACCEPT  VFX-4-RESP.
       GOBACK.
      ******************************************************************
       100-DISPLAY.
       ADD 1 TO VFX-4-CTR.
       IF VFX-4-CTR GREATER THAN 15
           DISPLAY PTSCREEN-HEADER
           DISPLAY PTSCREEN-LABEL
           DISPLAY SPACES
           MOVE 1 TO VFX-4-CTR
       END-IF.
       IF VTP-VM-ID-KEY = VFX-4-SEARCH-ID
           IF VTP-VML-ID-KEY = VFX-4-ID
               MOVE 'O' TO VFX-4-LOOP
           ELSE
               MOVE VTP-VML-ID-KEY TO VML-ID-KEY
               READ VML-FILE KEY VML-ID
                   INVALID KEY
                       DISPLAY 'SOMETHING WENT WRONG'
                       ACCEPT VFX-4-RESP
                       PERFORM 000-MAIN
                   NOT INVALID KEY
                       MOVE VML-ID     TO VFX-4-ID
                       MOVE VML-TITLE  TO VFX-4-TITLE
                       MOVE VML-GENRE  TO VFX-4-GENRE
                       MOVE VML-PRICE  TO VFX-4-PRICE
               END-READ
           END-IF
           IF VFX-4-LOOP = 'O'
               CONTINUE
           ELSE
               DISPLAY VFX-4-VML-LINE
           END-IF
       END-IF.
      ******************************************************************
       100-CHECK.
       DISPLAY IDSCREEN.
       ACCEPT CHOOSEID.
       IF VFX-4-SEARCH-ID = '99999999'
           GOBACK
       END-IF.
       PERFORM UNTIL VFX-4-CHECK = 'Y' OR 'y'
           MOVE SPACES TO VFX-4-CHECK
           MOVE VFX-4-SEARCH-ID TO VM-ID-KEY
           READ VM-FILE
               INVALID KEY
                   MOVE 'INVALID ID' TO VFX-2-MSG
               NOT INVALID KEY
                   MOVE SPACES TO VFX-2-MSG
                   PERFORM 200-MOVE
           END-READ
           IF VFX-4-RESP = 'C'
               CONTINUE
           ELSE
               DISPLAY IDSCREEN
               ACCEPT CHOOSEID
           END-IF
       END-PERFORM.
      ******************************************************************
       200-MOVE.
       MOVE 'C'        TO VFX-4-RESP.
       MOVE VM-ZIP     TO ZIP-KEY.
       START   ZIP-MST-OUT KEY NOT LESS THAN   ZIP-KEY.
       READ    ZIP-MST-OUT KEY IS              ZIP-KEY.
       MOVE SPACES     TO VFX-4-ORIG.
       MOVE VM-ID      TO VFX-4-ORIG-ID.
       MOVE VM-FNAME   TO VFX-4-ORIG-FNAME.
       MOVE VM-LNAME   TO VFX-4-ORIG-LNAME.
       MOVE VM-ADDRESS TO VFX-4-ORIG-ADDRESS.
       MOVE ZIP-CITYO  TO VFX-4-ORIG-CITY.
       MOVE ZIP-STATEO TO VFX-4-ORIG-STATE.
       MOVE VM-ZIP     TO VFX-4-ORIG-ZIP.
       MOVE VM-PHONE   TO VFX-4-ORIG-PHONE.
       MOVE VM-EMAIL   TO VFX-4-ORIG-EMAIL.
       MOVE VM-CC      TO VFX-4-ORIG-CC.
       DISPLAY CHECKSCREEN.
       ACCEPT CHECK.
       IF VFX-4-CHECK = 'Y' OR 'y'
           CONTINUE
       ELSE
           MOVE SPACES TO VFX-4-RESP
           PERFORM 100-CHECK
       END-IF.