Import("Core.Animation");
Import("Core.Collision");

This:useLocalTrigger("Init");
This:useLocalTrigger("Update");

Linear = require("Lib/GameLib/Trajectories/Linear");

function Local.Init(x, y)
    This:Animator():setKey("IDLE");
    nextShoot = 1000;
    cSum = 0;
    trajectory = Linear(0, 0, 0);
    trajectory:bind(This, {0, 0});
    trajectory:setPosition(53, 550);
    bibleIndex = 0;
end

function Local.Update(P)
    cSum = cSum + P.dt;
    if cSum > nextShoot then
        This:Animator():setKey("SHOOT");
        nextShoot = math.random(500);
        cSum = 0;
        World:createGameObject("bible_" .. bibleIndex, "Bible");
        World:createGameObject("ball_" .. bibleIndex, "Ball");
        bibleIndex = bibleIndex + 1;
    else
        This:Animator():setKey("IDLE");
    end
end