Import("Core.LevelSprite");
Import("Core.MathExp");
Import("Core.Particle");

inspect = require('Lib/StdLib/Inspect');

This:useLocalTrigger("Init");
This:useLocalTrigger("Update");
CloudManager = {};

function Local.Init(clouds)
    print("Cloud Manager Launch");
    print(inspect(clouds));
    CloudManager.Dump = clouds;
    CloudManager.Clouds = {};
    CloudManager.Offsets = {};
    CloudManager.Widths = {};
    CloudManager.Speeds = {};

    for k, v in pairs(clouds) do
        CloudManager.Clouds[k] = {};
        CloudManager.Offsets[k] = 0;
        CloudManager.Speeds[k] = v.speed;
        table.insert(CloudManager.Clouds[k], Core.LevelSprite.LevelSprite.new("cloud_" .. k .. "0"));
        CloudManager.Clouds[k][1]:load(v["sprite"]);
        CloudManager.Clouds[k][1]:addAtr("+FIX");
        CloudManager.Clouds[k][1]:setZDepth(2);
        CloudManager.Widths[k] = CloudManager.Clouds[k][1]:getW();
        CloudManager.Clouds[k][1]:setPosition(-CloudManager.Widths[k], v.y);
        CloudManager.Clouds[k][1]:setParentID(This:getID());
        World:addLevelSprite(CloudManager.Clouds[k][1]);
        local cloudCounter = math.ceil(1920.0 / CloudManager.Widths[k]);
        for i = 1, cloudCounter do
            table.insert(CloudManager.Clouds[k], Core.LevelSprite.LevelSprite.new("cloud_" .. k .. tostring(i)));
            CloudManager.Clouds[k][i + 1]:load(v["sprite"]);
            CloudManager.Clouds[k][i + 1]:addAtr("+FIX");
            CloudManager.Clouds[k][i + 1]:setZDepth(2);
            CloudManager.Clouds[k][i + 1]:setPosition(CloudManager.Widths[k] * (i - 1), v.y);
            CloudManager.Clouds[k][i + 1]:setParentID(This:getID());
            World:addLevelSprite(CloudManager.Clouds[k][i + 1]);
        end
    end
    print(inspect(CloudManager));
end

function Local.Update(P)
    for k, offset in pairs(CloudManager.Offsets) do
        CloudManager.Offsets[k] = offset + (P.dt * CloudManager.Speeds[k]);
        if offset >= CloudManager.Widths[k] then
            CloudManager.Offsets[k] = offset - CloudManager.Widths[k];
        end
    end
    for k, v in pairs(CloudManager.Clouds) do
        for i, cloud in pairs(v) do
            cloud:setPosition((i - 2) * cloud:getW() + CloudManager.Offsets[k], cloud:getY());
        end
    end
end

function Local.Save()
    return {clouds = CloudManager.Dump};
end