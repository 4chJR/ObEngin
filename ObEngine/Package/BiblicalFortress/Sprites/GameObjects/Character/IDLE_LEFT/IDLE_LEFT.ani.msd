Define Flag (Anim);
Define Flag (Lock);

Meta:
    name:"IDLE_LEFT"
    clock:10
Images:
    ImageList:[0..61]
    model:"f_%s.png"
Groups:
    @main
        content:[0..61]
Animation:
    AnimationCode:["PLAY_GROUP(main, -1)"]