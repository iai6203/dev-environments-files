return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "h",
        function()
          -- Neo-tree 버퍼인지 확인
          if vim.bo.filetype == "neo-tree" then
            local state = require("neo-tree.sources.manager").get_state("filesystem")
            local node = state.tree:get_node()

            if node.type == "directory" and node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          else
            -- 기본 Vim 동작 수행
            vim.api.nvim_feedkeys("h", "n", false)
          end
        end,
        desc = "Focus Parent Node in Neo-tree (if active), otherwise default 'h'",
      },
    },
  },
}
