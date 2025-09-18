-- Monochromatyczny motyw na podstawie Twojej palety kolorów
local style = require "core.style"
local common = require "core.common"

-- Kolory z Twojej palety:
--[[
background        #1a1a1a
foreground        #d0d0d0
cursor            #ffffff
color0            #1a1a1a  (czarny)
color1            #000000  (głęboki czarny)
color2            #3a3a3a  (ciemny szary)
color3            #5a5a5a  (średni ciemny szary)
color4            #7a7a7a  (średni szary)
color5            #9a9a9a  (jasny szary)
color6            #FFFFFF  (biały)
color7            #d0d0d0  (jasny szary)
color8            #2a2a2a  (ciemny szary)
color9            #000000  (głęboki czarny)
color10           #4a4a4a  (średni ciemny szary)
color11           #6a6a6a  (średni szary)
color12           #8a8a8a  (jasny szary)
color13           #aaaaaa  (bardzo jasny szary)
color14           #d0d0d0  (jasny szary)
color15           #ffffff  (biały)
]]--

--[[
    #////////////////////////////#
                Editor
    #////////////////////////////#
]]--
style.background = { common.color "#1a1a1a" }         -- główne tło edytora
style.syntax["normal"] = { common.color "#d0d0d0" }   -- zwykły tekst
style.syntax["symbol"] = { common.color "#9a9a9a" }   -- symbole
style.syntax["comment"] = { common.color "#7a7a7a" }  -- komentarze
style.syntax["keyword"] = { common.color "#ffffff" }  -- słowa kluczowe (function, local, if)
style.syntax["keyword2"] = { common.color "#aaaaaa" } -- słowa kluczowe 2 (true, false, nil)
style.syntax["number"] = { common.color "#8a8a8a" }   -- liczby
style.syntax["literal"] = { common.color "#9a9a9a" }  -- literały
style.syntax["string"] = { common.color "#aaaaaa" }   -- stringi
style.syntax["operator"] = { common.color "#6a6a6a" } -- operatory (+, -, *, /)
style.syntax["function"] = { common.color "#ffffff" } -- nazwy funkcji
style.caret = { common.color "#ffffff" }              -- kursor
style.line_highlight = { common.color "#2a2a2a" }     -- podświetlenie linii
style.selection = { common.color "#5a5a5a" }          -- zaznaczenie
style.guide = { common.color "#4a4a4a30" }            -- linie wcięć
style.guide_highlighting = { common.color "#6a6a6abb" } -- aktywne linie wcięć

--[[
    #////////////////////////////#
           User Interface
    #////////////////////////////#
]]--
style.background2 = { common.color "#2a2a2a" }        -- pasek boczny (color8)
style.background3 = { common.color "#3a3a3a" }        -- pasek statusu (color2)
style.text = { common.color "#d0d0d0" }               -- tekst interfejsu (foreground)
style.accent = { common.color "#aaaaaa" }             -- kolor akcentu (color13)
style.divider = { common.color "#4a4a4a" }            -- granice/dzielniki (color10)
style.line_number = { common.color "#7a7a7a" }        -- numery linii nieaktywne (color4)
style.line_number2 = { common.color "#d0d0d0" }       -- numer aktywnej linii (color14)

-- Scrollbary
style.scrollbar = { common.color "#3a3a3a" }          -- tło scrollbara (color2)
style.scrollbar2 = { common.color "#6a6a6a" }         -- uchwyt scrollbara (color11)

-- Powiadomienia
style.nagbar = { common.color "#5a5a5a" }             -- pasek powiadomień (color3)
style.nagbar_text = { common.color "#ffffff" }        -- tekst powiadomień (color6)
style.nagbar_dim = { common.color "rgba(90, 90, 90, 0.45)" } -- (color3 + alpha)

-- Stany elementów
style.good = { common.color "#aaaaaa" }               -- pozytywny stan (color13)
style.warn = { common.color "#9a9a9a" }               -- ostrzeżenie (color5)
style.error = { common.color "#ffffff" }              -- błąd (color6)
