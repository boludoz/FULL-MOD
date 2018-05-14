; War preparation GUI Control
Func ChkStopForWar()
	If GUICtrlRead($g_hChkStopForWar) = $GUI_CHECKED Then
		For $i = $g_hCmbStopTime To $g_hChkTrainWarTroop
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		ChkTrainWarTroop()
		GUICtrlSetState($g_hChkRequestCCForWar, $GUI_ENABLE)
		ChkRequestCCForWar()
	Else
		For $i = $g_hCmbStopTime To $g_hTxtRequestCCForWar
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, $COLOR_MONEYGREEN)
	EndIf
EndFunc

Func CmbStopTime()
	If _GUICtrlComboBox_GetCurSel($g_CmbStopBeforeBattle) < 1 Then Return
	If _GUICtrlComboBox_GetCurSel($g_hCmbStopTime) >= 24 - _GUICtrlComboBox_GetCurSel($g_hCmbReturnTime) Then
		_GUICtrlComboBox_SetCurSel($g_hCmbReturnTime, 0)
		ToolTip("Set Return Time: " & @CRLF & "Pause time should be before Return time.")
		Sleep(3500)
		ToolTip('')
	EndIf
EndFunc

Func CmbReturnTime()
	If _GUICtrlComboBox_GetCurSel($g_CmbStopBeforeBattle) < 1 Then Return
	If _GUICtrlComboBox_GetCurSel($g_hCmbReturnTime) >= 24 - _GUICtrlComboBox_GetCurSel($g_hCmbStopTime) Then
		_GUICtrlComboBox_SetCurSel($g_hCmbReturnTime, 0)
		ToolTip("Set Return Time: " & @CRLF & "Return time should be after Pause time.")
		Sleep(3500)
		ToolTip('')
	EndIf
EndFunc

Func ChkTrainWarTroop()
	If GUICtrlRead($g_hChkTrainWarTroop) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkUseQuickTrainWar, $GUI_ENABLE)
		GUICtrlSetState($g_hChkX2ForWar, $GUI_ENABLE) ; War
		chkUseQTrainWar()
	Else
		For $i = $g_hChkUseQuickTrainWar To $g_hLblCountWarSpellsTotal
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, $COLOR_MONEYGREEN)
		GUICtrlSetState($g_hChkX2ForWar, $GUI_DISABLE) ; War
	EndIf
EndFunc

Func chkUseQTrainWar()
	If GUICtrlRead($g_hChkUseQuickTrainWar) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_ahChkArmyWar[0] & "#" & $g_ahChkArmyWar[1] & "#" & $g_ahChkArmyWar[2])
		chkQuickTrainComboWar()
		For $i = $g_hLblRemoveArmy To $g_hLblCountWarSpellsTotal
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, $COLOR_MONEYGREEN)
	Else
		_GUI_Value_STATE("DISABLE", $g_ahChkArmyWar[0] & "#" & $g_ahChkArmyWar[1] & "#" & $g_ahChkArmyWar[2])
		For $i = $g_hLblRemoveArmy To $g_hLblCountWarSpellsTotal
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		lblTotalWarTroopCount()
		lblTotalWarSpellCount()
	EndIf
EndFunc

Func chkQuickTrainComboWar()
	If GUICtrlRead($g_ahChkArmyWar[0]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmyWar[1]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmyWar[2]) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_ahChkArmyWar[0], $GUI_CHECKED)
		ToolTip("QuickTrainCombo: " & @CRLF & "At least 1 Army Check is required! Default Army 1.")
		Sleep(2000)
		ToolTip('')
	EndIf
EndFunc

Func RemovecampWar()
	For $T = 0 To $eTroopCount - 1
		$g_aiWarCompTroops[$T] = 0
		GUICtrlSetData($g_ahTxtTrainWarTroopCount[$T], 0)
	Next
	For $S = 0 To $eSpellCount - 1
		$g_aiWarCompSpells[$S] = 0
		GUICtrlSetData($g_ahTxtTrainWarSpellCount[$S], 0)
	Next
	lblTotalWarTroopCount()
	lblTotalWarSpellCount()
EndFunc

Func lblTotalWarTroopCount($TotalArmyCamp = 0)
	Local $TotalTroopsToTrain
	If $TotalArmyCamp = 0 Then $TotalArmyCamp = $g_bTotalCampForced ? $g_iTotalCampForcedValue : 260

	For $i = 0 To $eTroopCount - 1
		Local $iCount = GUICtrlRead($g_ahTxtTrainWarTroopCount[$i])
		If $iCount > 0 Then
			$TotalTroopsToTrain += $iCount * $g_aiTroopSpace[$i]
		Else
			GUICtrlSetData($g_ahTxtTrainWarTroopCount[$i], 0)
		EndIf
	Next

	GUICtrlSetData($g_hLblCountWarTroopsTotal, String($TotalTroopsToTrain))

	If $TotalTroopsToTrain = $TotalArmyCamp Then
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, $COLOR_MONEYGREEN)
	ElseIf $TotalTroopsToTrain > $TotalArmyCamp / 2 And $TotalTroopsToTrain < $TotalArmyCamp Then
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, $COLOR_ORANGE)
	Else
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, $COLOR_RED)
	EndIf

	Local $fPctOfCalculated = Floor(($TotalTroopsToTrain / $TotalArmyCamp) * 100)

	GUICtrlSetData($g_hCalTotalWarTroops, $fPctOfCalculated < 1 ? ($TotalTroopsToTrain > 0 ? 1 : 0) : $fPctOfCalculated)

	If $TotalTroopsToTrain > $TotalArmyCamp Then
		GUICtrlSetState($g_hLblTotalWarTroopsProgress, $GUI_SHOW)
	Else
		GUICtrlSetState($g_hLblTotalWarTroopsProgress, $GUI_HIDE)
	EndIf

EndFunc

Func lblTotalWarSpellCount($TotalArmyCamp = 0 )

	Local $TotalSpellsToBrew
	If $TotalArmyCamp = 0 Then $TotalArmyCamp = $g_iTotalSpellValue > 0 ? $g_iTotalSpellValue : 11

	For $i = 0 To $eSpellCount - 1
		Local $iCount = GUICtrlRead($g_ahTxtTrainWarSpellCount[$i])
		If $iCount > 0 Then
			$TotalSpellsToBrew += $iCount * $g_aiSpellSpace[$i]
		Else
			GUICtrlSetData($g_ahTxtTrainWarSpellCount[$i], 0)
		EndIf
	Next

	GUICtrlSetData($g_hLblCountWarSpellsTotal, String($TotalSpellsToBrew))

	If $TotalSpellsToBrew = $TotalArmyCamp Then
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, $COLOR_MONEYGREEN)
	ElseIf $TotalSpellsToBrew > $TotalArmyCamp / 2 And $TotalSpellsToBrew < $TotalArmyCamp Then
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, $COLOR_ORANGE)
	Else
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, $COLOR_RED)
	EndIf

	Local $fPctOfCalculated = Floor(($TotalSpellsToBrew / $TotalArmyCamp) * 100)

	GUICtrlSetData($g_hCalTotalWarSpells, $fPctOfCalculated < 1 ? ($TotalSpellsToBrew > 0 ? 1 : 0) : $fPctOfCalculated)

	If $TotalSpellsToBrew > $TotalArmyCamp Then
		GUICtrlSetState($g_hLblTotalWarSpellsProgress, $GUI_SHOW)
	Else
		GUICtrlSetState($g_hLblTotalWarSpellsProgress, $GUI_HIDE)
	EndIf

EndFunc

Func TrainWarTroopCountEdit()
	For $i = 0 To $eTroopCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainWarTroopCount[$i] Then
			$g_aiWarCompTroops[$i] = GUICtrlRead($g_ahTxtTrainWarTroopCount[$i])
			lblTotalWarTroopCount()
			Return
		EndIf
	Next
EndFunc

Func TrainWarSpellCountEdit()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainWarSpellCount[$i] Then
			$g_aiWarCompSpells[$i] = GUICtrlRead($g_ahTxtTrainWarSpellCount[$i])
			lblTotalWarSpellCount()
			Return
		EndIf
	Next
EndFunc

Func ChkRequestCCForWar()
	If GUICtrlRead($g_hChkRequestCCForWar) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCCForWar, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtRequestCCForWar, $GUI_DISABLE)
	EndIf
EndFunc
