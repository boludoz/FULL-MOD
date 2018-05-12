Global $hGUI_MOD = 0
Local $sTxtTip

$hGUI_MOD = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, $WS_CHILD, -1, $g_hFrmBotEx)

GUISwitch($hGUI_MOD)

GUICtrlCreateGroup("", -99, -99, 1, 1)
SplashStep("Loading Mod - Friend Challenge tab...")
GUICtrlCreateTabItem(GetTranslatedFileIni("Mod","Friendly Challenge", "Friend Challenge"))


Local $x = 10, $y = 30

SetupFriendlyChallengeGUI($x, $y)

GUICtrlCreateTabItem("") ; end tabitem definition
