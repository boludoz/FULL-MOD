Global $hGUI_MOD = 0
Local $sTxtTip

$hGUI_MOD = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, $WS_CHILD, -1, $g_hFrmBotEx)

GUISwitch($hGUI_MOD)



;;================================= Friendly Challenge ===============================================
SplashStep("Loading Mods - Friendly Challenge...")
GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $TCS_FLATBUTTONS)
GUICtrlCreateTabItem(GetTranslatedFileIni("Mod", 11, "Friendly Challenge"))

Local $x = 10, $y = 30

SetupFriendlyChallengeGUI($x, $y)

GUICtrlCreateTabItem("") ; end tabitem definition

;;================================= War troops ===============================================
SplashStep("Loading Mods - War troops...")
GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $TCS_FLATBUTTONS)
GUICtrlCreateTabItem(GetTranslatedFileIni("Mod", 12, "War troops"))

Local $x = 10, $y = 30

; War preparation (Demen) Design
    Local $aTroopsIcons[19] = [$eIcnBarbarian, $eIcnArcher, $eIcnGiant, $eIcnGoblin, $eIcnWallBreaker, $eIcnBalloon, _
            $eIcnWizard, $eIcnHealer, $eIcnDragon, $eIcnPekka, $eIcnBabyDragon, $eIcnMiner, $eIcnMinion, _
            $eIcnHogRider, $eIcnValkyrie, $eIcnGolem, $eIcnWitch, $eIcnLavaHound, $eIcnBowler]
    Local $aSpellsIcons[10] =[$eIcnLightSpell, $eIcnHealSpell, $eIcnRageSpell, $eIcnJumpSpell, $eIcnFreezeSpell, _
            $eIcnCloneSpell, $eIcnPoisonSpell, $eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnSkeletonSpell]

    Local $x = 15, $y = 40

        $g_hChkStopForWar = GUICtrlCreateCheckbox("Pause farming for war", $x, $y, -1, -1)
            _GUICtrlSetTip(-1, "Pause or set current account 'idle' to prepare for war")
            GUICtrlSetOnEvent(-1, "ChkStopForWar")

        $g_hCmbStopTime = GUICtrlCreateCombo("", $x + 140, $y, 60, -1)
            GUICtrlSetData(-1,     "0 hr|1 hr|2 hrs|3 hrs|4 hrs|5 hrs|6 hrs|7 hrs|8 hrs|9 hrs|10 hrs|11 hrs|12 hrs |13 hrs|14 hrs|15 hrs|16 hrs|17 hrs|18 hrs|19 hrs|20 hrs|21 hrs|22 hrs|23 hrs", "0 hr")
            GUICtrlSetOnEvent(-1,"CmbStopTime")
        $g_CmbStopBeforeBattle = GUICtrlCreateCombo("", $x + 220, $y, 120, -1)
            GUICtrlSetData(-1,     "before battle start|after battle start", "before battle start")
            GUICtrlSetOnEvent(-1,"CmbStopTime")

    $y += 25
        GUICtrlCreateLabel("Return to farm", $x + 15, $y + 1, -1, -1)
        $g_hCmbReturnTime = GUICtrlCreateCombo("", $x + 140, $y, 60, -1)
            GUICtrlSetData(-1,     "0 hr|1 hr|2 hrs|3 hrs|4 hrs|5 hrs|6 hrs|7 hrs|8 hrs|9 hrs|10 hrs|11 hrs|12 hrs |13 hrs|14 hrs|15 hrs|16 hrs|17 hrs|18 hrs|19 hrs|20 hrs|21 hrs|22 hrs|23 hrs", "0 hr")
            GUICtrlSetOnEvent(-1,"CmbReturnTime")
        GUICtrlCreateLabel("before battle finish", $x + 220, $y + 1, -1, -1)

    $y += 25
        $g_hChkTrainWarTroop = GUICtrlCreateCheckbox("Delete all farming troops and train war troops before pausing", $x, $y, -1, -1)
            GUICtrlSetOnEvent(-1, "ChkTrainWarTroop")

    $y += 25
        $g_hChkUseQuickTrainWar = GUICtrlCreateCheckbox("Use Quick Train", $x + 15, $y, -1, 15)
            GUICtrlSetState(-1, $GUI_UNCHECKED)
            GUICtrlSetOnEvent(-1, "chkUseQTrainWar")
        For $i = 0 To 2
            $g_ahChkArmyWar[$i] = GUICtrlCreateCheckbox("Army " & $i + 1, $x + 120 + $i * 60, $y, 50, 15)
                GUICtrlSetState(-1, $GUI_DISABLE)
                If $i = 0 Then GUICtrlSetState(-1, $GUI_CHECKED)
                GUICtrlSetOnEvent(-1, "chkQuickTrainComboWar")
        Next
        $g_hLblRemoveArmy = GUICtrlCreateLabel("Remove Army", $x + 305, $y + 1, -1, 15, $SS_LEFT)
        _GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x + 375, $y - 4, 24, 24)
            GUICtrlSetOnEvent(-1, "RemovecampWar")

    $x = 30
    $y += 25
        For $i = 0 To 18 ; Troops
            If $i >= 12 Then $x = 37
            _GUICtrlCreateIcon($g_sLibIconPath, $aTroopsIcons[$i], $x + Int($i / 2) * 38, $y + Mod($i, 2) * 60, 32, 32)

            $g_ahTxtTrainWarTroopCount[$i] = GUICtrlCreateInput("0", $x + Int($i / 2) * 38 + 1, $y + Mod($i, 2) * 60 + 34, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
                GUICtrlSetLimit(-1, 3)
                GUICtrlSetOnEvent(-1, "TrainWarTroopCountEdit")
        Next

    $x = 30
    $y += 120
        $g_hCalTotalWarTroops = GUICtrlCreateProgress($x, $y + 3, 285, 10)
        $g_hLblTotalWarTroopsProgress = GUICtrlCreateLabel("", $x, $y + 3, 285, 10)
            GUICtrlSetBkColor(-1, $COLOR_RED)
            GUICtrlSetState(-1, BitOR($GUI_DISABLE, $GUI_HIDE))

        GUICtrlCreateLabel("Total troops", $x + 290, $y, -1, -1)
        $g_hLblCountWarTroopsTotal = GUICtrlCreateLabel("" & 0, $x + 350, $y, 30, 15, $SS_CENTER)
            GUICtrlSetBkColor(-1, $COLOR_MONEYGREEN) ;lime, moneygreen

    $y += 25
        For $i = 0 To 9 ; Spells
            If $i >= 6 Then $x = 37
            _GUICtrlCreateIcon($g_sLibIconPath, $aSpellsIcons[$i], $x + $i * 38, $y, 32, 32)
            $g_ahTxtTrainWarSpellCount[$i] = GUICtrlCreateInput("0", $x +  $i * 38, $y + 34, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
                GUICtrlSetLimit(-1, 3)
                GUICtrlSetOnEvent(-1, "TrainWarSpellCountEdit")
        Next

	$x = 30
	$y += 60
		$g_hCalTotalWarSpells = GUICtrlCreateProgress($x, $y + 3, 285, 10)
		$g_hLblTotalWarSpellsProgress = GUICtrlCreateLabel("", $x, $y + 3, 285, 10)
			GUICtrlSetBkColor(-1, $COLOR_RED)
			GUICtrlSetState(-1, BitOR($GUI_DISABLE, $GUI_HIDE))

		GUICtrlCreateLabel("Total spells", $x + 290, $y, -1, -1)
		$g_hLblCountWarSpellsTotal = GUICtrlCreateLabel("" & 0, $x + 350, $y, 30, 15, $SS_CENTER)
			GUICtrlSetBkColor(-1, $COLOR_MONEYGREEN) ;lime, moneygreen

	$x = 15
	$y += 13
	$g_hChkX2ForWar = GUICtrlCreateCheckbox("Train X2", $x, $y, -1, -1)  ; War
			GUICtrlSetOnEvent(-1, -1)

	$x = 15
	$y += 17
		$g_hChkRequestCCForWar = GUICtrlCreateCheckbox("Request CC before pausing", $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "ChkRequestCCForWar")
		$g_hTxtRequestCCForWar = GUICtrlCreateInput("War troop please", $x + 180, $y, 120, -1, $SS_CENTER)


    GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateTabItem("") ; end tabitem definition