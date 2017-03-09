Define Flag (Anim);
Define Flag (Lock);

Meta:
    name:"AIM"
    clock:60
Images:
    ImageList:[1..12]
    model:"%s.png"
Groups:
    @main
        content:[0..11]
Animation:
    AnimationCode:[
        "PLAY_GROUP(main, -1)"
    ]