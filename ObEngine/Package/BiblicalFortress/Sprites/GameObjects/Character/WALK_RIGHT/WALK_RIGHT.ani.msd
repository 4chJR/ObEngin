Define Flag (Anim);
Define Flag (Lock);

Meta:
    name:"WALK_RIGHT"
    clock:40
Images:
    ImageList:[0..24]
    model:"f_%s.png"
Groups:
    @main
        content:[0..24]
Animation:
    AnimationCode:["PLAY_GROUP(main, -1)"]