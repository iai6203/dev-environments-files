return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    opts = {
      window = {
        mappings = {
          ["h"] = {
            function(state)
              local node = state.tree:get_node()
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end,
          },
        },
      },
    },
  },
}
