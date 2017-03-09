-- Namespaces Definition
Character = {};
Keys = {};
Trajectories = {};

-- CPP API Imports
Import("Core.Animation.Animator");
Import("Core.Collision");
Import("Core.LevelSprite");
Import("Core.Constants");
Import("Core.Trigger");
Import("Core.Dialog");

GetHook("TextDisplay");

-- Trajectories Imports
Linear = require("Lib/GameLib/Trajectories/Linear");
Constraints = require("Lib/GameLib/Trajectories/Constraints");

-- Lua MSE Lib Imports
contains = require("Lib/StdLib/Contains");
inspect = require("Lib/StdLib/Inspect");

-- Hooks
GetHook("TriggerDatabase");

-- Local Triggers
This:useLocalTrigger("Init");
This:useLocalTrigger("Update");

-- Local Init Function
function Local.Init(x, y)
    if (x == nil) then x = 0; end
    if (y == nil) then y = 0; end
    This:Collider():setPosition(x, y);
    Character.Dump = {x = x, y = y};
    This:useExternalTrigger("Global", "Keys", "ActionToggled");
    This:useExternalTrigger("Global", "Keys", "ActionReleased");
    This:Collider():addTag("Character");
    This:Collider():addExcludedTag("NotSolid");
    This:Collider():addExcludedTag("Ladder");
    This:Collider():addExcludedTag("Character");

    print(inspect(Hook));
    cameraFollower = Hook.TriggerDatabase:createTriggerGroup(Public, "ActorsCamera"):addTrigger("Moved");

    --This:Animator():loadAnimator();

    Character.isJumping = false;
    Character.transientJump = false;
    Character.isFalling = false;
    Character.isMoving = false;
    Character.isRunning = false;
    Character.isCrouching = false;
    Character.onLadder = false;
    Character.isHooked = false;
    Character.direction = "Right";
    Character.moveSpeed = 7;
    Character.walkSpeed = 7;
    Character.runSpeed = 18;
    Character.jumpHeight = 40;

    Character.oldX = 0;
    Character.oldY = 0;
    
    allColliders = World:getColliders();
    
    -- Jumping Trajectory
    Trajectories.Jump = Linear(0, -1, 0);
    Trajectories.Jump:setConstraint("JumpStart", function(self)    
        if self.speed > 0 and not Character.isFalling and not Character.isJumping then
            self.static = false;
            Character.isJumping = true;
            Character.transientJump = true;
            This:Animator():setKey("JUMP_" .. Character.direction:upper());
        end
    end);
    Trajectories.Jump:setConstraint("JumpEndSpeedNull", function(self) 
        Constraints.StaticWhenSpeedIsNull(self, function() Character.transientJump = false; end);
    end);
    Trajectories.Jump:setConstraint("JumpEndCollided", function(self) 
        Constraints.StaticWhenColliding(self, function() Character.transientJump = false; end);
    end);
    
    --Falling Trajectory
    Trajectories.Fall = Linear(0, 1, 180);
    Trajectories.Fall:setConstraint("FallStart", function(self)
        if not This:Collider():testAllColliders(allColliders, 0, 1, true) and not Character.transientJump and not Character.isFalling then
            Character.isJumping = false;
            Character.isFalling = true;
            self.static = false;
            self.speed = 0;
            This:Animator():setKey("FALL_" .. Character.direction:upper());
        end
    end);
    Trajectories.Fall:setConstraint("FallEndCollided", function(self)
        Constraints.StaticWhenColliding(self, function() Character.isFalling = false; This:Animator():setKey("IDLE_" .. Character.direction:upper()); end);
    end);
    
    -- Moving Trajectory
    Trajectories.Direction = Linear(0, 0, 0);
    Trajectories.Direction:setConstraint("DirectionEndCollided", function(self)
        Constraints.StopWhenColliding(self, function() end);
    end);

    -- Ladder Trajectory
    Trajectories.Ladder = Linear(10, 0, 180);
    Trajectories.Ladder:setConstraint("LadderCollided", function(self)
        Constraints.StopWhenColliding(self, function() end);
    end);
    
    Character.BindTrajectories();
    This:Animator():setKey("IDLE_RIGHT");
    This:setInitialised(true);
end

-- Local Update Function
function Local.Update(param)
    local x, y = This:Collider():getMasterPointPosition():first(), This:Collider():getMasterPointPosition():second();
    if x ~= Character.oldX or y ~= Character.oldY then
        cameraFollower:pushParameter("Moved", "Id", Public);
        cameraFollower:pushParameter("Moved", "Position", {x = x, y = y});
        cameraFollower:enableTrigger("Moved");
        Character.oldX = x;
        Character.oldY = y;
    end
    allColliders = World:getColliders();
    Character.UpdateTrajectories(param.dt);

    -- Ladder Detection
    if This:Collider():doesCollideWithTag(allColliders, {"Ladder"}, 0, 0) and not Character.onLadder then
        Character.onLadder = true;
    elseif not This:Collider():doesCollideWithTag(allColliders, {"Ladder"}, 0, 0) and Character.onLadder then
        Character.onLadder = false;
    end

    -- Platform hook Detection
    if This:Collider():doesCollideWithTag(allColliders, {"Hook"}, 0, 1) and not Character.isHooked then
        Character.isHooked = true;
        local newOrigin = This:Collider():getCollidedCollidersWithTags(allColliders, {"Hook"}, 0, 1)[1];
        print("Hooked to : " .. newOrigin:getID());
        This:Collider():setOrigin(newOrigin);
    elseif not This:Collider():doesCollideWithTag(allColliders, {"Hook"}, 0, 1) and Character.isHooked then
        print("Remove origin");
        Character.isHooked = false;
        This:Collider():removeOrigin();
    end

    if Character.onLadder then
        Trajectories.Fall:disable();
        Trajectories.Ladder:enable();
    else
        Trajectories.Fall:enable();
        Trajectories.Ladder:disable();
    end

    if Character.isMoving then
        Character.Move(Character.direction);
    end

    if This:Collider():doesCollideWithTag(allColliders, {"Bible"}, 0, 0) then
        This:delete();
        Hook.TextDisplay:sendToRenderer("intro", {text = "Perdu :'( Merci de relancer !"});
    end
end

function Local.Save()
    return Character.Dump;
end

-- Character Actions
function Character.BindTrajectories()
    for k, v in pairs(Trajectories) do
        v:bind(This, {0, 0});
    end
end

function Character.UpdateTrajectories(dt)
    for k, v in pairs(Trajectories) do
        v:update(dt);
    end
end

function Character.Jump()
    if not Character.isFalling and not Character.isJumping then
        Trajectories.Jump:setSpeed(Character.jumpHeight);
    end
end

function Character.Move(direction)
    local directionAngle = 0;
    if not Character.isJumping and not Character.isFalling and not Character.isRunning then
        This:Animator():setKey("WALK_" .. Character.direction:upper());
    elseif not Character.isJumping and not Character.isFalling then
        This:Animator():setKey("RUN_" .. Character.direction:upper());
    end
    if direction == "Left" then
        directionAngle = 270;
    elseif direction == "Right" then
        directionAngle = 90;
    end
    Trajectories.Direction:setAngle(directionAngle);
    Trajectories.Direction:setSpeed(Character.moveSpeed);
end

function Character.Climb(direction)
    if direction == "Up" then
        Trajectories.Ladder:setSpeed(-10);
    elseif direction == "Down" then
        Trajectories.Ladder:setSpeed(10);
    else
        Trajectories.Ladder:setSpeed(0);
    end
end

-- KeyBinding
function Keys.ActionToggled(param)
    if (contains(param.ToggledActions, "Jump")) then Character.Jump(); end
    if contains(param.ToggledActions, "Left") and contains(param.ToggledActions, "Right") then end
    if contains(param.ToggledActions, "Left") then Character.isMoving = true Character.direction = "Left"; end
    if contains(param.ToggledActions, "Right") then Character.isMoving = true; Character.direction = "Right"; end
    if contains(param.ToggledActions, "Up") then Character.Climb("Up"); end
    if contains(param.ToggledActions, "Down") then Character.Climb("Down"); end

    if contains(param.ToggledActions, "Sprint") then 
        Character.isRunning = true;
        Character.moveSpeed = Character.runSpeed;
        Trajectories.Direction:setSpeed(Character.moveSpeed);
        This:Animator():setKey("RUN_" .. Character.direction:upper());
    end
end
function Keys.ActionReleased(param)
    if (contains(param.ReleasedActions, "Left") 
        and Character.direction == "Left") or (contains(param.ReleasedActions, "Right") 
        and Character.direction == "Right") then
        This:Animator():setKey("IDLE_" .. Character.direction:upper());
        Character.isMoving = false;
        Trajectories.Direction:setSpeed(0);
    end
    if contains(param.ReleasedActions, "Up") or contains(param.ReleasedActions, "Down") then
        Character.Climb("None"); 
    end
    if contains(param.ReleasedActions, "Sprint") then
        Character.isRunning = false;
        Character.moveSpeed = Character.walkSpeed;
        if Character.isMoving then 
            This:Animator():setKey("WALK_" .. Character.direction:upper());
            Trajectories.Direction:setSpeed(Character.moveSpeed);
        else 
            This:Animator():setKey("IDLE_" .. Character.direction:upper());
            Trajectories.Direction:setSpeed(0);
        end
    end
end