-- mod-version:3
local core = require "core"
local common = require "core.common"
local style = require "core.style"
local keymap = require "core.keymap"
local command = require "core.command"
local View = require "core.view"

-- Dashboard state
local DashboardView = View:extend()
local dashboard_instance = nil

-- Menu configuration
local menu_items = {
  {text = "New File", action = "new-file", key = "F1"},
  {text = "Find File", action = "find-file", key = "F2"}, 
  {text = "Open Folder", action = "open-folder", key = "F3"},
  {text = "Recent Files", action = "recent", key = "F4"},
  {text = "Quit", action = "quit", key = "F5"}
}

-- Dashboard View implementation
function DashboardView:new()
  DashboardView.super.new(self)
  self.selected = 1
  self.show_recent = false
  self.recent_files = {}
  self:load_recent()
end

function DashboardView:get_name()
  return "Dashboard"
end

function DashboardView:load_recent()
  self.recent_files = {}
  if core.recent_projects then
    for i = math.min(#core.recent_projects, 3), 1, -1 do
      local project = core.recent_projects[i]
      if project and project.path then
        table.insert(self.recent_files, {
          name = common.basename(project.path),
          path = project.path
        })
      end
    end
  end
end

function DashboardView:execute_item(index)
  local items = self.show_recent and self.recent_files or menu_items
  local item = items[index]
  if not item then return end
  
  if self.show_recent then
    -- Open recent file
    core.try(function()
      core.root_view:open_doc(core.open_doc(item.path))
    end)
  else
    -- Execute menu action
    if item.action == "new-file" then
      command.perform("core:new-doc")
    elseif item.action == "find-file" then
      command.perform("core:find-file")
    elseif item.action == "open-folder" then
      command.perform("core:open-project-folder")
    elseif item.action == "recent" then
      self.show_recent = true
      self.selected = 1
      return
    elseif item.action == "quit" then
      command.perform("core:quit")
    end
  end
end

function DashboardView:draw()
  self:draw_background(style.background)
  
  local font = style.font
  local line_height = font:get_height() + 4
  
  -- Get view center
  local cx = self.size.x / 1.5
  local cy = self.size.y / 1.8
  
  -- ASCII Art
  local ascii_art = {
    "Lite-Xl Dashboard"
  }
  
  -- Draw ASCII art
  local ascii_height = #ascii_art * line_height
  local ascii_start_y = cy - 120
  
  for i, line in ipairs(ascii_art) do
    local text_w = font:get_width(line)
    local x = cx - text_w/2
    local y = ascii_start_y + (i-1) * line_height
    renderer.draw_text(font, line, x, y, style.accent)
  end
  
  -- Draw menu
  local items = self.show_recent and self.recent_files or menu_items
  local menu_height = #items * line_height
  local start_y = cy + 20
  
  for i, item in ipairs(items) do
    local y = start_y + (i-1) * line_height
    local text = self.show_recent and 
      string.format("F%d. %s", i, item.name) or
      string.format("%s [%s]", item.text, item.key)
    
    local text_w = font:get_width(text)
    local color = (i == self.selected) and style.accent or style.dim
    
    renderer.draw_text(font, text, cx - text_w/2, y, color)
  end
  
  -- Instructions
  local footer = self.show_recent and "ESC: Back, F1-F3: Select" or "Navigate: ↑↓  Select: F1-F5 or Enter"
  local footer_w = font:get_width(footer)
  renderer.draw_text(font, footer, cx - footer_w/2, self.size.y - 40, style.dim)
end

-- Commands
command.add(DashboardView, {
  ["dashboard:next"] = function(view)
    local max_items = view.show_recent and #view.recent_files or #menu_items
    view.selected = view.selected < max_items and view.selected + 1 or 1
  end,
  
  ["dashboard:prev"] = function(view)
    local max_items = view.show_recent and #view.recent_files or #menu_items
    view.selected = view.selected > 1 and view.selected - 1 or max_items
  end,
  
  ["dashboard:select"] = function(view)
    view:execute_item(view.selected)
  end,
  
  ["dashboard:select-number"] = function(view, number)
    if number >= 1 and number <= (view.show_recent and #view.recent_files or #menu_items) then
      view:execute_item(number)
    end
  end,
  
  ["dashboard:back"] = function(view)
    if view.show_recent then
      view.show_recent = false
      view.selected = 1
    end
  end
})

-- Global commands
command.add(nil, {
  ["dashboard:open"] = function()
    local node = core.root_view:get_active_node()
    dashboard_instance = DashboardView()
    node:add_view(dashboard_instance)
  end
})

-- Keybindings dla dashboardu
keymap.add {
  ["up"] = "dashboard:prev",
  ["down"] = "dashboard:next", 
  ["j"] = "dashboard:next",
  ["k"] = "dashboard:prev",
  ["return"] = "dashboard:select",
  ["escape"] = "dashboard:back",
}

-- F-key bindings - działają globalnie i w dashboardzie
keymap.add({
  ["f1"] = function()
    if core.active_view and core.active_view:is(DashboardView) then
      core.active_view:execute_item(1)
    else
      command.perform("core:new-doc")
    end
  end,
  ["f2"] = function()
    if core.active_view and core.active_view:is(DashboardView) then
      core.active_view:execute_item(2)
    else
      command.perform("core:find-file")
    end
  end,
  ["f3"] = function()
    if core.active_view and core.active_view:is(DashboardView) then
      core.active_view:execute_item(3)
    else
      command.perform("core:open-project-folder")
    end
  end,
  ["f4"] = function()
    if core.active_view and core.active_view:is(DashboardView) then
      core.active_view:execute_item(4)
    else
      command.perform("dashboard:open")
    end
  end,
  ["f5"] = function()
    if core.active_view and core.active_view:is(DashboardView) then
      core.active_view:execute_item(5)
    else
      command.perform("core:quit")
    end
  end
})

-- Auto-open on startup
print("Setting up auto-start...")
core.add_thread(function()
  print("Auto-start thread running...")
  coroutine.yield()
  coroutine.yield() -- Wait a bit longer for initialization
  
  print("Checking docs:", #core.docs)
  if core.docs[1] then
    print("First doc filename:", core.docs[1].filename or "nil")
    print("First doc dirty:", core.docs[1]:is_dirty())
  end
  
  -- Simplified condition - just check if we have only one empty doc
  if #core.docs == 1 and not core.docs[1].filename and not core.docs[1]:is_dirty() then
    print("Opening dashboard...")
    command.perform("dashboard:open")
  else
    print("Not opening dashboard - conditions not met")
    -- Let's try opening it anyway for now
    print("Opening dashboard anyway for testing...")
    command.perform("dashboard:open")
  end
end)

print("Dashboard plugin loaded!")
