local NETWORK_MESSAGE_TYPES = require 'lib.types.network_message_types'
local PlayerInputRelease = {}

--- PlayerInputRelease message service.
-- This message services handles the packaging and unpackaging
-- of the network message type player_input_release.
function PlayerInputRelease:new()
    local player_input_release = {}
    self.__index = self
    return setmetatable(player_input_release, self)
end

--- Packs the data into a compressed string.
-- @table data The data to be packaged
-- @treturn string packaged data
function PlayerInputRelease:package(node_id, data)
    -- Player Input Release Packet Info
    ---------------------
    -- Player Input Release network message, 6+ Byte total
    -- 1 Byte Message Type | 4 Bytes Node ID | 1+ Byte Key
    ---------------------
    local type_byte = love.data.pack('string', 'b', NETWORK_MESSAGE_TYPES.player_input_release)
    local node_id_bytes = love.data.pack('string', 'I', node_id)
    local key_bytes = love.data.pack('string', 'z', data.key)

    -- Byte indicies
    --        1,         2, 3, 4, 5,        6
    return type_byte .. node_id_bytes .. key_bytes
end

--- Unpacks the compressed data into a table.
-- @string packed_data The packed data to unpackage
-- @treturn table The unpackaged data as a table
function PlayerInputRelease:unpackage(packed_data)
    return {
        id = love.data.unpack('I', packed_data:sub(2,5)),
        key = love.data.unpack('z', packed_data:sub(6, string.len(packed_data)))
    }
end

return PlayerInputRelease