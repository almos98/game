return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 10,
  height = 10,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 3,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "tmw_desert_spacing_corrected",
      firstgid = 1,
      filename = "tmw_desert_spacing_corrected.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 8,
      image = "tmw_desert_spacing_corrected.png",
      imagewidth = 256,
      imageheight = 192,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 48,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "Ground",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30,
        30, 30, 30, 30, 30, 30, 30, 30, 30, 30
      }
    },
    {
      type = "tilelayer",
      id = 2,
      name = "Walls",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        36, 42, 42, 42, 42, 42, 42, 42, 42, 37,
        35, 0, 0, 0, 0, 0, 0, 0, 0, 33,
        35, 0, 0, 0, 0, 0, 0, 0, 0, 33,
        35, 0, 0, 0, 0, 0, 0, 0, 0, 33,
        35, 0, 0, 0, 0, 0, 0, 0, 0, 33,
        35, 0, 0, 0, 0, 0, 0, 0, 0, 33,
        35, 0, 0, 0, 0, 0, 0, 0, 0, 33,
        35, 0, 0, 0, 0, 0, 0, 0, 0, 33,
        35, 0, 0, 0, 0, 0, 0, 0, 0, 33,
        44, 26, 26, 26, 26, 26, 26, 26, 26, 45
      }
    }
  }
}
