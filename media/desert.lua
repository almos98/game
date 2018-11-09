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
      tiles = {
        {
          id = 25,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {},
            objects = {
              {
                id = 1,
                name = "",
                type = "",
                shape = "rectangle",
                x = 0,
                y = 13.5839,
                width = 32.0404,
                height = 9.1544,
                rotation = 0,
                visible = true,
                properties = {}
              }
            }
          }
        },
        {
          id = 32,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {},
            objects = {
              {
                id = 1,
                name = "",
                type = "",
                shape = "rectangle",
                x = 12.698,
                y = -0.147652,
                width = 9.30205,
                height = 32.0404,
                rotation = 0,
                visible = true,
                properties = {}
              }
            }
          }
        },
        {
          id = 34,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {},
            objects = {
              {
                id = 4,
                name = "",
                type = "",
                shape = "rectangle",
                x = 14.1746,
                y = -0.147652,
                width = 8.41614,
                height = 31.8927,
                rotation = 0,
                visible = true,
                properties = {}
              }
            }
          }
        },
        {
          id = 36,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {},
            objects = {
              {
                id = 1,
                name = "",
                type = "",
                shape = "polygon",
                x = 0.264385,
                y = 21.9439,
                width = 0,
                height = 0,
                rotation = 0,
                visible = true,
                polygon = {
                  { x = -0.264385, y = 0 },
                  { x = 12.6023, y = 0.0881282 },
                  { x = 12.6023, y = 10.0466 },
                  { x = 21.7677, y = 10.0466 },
                  { x = 21.7677, y = -8.90095 },
                  { x = -0.352513, y = -8.81282 }
                },
                properties = {}
              }
            }
          }
        },
        {
          id = 41,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {},
            objects = {
              {
                id = 1,
                name = "",
                type = "",
                shape = "rectangle",
                x = -0.147652,
                y = 14.1746,
                width = 32.0404,
                height = 7.67788,
                rotation = 0,
                visible = true,
                properties = {}
              }
            }
          }
        }
      }
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
