Define Flag (Map);
Define Flag (Lock);

Meta:
    Level:"Main"
    SizeX:1920
    SizeY:1080
    StartX:0
    StartY:0

LevelSprites:
    @6uXEONqv
        path:"Sprites/LevelSprites/ground.png"
        posX:0
        posY:782
        rotation:0
        scale:1.000000
        layer:1
        z-depth:1
    @pfmO3A90
        path:"Sprites/LevelSprites/wall.png"
        posX:398
        posY:0
        rotation:0
        scale:1.000000
        layer:1
        z-depth:1

Collisions:
    @collider0
        polygonPoints:[
            "1920,928"
            "0,928"
            "0,1056"
            "1920,1056"
        ]
    @collider2
        polygonPoints:[
            "478,0"
            "414,0"
            "414,928"
            "478,928"
        ]
    @collider3
        polygonPoints:[
            "1920,0"
            "1888,0"
            "1888,928"
            "1920,928"
        ]
        
LevelObjects:
    @TEsE1uez
        type:"Fortress"
        @Requires
    @pHpVJ1mK
        type:"Character"
        @Requires
            x:1200
            y:0
    @cloudManager
        type:"CloudManager"
        @Requires
            @clouds
                @line1
                    speed:8.0
                    sprite:"Sprites/GameObjects/Cloud/1.png"
                    y:0.0
                @line2
                    speed:7.0
                    sprite:"Sprites/GameObjects/Cloud/2.png"
                    y:77.0
                @line3
                    speed:6.0
                    sprite:"Sprites/GameObjects/Cloud/3.png"
                    y:150.0
                @line4
                    speed:5.0
                    sprite:"Sprites/GameObjects/Cloud/4.png"
                    y:232.0
                @line5
                    speed:4.0
                    sprite:"Sprites/GameObjects/Cloud/5.png"
                    y:310.0
                @line6
                    speed:3.0
                    sprite:"Sprites/GameObjects/Cloud/6.png"
                    y:387.0
                @line7
                    speed:2.0
                    sprite:"Sprites/GameObjects/Cloud/7.png"
                    y:460.0
                @line8
                    speed:1.0
                    sprite:"Sprites/GameObjects/Cloud/8.png"
                    y:504.0

