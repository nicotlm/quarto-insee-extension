-- Automatise l'ajout de .backgroundTitre et .backgroundStandard
-- Rotation automatique des couleurs par chapitre

local chapter_count = 0
local section_counts = {}
local current_color = nil
local default_palette = {"bleu", "violet", "jaune", "vert"}
local color_palette = default_palette

-- Fonction pour obtenir la couleur suivante dans la palette
local function get_next_color()
  chapter_count = chapter_count + 1
  local color_index = ((chapter_count - 1) % #color_palette) + 1
  return color_palette[color_index]
end

-- Fonction pour extraire une couleur personnalisee des classes
local function extract_custom_color(classes)
  local color_classes = {
    "bleu", "violet", "jaune", "vert"
  }
  
  for _, cls in ipairs(classes) do
    for _, color in ipairs(color_classes) do
      if cls == color then
        return color
      end
    end
  end
  return nil
end

-- Fonction pour extraire la couleur d'une classe backgroundTitre ou backgroundStandard
local function extract_color_from_background_class(classes)
  for _, cls in ipairs(classes) do
    local color = cls:match("^backgroundTitre_(.+)$")
    if not color then
      color = cls:match("^backgroundStandard_(.+)$")
    end
    if color then
      return color
    end
  end
  return nil
end

-- Fonction pour verifier si le header doit etre completement ignore ou pas
local function should_skip_header(classes)
  for _, cls in ipairs(classes) do
    if cls == "unnumbered" or cls == "backgroundPageFinale" then
      return true
    end
  end
  return false
end

-- Initialisation : lire la palette depuis les metadonnees
function Meta(meta)
  if meta['palette-chapitres'] then
    color_palette = {}
    for _, color in ipairs(meta['palette-chapitres']) do
      table.insert(color_palette, pandoc.utils.stringify(color))
    end
  end
  
  -- Si palette vide, utiliser la palette par defaut
  if #color_palette == 0 then
    color_palette = default_palette
  end
  
  return meta
end

-- Traitement des headers
function Header(el)
  -- Ignorer si pageDeFin 
  if el.identifier == "pageDeFin" then
    return el
  end
  -- Ignorer si le header doit etre skippe (unnumbered, etc.)
  if should_skip_header(el.classes) then
    return el
  end
  
  -- Niveau 1 : Titre de chapitre
  if el.level == 1 then
    -- Verifier si l'utilisateur a deja une classe backgroundTitre (avec ou sans couleur)
    local has_background_titre = false
    for _, cls in ipairs(el.classes) do
      if cls:match("^backgroundTitre") then
        has_background_titre = true
        break
      end
    end
    
    if has_background_titre then
      -- Extraire la couleur si elle existe (pour la propager aux slides suivantes)
      local existing_bg_color = extract_color_from_background_class(el.classes)
      if existing_bg_color then
        current_color = existing_bg_color
      else
        -- .backgroundTitre sans couleur -> pas de propagation de couleur
        current_color = nil
      end
      chapter_count = chapter_count + 1
    else
      -- Verifier si l'utilisateur a specifie une couleur personnalisee simple ({.rouge})
      local custom_color = extract_custom_color(el.classes)
      
      if custom_color then
        current_color = custom_color
        -- Retirer la classe de couleur simple (elle sera dans backgroundTitre_xxx)
        local new_classes = {}
        for _, cls in ipairs(el.classes) do
          if cls ~= custom_color then
            table.insert(new_classes, cls)
          end
        end
        el.classes = new_classes
      else
        current_color = get_next_color()
      end
      
      -- Ajouter la classe backgroundTitre avec la couleur
      table.insert(el.classes, "backgroundTitre_" .. current_color)
    end
    
    -- Generer l'ID si absent
    if not el.identifier or el.identifier == "" then
      el.identifier = "chapters_" .. (chapter_count - 1)
    end
    
    -- Initialiser le compteur de sections pour ce chapitre
    section_counts[chapter_count] = 0
    
  -- Niveau 2 : Slide standard
  elseif el.level == 2 then
    -- Verifier si l'utilisateur a deja une classe backgroundStandard (avec ou sans couleur)
    local has_background_standard = false
    for _, cls in ipairs(el.classes) do
      if cls:match("^backgroundStandard") then
        has_background_standard = true
        break
      end
    end
    
    if has_background_standard then
      -- L'utilisateur a deja mis une classe backgroundStandard, on ne touche pas
      -- (que ce soit .backgroundStandard ou .backgroundStandard_xxx)
    else
      -- Utiliser la couleur du chapitre courant
      local color_suffix = ""
      if current_color then
        color_suffix = "_" .. current_color
      end
      
      -- Verifier si l'utilisateur a specifie une couleur personnalisee simple ({.jaune})
      local custom_color = extract_custom_color(el.classes)
      if custom_color then
        color_suffix = "_" .. custom_color
        -- Retirer la classe de couleur simple
        local new_classes = {}
        for _, cls in ipairs(el.classes) do
          if cls ~= custom_color then
            table.insert(new_classes, cls)
          end
        end
        el.classes = new_classes
      end
      
      -- Ajouter la classe backgroundStandard avec la couleur
      table.insert(el.classes, "backgroundStandard" .. color_suffix)
    end
    
    -- Generer l'ID si absent
    if not el.identifier or el.identifier == "" then
      local current_chapter = math.max(0, chapter_count - 1)
      section_counts[chapter_count] = (section_counts[chapter_count] or 0) + 1
      el.identifier = "section_" .. current_chapter .. "_" .. section_counts[chapter_count]
    end
  end
  
  return el
end

-- Meta puis Header
return {
  {Meta = Meta},
  {Header = Header}
}