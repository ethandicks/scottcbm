 ;
 ; DEBUGGING STUFF
 ;

 .MAC RSAVE
   PHA
   TXA
   PHA
   TYA
   PHA
 .ENDM

 .MAC RREST
   PLA
   TAY
   PLA
   TAX
   PLA
 .ENDM

;
; Debugging strings/messages
;
RMDMSG .BYTE "ROOM=",0
CMDMSG .BYTE "CMD='",0
NVMSG  .BYTE "NV='",0
VMMSG  .BYTE "MATCH='",0
TSFMSG .BYTE "Test bit ",0
PFMSG  .BYTE "F1/F2 = ",0
MNMSG  .BYTE "MSG #",0
TNMSG  .BYTE "TEST #",0
ANMSG  .BYTE "ACTION #",0

MSGEND .BYTE "'",CR,0

SDMSG  .BYTE "-- START DAEMONS --",CR,0
EDMSG  .BYTE "-- END DAEMONS --",CR,0

;
; Debugging code snippets
;

; Print the verb and noun numbers just typed
DB_CMD
 RSAVE
 PRINT CMDMSG
 LDA VERB
 JSR DPRINT
 LDA NOUN
 JSR DPRINT
 PRINT MSGEND
 RREST
 RTS
;

; Print the room number
DB_ROOMN
 RSAVE
 PRINT RMDMSG
 LDA ROOM
 JSR DPRINT
 JSR CRLF
 RREST
 RTS
;

; Mark start and stop of Daemon checks
DB_STD
 RSAVE
 PRINT SDMSG
 RREST
 RTS
;
DB_EDD
 RSAVE
 PRINT EDMSG
 RREST
 RTS
;

; Print message number to be printed
DB_MSGN
 STA VTMP
 RSAVE
 PRINT MNMSG
 LDA VTMP
 JSR DPRINT
 JSR CRLF
 RREST
 RTS
;

; Print test routine to be executed
DB_TSTN
 STA VTMP
 RSAVE
 PRINT TNMSG
 LDA VTMP
 JSR DPRINT
 JSR CRLF
 RREST
 RTS
;

; Print action routine to be executed
DB_ACTN
 STA VTMP
 RSAVE
 PRINT ANMSG
 LDA VTMP
 JSR DPRINT
 JSR CRLF
 RREST
 RTS
;

; Print out info from testing SF bits
DB_TSTSF
 RSAVE
 PRINT TSFMSG
 LDA SF
 JSR DB_PHEX
 LDA SF+1
 JSR DB_PHEX
 LDA LL
 JSR DPRINT
 JSR CRLF
 RREST
 RTS
;

; Print out state of F1 and F2 flags
DB_PF12
 RSAVE
 PRINT PFMSG
 LDA F1
 JSR DB_PHEX
 LDA #$20
 JSR OUTCH
 LDA F2
 JSR DB_PHEX
 JSR CRLF
 RREST
 RTS

; Print out matching rule number (daemons and player command)
DB_VMAT
 RSAVE
 PRINT VMMSG
 SEC
 LDA INDEX2
 SBC #<SENMAT
 STA VTMP
 LDA INDEX2+1
 SBC #>SENMAT
 STA VTMP+1

 LDA VTMP+1
 ASL
 ROR VTMP+1
 ROR VTMP 
 LDA VTMP+1
 ASL
 ROR VTMP+1
 ROR VTMP 
 LDA VTMP+1
 ASL
 ROR VTMP+1
 ROR VTMP 
 LDA VTMP+1
 ASL
 ROR VTMP+1
 ROR VTMP 

 LDA VTMP
 JSR DPRINT
 PRINT MSGEND 
 RREST
 RTS

DB_PHEX
 PHA
 LSR
 LSR
 LSR
 LSR
 JSR DB_PNYB
 PLA
 JSR DB_PNYB
 RTS
;
DB_PNYB
 AND #15
 CMP #10
 BCC DB_PDIG
 ADC #6
DB_PDIG
 ADC #$30
 JSR OUTCH
 RTS
 
VTMP
 .WORD 0
;
