; #FUNCTION# ====================================================================================================================
; Name ..........: GetXPosOfArmySlot
; Description ...:
; Syntax ........: GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)
; Parameters ....: $slotNumber          - a string value.
;                  $xOffsetFor11Slot    - an unknown value.
; Return values .: None
; Author ........:
; Modified ......: Promac(12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; - Func GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)
; - 
; -     Local $CheckSlot12, $SlotPixelColorTemp, $SlotPixelColor1
Func GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot, $bNeedNewCapture = Default)   ; ExtendedAttackBar
    If $bNeedNewCapture = Default Then $bNeedNewCapture = True                       ; ExtendedAttackBar
    Local $CheckSlot12, $SlotPixelColorTemp, $SlotPixelColor1 , $SlotComp            ; ExtendedAttackBar

    $xOffsetFor11Slot -= 8

; -  Local $SlotComp = ($slotNumber = 7 ? 1 : 0)
    Switch $slotNumber      ; ExtendedAttackBar
        Case 7              ; ExtendedAttackBar
            $SlotComp = 1   ; ExtendedAttackBar
        Case Else           ; ExtendedAttackBar
            $SlotComp = 0   ; ExtendedAttackBar
    EndSwitch               ; ExtendedAttackBar

    If $slotNumber = $g_iKingSlot Or $slotNumber = $g_iQueenSlot Or $slotNumber = $g_iWardenSlot Then $xOffsetFor11Slot += 8

    ; ExtendedAttackBar                                                            ; ExtendedAttackBar
    If $g_bDraggedAttackBar Then Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72) + 14    ; ExtendedAttackBar
                                                                                                   ; ExtendedAttackBar
    Local $oldBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)                              ; ExtendedAttackBar
    ; check Dark color on slot 0 to verify if exists > 11 slots
    ; $SlotPixelColor = _ColorCheck(_GetPixelColor(17, 580 + $g_iBottomOffsetY, True), Hex(0x07202A, 6), 20)
; - $CheckSlot12 = _ColorCheck(_GetPixelColor(17, 643, True), Hex(0x478AC6, 6), 15) Or _       ; Slot Filled / Background Blue / More than 11 Slots
; -         _ColorCheck(_GetPixelColor(17, 643, True), Hex(0x434343, 6), 10) ; Slot deployed / Gray / More than 11 Slots
; -
    If $bNeedNewCapture = True Then                                                                                                                                             ; ExtendedAttackBar
        $CheckSlot12 = _ColorCheck(_GetPixelColor(17, 643, True), Hex(0x478AC6, 6), 15) Or _      ; Slot Filled / Background Blue / More than 11 Slots                          ; ExtendedAttackBar
                    _ColorCheck(_GetPixelColor(17, 643, True), Hex(0x434343, 6), 10)           ; Slot deployed / Gray / More than 11 Slots                                      ; ExtendedAttackBar
    Else                                                                                                                                                                        ; ExtendedAttackBar
        $CheckSlot12 = _ColorCheck(Hex(_GDIPlus_BitmapGetPixel($oldBitmap, 17, 643), 6), Hex(0x478AC6, 6), 15) Or _      ; Slot Filled / Background Blue / More than 11 Slots   ; ExtendedAttackBar
                    _ColorCheck(Hex(_GDIPlus_BitmapGetPixel($oldBitmap, 17, 643), 6), Hex(0x434343, 6), 10)           ; Slot deployed / Gray / More than 11 Slots               ; ExtendedAttackBar
    EndIf                                                                                                                                                                       ; ExtendedAttackBar
                                                                                                                                                                                
    If $g_bDebugSetlog Then
        SetDebugLog(" Slot 0  _ColorCheck 0x478AC6 at (17," & 643 & "): " & $CheckSlot12, $COLOR_DEBUG) ;Debug
; -     $SlotPixelColorTemp = _GetPixelColor(17, 643, $g_bCapturePixel)
        If $bNeedNewCapture = True Then                                                                      ; ExtendedAttackBar
            $SlotPixelColorTemp = _GetPixelColor(17, 643, $g_bCapturePixel)                                  ; ExtendedAttackBar
        Else                                                                                                 ; ExtendedAttackBar
            $SlotPixelColorTemp = Hex(_GDIPlus_BitmapGetPixel($oldBitmap, 17, 643), 6) ; Get pixel color     ; ExtendedAttackBar
        EndIf                                                                                                ; ExtendedAttackBar
        SetDebugLog(" Slot 0  _GetPixelColo(17," & 643 & "): " & $SlotPixelColorTemp, $COLOR_DEBUG) ;Debug
    EndIf

    _GDIPlus_BitmapDispose($oldBitmap)   ; ExtendedAttackBar
                                         ; ExtendedAttackBar
    If Not $CheckSlot12 Then
        Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72)
    Else
		Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72) - 13
	EndIf

EndFunc   ;==>GetXPosOfArmySlot
