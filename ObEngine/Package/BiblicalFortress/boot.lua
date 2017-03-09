World:loadFromFile("Main.map.msd");
GetHook("Cursor"); Hook.Cursor:selectCursor("RoundWhite");
GetHook("TextDisplay"); Hook.TextDisplay:createRenderer("Shade", "intro");
Hook.TextDisplay:sendToRenderer("intro", 
{text = 
[[ -- Biblical Mech Fortress --
Cliquez sur les Bibles pour les détruire !
Ne vous laissez pas toucher par les bibles et les boules arc-en-ciel !]]
});
Hook.TextDisplay:sendToRenderer("intro", {text = 
[[Contrôles :
  Q : Gauche
  D : Droite
  Space : Sauter
  Shift : Sprinter
  Cliquer : Attaquer]]
});