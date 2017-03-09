Define Flag (Anim);
Define Flag (Lock);

Meta:
    name:"SHOOT"
    clock:100
Images:
    ImageList:[1..6]
    model:"%s.png"
Groups:
    @main
        content:[0..5]
    @mainrev
        content:[5..0]
Animation:
    AnimationCode:[
        "PLAY_GROUP(main, 1)"
        "PLAY_GROUP(mainrev, 1)"
        "CALL('IDLE')"
    ]