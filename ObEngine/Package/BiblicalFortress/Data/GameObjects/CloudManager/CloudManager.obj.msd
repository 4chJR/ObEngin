CloudManager:
    @LevelSprite
        position:"absolute"
        offsetX:0
        offsetY:0
        rotation:0
        scale:1.0
        layer:1
        z-depth:2
        ?attributeList(string):
            "+FIX"
    @Script
        priority:0
        scriptList:["Data/GameObjects/CloudManager/CloudManager.lua"]

