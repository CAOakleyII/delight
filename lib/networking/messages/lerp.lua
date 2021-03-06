local NETWORK_MESSAGE_TYPES = require 'lib.types.network_message_types'
local Lerp = {}

--- Lerp message service.
-- This message services handles the packaging and unpackaging
-- of the network message type lerp.
function Lerp:new()
    local player_inputs = {}
    self.__index = self
    return setmetatable(player_inputs, self)
end

--- Packs the data into a compressed string.
-- @table data The data to be packaged
-- @treturn string packaged data
function Lerp:package(node_id, data)
    -- Player Inputs Packet Info
    ---------------------
    -- Player Inputs network message, 13 Bytes total
    -- 1 Byte Message Type | 4 Bytes Node ID | 2 Bytes Position X | 2 Bytes Position Y | 2 Bytes Velocity X | 2 Bytes Velocity Y
    ---------------------
    local type_byte = love.data.pack('string', 'b', NETWORK_MESSAGE_TYPES.lerp)
    local node_id_bytes = love.data.pack('string', 'I', node_id)
    local position_x_bytes = love.data.pack('string', 'H', math.floor(data.position.x))
    local position_y_bytes = love.data.pack('string', 'H', math.floor(data.position.y))
    local velocity_x_bytes = love.data.pack('string', 'h', math.floor(data.velocity.x))
    local velocity_y_bytes = love.data.pack('string', 'h', math.floor(data.velocity.y))

    -- Byte indicies
    --        1,         2, 3, 4, 5,            6,7                8, 9             10, 11              12, 13
    return type_byte .. node_id_bytes .. position_x_bytes .. position_y_bytes .. velocity_x_bytes .. velocity_y_bytes
end

--- Unpacks the compressed data into a table.
-- @string packed_data The packed data to unpackage
-- @treturn table The unpackaged data as a table
function Lerp:unpackage(packed_data)
    return {
        id = love.data.unpack('I', packed_data:sub(2, 5)),
        position = {
          x = love.data.unpack('H', packed_data:sub(6, 7)),
          y = love.data.unpack('H', packed_data:sub(8, 9))
        },
        velocity = {
            x = love.data.unpack('h', packed_data:sub(10, 11)),
            y = love.data.unpack('h', packed_data:sub(12, 13))
        }
    }
end

return Lerp