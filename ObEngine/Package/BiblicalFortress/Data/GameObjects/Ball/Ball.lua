Import("Core.Collision");

Linear = require("Lib/GameLib/Trajectories/Linear");

This:useLocalTrigger("Init");
This:useLocalTrigger("Update");

function Local.Init()
    This:Collider():addTag("NotSolid");
    This:Collider():addTag("Bible");
    trajectory = Linear(0, 0, 0);
    trajectory:bind(This, {0, 0});
    trajectory:setPosition(160, 805);
    speed = math.random(6);
end

function Local.Update(P)
    trajectory:move(P.dt * speed, 0);
end