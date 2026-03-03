local colors = {
    -- Base colors
    bg = "#181818",
    bg_dark = "#181818",
    bg_darker = "#1C1C1C",
    fg = "#A9B7C6",

    -- UI elements
    selection = "#214283",
    line_highlight = "#323232",
    cursor_line = "#323232",
    gutter_bg = "#171717",
    gutter_fg = "#606366",

    -- Syntax colors
    comment = "#808080",
    keyword = "#CC7832",
    string = "#6A8759",
    number = "#6897BB",
    type = "#FFC66D",
    class = "#A9B7C6",
    function_name = "#FFC66D",
    parameter = "#A9B7C6",
    variable = "#A9B7C6",
    constant = "#9876AA",

    -- Special
    operator = "#A9B7C6",
    delimiter = "#CC7832",
    special = "#CC7832",
    preprocessor = "#BBB529",

    -- Diagnostics
    error = "#BC3F3C",
    warning = "#A9B7C6",
    info = "#6A8759",
    hint = "#6897BB",

    -- Git
    git_add = "#629755",
    git_change = "#6897BB",
    git_delete = "#BC3F3C",

    -- UI colors
    menu_bg = "#3C3F41",
    menu_fg = "#A9B7C6",
    border = "#323232"
}

-- Clear existing highlights
vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
end

vim.g.colors_name = 'jetbrains-dark'
vim.o.background = 'dark'
vim.o.termguicolors = true

local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hl('Normal', {
    fg = colors.fg,
    bg = colors.bg
})
hl('NormalFloat', {
    fg = colors.fg,
    bg = colors.bg_dark
})
hl('NormalNC', {
    fg = colors.fg,
    bg = colors.bg
})
hl('Cursor', {
    fg = colors.bg,
    bg = colors.fg
})
hl('CursorLine', {
    bg = colors.cursor_line
})
hl('CursorColumn', {
    bg = colors.cursor_line
})
hl('LineNr', {
    fg = colors.gutter_fg,
    bg = colors.gutter_bg
})
hl('CursorLineNr', {
    fg = colors.fg,
    bg = colors.gutter_bg,
    bold = true
})
hl('SignColumn', {
    fg = colors.gutter_fg,
    bg = colors.gutter_bg
})
hl('Visual', {
    bg = colors.selection
})
hl('VisualNOS', {
    bg = colors.selection
})
hl('Search', {
    bg = '#32593D',
    fg = colors.fg
})
hl('IncSearch', {
    bg = '#155221',
    fg = colors.fg
})
hl('ColorColumn', {
    bg = colors.bg_dark
})
hl('Conceal', {
    fg = colors.comment
})
hl('VertSplit', {
    fg = colors.border,
    bg = colors.bg
})
hl('WinSeparator', {
    fg = colors.border,
    bg = colors.bg
})
hl('Folded', {
    fg = colors.comment,
    bg = colors.bg_dark
})
hl('FoldColumn', {
    fg = colors.gutter_fg,
    bg = colors.gutter_bg
})
hl('MatchParen', {
    bg = '#3B514D',
    bold = true
})
hl('Pmenu', {
    fg = colors.menu_fg,
    bg = colors.menu_bg
})
hl('PmenuSel', {
    fg = colors.fg,
    bg = colors.selection
})
hl('PmenuSbar', {
    bg = colors.bg_dark
})
hl('PmenuThumb', {
    bg = colors.gutter_fg
})
hl('StatusLine', {
    fg = colors.fg,
    bg = colors.bg_dark
})
hl('StatusLineNC', {
    fg = colors.comment,
    bg = colors.bg_dark
})
hl('TabLine', {
    fg = colors.comment,
    bg = colors.bg_dark
})
hl('TabLineSel', {
    fg = colors.fg,
    bg = colors.bg
})
hl('TabLineFill', {
    bg = colors.bg_dark
})

-- Syntax
hl('Comment', {
    fg = colors.comment,
    italic = true
})
hl('Constant', {
    fg = colors.constant
})
hl('String', {
    fg = colors.string
})
hl('Character', {
    fg = colors.string
})
hl('Number', {
    fg = colors.number
})
hl('Boolean', {
    fg = colors.keyword
})
hl('Float', {
    fg = colors.number
})
hl('Identifier', {
    fg = colors.variable
})
hl('Function', {
    fg = colors.function_name
})
hl('Statement', {
    fg = colors.keyword
})
hl('Conditional', {
    fg = colors.keyword
})
hl('Repeat', {
    fg = colors.keyword
})
hl('Label', {
    fg = colors.keyword
})
hl('Operator', {
    fg = colors.operator
})
hl('Keyword', {
    fg = colors.keyword
})
hl('Exception', {
    fg = colors.keyword
})
hl('PreProc', {
    fg = colors.preprocessor
})
hl('Include', {
    fg = colors.keyword
})
hl('Define', {
    fg = colors.preprocessor
})
hl('Macro', {
    fg = colors.preprocessor
})
hl('PreCondit', {
    fg = colors.preprocessor
})
hl('Type', {
    fg = colors.type
})
hl('StorageClass', {
    fg = colors.keyword
})
hl('Structure', {
    fg = colors.keyword
})
hl('Typedef', {
    fg = colors.keyword
})
hl('Special', {
    fg = colors.special
})
hl('SpecialChar', {
    fg = colors.special
})
hl('Tag', {
    fg = colors.keyword
})
hl('Delimiter', {
    fg = colors.delimiter
})
hl('SpecialComment', {
    fg = colors.comment,
    italic = true
})
hl('Debug', {
    fg = colors.error
})
hl('Underlined', {
    underline = true
})
hl('Error', {
    fg = colors.error,
    bold = true
})
hl('Todo', {
    fg = colors.warning,
    bold = true
})

-- Treesitter
hl('@variable', {
    fg = colors.variable
})
hl('@variable.builtin', {
    fg = colors.constant
})
hl('@variable.parameter', {
    fg = colors.parameter
})
hl('@variable.member', {
    fg = colors.variable
})
hl('@constant', {
    fg = colors.constant
})
hl('@constant.builtin', {
    fg = colors.constant
})
hl('@module', {
    fg = colors.class
})
hl('@label', {
    fg = colors.keyword
})
hl('@string', {
    fg = colors.string
})
hl('@string.escape', {
    fg = colors.special
})
hl('@string.special', {
    fg = colors.special
})
hl('@character', {
    fg = colors.string
})
hl('@number', {
    fg = colors.number
})
hl('@boolean', {
    fg = colors.keyword
})
hl('@float', {
    fg = colors.number
})
hl('@function', {
    fg = colors.function_name
})
hl('@function.builtin', {
    fg = colors.function_name
})
hl('@function.macro', {
    fg = colors.preprocessor
})
hl('@function.method', {
    fg = colors.function_name
})
hl('@constructor', {
    fg = colors.class
})
hl('@keyword', {
    fg = colors.keyword
})
hl('@keyword.function', {
    fg = colors.keyword
})
hl('@keyword.operator', {
    fg = colors.keyword
})
hl('@keyword.return', {
    fg = colors.keyword
})
hl('@operator', {
    fg = colors.operator
})
hl('@type', {
    fg = colors.type
})
hl('@type.builtin', {
    fg = colors.keyword
})
hl('@type.qualifier', {
    fg = colors.keyword
})
hl('@property', {
    fg = colors.variable
})
hl('@attribute', {
    fg = colors.preprocessor
})
hl('@namespace', {
    fg = colors.class
})
hl('@punctuation.delimiter', {
    fg = colors.fg
})
hl('@punctuation.bracket', {
    fg = colors.fg
})
hl('@punctuation.special', {
    fg = colors.special
})
hl('@comment', {
    link = 'Comment'
})
hl('@tag', {
    fg = colors.keyword
})
hl('@tag.attribute', {
    fg = colors.type
})
hl('@tag.delimiter', {
    fg = colors.fg
})

-- LSP
hl('DiagnosticError', {
    fg = colors.error
})
hl('DiagnosticWarn', {
    fg = colors.warning
})
hl('DiagnosticInfo', {
    fg = colors.info
})
hl('DiagnosticHint', {
    fg = colors.hint
})
hl('DiagnosticUnderlineError', {
    undercurl = true,
    sp = colors.error
})
hl('DiagnosticUnderlineWarn', {
    undercurl = true,
    sp = colors.warning
})
hl('DiagnosticUnderlineInfo', {
    undercurl = true,
    sp = colors.info
})
hl('DiagnosticUnderlineHint', {
    undercurl = true,
    sp = colors.hint
})
hl('LspReferenceText', {
    bg = colors.cursor_line
})
hl('LspReferenceRead', {
    bg = colors.cursor_line
})
hl('LspReferenceWrite', {
    bg = colors.cursor_line
})

-- Git signs
hl('GitSignsAdd', {
    fg = colors.git_add,
    bg = colors.gutter_bg
})
hl('GitSignsChange', {
    fg = colors.git_change,
    bg = colors.gutter_bg
})
hl('GitSignsDelete', {
    fg = colors.git_delete,
    bg = colors.gutter_bg
})

-- Telescope
hl('TelescopeBorder', {
    fg = colors.border
})
hl('TelescopePromptBorder', {
    fg = colors.border
})
hl('TelescopeResultsBorder', {
    fg = colors.border
})
hl('TelescopePreviewBorder', {
    fg = colors.border
})
hl('TelescopeSelection', {
    fg = colors.fg,
    bg = colors.selection
})
hl('TelescopeSelectionCaret', {
    fg = colors.keyword,
    bg = colors.selection
})
hl('TelescopeMatching', {
    fg = colors.keyword,
    bold = true
})

-- nvim-tree
hl('NvimTreeFolderIcon', {
    fg = colors.keyword
})
hl('NvimTreeFolderName', {
    fg = colors.fg
})
hl('NvimTreeOpenedFolderName', {
    fg = colors.fg,
    bold = true
})
hl('NvimTreeEmptyFolderName', {
    fg = colors.comment
})
hl('NvimTreeIndentMarker', {
    fg = colors.comment
})
hl('NvimTreeGitDirty', {
    fg = colors.git_change
})
hl('NvimTreeGitNew', {
    fg = colors.git_add
})
hl('NvimTreeGitDeleted', {
    fg = colors.git_delete
})
hl('NvimTreeSpecialFile', {
    fg = colors.special
})
hl('NvimTreeRootFolder', {
    fg = colors.keyword,
    bold = true
})

-- WhichKey
hl('WhichKey', {
    fg = colors.keyword
})
hl('WhichKeyGroup', {
    fg = colors.type
})
hl('WhichKeyDesc', {
    fg = colors.fg
})
hl('WhichKeySeparator', {
    fg = colors.comment
})
hl('WhichKeyFloat', {
    bg = colors.bg_dark
})
