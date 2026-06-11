-- Auto section dividers: every numbered level-1 heading gets a full-slide
-- background (cycling the 4 intercalaire designs) and a colour class.

local n = 0
local base = "_extensions/insee-clair/ressources/revealJs/2_Template-INSEE-Clair_Intercalaire"

function Header(h)
  -- Background page finale
  if h.identifier == "pageDeFin" then
    h.attributes["background-image"] = "_extensions/insee-clair/ressources/revealJs/6_Template-INSEE-Clair_Diapo-finale.svg"
    h.attributes["background-size"]  = "100% 100%"
    return h
  end
  -- Slides de titres de parties
  if h.level == 1 and not h.classes:includes("unnumbered") then
    n = n + 1
    local k = (n - 1) % 4 + 1                       -- 1,2,3,4,1,2,3,4 …
    h.attributes["background-image"]    = base .. k .. ".svg"
    h.attributes["background-size"] = "100% 100%"
    h.attributes["background-position"] = "center"
    h.classes:insert("sectionColor" .. k)
    return h
  end
end

