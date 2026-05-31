#Requires AutoHotkey v2.0
#SingleInstance Force

; ========== АВТОЗАПУСК И ИНИЦИАЛИЗАЦИЯ ==========
Persistent

; Глобальные переменные
global clipHistory := []
global pinnedClips := []
global customApps := Map()
global settingsFile := A_ScriptDir "\supermenu_settings.ini"
global startupShortcut := A_Startup "\SuperMenu.lnk"
global notesFile := A_ScriptDir "\supermenu_notes.txt"

; Переменные темы по умолчанию
global currentBgColor := "1a1a2e"
global currentAccentColor := "00d4aa"
global currentTextColor := "FFFFFF"
global currentThemeName := "Blue"

; Переменные языка по умолчанию
global currentLang := "RU"
global showLangSelector := true

; Глобальные состояния виджетов
global resMonitorGui := ""
global isColorPicking := false
global quickGui := ""
global searchBox := ""
global cpuText := ""
global ramText := ""

; Словарь переводов
global LangData := Map(
"RU", Map(
"welcome", "⚡ SUPERMENU v5.0 Ultimate ⚡",
"sub_welcome", "Панель управления Windows",
"office", "📁 Office",
"browsers", "🌐 Браузеры",
"system", "⚙️ Система",
"tools", "🛠️ Инструменты",
"custom", "⭐ Мои файлы/Папки",
"settings", "⚙️ Параметры",
"taskmgr", "🗂️ Диспетчер задач",
"regedit", "📟 Редактор реестра",
"cmd", "💻 Командная строка (CMD)",
"ps", "💙 PowerShell",
"as_admin", "🛡️ От имени админа",
"normal", "👤 Обычный запуск",
"kill_win", "💀 Убить активное окно",
"hidden", "👁️ Показать/Скрыть файлы",
"themes", "🎨 Палитры и Темы",
"notes", "📝 Быстрая заметка",
"save_as", "💾 Сохранить в файл...",
"timer", "⏱️ Таймер",
"alarm", "⏰ Будильник",
"clipboard", "📋 История буфера",
"lang_settings", "🌐 Язык / Language",
"startup", "Автозагрузка",
"help", "📖 Справка",
"reload", "🔄 Перезапуск",
"exit", "❌ Выход",
"add_app", "➕ Добавить программу/папку/сайт",
"del_app", "🗑️ Удалить пункт",
"save", "💾 Сохранить",
"start", "▶️ Запустить",
"hours", "Ч:", "mins", "М:", "secs", "С:",
"timer_done", "Время вышло!",
"alarm_done", "ПОРА ВСТАВАТЬ!",
"search_run", "🔍 Быстрый поиск / Запуск",
"search_holder", "Введите команду, путь, URL или текст для поиска...",
"color_picker", "🎨 Пипетка цветов",
"res_monitor", "🖥️ Монитор ресурсов",
"cpu_usage", "ЦП",
"ram_usage", "ОЗУ",
"pinned_clips", "📍 Закрепленные клипы",
"pin_action", "📌 Закрепить выделенный",
"unpin_action", "🗑️ Открепить",
"copied_tip", "Скопировано в буфер!",
"hotkeys", "Alt+Z`t→ Главное меню`nWin+Space`t→ Быстрый поиск/Запуск`nWin+Shift+P`t→ Пипетка цветов`nWin+Shift+R`t→ Монитор ресурсов`nWin+T`t→ Терминал`nWin+Shift+A`t→ Поверх всех`nWin+Shift+C`t→ Путь файла`nWin+Shift+J`t→ Заметки`nWin+Shift+K`t→ Убить окно`nWin+Shift+H`t→ Скрытые файлы`nWin+Shift+T`t→ Таймер`nWin+Shift+V`t→ Буфер обмена`nWin+F1`t→ Справка`nWin+Shift+Q`t→ Выход" 
), 
"EN", Map( 
"welcome", "⚡ SUPERMENU v5.0 Ultimate ⚡", 
"sub_welcome", "Windows Control Panel", 
"office", "📁 Office", 
"browsers", "🌐 Browsers", 
"system", "⚙️ System", 
"tools", "🛠️ Tools", 
"custom", "⭐ My Files/Folders", 
"settings", "⚙️ Settings", 
"taskmgr", "🗂️ Task Manager", 
"regedit", "📟 Registry Editor", 
"cmd", "💻 Command Prompt (CMD)", 
"ps", "💙 PowerShell", 
"as_admin", "🛡️ Run as Admin", 
"normal", "👤 Normal Run", 
"kill_win", "💀 Kill Active Window", 
"hidden", "👁️ Show/Hide Files", 
"themes", "🎨 Themes & Palettes", 
"notes", "📝 Quick Note", 
"save_as", "💾 Save to File...", 
"timer", "⏱️ Timer", 
"alarm", "⏰ Alarm Clock", 
"clipboard", "📋 Clipboard History", 
"lang_settings", "🌐 Language / Язык", 
"startup", "Startup", 
"help", "📖 Help", 
"reload", "🔄 Reload", 
"exit", "❌ Exit", 
"add_app", "➕ Add App/Folder/Website", 
"del_app", "🗑️ Remove Item", 
"save", "💾 Save", 
"start", "▶️ Start", 
"hours", "H:", "mins", "M:", "secs", "S:", 
"timer_done", "Time is up!", 
"alarm_done", "WAKE UP!", 
"search_run", "🔍 Quick Run / Search", 
"search_holder", "Enter command, path, URL or text to search...", 
"color_picker", "🎨 Screen Color Picker", 
"res_monitor", "🖥️ Resource Monitor", 
"cpu_usage", "CPU", 
"ram_usage", "RAM", 
"pinned_clips", "📍 Pinned Clips", 
"pin_action", "📌 Pin Selected", 
"unpin_action", "🗑️ Unpin", 
"copied_tip", "Copied to clipboard!", 
"hotkeys", "Alt+Z`t→ Main Menu`nWin+Space`t→ Quick Run/Search`nWin+Shift+P`t→ Color Picker`nWin+Shift+R`t→ Resource Monitor`nWin+T`t→ Terminal`nWin+Shift+A`t→ Always on Top`nWin+Shift+C`t→ Copy Path`nWin+Shift+J`t→ Quick Notes`nWin+Shift+K`t→ Kill Window`nWin+Shift+H`t→ Hidden Files`nWin+Shift+T`t→ Timer`nWin+Shift+V`t→ Clipboard`nWin+F1`t→ Help`nWin+Shift+Q`t→ Exit"
)
)

T(key) => LangData[currentLang][key]

; Загрузка настроек и выбор языка при запуске
LoadSettings()
ShowInitialLangSelector()

; ========== ФУНКЦИИ ИНТЕРФЕЙСА (API ЭФФЕКТЫ) ==========

ApplyRoundedCorners(guiObj, width := 16, height := 16) {
    try {
        guiHwnd := guiObj.Hwnd
        rect := Buffer(16)
        DllCall("GetWindowRect", "Ptr", guiHwnd, "Ptr", rect)
        w := NumGet(rect, 8, "Int") - NumGet(rect, 0, "Int")
        h := NumGet(rect, 12, "Int") - NumGet(rect, 4, "Int")
        rgn := DllCall("CreateRoundRectRgn", "Int", 0, "Int", 0, "Int", w, "Int", h, "Int", width, "Int", height, "Ptr")
        DllCall("SetWindowRgn", "Ptr", guiHwnd, "Ptr", rgn, "Int", 1)
    }
}

; ========== ФУНКЦИИ НАСТРОЕК ==========

LoadSettings() {
    global customApps, pinnedClips, currentBgColor, currentAccentColor, currentTextColor, currentLang, showLangSelector, currentThemeName
    if FileExist(settingsFile) {
        try {
            content := ""
            try {
                content := IniRead(settingsFile, "Apps")
            } catch {
                ; Секция Apps пуста
            }

            loop parse, content, "`n", "`r" {
                if InStr(A_LoopField, "=") {
                    parts := StrSplit(A_LoopField, "=", , 2)
                    customApps[parts[1]] := parts[2]
                }
            }
            
            pinnedContent := ""
            try {
                pinnedContent := IniRead(settingsFile, "PinnedClips")
            } catch {
                ; Секция PinnedClips пуста
            }
            loop parse, pinnedContent, "`n", "`r" {
                if InStr(A_LoopField, "=") {
                    parts := StrSplit(A_LoopField, "=", , 2)
                    cleanVal := StrReplace(parts[2], "[NL]", "`n")
                    pinnedClips.Push(cleanVal)
                }
            }
            
            currentBgColor := IniRead(settingsFile, "Theme", "Bg", "1a1a2e")
            currentAccentColor := IniRead(settingsFile, "Theme", "Accent", "00d4aa")
            currentTextColor := IniRead(settingsFile, "Theme", "Text", "FFFFFF")
            currentThemeName := IniRead(settingsFile, "Theme", "Name", "Blue")
            currentLang := IniRead(settingsFile, "Settings", "Language", "RU")
            showLangSelector := (IniRead(settingsFile, "Settings", "ShowLangSelector", "1") = "1")
        }
    }
}

SaveSettings() {
    try {
        try IniDelete(settingsFile, "Apps")
        for name, path in customApps {
            IniWrite(path, settingsFile, "Apps", name)
        }

        try IniDelete(settingsFile, "PinnedClips")
        for idx, text in pinnedClips {
            safeVal := StrReplace(text, "`n", "[NL]")
            IniWrite(safeVal, settingsFile, "PinnedClips", "Clip" idx)
        }
        
        IniWrite(currentBgColor, settingsFile, "Theme", "Bg")
        IniWrite(currentAccentColor, settingsFile, "Theme", "Accent")
        IniWrite(currentTextColor, settingsFile, "Theme", "Text")
        IniWrite(currentThemeName, settingsFile, "Theme", "Name")
        IniWrite(currentLang, settingsFile, "Settings", "Language")
        IniWrite(showLangSelector ? "1" : "0", settingsFile, "Settings", "ShowLangSelector")
    } catch as e {
        MsgBox("Ошибка сохранения настроек: " e.Message)
    }
}

; ========== ЯЗЫКОВЫЕ ФУНКЦИИ ==========

ChangeLanguage(langCode) {
    global currentLang
    currentLang := langCode
    SaveSettings()
    Reload()
}

ToggleLangSelector(*) {
    global showLangSelector
    showLangSelector := !showLangSelector
    SaveSettings()
    Reload()
}

ShowInitialLangSelector() {
    global currentLang, showLangSelector
    if (!showLangSelector) {
        return
    }
    langGui := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale")
    langGui.BackColor := currentBgColor

    langGui.SetFont("s14 c" currentAccentColor " Bold", "Segoe UI")
    langGui.AddText("w320 Center y20", "SELECT LANGUAGE / ЯЗЫК")
    langGui.SetFont("s10 c" currentTextColor, "Segoe UI")

    btnRU := langGui.AddButton("w130 h40 x20 y+20", "Русский")
    btnEN := langGui.AddButton("w130 h40 x170 yP", "English")

    langGui.SetFont("s9 c" currentTextColor)
    chkSkip := langGui.AddCheckbox("x20 y+20 w280 c" currentTextColor, "Don't show on startup / Не показывать при запуске")

    btnRU.OnEvent("Click", (*) => FinishSelection(chkSkip.Value, "RU"))
    btnEN.OnEvent("Click", (*) => FinishSelection(chkSkip.Value, "EN"))

    FinishSelection(skip, lang) {
        global currentLang, showLangSelector
        currentLang := lang
        showLangSelector := !skip
        SaveSettings()
        langGui.Destroy()
    }

    langGui.Show("Center")
    ApplyRoundedCorners(langGui, 20, 20)
}

; ========== СТАРТОВАЯ ПОИСКОВАЯ СТРОКА / RUN (Win+Space) ==========

ShowQuickLauncher() {
    global quickGui, searchBox
    if (quickGui is Gui) {
        try quickGui.Destroy()
    }

    quickGui := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale +Border")
    quickGui.BackColor := currentBgColor

    quickGui.SetFont("s14 c" currentAccentColor " Bold", "Segoe UI")
    quickGui.AddText("x20 y15 w560", T("search_run"))

    quickGui.SetFont("s11 c" currentTextColor, "Segoe UI")
    searchBox := quickGui.AddEdit("x20 y+12 w560 h36 Background333344 c" currentTextColor " -E0x200")

    quickGui.SetFont("s9 c" currentTextColor " Italic")
    quickGui.AddText("x22 y+8 w550 c888888", T("search_holder"))

    btnDefault := quickGui.AddButton("x0 y0 w0 h0 +Default", "")
    btnDefault.OnEvent("Click", (*) => OnSearchEnter())

    quickGui.OnEvent("Escape", OnQuickGuiEscape)

    OnQuickGuiEscape(guiObj) {
        global quickGui
        guiObj.Destroy()
        quickGui := ""
    }

    OnSearchEnter() {
        global quickGui
        query := searchBox.Value
        if (query != "") {
            ExecuteQuickQuery(query)
        }
        quickGui.Destroy()
        quickGui := ""
    }

    quickGui.Show("Center")
    ApplyRoundedCorners(quickGui, 16, 16)
    searchBox.Focus()
}

ExecuteQuickQuery(query) {
    query := Trim(query)

    if FileExist(query) || DirExist(query) {
        SafeRun(query)
        return
    }

    if RegExMatch(query, "^(https?://)?([\w-]+\.)+[\w-]+(/.*)?$") {
        if !RegExMatch(query, "^https?://") {
            query := "https://" query
        }
        SafeRun(query)
        return
    }

    if customApps.Has(query) {
        SafeRun(customApps[query])
        return
    }

    searchUrl := (currentLang = "RU") 
        ? "https://yandex.ru/search/?text=" . UriEncode(query)
        : "https://www.google.com/search?q=" . UriEncode(query)
    SafeRun(searchUrl)
}

UriEncode(str) {
    local decoded := "", char := "", code := 0
    loop parse, str {
        char := A_LoopField
        if RegExMatch(char, "[A-Za-z0-9\-\._~]") {
            decoded .= char
        } else {
            code := Ord(char)
            if (code <= 0x7F) {
                decoded .= "%" . Format("{:02X}", code)
            } else if (code <= 0x7FF) {
                decoded .= "%" . Format("{:02X}", 0xC0 | (code >> 6))
                        . "%" . Format("{:02X}", 0x80 | (code & 0x3F))
            } else {
                decoded .= "%" . Format("{:02X}", 0xE0 | (code >> 12))
                        . "%" . Format("{:02X}", 0x80 | ((code >> 6) & 0x3F))
                        . "%" . Format("{:02X}", 0x80 | (code & 0x3F))
            }
        }
    }
    return decoded
}

; ========== ПИПЕТКА ЦВЕТОВ (Win+Shift+P) ==========

StartColorPicker() {
    global isColorPicking
    if (isColorPicking) {
        return
    }
    isColorPicking := true

    SetTimer(UpdateColorPicker, 15)

    Hotkey("~LButton", StopColorPickerAndCopy, "On")
    Hotkey("Escape", CancelColorPicker, "On")

    TrayTip(T("color_picker"), currentLang="RU" ? "Клик — скопировать, Esc — отмена" : "Left Click to copy, Esc to cancel", 10)
}

UpdateColorPicker() {
    global isColorPicking
    if (!isColorPicking) {
        return
    }

    MouseGetPos(&x, &y)
    try {
        color := PixelGetColor(x, y)
        rgbHex := Format("{:06X}", (color & 0xFF) << 16 | (color & 0xFF00) | (color >> 16) & 0xFF)
        ToolTip("HEX: #" rgbHex "`nRGB: " ((color >> 16) & 0xFF) ", " ((color >> 8) & 0xFF) ", " (color & 0xFF) "`n[Клик - Скопировать]", x + 15, y + 15)
    } catch {
        ToolTip("...")
    }
}

StopColorPickerAndCopy(*) {
    global isColorPicking
    if (!isColorPicking) {
        return
    }
    isColorPicking := false
    SetTimer(UpdateColorPicker, 0)

    Hotkey("~LButton", "Off")
    Hotkey("Escape", "Off")
    ToolTip()

    MouseGetPos(&x, &y)
    try {
        color := PixelGetColor(x, y)
        rgbHex := "#" Format("{:06X}", (color & 0xFF) << 16 | (color & 0xFF00) | (color >> 16) & 0xFF)
        A_Clipboard := rgbHex
        TrayTip(T("color_picker"), T("copied_tip") " (" rgbHex ")", 10)
    }
}

CancelColorPicker(*) {
    global isColorPicking
    isColorPicking := false
    SetTimer(UpdateColorPicker, 0)
    Hotkey("~LButton", "Off")
    Hotkey("Escape", "Off")
    ToolTip()
}

; ========== МОНИТОР РЕСУРСОВ (Win+Shift+R) ==========

ToggleResourceMonitor(*) {
    global resMonitorGui, cpuText, ramText
    if (resMonitorGui != "") {
        SetTimer(UpdateResources, 0)
        resMonitorGui.Destroy()
        resMonitorGui := ""
        return
    }

    resMonitorGui := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000")
    resMonitorGui.BackColor := currentBgColor

    resMonitorGui.SetFont("s10 c" currentAccentColor " Bold", "Segoe UI")
    resMonitorGui.AddText("x15 y10 w150 Center", T("res_monitor"))

    resMonitorGui.SetFont("s9 c" currentTextColor, "Segoe UI")
    resMonitorGui.AddText("x15 y+10", T("cpu_usage") ":")
    cpuText := resMonitorGui.AddText("x60 yP w100 Right", "0%")

    resMonitorGui.AddText("x15 y+6", T("ram_usage") ":")
    ramText := resMonitorGui.AddText("x60 yP w100 Right", "0%")

    OnMessage(0x0201, WM_LBUTTONDOWN)

    resMonitorGui.Show("w180 h85 x" (A_ScreenWidth - 200) " y50 NoActivate")
    WinSetTransparent(200, "ahk_id " resMonitorGui.Hwnd)
    ApplyRoundedCorners(resMonitorGui, 12, 12)

    SetTimer(UpdateResources, 1000)
    UpdateResources()
}

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global resMonitorGui
    if (resMonitorGui != "" && hwnd == resMonitorGui.Hwnd) {
        PostMessage(0xA1, 2, , , "ahk_id " resMonitorGui.Hwnd)
    }
}

UpdateResources() {
    global resMonitorGui, cpuText, ramText
    if (resMonitorGui == "")
        return
    cpuText.Value := GetCPULoad() "%"
    ramText.Value := GetRAMLoad() "%"
}

GetCPULoad() {
    static lastIdleTime := 0, lastKernelTime := 0, lastUserTime := 0
    idleTime := 0, kernelTime := 0, userTime := 0
    if DllCall("GetSystemTimes", "Int64*", &idleTime, "Int64*", &kernelTime, "Int64*", &userTime) {
        idleDiff := idleTime - lastIdleTime
        kernelDiff := kernelTime - lastKernelTime
        userDiff := userTime - lastUserTime
        lastIdleTime := idleTime
        lastKernelTime := kernelTime
        lastUserTime := userTime

        total := kernelDiff + userDiff
        if (total = 0) {
            return 0
        }
        return Round((total - idleDiff) * 100 / total)
    }
    return 0
}

GetRAMLoad() {
    stat := Buffer(64, 0)
    NumPut("UInt", 64, stat, 0)
    DllCall("GlobalMemoryStatusEx", "Ptr", stat)
    return NumGet(stat, 4, "UInt")
}

; ========== СИСТЕМНЫЕ ФУНКЦИИ ==========

KillActiveWindow(*) {
    try {
        activeHwnd := WinGetID("A")
        activePID := WinGetPID("ahk_id " activeHwnd)
        ProcessClose(activePID)
        TrayTip("System", currentLang="RU" ? "Процесс завершен" : "Process terminated", 10)
    }
}

ToggleHiddenFiles(*) {
    rootKey := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    current := RegRead(rootKey, "Hidden")
    newVal := (current = 2) ? 1 : 2
    RegWrite(newVal, "REG_DWORD", rootKey, "Hidden")
    SendMessage(0x111, 28931, , , "ahk_class Progman")
    TrayTip("Explorer", (newVal = 1 ? (currentLang="RU" ? "Файлы показаны" : "Файлы скрыты") : (currentLang="RU" ? "Файлы скрыты" : "Files hidden")), 10)
}

ShowScratchpad(*) {
    global notesFile
    noteGui := Gui("+AlwaysOnTop -DPIScale", T("notes"))
    noteGui.BackColor := currentBgColor

    noteGui.SetFont("s11 c" currentAccentColor " Bold", "Segoe UI")
    noteGui.AddText("w400 Center", "📝 " T("notes"))

    noteGui.SetFont("s11 c" currentTextColor, "Consolas")
    existingText := FileExist(notesFile) ? FileRead(notesFile) : ""
    editBox := noteGui.AddEdit("w400 h280 Multi Background333344 c" currentTextColor " -E0x200", existingText)

    noteGui.SetFont("s9 c" currentAccentColor, "Segoe UI")
    statText := noteGui.AddText("w400 Left", "")

    UpdateStatsAndSave(*) {
        global notesFile
        txt := editBox.Value
        charCount := StrLen(txt)
        wordCount := (txt = "") ? 0 : StrSplit(RegExReplace(txt, "\s+", " "), " ").Length
        
        statText.Value := (currentLang="RU" ? "Символов: " charCount " | Слов: " wordCount
                                            : "Chars: " charCount " | Words: " wordCount)
        
        try {
            if (FileExist(notesFile)) {
                FileDelete(notesFile)
            }
            FileAppend(txt, notesFile)
        }
    }

    editBox.OnEvent("Change", UpdateStatsAndSave)
    UpdateStatsAndSave()

    noteGui.SetFont("s10", "Segoe UI")
    noteGui.AddButton("w160 h35 x120 y+15", T("save_as")).OnEvent("Click", (*) => SaveNoteToCustomFolder(editBox.Value))

    noteGui.Show()
    ApplyRoundedCorners(noteGui, 16, 16)
}

SaveNoteToCustomFolder(text) {
    folders := []
    for name, path in customApps {
        if DirExist(path) {
            folders.Push({name: name, path: path})
        }
    }

    if (folders.Length = 0) {
        dest := FileSelect("S16", , "Save Note", "Text Documents (*.txt)")
        if (dest) {
            FileAppend(text, dest)
        }
        return
    }

    saveGui := Gui("+AlwaysOnTop -DPIScale", T("save_as"))
    saveGui.BackColor := currentBgColor
    saveGui.SetFont("s10 c" currentTextColor, "Segoe UI")
    saveGui.AddText("w300", currentLang="RU" ? "Выберите папку для сохранения:" : "Choose folder to save:")

    folderNames := []
    for f in folders {
        folderNames.Push(f.name)
    }

    lb := saveGui.AddListBox("w300 h150 Background333344 c" currentTextColor, folderNames)
    saveGui.AddText("w300", currentLang="RU" ? "Имя файла:" : "File name:")
    fnEdit := saveGui.AddEdit("w300 Background333344 c" currentTextColor, "note_" FormatTime(, "yyyyMMdd_HHmm") ".txt")

    saveGui.AddButton("w100 h35 x100 y+15", "OK").OnEvent("Click", (*) => OnConfirmSave())

    OnConfirmSave() {
        idx := lb.Value
        if (idx) {
            fullPath := folders[idx].path "\" fnEdit.Value
            FileAppend(text, fullPath)
            MsgBox(currentLang="RU" ? "Файл сохранен: " fullPath : "File saved: " fullPath)
            saveGui.Destroy()
        } else {
            MsgBox("Choose a folder!")
        }
    }

    saveGui.Show()
    ApplyRoundedCorners(saveGui, 16, 16)
}

ApplyColorTheme(themeName) {
    global currentBgColor, currentAccentColor, currentTextColor, currentThemeName
    themes := Map(
        "Blue", ["1a1a2e", "00d4aa", "FFFFFF"], 
        "Green", ["0b2410", "4cff88", "FFFFFF"], 
        "Red", ["2e1a1a", "ff4c4c", "FFFFFF"], 
        "Dark", ["121212", "bb86fc", "FFFFFF"], 
        "Light", ["F0F0F0", "0078D7", "000000"]
    )
    if themes.Has(themeName) {
        currentBgColor := themes[themeName][1]
        currentAccentColor := themes[themeName][2]
        currentTextColor := themes[themeName][3]
        currentThemeName := themeName
        try {
            regKey := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
            RegWrite((themeName = "Light" ? 1 : 0), "REG_DWORD", regKey, "AppsUseLightTheme")
            RegWrite((themeName = "Light" ? 1 : 0), "REG_DWORD", regKey, "SystemUsesLightTheme")
        }
        SaveSettings()
        Reload()
    }
}

; ========== УВЕДОМЛЕНИЯ С СИСТЕМНЫМИ ЗВУКАМИ ==========

ShowTimerNotify(msg) {
    notify := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale")
    notify.BackColor := currentAccentColor
    notify.SetFont("s20 cFFFFFF Bold", "Segoe UI")
    notify.AddText("w500 Center y20", T("timer_done"))
    notify.Show("Center NoActivate")

    SoundPlay("*64")
    SetTimer(() => notify.Destroy(), -3000)
}

ShowAlarmNotify(msg) {
    notify := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale")
    notify.BackColor := "ff4c4c"
    notify.SetFont("s22 cFFFFFF Bold", "Segoe UI")
    notify.AddText("w600 Center y30", T("alarm_done"))
    notify.Show("Center NoActivate")

    SetTimer(FlashColor, 300)

    FlashColor() {
        static flashCount := 0
        flashCount++
        if (flashCount > 6) {
            SetTimer(FlashColor, 0)
            notify.Destroy()
            flashCount := 0 ; Сброс счетчика для будущих вызовов
            return
        }
        SoundPlay("*48")
        notify.BackColor := (Mod(flashCount, 2) = 0) ? "ff4c4c" : "ffcc00"
    }
}

; ========== СПРАВКА ==========
ShowWelcome(*) {
    welcome := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale")
    welcome.BackColor := currentBgColor
    welcome.SetFont("s18 c" currentAccentColor " Bold", "Segoe UI")
    welcome.AddText("w450 Center y15", T("welcome"))
    welcome.SetFont("s11 c" currentTextColor, "Segoe UI")
    welcome.AddText("w450 Center", T("sub_welcome"))
    welcome.AddText("w410 h2 Background" currentAccentColor " x20 y+10", "")
    welcome.SetFont("s10", "Consolas")
    welcome.AddText("w410 x25 y+15", T("hotkeys"))
    welcome.AddButton("w120 h35 x165 y+15", "OK").OnEvent("Click", (*) => welcome.Destroy())
    welcome.Show("Center")
    ApplyRoundedCorners(welcome, 20, 20)
}

; ========== ГЛАВНОЕ МЕНЮ (Alt+Z) ==========
!z:: {
    MyMenu := Menu()

    officeMenu := Menu()
    officeMenu.Add("📄 Word", (*) => SafeRun("winword.exe"))
    officeMenu.Add("📊 PowerPoint", (*) => SafeRun("powerpnt.exe"))
    officeMenu.Add("📈 Excel", (*) => SafeRun("excel.exe"))

    browserMenu := Menu()
    browserMenu.Add("🌐 Chrome", (*) => SafeRun("chrome.exe"))
    browserMenu.Add("🦊 Firefox", (*) => SafeRun("firefox.exe"))
    browserMenu.Add("🌊 Edge", (*) => SafeRun("msedge.exe"))

    cmdSub := Menu()
    cmdSub.Add(T("normal"), (*) => SafeRun("cmd.exe"))
    cmdSub.Add(T("as_admin"), (*) => SafeRun("*RunAs cmd.exe"))

    psSub := Menu()
    psSub.Add(T("normal"), (*) => SafeRun("powershell.exe"))
    psSub.Add(T("as_admin"), (*) => SafeRun("*RunAs powershell.exe"))

    systemMenu := Menu()
    systemMenu.Add(T("settings"), (*) => SafeRun("ms-settings:"))
    systemMenu.Add(T("taskmgr"), (*) => SafeRun("taskmgr.exe"))
    systemMenu.Add(T("regedit"), (*) => SafeRun("*RunAs regedit.exe"))
    systemMenu.Add(T("cmd"), cmdSub)
    systemMenu.Add(T("ps"), psSub)
    systemMenu.Add()
    systemMenu.Add(T("kill_win"), KillActiveWindow)
    systemMenu.Add(T("hidden"), ToggleHiddenFiles)

    langMenu := Menu()
    langMenu.Add("Русский", (*) => ChangeLanguage("RU"))
    langMenu.Add("English", (*) => ChangeLanguage("EN"))
    langMenu.Add()
    langMenu.Add((showLangSelector ? "✅ " : "⬜ ") (currentLang="RU" ? "Выбор при запуске" : "Selector on startup"), ToggleLangSelector)

    themeMenu := Menu()
    themeMenu.Add((currentThemeName="Dark" ? "✅ " : "⬜ ") "Dark Mode", (*) => ApplyColorTheme("Dark"))
    themeMenu.Add((currentThemeName="Light" ? "✅ " : "⬜ ") "Light Mode", (*) => ApplyColorTheme("Light"))
    themeMenu.Add()
    themeMenu.Add((currentThemeName="Blue" ? "✅ " : "⬜ ") "Deep Blue", (*) => ApplyColorTheme("Blue"))
    themeMenu.Add((currentThemeName="Green" ? "✅ " : "⬜ ") "Forest Green", (*) => ApplyColorTheme("Green"))
    themeMenu.Add((currentThemeName="Red" ? "✅ " : "⬜ ") "Crimson Red", (*) => ApplyColorTheme("Red"))

    toolsMenu := Menu()
    toolsMenu.Add(T("search_run"), (*) => ShowQuickLauncher())
    toolsMenu.Add(T("color_picker"), (*) => StartColorPicker())
    toolsMenu.Add(T("res_monitor"), (*) => ToggleResourceMonitor())
    toolsMenu.Add()
    toolsMenu.Add(T("notes"), ShowScratchpad)
    toolsMenu.Add(T("timer"), (*) => ShowTimer())
    toolsMenu.Add(T("alarm"), (*) => ShowAlarm())
    toolsMenu.Add(T("clipboard"), (*) => ShowClipboardHistory())
    toolsMenu.Add(T("themes"), themeMenu)
    toolsMenu.Add(T("lang_settings"), langMenu)

    customMenu := Menu()
    customMenu.Add(T("add_app"), (*) => AddCustomApp())
    customMenu.Add(T("del_app"), (*) => DeleteCustomApp())
    if (customApps.Count > 0) {
        customMenu.Add()
        for name, path in customApps {
            callback := RunWrapper.Bind(path)
            customMenu.Add(name, callback)
        }
    }

    MyMenu.Add(T("office"), officeMenu)
    MyMenu.Add(T("browsers"), browserMenu)
    MyMenu.Add(T("system"), systemMenu)
    MyMenu.Add(T("tools"), toolsMenu)
    MyMenu.Add(T("custom"), customMenu)
    MyMenu.Add()
    MyMenu.Add((FileExist(startupShortcut) ? "✅ " : "⬜ ") T("startup"), (*) => ToggleStartup())
    MyMenu.Add(T("help"), (*) => ShowWelcome())
    MyMenu.Add(T("reload"), (*) => Reload())
    MyMenu.Add(T("exit"), (*) => ExitApp())
    MyMenu.Show()
}

RunWrapper(path, *) => SafeRun(path)

ExpandEnvVars(path) {
    size := DllCall("ExpandEnvironmentStrings", "Str", path, "Ptr", 0, "UInt", 0)
    buf := Buffer(size * 2)
    DllCall("ExpandEnvironmentStrings", "Str", path, "Ptr", buf, "UInt", size)
    return StrGet(buf)
}

SafeRun(target) {
    resolvedTarget := ExpandEnvVars(target)
    try {
        Run(resolvedTarget)
    } catch {
        try {
            Run('"' resolvedTarget '"')
        } catch as e {
            MsgBox("Error starting: " target "`n`n" e.Message)
        }
    }
}

ToggleStartup(*) {
    if FileExist(startupShortcut) {
        FileDelete(startupShortcut)
    } else {
        FileCreateShortcut(A_ScriptFullPath, startupShortcut)
    }
    Reload()
}

; ========== ГОРЯЧИЕ КЛАВИШИ ==========

#Space:: ShowQuickLauncher()
#+p:: StartColorPicker()
#+r:: ToggleResourceMonitor()

#t:: {
    try {
        Run("powershell.exe")
    } catch {
        Run("cmd.exe")
    }
}
#+a:: WinSetAlwaysOnTop(-1, "A")

#+c:: {
    path := GetSelectedExplorerPath()
    if (path != "") {
        A_Clipboard := path
        TrayTip("Copied", path, 10)
    }
}

#+k:: KillActiveWindow()
#+h:: ToggleHiddenFiles()
#+j:: ShowScratchpad()
#+n:: Send("!z")
#+t:: ShowTimer()
#+v:: ShowClipboardHistory()
#F1:: ShowWelcome()
#+q:: ExitApp()

GetSelectedExplorerPath() {
    hwnd := WinExist("A")
    activeClass := WinGetClass("ahk_id " hwnd)
    if (activeClass ~= "Progman|WorkerW") {
        return A_Desktop
    }
    if (activeClass = "CabinetWClass") {
        for window in ComObject("Shell.Application").Windows {
            if (window.hwnd == hwnd) {
                sel := window.Document.SelectedItems
                for item in sel {
                    return item.Path
                }
                return window.Document.Folder.Self.Path
            }
        }
    }
    return ""
}

; ========== УЛУЧШЕННАЯ ИСТОРИЯ БУФЕРА ==========

OnClipboardChange(SaveClipboard)

SaveClipboard(type) {
    global clipHistory
    if (type != 1 || A_Clipboard == "")
        return

    clipText := A_Clipboard

    foundIdx := 0
    for i, v in clipHistory {
        if (v == clipText) {
            foundIdx := i
            break
        }
    }
    if (foundIdx > 0) {
        clipHistory.RemoveAt(foundIdx)
    }

    clipHistory.InsertAt(1, clipText)
    if (clipHistory.Length > 30) {
        clipHistory.Pop()
    }
}

ShowClipboardHistory() {
    hGui := Gui("+AlwaysOnTop -DPIScale", T("clipboard"))
    hGui.BackColor := currentBgColor
    hGui.SetFont("s10 c" currentTextColor, "Segoe UI")

    hGui.AddText("w280 c" currentAccentColor, currentLang="RU" ? "История буфера обмена:" : "Clipboard History:")
    searchEdit := hGui.AddEdit("w280 Background333344 c" currentTextColor " -Border")
    list := hGui.AddListBox("w280 h220 Background333344 c" currentTextColor)

    hGui.AddText("x+20 y10 w280 c" currentAccentColor, T("pinned_clips") . ":")
    pinnedList := hGui.AddListBox("w280 h256 Background333344 c" currentTextColor)

    btnPin := hGui.AddButton("x20 y+12 w140 h35", T("pin_action"))
    btnUnpin := hGui.AddButton("x+160 yP w140 h35", T("unpin_action"))

    filteredIndices := []

    UpdateFilteredList(*) {
        list.Delete()
        filteredIndices.Length := 0
        query := searchEdit.Value
        dispArray := []
        
        for index, text in clipHistory {
            if (query = "" || InStr(text, query, false)) {
                filteredIndices.Push(index)
                cleanText := StrReplace(text, "`r`n", " ")
                dispArray.Push(StrLen(cleanText) > 35 ? SubStr(cleanText, 1, 35) "..." : cleanText)
            }
        }
        list.Add(dispArray)
    }

    UpdatePinnedList() {
        pinnedList.Delete()
        dispArray := []
        for text in pinnedClips {
            cleanText := StrReplace(text, "`r`n", " ")
            dispArray.Push(StrLen(cleanText) > 35 ? SubStr(cleanText, 1, 35) "..." : cleanText)
        }
        pinnedList.Add(dispArray)
    }

    searchEdit.OnEvent("Change", UpdateFilteredList)
    UpdateFilteredList()
    UpdatePinnedList()

    list.OnEvent("DoubleClick", (*) => OnHistoryDoubleClick())
    pinnedList.OnEvent("DoubleClick", (*) => OnPinnedDoubleClick())

    OnHistoryDoubleClick() {
        idx := list.Value
        if (idx) {
            actualIdx := filteredIndices[idx]
            A_Clipboard := clipHistory[actualIdx]
            hGui.Destroy()
        }
    }

    OnPinnedDoubleClick() {
        idx := pinnedList.Value
        if (idx) {
            A_Clipboard := pinnedClips[idx]
            hGui.Destroy()
        }
    }

    btnPin.OnEvent("Click", (*) => OnPinClick())
    btnUnpin.OnEvent("Click", (*) => OnUnpinClick())

    OnPinClick() {
        idx := list.Value
        if (idx) {
            actualIdx := filteredIndices[idx]
            pinnedClips.Push(clipHistory[actualIdx])
            SaveSettings()
            UpdatePinnedList()
        } else {
            MsgBox(currentLang="RU" ? "Выберите элемент для закрепления!" : "Select item to pin!")
        }
    }

    OnUnpinClick() {
        idx := pinnedList.Value
        if (idx) {
            pinnedClips.RemoveAt(idx)
            SaveSettings()
            UpdatePinnedList()
        } else {
            MsgBox(currentLang="RU" ? "Выберите элемент для удаления!" : "Select item to unpin!")
        }
    }

    hGui.Show()
    ApplyRoundedCorners(hGui, 18, 18)
}

; ========== ТАЙМЕР И БУДИЛЬНИК ==========
ShowTimer() {
    tGui := Gui("+AlwaysOnTop -DPIScale", T("timer"))
    tGui.BackColor := currentBgColor
    tGui.SetFont("s10 c" currentTextColor, "Segoe UI")
    tGui.AddText("x20 y50", T("hours"))
    hE := tGui.AddEdit("x40 y47 w40 Background333344 c" currentTextColor " Center", "0")
    tGui.AddText("x90 y50", T("mins"))
    mE := tGui.AddEdit("x110 y47 w40 Background333344 c" currentTextColor " Center", "5")
    tGui.AddText("x160 y50", T("secs"))
    sE := tGui.AddEdit("x180 y47 w40 Background333344 c" currentTextColor " Center", "0")

    tGui.AddButton("w200 h35 x50 y+20", T("start")).OnEvent("Click", (*) => OnStartTimer())

    OnStartTimer() {
        ms := (Integer(hE.Value || 0)*3600 + Integer(mE.Value || 0)*60 + Integer(sE.Value || 0)) * 1000
        if (ms > 0) {
            SetTimer(() => ShowTimerNotify("Done"), -ms)
            tGui.Destroy()
        }
    }

    tGui.Show()
    ApplyRoundedCorners(tGui, 16, 16)
}

ShowAlarm() {
    aGui := Gui("+AlwaysOnTop -DPIScale", T("alarm"))
    aGui.BackColor := currentBgColor

    aGui.SetFont("s14 c" currentTextColor, "Segoe UI")
    timeE := aGui.AddEdit("w200 x50 Background333344 c" currentTextColor " Center", FormatTime(, "HH:mm:ss"))

    aGui.SetFont("s10 c" currentTextColor, "Segoe UI")
    aGui.AddButton("w200 h35 x50 y+15", T("save")).OnEvent("Click", (*) => OnSaveAlarm())

    OnSaveAlarm() {
        target := timeE.Value 
        ms := CalculateAlarmMs(target)
        if (ms > 0) {
            SetTimer(() => ShowAlarmNotify("Alarm"), -ms)
            aGui.Destroy()
        } else {
            MsgBox("Формат времени должен быть HH:mm:ss")
        }
    }

    aGui.Show()
    ApplyRoundedCorners(aGui, 16, 16)
}

CalculateAlarmMs(targetTime) {
    try {
        parts := StrSplit(targetTime, ":")
        if (parts.Length < 2) {
            return 0
        }
        targetH := Integer(parts[1])
        targetM := Integer(parts[2])
        targetS := (parts.Length >= 3) ? Integer(parts[3]) : 0

        now := A_Now
        currH := Integer(FormatTime(now, "H"))
        currM := Integer(FormatTime(now, "m"))
        currS := Integer(FormatTime(now, "s"))
        
        targetSec := targetH * 3600 + targetM * 60 + targetS
        currSec := currH * 3600 + currM * 60 + currS
        
        diffSec := targetSec - currSec
        if (diffSec <= 0) {
            diffSec += 86400
        }
        return diffSec * 1000
    } catch {
        return 0
    }
}

; ========== ПРОГРАММЫ С DRAG & DROP ==========
AddCustomApp() {
    addGui := Gui("+AlwaysOnTop -DPIScale", T("add_app"))
    addGui.BackColor := currentBgColor
    addGui.SetFont("s10 c" currentTextColor, "Segoe UI")

    addGui.AddText("w350", (currentLang="RU" ? "Название (для меню):" : "Name (for menu):"))
    nE := addGui.AddEdit("w350 Background333344 c" currentTextColor)
    addGui.AddText("w350", (currentLang="RU" ? "Путь к файлу/папке или URL:" : "Path to file/folder or URL:"))
    pE := addGui.AddEdit("w350 Background333344 c" currentTextColor)

    addGui.SetFont("s9 c" currentAccentColor " Italic", "Segoe UI")
    addGui.AddText("w350 Center", currentLang="RU" ? "💡 Можно перетащить файл/папку в это окно" : "💡 You can drag & drop file/folder here")
    addGui.SetFont("s10 c" currentTextColor, "Segoe UI")

    btnF := addGui.AddButton("w150 h30 x20 y+15", (currentLang="RU" ? "Выбрать файл..." : "Select file..."))
    btnF.OnEvent("Click", (*) => OnSelectFile())
    btnD := addGui.AddButton("w150 h30 x180 yP", (currentLang="RU" ? "Выбрать папку..." : "Select folder..."))
    btnD.OnEvent("Click", (*) => OnSelectFolder())

    OnSelectFile() {
        s := FileSelect()
        if (s) {
            pE.Value := s
            SplitPath(s, &n)
            nE.Value := n
        }
    }

    OnSelectFolder() {
        d := DirSelect()
        if (d) {
            pE.Value := d
            nE.Value := StrSplit(d, "\").Pop()
        }
    }

    addGui.OnEvent("DropFiles", (guiObj, ctrlObj, fileArray, x, y) => (
        pE.Value := fileArray[1],
        SplitPath(fileArray[1], &fileName),
        nE.Value := fileName
    ))

    addGui.AddButton("w160 h35 x110 y+20", T("save")).OnEvent("Click", (*) => OnSaveApp())

    OnSaveApp() {
        if (nE.Value && pE.Value) {
            customApps[nE.Value] := pE.Value
            SaveSettings()
            addGui.Destroy()
        }
    }

    addGui.Show()
    ApplyRoundedCorners(addGui, 16, 16)
}

DeleteCustomApp() {
    if (customApps.Count = 0) {
        return
    }
    delGui := Gui("+AlwaysOnTop -DPIScale", T("del_app"))
    delGui.BackColor := currentBgColor
    names := []
    for n, p in customApps {
        names.Push(n)
    }
    delGui.SetFont("s10 c" currentTextColor, "Segoe UI")
    list := delGui.AddListBox("w300 h200 Background333344 c" currentTextColor, names)
    delGui.AddButton("w300 h35", (currentLang="RU" ? "Удалить" : "Delete")).OnEvent("Click", (*) => OnDeleteClick())

    OnDeleteClick() {
        idx := list.Value
        if (idx) {
            customApps.Delete(names[idx])
            SaveSettings()
            delGui.Destroy()
        }
    }

    delGui.Show()
    ApplyRoundedCorners(delGui, 16, 16)
}