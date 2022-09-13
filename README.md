# tuxedo_keyboard
Tastatur-LEDs beim Tuxedo-Notebook Polaris 15 steuern

Die Systemkonfiguration lässt sich nur mit erhöhten Rechten ändern. Das gilt auch für Treiber, bei denen sich zur Laufzeit Optionen dynamisch anpassen lassen. Ein Beispiel ist die LED-Beleuchtung der Tastatur des Tuxedo-Notebooks Polaris. Farbe und Helligkeit des LEDs lassen sich über Werte in den Dateien "/sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/color_string" beziehungsweise "/sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness" bestimmen.
Mit beispielsweise
```
sudo echo BLUE > /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/color_string
```
stellt man eine blaue Beleuchtung ein.

Bei Tuxedo (https://www.tuxedocomputers.com) gibt es eine Dokumentation zu den Treibern und den Optionen für die Tastatur-LEDs (https://www.tuxedocomputers.com/de/Infos/Hilfe-Support/Anleitungen/Tastatur-Treiber-fuer-TUXEDO-Computers-Modelle-mit-RGB-Tastatur-nachinstallieren.tuxedo). Den Source Code der Treiber gibt es bei https://github.com/tuxedocomputers/tuxedo-keyboard.

Die möglichen Werte lassen sich mit 
```
cat /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/color_string
```
ermitteln (BLACK, RED, GREEN, BLUE, YELLOW, MAGENTA, CYAN, WHITE). Die Farben müssen in Großbuchstaben angegeben werden. Für die Helligkeit ist "/sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness" zuständig. Der Wert kann zwischen „0“ (keine Beleuchtung) und "255" (Maximum) liegen. Der Befehl
```
sudo -s echo 0 > /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness
```
schaltet die Beleuchtung der Tastatur aus.

Die Optionen kann man mit
```
sudo -s echo "options tuxedo_keyboard color=BLUE" > /etc/modprobe.d/tuxedo_keyboard.conf
```
in einer Datei speichern. Beim Linux-Neustart wird die Datei gelesen und die Tastaturbeleuchtung gemäß der Werte eingestellt.

Bei anderen Tuxedo-Notebooks gibt es mehr Optionen (siehe https://www.tuxedocomputers.com/de/Infos/Hilfe-Support/Anleitungen/Tastatur-Treiber-fuer-TUXEDO-Computers-Modelle-mit-RGB-Tastatur-nachinstallieren.tuxedo).

Optimal wäre ein Treiber, über den sich die Optionen in Echtzeit setzen lassen, also nicht nur bei einem Neustart des Systems. Ein Ansatz dafür ist unter https://github.com/dariost/clevo-xsm-wmi zu finden. Für das Polaris 15 eignet sich der Treiber aber nicht, weil er nur mit Clevo-Geräten funktioniert. Das Polaris 15 basiert jedoch auf einem Uniwill-Notebook.

Unser Beispiel zeigt, wie sich der Wert auch ohne sudo ändern lässt. Das Grundprinzip lässt sich auf alle Treiber anwenden, die sich über Dateien unter „/sys“ oder per Konfigurationsdatei steuern lassen.

## Systemd-Units und Tool verwenden

Die beiden Dateien aus dem Ordner "systemd" kopieren Sie (mit root-Rechten) in den Ordner "/etc/systemd/system".

Die Datei "tuxedo_keyboard.sh" aus dem Ordner "script" kopieren Sie in den Ordner "/root". Die Datei "tuxedo_keybord.ini" aus dem gleichen Ordner kopieren Sie in Ihr Home-Verzeichnis.

Aktivieren und starten Sie das Path-Unit:
```
sudo systemctl enable tuxedo_keyboard.path
sudo systemctl start tuxedo_keyboard.path
```
Sie können jetzt in der Datei "tuxedo_keybord.ini" Werte ändern, tragen Sie beispielsweise statt "color=GREEN" den Wert "color=RED" ein (Großschreibung beachten). Die Farbe der Tastatur-LEDs ändert sich sofort.

Das Programm tuxedo_keyboard aus dem Ordner "bin" ändert nur die Farbe in der Datei "tuxedo_keybord.ini". Die eigentliche Arbeit übernimmt das Systemd.Path-Unit und das Bash-Script. Der Quelltext (Lazarus/Free Pascal) liegt im Ordner "tuxedo_keyboard".

![](https://github.com/Myria-de/tuxedo_keyboard/blob/main/images/Tuxedo_Keyboard_GUI.png?raw=true)

