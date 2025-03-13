{pkgs }:

pkgs.writeShellScriptBin "update" ''
  echo "updating"
  cd /home/SVArcade-2025
  ${pkgs.git}/bin/git pull
  ${pkgs.godot_4}/bin/godot4  --path /home/svarcade/SVArcade-2025/
''
