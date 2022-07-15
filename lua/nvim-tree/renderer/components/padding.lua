local M = {}

local function check_siblings_for_folder(node, with_arrows)
  if with_arrows then
    for _, n in pairs(node.parent.nodes) do
      if n.nodes then
        return true
      end
    end
  end
  return false
end

local function get_padding_indent_markers(depth, idx, nodes_number, markers, with_arrows, node)
  local base_padding = with_arrows and (not node.nodes or depth > 0) and "  " or ""
  local padding = base_padding

  if depth > 0 then
    local has_folder_sibling = check_siblings_for_folder(node, with_arrows)
    local rdepth = depth / 2
    markers[rdepth] = idx ~= nodes_number
    for i = 1, rdepth do
      local glyph
      if idx == nodes_number and i == rdepth then
        glyph = M.config.indent_markers.icons.corner
      elseif markers[i] and i == rdepth then
        glyph = M.config.indent_markers.icons.item
      elseif markers[i] then
        glyph = M.config.indent_markers.icons.edge
      else
        glyph = M.config.indent_markers.icons.none
      end

      if not with_arrows or i == 1 then
        padding = padding .. glyph .. " "
      elseif idx == nodes_number and i == rdepth and has_folder_sibling then
        padding = padding .. base_padding .. glyph .. "── "
      elseif rdepth == i and not node.nodes and has_folder_sibling then
        padding = padding .. base_padding .. glyph .. " " .. base_padding
      else
        padding = padding .. base_padding .. glyph .. " "
      end
    end
  end
  return padding
end

local function get_padding_arrows(node, indent)
  if node.nodes then
    return M.config.icons.glyphs.folder[node.open and "arrow_open" or "arrow_closed"] .. " "
  elseif indent then
    return "  "
  else
    return ""
  end
end

function M.get_padding(depth, idx, nodes_number, node, markers)
  local padding = ""

  local show_arrows = M.config.icons.show.folder_arrow
  local show_markers = M.config.indent_markers.enable

  if show_markers then
    padding = padding .. get_padding_indent_markers(depth, idx, nodes_number, markers, show_arrows, node)
  else
    padding = padding .. string.rep(" ", depth)
  end

  if show_arrows then
    padding = padding .. get_padding_arrows(node, not show_markers)
  end

  return padding
end

function M.setup(opts)
  M.config = opts.renderer
end

return M
