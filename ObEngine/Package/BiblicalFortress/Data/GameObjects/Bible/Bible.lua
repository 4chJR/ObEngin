Import("Core.Animation");
Import("Core.Collision");
Import("Core.STD");
Import("Core.SFML");
Import("Core.LevelSprite");

This:useLocalTrigger("Init");
This:useLocalTrigger("Update");
This:useLocalTrigger("Click");

Linear = require("Lib/GameLib/Trajectories/Linear");

function Local.Init()
    This:Animator():setKey("AIM");

    target = 0;
    for key, value in pairs(World:getColliders()) do
        if value:doesHaveTag("Character") and value:getParentID() ~= "" then
            target = value;
        end
    end
    This:Collider():addTag("NotSolid");
    This:Collider():addTag("Bible");

    trajectory = Linear(0, 0, 0);
    trajectory:bind(This, {0, 0});
    trajectory:setPosition(0, 0);
    speed = math.random(3);
    life = 15;
end

function Local.Update(P)
    if target:getPosition():first() > This:Collider():getPosition():first() then trajectory:move(P.dt * speed, 0);
    else trajectory:move(-P.dt * speed, 0);
    end
    if target:getPosition():second() > This:Collider():getPosition():second() then trajectory:move(0, P.dt * speed);
    else trajectory:move(0, -P.dt * speed);
    end
end

function Local.Click()
    life = life - 1;
    This:LevelSprite():setColor(Core.SFML.Color.new(255, (255 * life / 15), (255 * life / 15), 255));
    if life == 0 then
        This:Collider():removeTag("Bible");
        This:delete();
    end
end