#  CheckMyPower v1.1 — Style Neo-Neon
#  Cree par Nicleox — nicleox@cityx.link — 2026
#  Licence : Usage personnel
# ============================================================

#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = "SilentlyContinue"
# Les erreurs non bloquantes sont absorbees puis degradees par fallback:
# l'objectif est de sortir un rapport exploitable, meme sur des pilotes limites.

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$script:lastReport = $null

# ============================================================
#  TABLES DE REFERENCE — CPU Boost (GHz max turbo)
# ============================================================

$script:cpuBoostTable = @{

    # ═══════════════════════════════════════════════════════════
    #  INTEL DESKTOP
    # ═══════════════════════════════════════════════════════════

    # Intel 14e gen desktop
    "i9-14900KS"=6.2; "i9-14900K"=6.0; "i9-14900KF"=6.0; "i9-14900"=5.8; "i9-14900F"=5.8
    "i7-14700K"=5.6; "i7-14700KF"=5.6; "i7-14700"=5.4; "i7-14700F"=5.4
    "i5-14600K"=5.3; "i5-14600KF"=5.3; "i5-14600"=5.2; "i5-14500"=5.0; "i5-14400"=4.7; "i5-14400F"=4.7
    "i3-14100"=4.7; "i3-14100F"=4.7; "i3-14100T"=4.4

    # Intel 13e gen desktop
    "i9-13900KS"=6.0; "i9-13900K"=5.8; "i9-13900KF"=5.8; "i9-13900"=5.6; "i9-13900F"=5.6
    "i7-13700K"=5.4; "i7-13700KF"=5.4; "i7-13700"=5.2; "i7-13700F"=5.2
    "i5-13600K"=5.1; "i5-13600KF"=5.1; "i5-13600"=5.0; "i5-13500"=4.8; "i5-13400"=4.6; "i5-13400F"=4.6
    "i3-13100"=4.5; "i3-13100F"=4.5; "i3-13100T"=4.2

    # Intel 12e gen desktop
    "i9-12900KS"=5.5; "i9-12900K"=5.2; "i9-12900KF"=5.2; "i9-12900"=5.1; "i9-12900F"=5.1
    "i7-12700K"=5.0; "i7-12700KF"=5.0; "i7-12700"=4.9; "i7-12700F"=4.9
    "i5-12600K"=4.9; "i5-12600KF"=4.9; "i5-12600"=4.8; "i5-12500"=4.6; "i5-12400"=4.4; "i5-12400F"=4.4
    "i3-12300"=4.4; "i3-12100"=4.3; "i3-12100F"=4.3; "i3-12100T"=4.1

    # Intel 11e gen desktop
    "i9-11900K"=5.3; "i9-11900KF"=5.3; "i9-11900"=5.2; "i9-11900F"=5.2
    "i7-11700K"=5.0; "i7-11700KF"=5.0; "i7-11700"=4.9; "i7-11700F"=4.9
    "i5-11600K"=4.9; "i5-11600KF"=4.9; "i5-11600"=4.8; "i5-11500"=4.6; "i5-11400"=4.4; "i5-11400F"=4.4
    "i3-11100"=4.4

    # Intel 10e gen desktop
    "i9-10900K"=5.3; "i9-10900KF"=5.3; "i9-10900"=5.2; "i9-10900F"=5.2; "i9-10850K"=5.2
    "i7-10700K"=5.1; "i7-10700KF"=5.1; "i7-10700"=4.8; "i7-10700F"=4.8
    "i5-10600K"=4.8; "i5-10600KF"=4.8; "i5-10600"=4.8; "i5-10500"=4.5; "i5-10400"=4.3; "i5-10400F"=4.3
    "i3-10300"=4.4; "i3-10100"=4.3; "i3-10100F"=4.3

    # Intel 9e gen desktop
    "i9-9900KS"=5.0; "i9-9900K"=5.0; "i9-9900KF"=5.0; "i9-9900"=4.9
    "i7-9700K"=4.9; "i7-9700KF"=4.9; "i7-9700"=4.7; "i7-9700F"=4.7
    "i5-9600K"=4.6; "i5-9600KF"=4.6; "i5-9600"=4.6; "i5-9500"=4.4; "i5-9400"=4.1; "i5-9400F"=4.1
    "i3-9350K"=4.4; "i3-9300"=4.3; "i3-9100"=4.2; "i3-9100F"=4.2

    # Intel 8e gen desktop
    "i7-8700K"=4.7; "i7-8700"=4.6; "i7-8086K"=5.0
    "i5-8600K"=4.3; "i5-8600"=4.3; "i5-8500"=4.1; "i5-8400"=4.0
    "i3-8350K"=4.0; "i3-8300"=3.7; "i3-8100"=3.6

    # ═══════════════════════════════════════════════════════════
    #  INTEL MOBILE — H/HX/HK
    # ═══════════════════════════════════════════════════════════

    # Intel 14e gen mobile H/HX
    "i9-14900HX"=5.8; "i7-14700HX"=5.5; "i7-14650HX"=5.2
    "i5-14500HX"=4.9; "i5-14450HX"=4.8
    "i9-14900H"=5.4; "i7-14700H"=5.2; "i7-14650H"=5.0
    "i5-14500H"=4.6; "i5-14450H"=4.5; "i5-14400H"=4.4

    # Intel 13e gen mobile H/HX
    "i9-13980HX"=5.6; "i9-13950HX"=5.5; "i9-13900HX"=5.4; "i9-13900HK"=5.4
    "i9-13900H"=5.4; "i7-13800H"=5.2; "i7-13700HX"=5.0; "i7-13700H"=5.0; "i7-13650HX"=4.9
    "i5-13600HX"=4.8; "i5-13500HX"=4.7; "i5-13500H"=4.7; "i5-13420H"=4.4

    # Intel 12e gen mobile H/HX
    "i9-12950HX"=5.0; "i9-12900HX"=5.0; "i9-12900HK"=5.0; "i9-12900H"=5.0
    "i7-12850HX"=4.8; "i7-12800HX"=4.8; "i7-12800H"=4.8; "i7-12700H"=4.7; "i7-12650H"=4.7
    "i5-12600HX"=4.6; "i5-12600H"=4.5; "i5-12500H"=4.5; "i5-12450H"=4.4

    # Intel 11e gen mobile H
    "i9-11980HK"=5.0; "i9-11900H"=4.9
    "i7-11850H"=4.8; "i7-11800H"=4.6; "i7-11600H"=4.6; "i7-11390H"=5.0
    "i5-11500H"=4.6; "i5-11400H"=4.5; "i5-11260H"=4.4

    # Intel 10e gen mobile H
    "i9-10980HK"=5.3; "i9-10885H"=5.3; "i9-10875H"=5.1
    "i7-10870H"=5.0; "i7-10850H"=5.1; "i7-10750H"=5.0
    "i5-10500H"=4.5; "i5-10400H"=4.6; "i5-10300H"=4.5

    # Intel 9e gen mobile H
    "i9-9980HK"=5.0; "i9-9880H"=4.8
    "i7-9850H"=4.6; "i7-9750H"=4.5; "i7-9750HF"=4.5
    "i5-9400H"=4.3; "i5-9300H"=4.1; "i5-9300HF"=4.1

    # Intel 8e gen mobile H
    "i9-8950HK"=4.8
    "i7-8850H"=4.3; "i7-8750H"=4.1; "i7-8700B"=4.6
    "i5-8400H"=4.2; "i5-8300H"=4.0

    # ═══════════════════════════════════════════════════════════
    #  INTEL MOBILE — U/P
    # ═══════════════════════════════════════════════════════════

    # Intel Core Ultra 200V
    "Ultra 9 288V"=5.1; "Ultra 7 268V"=5.0; "Ultra 7 258V"=4.8; "Ultra 5 238V"=4.7; "Ultra 5 228V"=4.5

    # Intel Core Ultra 200
    "Ultra 9 285K"=5.7; "Ultra 9 285"=5.5; "Ultra 7 265K"=5.5; "Ultra 7 265KF"=5.5; "Ultra 7 265"=5.3
    "Ultra 5 245K"=5.2; "Ultra 5 245KF"=5.2; "Ultra 5 245"=5.0; "Ultra 5 235"=4.8

    # Intel Core Ultra 100 (Meteor Lake)
    "Ultra 9 185H"=5.1; "Ultra 7 165H"=5.0; "Ultra 7 155H"=4.8; "Ultra 5 135H"=4.6; "Ultra 5 125H"=4.5
    "Ultra 7 165U"=4.1; "Ultra 7 155U"=4.0; "Ultra 5 135U"=3.8; "Ultra 5 125U"=3.6

    # Intel 14e gen mobile U/P
    "i7-1470P"=4.8; "i7-1460P"=4.7
    "i5-1450P"=4.5; "i5-1440P"=4.4; "i5-1435U"=3.8
    "i7-1465U"=4.0; "i7-1455U"=3.8
    "i3-1415U"=3.7; "i3-1405U"=3.5

    # Intel 13e gen mobile U/P
    "i7-1370P"=5.0; "i7-1360P"=5.0
    "i5-1350P"=4.7; "i5-1340P"=4.6; "i5-1335U"=4.6; "i5-1345U"=4.7
    "i7-1365U"=5.2; "i7-1355U"=5.0
    "i3-1315U"=4.5; "i3-1305U"=4.5; "i3-N305"=3.8; "N100"=3.4; "N200"=3.7; "N305"=3.8

    # Intel 12e gen mobile U/P
    "i7-1280P"=4.8; "i7-1270P"=4.8; "i7-1260P"=4.7
    "i5-1250P"=4.4; "i5-1240P"=4.4; "i5-1235U"=4.4; "i5-1245U"=4.4
    "i7-1265U"=4.8; "i7-1255U"=4.7
    "i3-1215U"=4.4; "i3-1210U"=4.4; "N95"=3.4; "N97"=3.6

    # Intel 11e gen mobile U (Tiger Lake)
    "i7-1195G7"=5.0; "i7-1185G7"=4.8; "i7-1165G7"=4.7; "i7-11370H"=4.8
    "i5-1155G7"=4.5; "i5-1145G7"=4.4; "i5-1135G7"=4.2
    "i3-1125G4"=3.7; "i3-1115G4"=4.1

    # Intel 10e gen mobile U (Ice Lake / Comet Lake U)
    "i7-1068G7"=4.1; "i7-1065G7"=3.9; "i7-10710U"=4.7; "i7-10510U"=4.9
    "i5-1038G7"=3.8; "i5-1035G7"=3.7; "i5-1035G4"=3.7; "i5-1035G1"=3.6; "i5-10310U"=4.4; "i5-10210U"=4.2
    "i3-1005G1"=3.4; "i3-10110U"=4.1

    # Intel 8e gen mobile U
    "i7-8665U"=4.8; "i7-8565U"=4.6; "i7-8550U"=4.0
    "i5-8365U"=4.1; "i5-8265U"=3.9; "i5-8250U"=3.4
    "i3-8145U"=3.9; "i3-8130U"=3.4

    # ═══════════════════════════════════════════════════════════
    #  AMD DESKTOP
    # ═══════════════════════════════════════════════════════════

    # AMD Ryzen 9000 desktop
    "Ryzen 9 9950X"=5.7; "Ryzen 9 9950X3D"=5.7; "Ryzen 9 9900X"=5.6; "Ryzen 9 9900X3D"=5.6
    "Ryzen 7 9800X3D"=5.2; "Ryzen 7 9700X"=5.5
    "Ryzen 5 9600X"=5.4; "Ryzen 5 9600"=5.2

    # AMD Ryzen 7000 desktop
    "Ryzen 9 7950X"=5.7; "Ryzen 9 7950X3D"=5.7; "Ryzen 9 7900X"=5.6; "Ryzen 9 7900X3D"=5.6; "Ryzen 9 7900"=5.4
    "Ryzen 7 7800X3D"=5.0; "Ryzen 7 7700X"=5.4; "Ryzen 7 7700"=5.3
    "Ryzen 5 7600X"=5.3; "Ryzen 5 7600"=5.1; "Ryzen 5 7500F"=5.0

    # AMD Ryzen 5000 desktop
    "Ryzen 9 5950X"=4.9; "Ryzen 9 5900X"=4.8; "Ryzen 9 5900"=4.7
    "Ryzen 7 5800X"=4.7; "Ryzen 7 5800X3D"=4.5; "Ryzen 7 5800"=4.7; "Ryzen 7 5700X"=4.6; "Ryzen 7 5700X3D"=4.5; "Ryzen 7 5700G"=4.6
    "Ryzen 5 5600X"=4.6; "Ryzen 5 5600"=4.4; "Ryzen 5 5600G"=4.4; "Ryzen 5 5500"=4.2

    # AMD Ryzen 3000 desktop
    "Ryzen 9 3950X"=4.7; "Ryzen 9 3900X"=4.6; "Ryzen 9 3900XT"=4.7
    "Ryzen 7 3800X"=4.5; "Ryzen 7 3800XT"=4.7; "Ryzen 7 3700X"=4.4
    "Ryzen 5 3600X"=4.4; "Ryzen 5 3600XT"=4.5; "Ryzen 5 3600"=4.2; "Ryzen 5 3500X"=4.1
    "Ryzen 3 3300X"=4.3; "Ryzen 3 3100"=3.9

    # AMD Ryzen 2000 desktop
    "Ryzen 7 2700X"=4.3; "Ryzen 7 2700"=4.1
    "Ryzen 5 2600X"=4.2; "Ryzen 5 2600"=3.9; "Ryzen 5 2500X"=4.0
    "Ryzen 3 2300X"=4.0; "Ryzen 3 2200G"=3.7

    # AMD Ryzen 1000 desktop
    "Ryzen 7 1800X"=4.0; "Ryzen 7 1700X"=3.8; "Ryzen 7 1700"=3.7
    "Ryzen 5 1600X"=4.0; "Ryzen 5 1600"=3.6; "Ryzen 5 1500X"=3.7
    "Ryzen 3 1300X"=3.7; "Ryzen 3 1200"=3.4

    # AMD Threadripper
    "Threadripper 7980X"=5.1; "Threadripper 7970X"=5.0; "Threadripper 7960X"=5.3
    "Threadripper PRO 5995WX"=4.5; "Threadripper PRO 5975WX"=4.5; "Threadripper PRO 5965WX"=4.5
    "Threadripper 3990X"=4.3; "Threadripper 3970X"=4.5; "Threadripper 3960X"=4.5
    "Threadripper 2990WX"=4.2; "Threadripper 2970WX"=4.2; "Threadripper 2950X"=4.4

    # ═══════════════════════════════════════════════════════════
    #  AMD MOBILE — H/HX/HS
    # ═══════════════════════════════════════════════════════════

    # AMD Ryzen AI 300 / Strix
    "Ryzen AI 9 HX 370"=5.1; "Ryzen AI 9 HX 365"=5.0; "Ryzen AI 9 365"=5.0
    "Ryzen AI 7 PRO 360"=5.0; "Ryzen AI 7 360"=5.0; "Ryzen AI 5 340"=4.8

    # AMD Ryzen 9000 mobile HX
    "Ryzen 9 9955HX"=5.4; "Ryzen 9 9955HX3D"=5.4
    "Ryzen 7 9855HX"=5.1

    # AMD Ryzen 8000/8040 mobile
    "Ryzen 9 8945HS"=5.2; "Ryzen 9 8945H"=5.2
    "Ryzen 7 8845HS"=5.1; "Ryzen 7 8845H"=5.1; "Ryzen 7 8840HS"=5.1; "Ryzen 7 8840H"=5.1; "Ryzen 7 8840U"=5.1
    "Ryzen 5 8645HS"=4.9; "Ryzen 5 8645H"=4.9; "Ryzen 5 8640HS"=4.9; "Ryzen 5 8640U"=4.9; "Ryzen 5 8540U"=4.9
    "Ryzen 3 8440U"=4.7

    # AMD Ryzen 7045 mobile HX
    "Ryzen 9 7945HX"=5.4; "Ryzen 9 7945HX3D"=5.4
    "Ryzen 7 7845HX"=5.2; "Ryzen 5 7645HX"=4.9

    # AMD Ryzen 7040 mobile HS/H
    "Ryzen 9 7940HS"=5.2; "Ryzen 9 7940H"=5.2
    "Ryzen 7 7840HS"=5.1; "Ryzen 7 7840H"=5.1; "Ryzen 7 7840U"=5.1
    "Ryzen 5 7640HS"=4.9; "Ryzen 5 7640H"=4.9; "Ryzen 5 7640U"=4.9

    # AMD Ryzen 7035 mobile
    "Ryzen 7 7735HS"=4.8; "Ryzen 7 7735H"=4.8; "Ryzen 7 7735U"=4.8
    "Ryzen 5 7535HS"=4.6; "Ryzen 5 7535H"=4.6; "Ryzen 5 7535U"=4.6
    "Ryzen 3 7335U"=4.3

    # AMD Ryzen 7030 mobile
    "Ryzen 7 7730U"=4.5; "Ryzen 5 7530U"=4.5; "Ryzen 5 7520U"=4.4; "Ryzen 3 7330U"=4.3; "Ryzen 3 7320U"=4.1

    # AMD Ryzen 6000 mobile
    "Ryzen 9 6980HX"=5.0; "Ryzen 9 6980HS"=5.0; "Ryzen 9 6900HX"=5.0; "Ryzen 9 6900HS"=4.9
    "Ryzen 7 6800H"=4.7; "Ryzen 7 6800HS"=4.7; "Ryzen 7 6800U"=4.7
    "Ryzen 5 6600H"=4.5; "Ryzen 5 6600HS"=4.5; "Ryzen 5 6600U"=4.5

    # AMD Ryzen 5000 mobile
    "Ryzen 9 5980HX"=4.8; "Ryzen 9 5980HS"=4.8; "Ryzen 9 5900HX"=4.6; "Ryzen 9 5900HS"=4.6; "Ryzen 9 5900H"=4.6
    "Ryzen 7 5800H"=4.4; "Ryzen 7 5800HS"=4.4; "Ryzen 7 5800U"=4.4
    "Ryzen 5 5600H"=4.2; "Ryzen 5 5600HS"=4.2; "Ryzen 5 5600U"=4.2; "Ryzen 5 5625U"=4.2; "Ryzen 5 5500U"=4.0
    "Ryzen 3 5400U"=4.0; "Ryzen 3 5300U"=3.8; "Ryzen 3 5125C"=3.0

    # AMD Ryzen 4000 mobile
    "Ryzen 9 4900HS"=4.3; "Ryzen 9 4900H"=4.4
    "Ryzen 7 4800H"=4.2; "Ryzen 7 4800HS"=4.2; "Ryzen 7 4800U"=4.2; "Ryzen 7 4700U"=4.1
    "Ryzen 5 4600H"=4.0; "Ryzen 5 4600HS"=4.0; "Ryzen 5 4600U"=4.0; "Ryzen 5 4500U"=4.0
    "Ryzen 3 4300U"=3.7; "Ryzen 3 4300G"=4.0

    # AMD Ryzen 3000 mobile
    "Ryzen 7 3780U"=4.0; "Ryzen 7 3750H"=4.0; "Ryzen 7 3700U"=4.0
    "Ryzen 5 3580U"=3.7; "Ryzen 5 3550H"=3.7; "Ryzen 5 3500U"=3.7
    "Ryzen 3 3350U"=3.5; "Ryzen 3 3300U"=3.5; "Ryzen 3 3200U"=3.5

    # AMD Ryzen 2000 mobile
    "Ryzen 7 2800H"=3.8; "Ryzen 7 2700U"=3.8
    "Ryzen 5 2600H"=3.6; "Ryzen 5 2500U"=3.6
    "Ryzen 3 2300U"=3.4; "Ryzen 3 2200U"=3.4

    # ═══════════════════════════════════════════════════════════
    #  INTEL HEDT
    # ═══════════════════════════════════════════════════════════
    "i9-10980XE"=4.8; "i9-10940X"=4.8; "i9-10920X"=4.8; "i9-10900X"=4.7
    "i9-9980XE"=4.5; "i9-9960X"=4.5; "i9-9940X"=4.5; "i9-9920X"=4.4; "i9-9900X"=4.4
    "i9-7980XE"=4.4; "i9-7960X"=4.4; "i9-7940X"=4.3; "i9-7920X"=4.3
    }
# ============================================================
#  TABLE — CPU Score global (sur 10)
# ============================================================

$script:cpuScoreTable = @{

    # ═══════════════════════════════════════════════════════════
    #  INTEL DESKTOP
    # ═══════════════════════════════════════════════════════════

    # Intel 14e gen desktop (Raptor Lake Refresh - 2024)
    "i9-14900KS"=9.8; "i9-14900K"=9.7; "i9-14900KF"=9.7; "i9-14900"=9.5; "i9-14900F"=9.5
    "i7-14700K"=9.2; "i7-14700KF"=9.2; "i7-14700"=9.0; "i7-14700F"=9.0
    "i5-14600K"=8.5; "i5-14600KF"=8.5; "i5-14600"=8.2; "i5-14500"=8.0; "i5-14400"=7.5; "i5-14400F"=7.5
    "i3-14100"=6.5; "i3-14100F"=6.5; "i3-14100T"=5.8

    # Intel 13e gen desktop (Raptor Lake - 2023)
    "i9-13900KS"=9.6; "i9-13900K"=9.5; "i9-13900KF"=9.5; "i9-13900"=9.3; "i9-13900F"=9.3
    "i7-13700K"=9.0; "i7-13700KF"=9.0; "i7-13700"=8.7; "i7-13700F"=8.7
    "i5-13600K"=8.3; "i5-13600KF"=8.3; "i5-13600"=8.0; "i5-13500"=7.8; "i5-13400"=7.3; "i5-13400F"=7.3
    "i3-13100"=6.3; "i3-13100F"=6.3; "i3-13100T"=5.5

    # Intel 12e gen desktop (Alder Lake - 2022)
    "i9-12900KS"=9.3; "i9-12900K"=9.2; "i9-12900KF"=9.2; "i9-12900"=9.0; "i9-12900F"=9.0
    "i7-12700K"=8.8; "i7-12700KF"=8.8; "i7-12700"=8.5; "i7-12700F"=8.5
    "i5-12600K"=8.0; "i5-12600KF"=8.0; "i5-12600"=7.6; "i5-12500"=7.3; "i5-12400"=7.0; "i5-12400F"=7.0
    "i3-12300"=6.2; "i3-12100"=6.0; "i3-12100F"=6.0; "i3-12100T"=5.3

    # Intel 11e gen desktop (Rocket Lake - 2021)
    "i9-11900K"=8.5; "i9-11900KF"=8.5; "i9-11900"=8.3; "i9-11900F"=8.3
    "i7-11700K"=8.2; "i7-11700KF"=8.2; "i7-11700"=7.8; "i7-11700F"=7.8
    "i5-11600K"=7.5; "i5-11600KF"=7.5; "i5-11600"=7.2; "i5-11500"=7.0; "i5-11400"=6.8; "i5-11400F"=6.8
    "i3-11100"=5.8

    # Intel 10e gen desktop (Comet Lake - 2020)
    "i9-10900K"=8.2; "i9-10900KF"=8.2; "i9-10900"=8.0; "i9-10900F"=8.0; "i9-10850K"=8.1
    "i7-10700K"=7.8; "i7-10700KF"=7.8; "i7-10700"=7.5; "i7-10700F"=7.5
    "i5-10600K"=7.2; "i5-10600KF"=7.2; "i5-10600"=7.0; "i5-10500"=6.8; "i5-10400"=6.5; "i5-10400F"=6.5
    "i3-10300"=5.8; "i3-10100"=5.5; "i3-10100F"=5.5

    # Intel 9e gen desktop (Coffee Lake Refresh - 2019)
    "i9-9900KS"=7.8; "i9-9900K"=7.7; "i9-9900KF"=7.7; "i9-9900"=7.5
    "i7-9700K"=7.3; "i7-9700KF"=7.3; "i7-9700"=7.0; "i7-9700F"=7.0
    "i5-9600K"=6.8; "i5-9600KF"=6.8; "i5-9600"=6.5; "i5-9500"=6.3; "i5-9400"=6.0; "i5-9400F"=6.0
    "i3-9350K"=5.5; "i3-9300"=5.2; "i3-9100"=5.0; "i3-9100F"=5.0

    # Intel 8e gen desktop (Coffee Lake - 2018)
    "i7-8700K"=7.0; "i7-8700"=6.8; "i7-8086K"=7.2
    "i5-8600K"=6.5; "i5-8600"=6.3; "i5-8500"=6.0; "i5-8400"=5.8
    "i3-8350K"=5.3; "i3-8300"=5.0; "i3-8100"=4.8

    # ═══════════════════════════════════════════════════════════
    #  INTEL MOBILE — H/HX/HK (Performance)
    # ═══════════════════════════════════════════════════════════

    # Intel 14e gen mobile H/HX (Raptor Lake Refresh - 2024)
    "i9-14900HX"=9.4; "i7-14700HX"=8.8; "i7-14650HX"=8.5
    "i5-14500HX"=7.5; "i5-14450HX"=7.0
    "i9-14900H"=8.8; "i7-14700H"=8.2; "i7-14650H"=8.0
    "i5-14500H"=7.2; "i5-14450H"=6.8; "i5-14400H"=6.5

    # Intel 13e gen mobile H/HX (Raptor Lake - 2023)
    "i9-13980HX"=9.2; "i9-13950HX"=9.1; "i9-13900HX"=9.0; "i9-13900HK"=8.8
    "i9-13900H"=8.5; "i7-13800H"=8.3; "i7-13700HX"=8.5; "i7-13700H"=8.0; "i7-13650HX"=8.0
    "i5-13600HX"=7.5; "i5-13500HX"=7.3; "i5-13500H"=7.0; "i5-13420H"=6.5

    # Intel 12e gen mobile H/HX (Alder Lake - 2022)
    "i9-12950HX"=8.8; "i9-12900HX"=8.7; "i9-12900HK"=8.5; "i9-12900H"=8.3
    "i7-12850HX"=8.3; "i7-12800HX"=8.2; "i7-12800H"=8.0; "i7-12700H"=7.8; "i7-12650H"=7.5
    "i5-12600HX"=7.3; "i5-12600H"=7.0; "i5-12500H"=6.8; "i5-12450H"=6.3

    # Intel 11e gen mobile H (Tiger Lake H - 2021)
    "i9-11980HK"=8.0; "i9-11900H"=7.8
    "i7-11850H"=7.5; "i7-11800H"=7.3; "i7-11600H"=7.0; "i7-11390H"=6.5
    "i5-11500H"=6.8; "i5-11400H"=6.5; "i5-11260H"=6.2

    # Intel 10e gen mobile H (Comet Lake H - 2020)
    "i9-10980HK"=7.5; "i9-10885H"=7.3; "i9-10875H"=7.2
    "i7-10870H"=7.0; "i7-10850H"=6.8; "i7-10750H"=6.5
    "i5-10500H"=6.0; "i5-10400H"=5.8; "i5-10300H"=5.5

    # Intel 9e gen mobile H (Coffee Lake H - 2019)
    "i9-9980HK"=7.0; "i9-9880H"=6.8
    "i7-9850H"=6.5; "i7-9750H"=6.2; "i7-9750HF"=6.2
    "i5-9400H"=5.5; "i5-9300H"=5.3; "i5-9300HF"=5.3

    # Intel 8e gen mobile H (Coffee Lake H - 2018)
    "i9-8950HK"=6.5
    "i7-8850H"=6.0; "i7-8750H"=5.8; "i7-8700B"=6.0
    "i5-8400H"=5.3; "i5-8300H"=5.0

    # ═══════════════════════════════════════════════════════════
    #  INTEL MOBILE — U/P (Ultrabook / Basse conso)
    # ═══════════════════════════════════════════════════════════

    # Intel Core Ultra 200V (Arrow Lake / Lunar Lake - 2025)
    "Ultra 9 288V"=8.0; "Ultra 7 268V"=7.3; "Ultra 7 258V"=7.0; "Ultra 5 238V"=6.3; "Ultra 5 228V"=6.0

    # Intel Core Ultra 200 (Arrow Lake - 2025)
    "Ultra 9 285K"=9.6; "Ultra 9 285"=9.2; "Ultra 7 265K"=9.0; "Ultra 7 265KF"=9.0; "Ultra 7 265"=8.5
    "Ultra 5 245K"=8.3; "Ultra 5 245KF"=8.3; "Ultra 5 245"=7.8; "Ultra 5 235"=7.5

    # Intel Core Ultra 100 (Meteor Lake - 2024)
    "Ultra 9 185H"=7.5; "Ultra 7 165H"=7.2; "Ultra 7 155H"=7.0; "Ultra 5 135H"=6.5; "Ultra 5 125H"=6.2
    "Ultra 7 165U"=5.8; "Ultra 7 155U"=5.5; "Ultra 5 135U"=5.2; "Ultra 5 125U"=4.8

    # Intel 14e gen mobile U/P (Raptor Lake Refresh - 2024)
    "i7-1470P"=6.8; "i7-1460P"=6.5
    "i5-1450P"=6.0; "i5-1440P"=5.8; "i5-1435U"=5.2
    "i7-1465U"=5.5; "i7-1455U"=5.3
    "i3-1415U"=4.5; "i3-1405U"=4.2

    # Intel 13e gen mobile U/P (Raptor Lake - 2023)
    "i7-1370P"=6.5; "i7-1360P"=6.3
    "i5-1350P"=5.8; "i5-1340P"=5.6; "i5-1335U"=5.0; "i5-1345U"=5.3
    "i7-1365U"=5.5; "i7-1355U"=5.3
    "i3-1315U"=4.2; "i3-1305U"=4.0; "i3-N305"=3.8; "N100"=3.0; "N200"=3.2; "N305"=3.8

    # Intel 12e gen mobile U/P (Alder Lake - 2022)
    "i7-1280P"=7.0; "i7-1270P"=6.5; "i7-1260P"=6.3
    "i5-1250P"=5.8; "i5-1240P"=5.6; "i5-1235U"=5.0; "i5-1245U"=5.3
    "i7-1265U"=5.5; "i7-1255U"=5.3
    "i3-1215U"=4.0; "i3-1210U"=3.8; "N95"=2.8; "N97"=2.8

    # Intel 11e gen mobile U (Tiger Lake - 2020/2021)
    "i7-1195G7"=6.0; "i7-1185G7"=5.8; "i7-1165G7"=5.5; "i7-11370H"=5.8
    "i5-1155G7"=5.0; "i5-1145G7"=4.8; "i5-1135G7"=4.5
    "i3-1125G4"=4.0; "i3-1115G4"=3.8

    # Intel 10e gen mobile U (Ice Lake / Comet Lake U - 2020)
    "i7-1068G7"=5.3; "i7-1065G7"=5.0; "i7-10710U"=5.5; "i7-10510U"=4.8
    "i5-1038G7"=4.5; "i5-1035G7"=4.3; "i5-1035G4"=4.2; "i5-1035G1"=4.0; "i5-10310U"=4.5; "i5-10210U"=4.3
    "i3-1005G1"=3.5; "i3-10110U"=3.8

    # Intel 8e gen mobile U (Whiskey Lake / Kaby Lake R - 2018)
    "i7-8665U"=5.2; "i7-8565U"=5.0; "i7-8550U"=4.8
    "i5-8365U"=4.5; "i5-8265U"=4.3; "i5-8250U"=4.0
    "i3-8145U"=3.5; "i3-8130U"=3.3

    # ═══════════════════════════════════════════════════════════
    #  AMD DESKTOP
    # ═══════════════════════════════════════════════════════════

    # AMD Ryzen 9000 desktop (Zen5 - 2024/2025)
    "Ryzen 9 9950X"=9.8; "Ryzen 9 9950X3D"=9.9; "Ryzen 9 9900X"=9.5; "Ryzen 9 9900X3D"=9.6
    "Ryzen 7 9800X3D"=9.3; "Ryzen 7 9700X"=8.8
    "Ryzen 5 9600X"=8.3; "Ryzen 5 9600"=8.0

    # AMD Ryzen 7000 desktop (Zen4 - 2022/2023)
    "Ryzen 9 7950X"=9.6; "Ryzen 9 7950X3D"=9.7; "Ryzen 9 7900X"=9.3; "Ryzen 9 7900X3D"=9.4; "Ryzen 9 7900"=9.0
    "Ryzen 7 7800X3D"=9.0; "Ryzen 7 7700X"=8.5; "Ryzen 7 7700"=8.2
    "Ryzen 5 7600X"=8.0; "Ryzen 5 7600"=7.8; "Ryzen 5 7500F"=7.5

    # AMD Ryzen 5000 desktop (Zen3 - 2020/2021)
    "Ryzen 9 5950X"=9.0; "Ryzen 9 5900X"=8.8; "Ryzen 9 5900"=8.5
    "Ryzen 7 5800X"=8.3; "Ryzen 7 5800X3D"=8.5; "Ryzen 7 5800"=8.0; "Ryzen 7 5700X"=7.8; "Ryzen 7 5700X3D"=8.0; "Ryzen 7 5700G"=7.3
    "Ryzen 5 5600X"=7.5; "Ryzen 5 5600"=7.3; "Ryzen 5 5600G"=6.8; "Ryzen 5 5500"=6.5

    # AMD Ryzen 3000 desktop (Zen2 - 2019)
    "Ryzen 9 3950X"=8.3; "Ryzen 9 3900X"=8.0; "Ryzen 9 3900XT"=8.2
    "Ryzen 7 3800X"=7.5; "Ryzen 7 3800XT"=7.7; "Ryzen 7 3700X"=7.3
    "Ryzen 5 3600X"=6.8; "Ryzen 5 3600XT"=7.0; "Ryzen 5 3600"=6.5; "Ryzen 5 3500X"=6.0
    "Ryzen 3 3300X"=5.8; "Ryzen 3 3100"=5.5

    # AMD Ryzen 2000 desktop (Zen+ - 2018)
    "Ryzen 7 2700X"=6.8; "Ryzen 7 2700"=6.5
    "Ryzen 5 2600X"=6.2; "Ryzen 5 2600"=6.0; "Ryzen 5 2500X"=5.5
    "Ryzen 3 2300X"=5.0; "Ryzen 3 2200G"=4.5

    # AMD Ryzen 1000 desktop (Zen - 2017/2018)
    "Ryzen 7 1800X"=6.0; "Ryzen 7 1700X"=5.8; "Ryzen 7 1700"=5.5
    "Ryzen 5 1600X"=5.3; "Ryzen 5 1600"=5.0; "Ryzen 5 1500X"=4.8
    "Ryzen 3 1300X"=4.2; "Ryzen 3 1200"=3.8

    # AMD Threadripper (HEDT)
    "Threadripper 7980X"=10.0; "Threadripper 7970X"=9.8; "Threadripper 7960X"=9.6
    "Threadripper PRO 5995WX"=9.8; "Threadripper PRO 5975WX"=9.5; "Threadripper PRO 5965WX"=9.3
    "Threadripper 3990X"=9.5; "Threadripper 3970X"=9.2; "Threadripper 3960X"=9.0
    "Threadripper 2990WX"=8.5; "Threadripper 2970WX"=8.2; "Threadripper 2950X"=8.0

    # ═══════════════════════════════════════════════════════════
    #  AMD MOBILE — H/HX/HS (Performance)
    # ═══════════════════════════════════════════════════════════

    # AMD Ryzen AI 300 / Strix (Zen5 mobile - 2024/2025)
    "Ryzen AI 9 HX 370"=9.0; "Ryzen AI 9 HX 365"=8.5; "Ryzen AI 9 365"=8.3
    "Ryzen AI 7 PRO 360"=7.5; "Ryzen AI 7 360"=7.5; "Ryzen AI 5 340"=6.5

    # AMD Ryzen 9000 mobile HX (Zen5 Fire Range - 2025)
    "Ryzen 9 9955HX"=9.5; "Ryzen 9 9955HX3D"=9.6
    "Ryzen 7 9855HX"=8.8

    # AMD Ryzen 8000/8040 mobile (Zen4 Hawk Point - 2024)
    "Ryzen 9 8945HS"=8.8; "Ryzen 9 8945H"=8.5
    "Ryzen 7 8845HS"=8.2; "Ryzen 7 8845H"=8.0; "Ryzen 7 8840HS"=8.0; "Ryzen 7 8840H"=7.8; "Ryzen 7 8840U"=7.0
    "Ryzen 5 8645HS"=7.2; "Ryzen 5 8645H"=7.0; "Ryzen 5 8640HS"=7.0; "Ryzen 5 8640U"=6.2; "Ryzen 5 8540U"=5.8
    "Ryzen 3 8440U"=5.0

    # AMD Ryzen 7045 mobile HX (Zen4 Dragon Range - 2023)
    "Ryzen 9 7945HX"=9.3; "Ryzen 9 7945HX3D"=9.4
    "Ryzen 7 7845HX"=8.5; "Ryzen 5 7645HX"=7.5

    # AMD Ryzen 7040 mobile HS/H (Zen4 Phoenix - 2023)
    "Ryzen 9 7940HS"=8.5; "Ryzen 9 7940H"=8.3
    "Ryzen 7 7840HS"=8.0; "Ryzen 7 7840H"=7.8; "Ryzen 7 7840U"=7.0
    "Ryzen 5 7640HS"=7.0; "Ryzen 5 7640H"=6.8; "Ryzen 5 7640U"=6.2

    # AMD Ryzen 7035 mobile (Zen3+ Rembrandt-R - 2023)
    "Ryzen 7 7735HS"=7.5; "Ryzen 7 7735H"=7.3; "Ryzen 7 7735U"=6.0
    "Ryzen 5 7535HS"=6.5; "Ryzen 5 7535H"=6.3; "Ryzen 5 7535U"=5.5
    "Ryzen 3 7335U"=4.5

    # AMD Ryzen 7030 mobile (Zen3 Barcelo-R - 2023)
    "Ryzen 7 7730U"=5.8; "Ryzen 5 7530U"=5.3; "Ryzen 5 7520U"=4.5; "Ryzen 3 7330U"=4.0; "Ryzen 3 7320U"=3.5

    # AMD Ryzen 6000 mobile (Zen3+ Rembrandt - 2022)
    "Ryzen 9 6980HX"=8.5; "Ryzen 9 6980HS"=8.3; "Ryzen 9 6900HX"=8.2; "Ryzen 9 6900HS"=8.0
    "Ryzen 7 6800H"=7.8; "Ryzen 7 6800HS"=7.5; "Ryzen 7 6800U"=6.5
    "Ryzen 5 6600H"=7.0; "Ryzen 5 6600HS"=6.8; "Ryzen 5 6600U"=5.8

    # AMD Ryzen 5000 mobile (Zen3 Cezanne - 2021)
    "Ryzen 9 5980HX"=8.2; "Ryzen 9 5980HS"=8.0; "Ryzen 9 5900HX"=8.0; "Ryzen 9 5900HS"=7.8; "Ryzen 9 5900H"=7.8
    "Ryzen 7 5800H"=7.5; "Ryzen 7 5800HS"=7.3; "Ryzen 7 5800U"=6.0
    "Ryzen 5 5600H"=6.5; "Ryzen 5 5600HS"=6.3; "Ryzen 5 5600U"=5.5; "Ryzen 5 5625U"=5.5; "Ryzen 5 5500U"=5.0
    "Ryzen 3 5400U"=4.5; "Ryzen 3 5300U"=4.0; "Ryzen 3 5125C"=3.5

    # AMD Ryzen 4000 mobile (Zen2 Renoir - 2020)
    "Ryzen 9 4900HS"=7.5; "Ryzen 9 4900H"=7.5
    "Ryzen 7 4800H"=7.0; "Ryzen 7 4800HS"=6.8; "Ryzen 7 4800U"=5.5; "Ryzen 7 4700U"=5.3
    "Ryzen 5 4600H"=6.3; "Ryzen 5 4600HS"=6.0; "Ryzen 5 4600U"=5.0; "Ryzen 5 4500U"=4.8
    "Ryzen 3 4300U"=4.0; "Ryzen 3 4300G"=4.5

    # AMD Ryzen 3000 mobile (Zen+ Picasso - 2019)
    "Ryzen 7 3780U"=4.8; "Ryzen 7 3750H"=5.0; "Ryzen 7 3700U"=4.5
    "Ryzen 5 3580U"=4.3; "Ryzen 5 3550H"=4.5; "Ryzen 5 3500U"=4.0
    "Ryzen 3 3350U"=3.5; "Ryzen 3 3300U"=3.3; "Ryzen 3 3200U"=3.0

    # AMD Ryzen 2000 mobile (Zen - 2018)
    "Ryzen 7 2800H"=5.0; "Ryzen 7 2700U"=4.3
    "Ryzen 5 2600H"=4.5; "Ryzen 5 2500U"=4.0
    "Ryzen 3 2300U"=3.5; "Ryzen 3 2200U"=3.0

    # ═══════════════════════════════════════════════════════════
    #  INTEL HEDT (X-series)
    # ═══════════════════════════════════════════════════════════
    "i9-10980XE"=9.0; "i9-10940X"=8.8; "i9-10920X"=8.5; "i9-10900X"=8.3
    "i9-9980XE"=8.5; "i9-9960X"=8.3; "i9-9940X"=8.0; "i9-9920X"=7.8; "i9-9900X"=7.5
    "i9-7980XE"=8.0; "i9-7960X"=7.8; "i9-7940X"=7.5; "i9-7920X"=7.3

    # ═══════════════════════════════════════════════════════════
    #  QUALCOMM (Windows on ARM - 2024/2025)
    # ═══════════════════════════════════════════════════════════
    "Snapdragon X Elite X1E-84-100"=8.0; "Snapdragon X Elite X1E-80-100"=7.5
    "Snapdragon X Plus X1P-64-100"=6.5; "Snapdragon X Plus X1P-46-100"=5.8
    "Snapdragon X Elite"=7.8; "Snapdragon X Plus"=6.3

    # ═══════════════════════════════════════════════════════════
    #  INTEL Pentium / Celeron (fin de gamme)
    # ═══════════════════════════════════════════════════════════
    "Pentium Gold G7400"=3.5; "Pentium Gold G6400"=3.3; "Pentium Gold G5400"=3.0
    "Celeron G6900"=2.5; "Celeron G5905"=2.3; "Celeron G4930"=2.0
    "Pentium Silver N6000"=2.8; "Pentium Silver N5030"=2.5; "Pentium Silver N5000"=2.3
    "Celeron N5100"=2.5; "Celeron N5095"=2.5; "Celeron N4120"=2.0; "Celeron N4100"=1.8; "Celeron N4020"=1.5; "Celeron N4000"=1.3

    # AMD Athlon (fin de gamme)
    "Athlon Gold 7220U"=3.0; "Athlon Silver 7120U"=2.5
    "Athlon Gold 3150U"=3.3; "Athlon Silver 3050U"=2.8
    "Athlon 3000G"=3.5; "Athlon 300U"=3.0; "Athlon 200GE"=2.8
}

# ============================================================
#  TABLE — GPU Gaming Score (sur 10)
# ============================================================

$script:gpuGamingScores = @{

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA DESKTOP — RTX 50 Series (Blackwell - 2025)
    # ═══════════════════════════════════════════════════════════
    "RTX 5090"=10.0; "RTX 5090D"=9.8
    "RTX 5080"=9.5; "RTX 5070 Ti"=9.2; "RTX 5070"=8.8
    "RTX 5060 Ti"=8.3; "RTX 5060 Ti 16GB"=8.5; "RTX 5060"=7.8

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA DESKTOP — RTX 40 Series (Ada Lovelace - 2022/2024)
    # ═══════════════════════════════════════════════════════════
    "RTX 4090"=8.8; "RTX 4090D"=8.6
    "RTX 4080 Super"=8.4; "RTX 4080"=8.2
    "RTX 4070 Ti Super"=7.9; "RTX 4070 Ti"=7.7; "RTX 4070 Super"=7.6; "RTX 4070"=7.2
    "RTX 4060 Ti 16GB"=6.9; "RTX 4060 Ti"=6.8; "RTX 4060"=6.3

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA DESKTOP — RTX 30 Series (Ampere - 2020/2022)
    # ═══════════════════════════════════════════════════════════
    "RTX 3090 Ti"=9.0; "RTX 3090"=8.8
    "RTX 3080 Ti"=8.7; "RTX 3080 12GB"=8.5; "RTX 3080"=8.3
    "RTX 3070 Ti"=7.8; "RTX 3070"=7.5
    "RTX 3060 Ti"=7.2; "RTX 3060 12GB"=6.8; "RTX 3060"=6.8
    "RTX 3050 8GB"=5.5; "RTX 3050"=5.5; "RTX 3050 6GB"=5.0

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA DESKTOP — RTX 20 Series (Turing - 2018/2020)
    # ═══════════════════════════════════════════════════════════
    "RTX 2080 Ti"=7.8; "RTX 2080 Super"=7.3; "RTX 2080"=7.0
    "RTX 2070 Super"=6.8; "RTX 2070"=6.5
    "RTX 2060 Super"=6.2; "RTX 2060 12GB"=6.2; "RTX 2060"=5.8

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA DESKTOP — GTX 16 Series (Turing sans RT - 2019/2020)
    # ═══════════════════════════════════════════════════════════
    "GTX 1660 Ti"=5.5; "GTX 1660 Super"=5.3; "GTX 1660"=5.0
    "GTX 1650 Super"=4.8; "GTX 1650"=4.3; "GTX 1650 GDDR6"=4.5
    "GTX 1630"=3.5

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA DESKTOP — GTX 10 Series (Pascal - 2016/2018)
    # ═══════════════════════════════════════════════════════════
    "GTX 1080 Ti"=6.0; "GTX 1080"=5.5; "GTX 1070 Ti"=5.3; "GTX 1070"=5.0
    "GTX 1060 6GB"=4.3; "GTX 1060 3GB"=4.0; "GTX 1060"=4.3
    "GTX 1050 Ti"=3.5; "GTX 1050"=3.0
    "GT 1030"=2.0; "GT 1010"=1.5

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA DESKTOP — TITAN
    # ═══════════════════════════════════════════════════════════
    "TITAN RTX"=7.5; "TITAN V"=6.8; "TITAN Xp"=6.0; "TITAN X Pascal"=5.8

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA LAPTOP — RTX 50 Mobile (Blackwell - 2025)
    # ═══════════════════════════════════════════════════════════
    "RTX 5090 Laptop"=9.5; "RTX 5090 Laptop GPU"=9.5; "RTX 5090 Mobile"=9.5
    "RTX 5080 Laptop"=9.0; "RTX 5080 Laptop GPU"=9.0; "RTX 5080 Mobile"=9.0
    "RTX 5070 Ti Laptop"=8.5; "RTX 5070 Ti Laptop GPU"=8.5; "RTX 5070 Ti Mobile"=8.5
    "RTX 5070 Laptop"=8.0; "RTX 5070 Laptop GPU"=8.0; "RTX 5070 Mobile"=8.0
    "RTX 5060 Laptop"=7.2; "RTX 5060 Laptop GPU"=7.2; "RTX 5060 Mobile"=7.2
    "RTX 5050 Laptop"=6.3; "RTX 5050 Laptop GPU"=6.3; "RTX 5050 Mobile"=6.3

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA LAPTOP — RTX 40 Mobile (Ada Lovelace - 2023/2024)
    # ═══════════════════════════════════════════════════════════
    "RTX 4090 Laptop"=9.0; "RTX 4090 Laptop GPU"=9.0; "RTX 4090 Mobile"=9.0
    "RTX 4080 Laptop"=8.5; "RTX 4080 Laptop GPU"=8.5; "RTX 4080 Mobile"=8.5
    "RTX 4070 Laptop"=7.8; "RTX 4070 Laptop GPU"=7.8; "RTX 4070 Mobile"=7.8
    "RTX 4060 Laptop"=7.0; "RTX 4060 Laptop GPU"=7.0; "RTX 4060 Mobile"=7.0
    "RTX 4050 Laptop"=6.2; "RTX 4050 Laptop GPU"=6.2; "RTX 4050 Mobile"=6.2

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA LAPTOP — RTX 30 Mobile (Ampere - 2021/2022)
    # ═══════════════════════════════════════════════════════════
    "RTX 3080 Ti Laptop"=8.0; "RTX 3080 Ti Laptop GPU"=8.0; "RTX 3080 Ti Mobile"=8.0
    "RTX 3080 Laptop"=7.5; "RTX 3080 Laptop GPU"=7.5; "RTX 3080 Mobile"=7.5
    "RTX 3070 Ti Laptop"=7.2; "RTX 3070 Ti Laptop GPU"=7.2; "RTX 3070 Ti Mobile"=7.2
    "RTX 3070 Laptop"=6.8; "RTX 3070 Laptop GPU"=6.8; "RTX 3070 Mobile"=6.8
    "RTX 3060 Laptop"=6.2; "RTX 3060 Laptop GPU"=6.2; "RTX 3060 Mobile"=6.2
    "RTX 3050 Ti Laptop"=5.2; "RTX 3050 Ti Laptop GPU"=5.2; "RTX 3050 Ti Mobile"=5.2
    "RTX 3050 Laptop"=4.8; "RTX 3050 Laptop GPU"=4.8; "RTX 3050 Mobile"=4.8

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA LAPTOP — RTX 20 Mobile (Turing - 2019/2020)
    # ═══════════════════════════════════════════════════════════
    "RTX 2080 Super Mobile"=6.8; "RTX 2080 Super Max-Q"=6.3
    "RTX 2080 Mobile"=6.5; "RTX 2080 Max-Q"=6.0
    "RTX 2070 Super Mobile"=6.3; "RTX 2070 Super Max-Q"=5.8
    "RTX 2070 Mobile"=6.0; "RTX 2070 Max-Q"=5.5
    "RTX 2060 Mobile"=5.5; "RTX 2060 Max-Q"=5.0

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA LAPTOP — GTX 16 Mobile (Turing - 2019/2020)
    # ═══════════════════════════════════════════════════════════
    "GTX 1660 Ti Mobile"=5.0; "GTX 1660 Ti Max-Q"=4.7
    "GTX 1650 Ti Mobile"=4.3; "GTX 1650 Mobile"=4.0; "GTX 1650 Max-Q"=3.7

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA LAPTOP — GTX 10 Mobile (Pascal - 2018)
    # ═══════════════════════════════════════════════════════════
    "GTX 1080 Mobile"=5.2; "GTX 1080 Max-Q"=4.8
    "GTX 1070 Mobile"=4.7; "GTX 1070 Max-Q"=4.3
    "GTX 1060 Mobile"=4.0; "GTX 1060 Max-Q"=3.7
    "GTX 1050 Ti Mobile"=3.3; "GTX 1050 Mobile"=2.8

    # ═══════════════════════════════════════════════════════════
    #  NVIDIA LAPTOP — MX Series (iGPU-level)
    # ═══════════════════════════════════════════════════════════
    "MX570 A"=3.0; "MX570"=2.8; "MX550"=2.5
    "MX450"=2.3; "MX350"=2.0; "MX330"=1.8; "MX250"=1.5; "MX230"=1.3; "MX150"=1.2; "MX130"=1.0; "MX110"=0.8

    # ═══════════════════════════════════════════════════════════
    #  AMD DESKTOP — RX 9000 Series (RDNA 4 - 2025)
    # ═══════════════════════════════════════════════════════════
    "RX 9070 XT"=8.8; "RX 9070"=8.3
    "RX 9060 XT"=7.5; "RX 9060"=7.0

    # ═══════════════════════════════════════════════════════════
    #  AMD DESKTOP — RX 7000 Series (RDNA 3 - 2023/2024)
    # ═══════════════════════════════════════════════════════════
    "RX 7900 XTX"=8.1; "RX 7900 XT"=7.8; "RX 7900 GRE"=7.4
    "RX 7800 XT"=7.1; "RX 7700 XT"=6.7
    "RX 7600 XT"=6.0; "RX 7600"=5.8
    "RX 7500 XT"=5.8

    # ═══════════════════════════════════════════════════════════
    #  AMD DESKTOP — RX 6000 Series (RDNA 2 - 2020/2022)
    # ═══════════════════════════════════════════════════════════
    "RX 6950 XT"=8.5; "RX 6900 XT"=8.3
    "RX 6800 XT"=8.0; "RX 6800"=7.5
    "RX 6750 XT"=7.3; "RX 6700 XT"=7.0; "RX 6700"=6.5
    "RX 6650 XT"=6.5; "RX 6600 XT"=6.3; "RX 6600"=6.0
    "RX 6500 XT"=4.5; "RX 6400"=3.8

    # ═══════════════════════════════════════════════════════════
    #  AMD DESKTOP — RX 5000 Series (RDNA 1 - 2019/2020)
    # ═══════════════════════════════════════════════════════════
    "RX 5700 XT"=6.5; "RX 5700"=6.0
    "RX 5600 XT"=5.5; "RX 5600"=5.3
    "RX 5500 XT 8GB"=4.8; "RX 5500 XT 4GB"=4.5; "RX 5500 XT"=4.8; "RX 5500"=4.3
    "RX 5300"=3.5

    # ═══════════════════════════════════════════════════════════
    #  AMD DESKTOP — RX Vega / 500 Series (GCN - 2017/2018)
    # ═══════════════════════════════════════════════════════════
    "RX Vega 64"=5.3; "RX Vega 56"=5.0
    "RX 590"=4.5; "RX 580 8GB"=4.3; "RX 580 4GB"=4.0; "RX 580"=4.3
    "RX 570 8GB"=3.8; "RX 570 4GB"=3.5; "RX 570"=3.8
    "RX 560"=3.0; "RX 550"=2.3

    # ═══════════════════════════════════════════════════════════
    #  AMD LAPTOP — RX 7000M / 7000S Mobile (RDNA 3 - 2023/2024)
    # ═══════════════════════════════════════════════════════════
    "RX 7900M"=8.0; "RX 7800M"=7.3; "RX 7700M"=6.8
    "RX 7700S"=6.5; "RX 7600M XT"=6.5; "RX 7600M"=6.0; "RX 7600S"=5.8
    "RX 7500M"=5.0

    # ═══════════════════════════════════════════════════════════
    #  AMD LAPTOP — RX 6000M / 6000S Mobile (RDNA 2 - 2021/2022)
    # ═══════════════════════════════════════════════════════════
    "RX 6850M XT"=7.2; "RX 6800M"=7.0; "RX 6800S"=6.5
    "RX 6700M"=6.3; "RX 6700S"=5.8
    "RX 6650M XT"=5.8; "RX 6650M"=5.5
    "RX 6600M"=5.5; "RX 6600S"=5.0
    "RX 6500M"=4.0; "RX 6300M"=3.0

    # ═══════════════════════════════════════════════════════════
    #  AMD LAPTOP — RX 5000M Mobile (RDNA 1 - 2020)
    # ═══════════════════════════════════════════════════════════
    "RX 5700M"=5.5; "RX 5600M"=5.0; "RX 5500M"=4.3; "RX 5300M"=3.5

    # ═══════════════════════════════════════════════════════════
    #  AMD iGPU / APU (Radeon Graphics intégrés)
    # ═══════════════════════════════════════════════════════════
    "Radeon 890M"=3.5; "Radeon 880M"=3.3; "Radeon 780M"=3.0; "Radeon 760M"=2.8
    "Radeon 740M"=2.5; "Radeon 680M"=2.8; "Radeon 660M"=2.3
    "Radeon Vega 8"=1.8; "Radeon Vega 7"=1.5; "Radeon Vega 6"=1.3; "Radeon Vega 3"=0.8
    "Radeon RX Vega 11"=2.0; "Radeon RX Vega 10"=1.8; "Radeon RX Vega 8"=1.5

    # ═══════════════════════════════════════════════════════════
    #  INTEL ARC DESKTOP (Alchemist / Battlemage - 2022/2024)
    # ═══════════════════════════════════════════════════════════
    "Arc B580"=6.5; "Arc B570"=5.8
    "Arc A770 16GB"=6.5; "Arc A770"=6.3; "Arc A750"=6.0
    "Arc A580"=5.3; "Arc A380"=3.5; "Arc A310"=2.5

    # ═══════════════════════════════════════════════════════════
    #  INTEL ARC LAPTOP (Alchemist / Battlemage Mobile - 2022/2024)
    # ═══════════════════════════════════════════════════════════
    "Arc A770M"=5.5; "Arc A730M"=5.3; "Arc A550M"=4.5; "Arc A530M"=4.0; "Arc A370M"=3.0; "Arc A350M"=2.8
    "Arc 140V"=3.2; "Arc 130V"=2.8

    # ═══════════════════════════════════════════════════════════
    #  INTEL iGPU (UHD / Iris - Desktop & Laptop)
    # ═══════════════════════════════════════════════════════════
    "Iris Xe Graphics 96EU"=2.5; "Iris Xe Graphics 80EU"=2.3; "Iris Xe"=2.3
    "Iris Plus G7"=1.8; "Iris Plus G4"=1.5; "Iris Plus 655"=1.5; "Iris Plus 645"=1.3; "Iris Plus"=1.3
    "UHD Graphics 770"=1.5; "UHD Graphics 730"=1.3; "UHD Graphics 710"=1.0
    "UHD Graphics 750"=1.3; "UHD Graphics 630"=1.0; "UHD Graphics 620"=0.8; "UHD Graphics 610"=0.7; "UHD Graphics 600"=0.5
    
    "UHD"=0.8; "Intel HD Graphics 630"=0.8; "Intel HD Graphics 620"=0.7; "Intel HD Graphics 530"=0.7; "Intel HD Graphics 520"=0.6
    }

$script:gpuGamingDesktopScores = @{}
$script:gpuGamingLaptopScores = @{}
foreach ($key in $script:gpuGamingScores.Keys) {
    if ($key -match "Laptop|Mobile|Max-Q|Notebook|\bMX\d") {
        $script:gpuGamingLaptopScores[$key] = $script:gpuGamingScores[$key]
    } else {
        $script:gpuGamingDesktopScores[$key] = $script:gpuGamingScores[$key]
    }
}

# ============================================================
#  FONCTIONS UTILITAIRES
# ============================================================

function Get-Verdict([double]$score) {
    if ($score -ge 9) { return @{ Text = "Excellent"; Color = "#00FF88" } }
    if ($score -ge 7) { return @{ Text = "Tres bien"; Color = "#00FFFF" } }
    if ($score -ge 5) { return @{ Text = "Bon";       Color = "#FFD700" } }
    if ($score -ge 3) { return @{ Text = "Moyen";     Color = "#FF6A00" } }
    return @{ Text = "Faible"; Color = "#FF4444" }
}

function Get-ScoreColor([double]$score) {
    if ($score -ge 8) { return "#00FF88" }
    if ($score -ge 6) { return "#00FFFF" }
    if ($score -ge 4) { return "#FFD700" }
    if ($score -ge 2) { return "#FF6A00" }
    return "#FF4444"
}

function Get-VRAM {
    $vramMB = 0

    # Priorite 1: nvidia-smi (source la plus fiable pour GPU NVIDIA).
    try {
        $nvsmiPath = "$env:SystemRoot\System32\nvidia-smi.exe"
        if (Test-Path $nvsmiPath) {
            $nv = & $nvsmiPath "--query-gpu=memory.total" "--format=csv,noheader,nounits" 2>$null
            if ($nv) {
                $lines = $nv -split "`n" | Where-Object { $_.Trim() -match '^\d+$' }
                foreach ($line in $lines) {
                    $mb = [int]$line.Trim()
                    if ($mb -gt $vramMB) { $vramMB = $mb }
                }
                if ($vramMB -gt 0) { return $vramMB }
            }
        }
    } catch {}

    # Priorite 2: registre video (valeur 64 bits quand exposee par le pilote).
    try {
        $regPath = "HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
        Get-ChildItem $regPath -ErrorAction SilentlyContinue | ForEach-Object {
            $val = (Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'
            if ($val -and $val -gt 0) {
                $mb = [math]::Round([uint64]$val / 1MB)
                if ($mb -gt $vramMB) { $vramMB = $mb }
            }
        }
        if ($vramMB -gt 0) { return $vramMB }
    } catch {}

    # Priorite 3: dxdiag XML (fallback universel NVIDIA/AMD/Intel).
    # Note securite: on appelle explicitement %SystemRoot%\System32\dxdiag.exe
    # et on utilise un fichier temporaire unique pour eviter les collisions.
    try {
        $tmpDx = Join-Path $env:TEMP ("cmp_dxdiag_vram_{0}.xml" -f ([guid]::NewGuid().ToString("N")))
        $dxdiagPath = Join-Path $env:SystemRoot "System32\dxdiag.exe"
        if (-not (Test-Path $dxdiagPath)) { throw "dxdiag introuvable" }

        $proc = $null
        try {
            $proc = Start-Process -FilePath $dxdiagPath -ArgumentList "/x `"$tmpDx`"" -PassThru -NoNewWindow -WindowStyle Hidden
            $waited = 0
            while (-not (Test-Path $tmpDx) -and $waited -lt 20) {
                Start-Sleep -Seconds 1
                $waited++
            }
            if (Test-Path $tmpDx) {
                [xml]$dx = Get-Content $tmpDx -Encoding UTF8
                foreach ($dev in $dx.DxDiag.DisplayDevices.DisplayDevice) {
                    $raw = $dev.DedicatedMemory
                    if ($raw -match '(\d+)') {
                        $mb = [int]$Matches[1]
                        if ($mb -gt $vramMB) { $vramMB = $mb }
                    }
                }
            }
        } finally {
            if ($proc -and -not $proc.HasExited) { $proc.Kill() }
            if (Test-Path $tmpDx) { Remove-Item $tmpDx -Force -ErrorAction SilentlyContinue }
        }
    } catch {}

    # Priorite 4: WMI AdapterRAM (fallback ancien, parfois limite a ~4 Go).
    if ($vramMB -le 0) {
        try {
            $gpu = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue |
                   Sort-Object AdapterRAM -Descending | Select-Object -First 1
            if ($gpu.AdapterRAM -and $gpu.AdapterRAM -gt 0) {
                $vramMB = [math]::Round($gpu.AdapterRAM / 1MB)
            }
        } catch {}
    }

    return $vramMB
}

function Get-CPUBoost([string]$cpuName) {
    $boostGHz = 0.0

    # ── Extraction du modele court (ex: i9-13980HX) ──
    $cpuShort = ""
    if ($cpuName -match "(i[3579]-\d{4,5}[A-Za-z]{0,4}\d?)") {
        $cpuShort = $Matches[1]
    }

    # ── Priorite 1 : Table en dur (matching exact sur le modele court) ──
    if ($cpuShort -ne "" -and $script:cpuBoostTable.ContainsKey($cpuShort)) {
        return $script:cpuBoostTable[$cpuShort]
    }

    # ── Priorite 2 : Frequence dans le nom CPU ("@ X.XX GHz") ──
    if ($cpuName -match '@\s*([\d\.]+)\s*GHz') {
        $fromName = [double]$Matches[1]
        if ($fromName -gt $boostGHz) { $boostGHz = $fromName }
    }

    # ── Priorite 3 : Registre Windows ──
    try {
        $regCPU = Get-ItemProperty "HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0" -ErrorAction Stop
        if ($regCPU.ProcessorNameString -match '@\s*([\d\.]+)\s*GHz') {
            $fromReg = [double]$Matches[1]
            if ($fromReg -gt $boostGHz) { $boostGHz = $fromReg }
        }
        if ($regCPU.'~MHz') {
            $regGHz = [math]::Round($regCPU.'~MHz' / 1000, 2)
            if ($regGHz -gt $boostGHz) { $boostGHz = $regGHz }
        }
    } catch {}

    # ── Priorite 4 : WMI CurrentClockSpeed ──
    try {
        $cpuWmi = Get-CimInstance Win32_Processor | Select-Object -First 1
        $currentGHz = [math]::Round($cpuWmi.CurrentClockSpeed / 1000, 2)
        if ($currentGHz -gt $boostGHz) { $boostGHz = $currentGHz }
    } catch {}

    # ── Priorite 5 : Mini-stress pour forcer le turbo ──
    if ($boostGHz -le 0) {
        try {
            $end = (Get-Date).AddMilliseconds(200)
            while ((Get-Date) -lt $end) { [math]::Sqrt(123456789.0) | Out-Null }
            Start-Sleep -Milliseconds 50
            $cpuAfter = Get-CimInstance Win32_Processor | Select-Object -First 1
            $afterGHz = [math]::Round($cpuAfter.CurrentClockSpeed / 1000, 2)
            if ($afterGHz -gt $boostGHz) { $boostGHz = $afterGHz }
        } catch {}
    }

    # ── Priorite 6 : Estimation base x 1.25 ──
    if ($boostGHz -le 0) {
        try {
            $cpuBase = Get-CimInstance Win32_Processor | Select-Object -First 1
            $baseGHz = [math]::Round($cpuBase.MaxClockSpeed / 1000, 2)
            $boostGHz = [math]::Round($baseGHz * 1.25, 2)
        } catch {}
    }

    if ($boostGHz -gt 0) { return $boostGHz }
    return $null
}


function Test-IsMobileCPUName([string]$cpuName) {
    if (-not $cpuName) { return $false }
    if ($cpuName -match "Snapdragon X") { return $true }
    if ($cpuName -match "Ryzen AI") { return $true }
    if ($cpuName -match "\b(HX|HS|HK|H|U|P|G7|G4)\b") { return $true }
    if ($cpuName -match "Laptop|Mobile|Notebook") { return $true }
    if ($cpuName -match "i[3579]-\d{4,5}[A-Za-z]*U\b|i[3579]-\d{4,5}[A-Za-z]*H\b|i[3579]-\d{4,5}[A-Za-z]*P\b") { return $true }
    if ($cpuName -match "Ryzen\s*\d\s+\d{4}.*(U|H|HS|HX)\b") { return $true }
    return $false
}

function Test-IsLaptopGPUName([string]$gpuName) {
    if (-not $gpuName) { return $false }
    return ($gpuName -match "Laptop|Mobile|Max-Q|Notebook|\bMX\d")
}

function Get-CPUScore($cpuName) {
    # ── Matching exact Intel (ex: i9-13980HX) ──
    $cpuShort = ""
    if ($cpuName -match "(i[3579]-\d{4,5}[A-Za-z]{0,4}\d?)") {
        $cpuShort = $Matches[1]
    }

    [double]$score = $null
    if ($cpuShort -ne "" -and $script:cpuScoreTable.ContainsKey($cpuShort)) {
        $score = $script:cpuScoreTable[$cpuShort]
    }

    # ── Matching exact AMD Ryzen ──
    if ($null -eq $score -and $cpuName -match "(Ryzen\s*\d\s+\d{4}[A-Za-z]{0,3})") {
        $amdShort = $Matches[1] -replace '\s+',' '
        if ($script:cpuScoreTable.ContainsKey($amdShort)) {
            $score = $script:cpuScoreTable[$amdShort]
        }
    }

    # ── Fallback : ancien parcours foreach ──
    if ($null -eq $score) {
        foreach ($key in $script:cpuScoreTable.Keys) {
            if ($cpuName -match [regex]::Escape($key)) {
                $score = $script:cpuScoreTable[$key]
                break
            }
        }
    }

    if ($null -eq $score) { return $null }

    # Recalibrage doux mobile vs desktop
    if (Test-IsMobileCPUName $cpuName) {
        $score = [math]::Round($score * 0.95, 1)
        if ($score -gt 9.4) { $score = 9.4 }
    }

    return $score
}

function Get-GPUGamingScore($gpuName) {
    # Trier les cles du plus long au plus court pour matcher "RTX 4090 Mobile" AVANT "RTX 4090"
    $sortedKeys = $script:gpuGamingScores.Keys | Sort-Object { $_.Length } -Descending

    foreach ($key in $sortedKeys) {
        if ($gpuName -match [regex]::Escape($key)) {
            return $script:gpuGamingScores[$key]
        }
    }

    # Fallback iGPU generique
    if ($gpuName -match "Iris Xe")                { return 2.0 }
    if ($gpuName -match "Iris Plus")              { return 1.5 }
    if ($gpuName -match "UHD")                    { return 1.0 }
    if ($gpuName -match "Vega")                   { return 1.5 }
    if ($gpuName -match "Radeon.*[6-9][0-9]0M")   { return 3.0 }
    return 1.0
}
function Get-RAMType($smbiosType, $speed) {
    switch ($smbiosType) {
        20 { return "DDR"        }
        21 { return "DDR2"       }
        22 { return "DDR2"       }
        24 { return "DDR3"       }
        26 { return "DDR4"       }
        27 { return "LPDDR"      }
        28 { return "LPDDR2"     }
        29 { return "LPDDR3"     }
        30 { return "LPDDR4/4x"  }
        34 { return "DDR5"       }
        35 { return "LPDDR5"     }
        default {
            if ($speed -ge 5200) { return "DDR5/LPDDR5"   }
            if ($speed -ge 3200) { return "DDR4/LPDDR4x"  }
            if ($speed -ge 1600) { return "DDR3/DDR4"      }
            return "Inconnu"
        }
    }
}

# ── Secure Boot (3 methodes) ──
function Get-SecureBootStatus {
    try {
        $sb = Confirm-SecureBootUEFI -ErrorAction Stop
        if ($sb -eq $true)  { return "Active"   }
        if ($sb -eq $false) { return "Desactive" }
    } catch {}

    try {
        $regVal = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State" `
                                   -Name "UEFISecureBootEnabled" -ErrorAction Stop
        if ($regVal.UEFISecureBootEnabled -eq 1) { return "Active" }
        else { return "Desactive" }
    } catch {}

    try {
        $fw = Get-CimInstance -Namespace "root\cimv2\Security\MicrosoftTpm" `
                              -ClassName Win32_Tpm -ErrorAction SilentlyContinue
        if ($null -ne $fw) { return "Supporte (verification partielle)" }
    } catch {}

    return "Non determine"
}

# ── TPM (3 methodes) ──
function Get-TPMStatus {
    try {
        $tpm = Get-CimInstance -Namespace "root\cimv2\Security\MicrosoftTpm" `
                               -ClassName Win32_Tpm -ErrorAction Stop
        if ($tpm) {
            $ver = $tpm.SpecVersion
            if ($ver) {
                $mainVer = ($ver -split ",")[0].Trim()
                return "TPM $mainVer (Active)"
            }
            return "TPM detecte (Active)"
        }
    } catch {}

    try {
        $tpmReg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\TPM" -ErrorAction Stop
        if ($tpmReg) { return "TPM present (service detecte)" }
    } catch {}

    try {
        $tpmWmi = Get-CimInstance -ClassName Win32_TPM -Namespace "root\cimv2\Security\MicrosoftTpm" `
                                  -ErrorAction SilentlyContinue
        if ($tpmWmi.IsEnabled_InitialValue) { return "TPM Active (WMI)" }
    } catch {}

    return "Non detecte"
}

# ── Antivirus ──
function Get-AntivirusName {
    try {
        $avList = Get-CimInstance -Namespace "root\SecurityCenter2" `
                                  -ClassName AntiVirusProduct -ErrorAction Stop
        $names = ($avList | ForEach-Object { $_.displayName }) -join ", "
        if ($names) { return $names }
    } catch {}
    return "Non detecte"
}

function Get-GPUDriverInfo {
    $info = @{
        Name    = "Inconnu"
        Version = "Inconnue"
        Date    = "Inconnue"
    }

    try {
        $gpu = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue |
               Where-Object { $_.Name -and $_.Name -notmatch "Microsoft Basic|Remote" } |
               Select-Object -First 1
        if (-not $gpu) {
            $gpu = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue | Select-Object -First 1
        }
        if ($gpu) {
            if ($gpu.Name) { $info.Name = $gpu.Name.Trim() }
            if ($gpu.DriverVersion) { $info.Version = $gpu.DriverVersion }
            if ($gpu.DriverDate) {
                try {
                    $dt = [Management.ManagementDateTimeConverter]::ToDateTime($gpu.DriverDate)
                    $info.Date = $dt.ToString("yyyy-MM-dd")
                } catch {
                    $info.Date = "$($gpu.DriverDate)"
                }
            }
        }
    } catch {}

    return $info
}

function Get-SystemDiskInfo {
    $result = @{
        Summary = "Inconnu"
        Alert   = ""
    }

    try {
        $systemDrive = if ($env:SystemDrive) { $env:SystemDrive } else { "C:" }
        $disk = Get-CimInstance Win32_LogicalDisk -Filter ("DeviceID='{0}'" -f $systemDrive) -ErrorAction SilentlyContinue
        if ($disk -and $disk.Size -gt 0) {
            $sizeGB = [math]::Round($disk.Size / 1GB)
            $freeGB = [math]::Round($disk.FreeSpace / 1GB)
            $freePct = [math]::Round(($disk.FreeSpace / $disk.Size) * 100)
            $result.Summary = "{0} libres / {1} Go ({2}%)" -f "$freeGB Go", $sizeGB, $freePct

            if ($freePct -le 10) {
                $result.Alert = "Espace critique (<=10%)"
            } elseif ($freePct -le 15) {
                $result.Alert = "Espace faible (<=15%)"
            }
        }
    } catch {}

    return $result
}

function Get-PowerInfo {
    $schemeName = "Inconnu"
    try {
        $activeScheme = (powercfg /GETACTIVESCHEME 2>$null | Out-String).Trim()
        if ($activeScheme -match "\((.+)\)") {
            $schemeName = $Matches[1].Trim()
        }
    } catch {}

    $source = "Etat secteur/batterie inconnu"
    try {
        $bat = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($bat) {
            $charge = if ($null -ne $bat.EstimatedChargeRemaining) { "$($bat.EstimatedChargeRemaining)%" } else { "N/A" }
            $status = [int]$bat.BatteryStatus
            $onAC = ($status -in 2,3,6,7,8,9,11)
            if ($onAC) {
                $source = "Secteur (batterie $charge)"
            } else {
                $source = "Batterie ($charge)"
            }
        } else {
            $source = "Secteur (pas de batterie detectee)"
        }
    } catch {}

    return "$schemeName | $source"
}
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="CheckMyPower v1.1" Width="920" Height="780"
        MinHeight="500" MaxHeight="1080"
        WindowStartupLocation="CenterScreen" ResizeMode="CanResizeWithGrip"
        Background="#0A0E17">
    <Window.Resources>
        <Style x:Key="NeonBtn" TargetType="Button">
            <Setter Property="FontSize"   Value="13"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding"    Value="18,10"/>
            <Setter Property="Cursor"     Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="8"
                                Padding="{TemplateBinding Padding}"
                                BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="2">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <ScrollViewer VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
        <StackPanel Margin="30,20,30,20">

            <!-- TITRE -->
            <TextBlock Text="CheckMyPower" FontSize="42" FontWeight="Bold"
                       Foreground="#00FFFF" HorizontalAlignment="Center" FontFamily="Segoe UI">
                <TextBlock.Effect>
                    <DropShadowEffect BlurRadius="20" ShadowDepth="0" Color="#00FFFF" Opacity="0.7"/>
                </TextBlock.Effect>
            </TextBlock>
            <TextBlock Text="v1.1 by Nicleox &#x2014; Analyse hardware complete selon les normes Q1 2026" FontSize="13"
                       Foreground="#556677" HorizontalAlignment="Center" Margin="0,0,0,15"/>

            <!-- SCORE GLOBAL -->
            <Border Background="#10182B" CornerRadius="14" Padding="20,15" Margin="0,0,0,12"
                    BorderBrush="#00FFFF" BorderThickness="2">
                <StackPanel>
                    <TextBlock Text="&#x26A1; SCORE GLOBAL" FontSize="16" FontWeight="Bold"
                               Foreground="#00FFFF" HorizontalAlignment="Center"
                               FontFamily="Segoe UI Emoji"/>
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,8,0,4">
                        <TextBlock x:Name="txtScoreGlobal" FontSize="38" FontWeight="Bold"
                                   Foreground="#00FF88"/>
                        <TextBlock Text=" / 10" FontSize="20" Foreground="#556677"
                                   VerticalAlignment="Bottom" Margin="0,0,0,5"/>
                    </StackPanel>
                    <TextBlock x:Name="txtGlobalVerdict" FontSize="14" FontWeight="Bold"
                               HorizontalAlignment="Center" Margin="0,0,0,6"/>
                    <Border Background="#0D1520" CornerRadius="6" Height="14" Width="300"
                            HorizontalAlignment="Center">
                        <Rectangle x:Name="barGlobalFill" Height="14" HorizontalAlignment="Left"
                                   RadiusX="6" RadiusY="6" Fill="#00FFFF" Width="0"/>
                    </Border>
                </StackPanel>
            </Border>

            <!-- SYSTEME -->
            <Border Background="#10182B" CornerRadius="12" Padding="18,12" Margin="0,0,0,10"
                    BorderBrush="#1E90FF" BorderThickness="1.5">
                <StackPanel>
                    <TextBlock Text="&#x1F5A5; SYSTEME" FontSize="15" FontWeight="Bold"
                               Foreground="#1E90FF" Margin="0,0,0,6"
                               FontFamily="Segoe UI Emoji"/>
                    <TextBlock x:Name="txtSystem" FontSize="12" Foreground="#CCDDEE"
                               TextWrapping="Wrap" FontFamily="Consolas"/>
                </StackPanel>
            </Border>

            <!-- CPU -->
            <Border Background="#10182B" CornerRadius="12" Padding="18,12" Margin="0,0,0,10"
                    BorderBrush="#FF6A00" BorderThickness="1.5">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="120"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="0">
                        <TextBlock Text="&#x2699; PROCESSEUR (CPU)" FontSize="15" FontWeight="Bold"
                                   Foreground="#FF6A00" Margin="0,0,0,6"
                                   FontFamily="Segoe UI Emoji"/>
                        <TextBlock x:Name="txtCPU" FontSize="12" Foreground="#CCDDEE"
                                   TextWrapping="Wrap" FontFamily="Consolas"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" VerticalAlignment="Center" HorizontalAlignment="Center">
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                            <TextBlock x:Name="txtCPUScore" FontSize="28" FontWeight="Bold"/>
                            <TextBlock Text="/10" FontSize="13" Foreground="#556677"
                                       VerticalAlignment="Bottom" Margin="2,0,0,3"/>
                        </StackPanel>
                        <Border Background="#0D1520" CornerRadius="5" Height="10" Width="100"
                                Margin="0,4,0,4">
                            <Rectangle x:Name="barCPUFill" Height="10" HorizontalAlignment="Left"
                                       RadiusX="5" RadiusY="5" Width="0"/>
                        </Border>
                        <TextBlock x:Name="txtCPUVerdict" FontSize="12" FontWeight="Bold"
                                   HorizontalAlignment="Center"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- RAM -->
            <Border Background="#10182B" CornerRadius="12" Padding="18,12" Margin="0,0,0,10"
                    BorderBrush="#FF00FF" BorderThickness="1.5">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="120"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="0">
                        <TextBlock Text="&#x1F9E9; MEMOIRE (RAM)" FontSize="15" FontWeight="Bold"
                                   Foreground="#FF00FF" Margin="0,0,0,6"
                                   FontFamily="Segoe UI Emoji"/>
                        <TextBlock x:Name="txtRAM" FontSize="12" Foreground="#CCDDEE"
                                   TextWrapping="Wrap" FontFamily="Consolas"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" VerticalAlignment="Center" HorizontalAlignment="Center">
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                            <TextBlock x:Name="txtRAMScore" FontSize="28" FontWeight="Bold"/>
                            <TextBlock Text="/10" FontSize="13" Foreground="#556677"
                                       VerticalAlignment="Bottom" Margin="2,0,0,3"/>
                        </StackPanel>
                        <Border Background="#0D1520" CornerRadius="5" Height="10" Width="100"
                                Margin="0,4,0,4">
                            <Rectangle x:Name="barRAMFill" Height="10" HorizontalAlignment="Left"
                                       RadiusX="5" RadiusY="5" Width="0"/>
                        </Border>
                        <TextBlock x:Name="txtRAMVerdict" FontSize="12" FontWeight="Bold"
                                   HorizontalAlignment="Center"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- GPU GENERAL -->
            <Border Background="#10182B" CornerRadius="12" Padding="18,12" Margin="0,0,0,10"
                    BorderBrush="#00AAFF" BorderThickness="1.5">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="120"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="0">
                        <TextBlock Text="&#x1F3A8; GPU (General)" FontSize="15" FontWeight="Bold"
                                   Foreground="#00AAFF" Margin="0,0,0,6"
                                   FontFamily="Segoe UI Emoji"/>
                        <TextBlock x:Name="txtGPU" FontSize="12" Foreground="#CCDDEE"
                                   TextWrapping="Wrap" FontFamily="Consolas"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" VerticalAlignment="Center" HorizontalAlignment="Center">
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                            <TextBlock x:Name="txtGPUScore" FontSize="28" FontWeight="Bold"/>
                            <TextBlock Text="/10" FontSize="13" Foreground="#556677"
                                       VerticalAlignment="Bottom" Margin="2,0,0,3"/>
                        </StackPanel>
                        <Border Background="#0D1520" CornerRadius="5" Height="10" Width="100"
                                Margin="0,4,0,4">
                            <Rectangle x:Name="barGPUFill" Height="10" HorizontalAlignment="Left"
                                       RadiusX="5" RadiusY="5" Width="0"/>
                        </Border>
                        <TextBlock x:Name="txtGPUVerdict" FontSize="12" FontWeight="Bold"
                                   HorizontalAlignment="Center"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- GPU GAMING -->
            <Border Background="#10182B" CornerRadius="12" Padding="18,12" Margin="0,0,0,10"
                    BorderBrush="#FF4444" BorderThickness="1.5">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="120"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="0">
                        <TextBlock Text="&#x1F3AE; GPU GAMING" FontSize="15" FontWeight="Bold"
                                   Foreground="#FF4444" Margin="0,0,0,6"
                                   FontFamily="Segoe UI Emoji"/>
                        <TextBlock x:Name="txtGPUGaming" FontSize="12" Foreground="#CCDDEE"
                                   TextWrapping="Wrap" FontFamily="Consolas"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" VerticalAlignment="Center" HorizontalAlignment="Center">
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                            <TextBlock x:Name="txtGPUGamingScore" FontSize="28" FontWeight="Bold"/>
                            <TextBlock Text="/10" FontSize="13" Foreground="#556677"
                                       VerticalAlignment="Bottom" Margin="2,0,0,3"/>
                        </StackPanel>
                        <Border Background="#0D1520" CornerRadius="5" Height="10" Width="100"
                                Margin="0,4,0,4">
                            <Rectangle x:Name="barGPUGamingFill" Height="10" HorizontalAlignment="Left"
                                       RadiusX="5" RadiusY="5" Width="0"/>
                        </Border>
                        <TextBlock x:Name="txtGPUGamingVerdict" FontSize="12" FontWeight="Bold"
                                   HorizontalAlignment="Center"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- DISQUES -->
            <Border Background="#10182B" CornerRadius="12" Padding="18,12" Margin="0,0,0,10"
                    BorderBrush="#00FF88" BorderThickness="1.5">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="120"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="0">
                        <TextBlock Text="&#x1F4BE; STOCKAGE" FontSize="15" FontWeight="Bold"
                                   Foreground="#00FF88" Margin="0,0,0,6"
                                   FontFamily="Segoe UI Emoji"/>
                        <TextBlock x:Name="txtDisk" FontSize="12" Foreground="#CCDDEE"
                                   TextWrapping="Wrap" FontFamily="Consolas"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" VerticalAlignment="Center" HorizontalAlignment="Center">
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                            <TextBlock x:Name="txtDiskScore" FontSize="28" FontWeight="Bold"/>
                            <TextBlock Text="/10" FontSize="13" Foreground="#556677"
                                       VerticalAlignment="Bottom" Margin="2,0,0,3"/>
                        </StackPanel>
                        <Border Background="#0D1520" CornerRadius="5" Height="10" Width="100"
                                Margin="0,4,0,4">
                            <Rectangle x:Name="barDiskFill" Height="10" HorizontalAlignment="Left"
                                       RadiusX="5" RadiusY="5" Width="0"/>
                        </Border>
                        <TextBlock x:Name="txtDiskVerdict" FontSize="12" FontWeight="Bold"
                                   HorizontalAlignment="Center"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- S.M.A.R.T -->
            <Border Background="#10182B" CornerRadius="12" Padding="18,12" Margin="0,0,0,10"
                    BorderBrush="#FFD700" BorderThickness="1.5">
                <StackPanel>
                    <TextBlock Text="&#x1F6E1; S.M.A.R.T &#x2014; Sante des disques" FontSize="15"
                               FontWeight="Bold" Foreground="#FFD700" Margin="0,0,0,6"
                               FontFamily="Segoe UI Emoji"/>
                    <TextBlock x:Name="txtSMART" FontSize="12" Foreground="#CCDDEE"
                               TextWrapping="Wrap" FontFamily="Consolas"/>
                </StackPanel>
            </Border>

            <!-- BOUTONS -->
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,15,0,8">
                <Button x:Name="btnRefresh" Content="&#x1F504; Rafraichir" Style="{StaticResource NeonBtn}"
                        Background="#0D1520" BorderBrush="#00FFFF" Margin="6,0"
                        FontFamily="Segoe UI Emoji"/>
                <Button x:Name="btnCopy" Content="&#x1F4CB; Copier" Style="{StaticResource NeonBtn}"
                        Background="#0D1520" BorderBrush="#FF00FF" Margin="6,0"
                        FontFamily="Segoe UI Emoji"/>
                <Button x:Name="btnExport" Content="&#x1F4BE; Exporter" Style="{StaticResource NeonBtn}"
                        Background="#0D1520" BorderBrush="#00FF88" Margin="6,0"
                        FontFamily="Segoe UI Emoji"/>
                <Button x:Name="btnCoffee" Content="&#x2615; Offrir un cafe" Style="{StaticResource NeonBtn}"
                        Background="#0D1520" BorderBrush="#FFD700" Margin="6,0"
                        FontFamily="Segoe UI Emoji"/>
            </StackPanel>

            <!-- STATUT -->
            <TextBlock x:Name="txtStatus" FontSize="12" Foreground="#556677"
                       HorizontalAlignment="Center" Margin="0,5,0,5"/>

            <!-- CREDITS -->
            <TextBlock FontSize="11" Foreground="#334455" HorizontalAlignment="Center" Margin="0,10,0,0"
                       Text="CheckMyPower v1.1 &#x2014; Cree par Nicleox &#x2014; nicleox@cityx.link"/>
        </StackPanel>
    </ScrollViewer>
</Window>
"@
# ============================================================
#  CREATION DE LA FENETRE
# ============================================================

$reader = [System.Xml.XmlNodeReader]::new($xaml)
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# ── Recuperation des controles ──
$txtScoreGlobal      = $window.FindName("txtScoreGlobal")
$txtGlobalVerdict    = $window.FindName("txtGlobalVerdict")
$barGlobalFill       = $window.FindName("barGlobalFill")
$txtSystem           = $window.FindName("txtSystem")
$txtCPU              = $window.FindName("txtCPU")
$txtCPUScore         = $window.FindName("txtCPUScore")
$txtCPUVerdict       = $window.FindName("txtCPUVerdict")
$barCPUFill          = $window.FindName("barCPUFill")
$txtRAM              = $window.FindName("txtRAM")
$txtRAMScore         = $window.FindName("txtRAMScore")
$txtRAMVerdict       = $window.FindName("txtRAMVerdict")
$barRAMFill          = $window.FindName("barRAMFill")
$txtGPU              = $window.FindName("txtGPU")
$txtGPUScore         = $window.FindName("txtGPUScore")
$txtGPUVerdict       = $window.FindName("txtGPUVerdict")
$barGPUFill          = $window.FindName("barGPUFill")
$txtGPUGaming        = $window.FindName("txtGPUGaming")
$txtGPUGamingScore   = $window.FindName("txtGPUGamingScore")
$txtGPUGamingVerdict = $window.FindName("txtGPUGamingVerdict")
$barGPUGamingFill    = $window.FindName("barGPUGamingFill")
$txtDisk             = $window.FindName("txtDisk")
$txtDiskScore        = $window.FindName("txtDiskScore")
$txtDiskVerdict      = $window.FindName("txtDiskVerdict")
$barDiskFill         = $window.FindName("barDiskFill")
$txtSMART            = $window.FindName("txtSMART")
$btnRefresh          = $window.FindName("btnRefresh")
$btnCopy             = $window.FindName("btnCopy")
$btnExport           = $window.FindName("btnExport")
$btnCoffee           = $window.FindName("btnCoffee")
$txtStatus           = $window.FindName("txtStatus")

# ── Helpers UI ──
$brushConv = [System.Windows.Media.BrushConverter]::new()

function Set-ScoreUI($scoreTB, $verdictTB, $barRect, $score, $max, $defaultBarColor) {
    [double]$s = [double]$score
    $color = Get-ScoreColor $s
    $v     = Get-Verdict $s
    $scoreTB.Text       = "$s"
    $scoreTB.Foreground = $brushConv.ConvertFromString($color)
    $verdictTB.Text       = $v.Text
    $verdictTB.Foreground = $brushConv.ConvertFromString($v.Color)
    [double]$pct   = [math]::Min($s / [double]$max, 1.0)
    $barRect.Width = $pct * 100
    $barRect.Fill  = $brushConv.ConvertFromString($color)
}

function Set-Status($msg, $color) {
    $txtStatus.Text       = $msg
    $txtStatus.Foreground = $brushConv.ConvertFromString($color)
    # Met a jour aussi le splash s'il est encore ouvert
    if ($splash -and $splash.IsVisible) {
        $splashTxt.Text = $msg
        $splash.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)
    }
    $window.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)
}
# ============================================================
#  LOGIQUE PRINCIPALE
# ============================================================

function Invoke-Refresh {
    Set-Status "Analyse du systeme..." "#FFD700"

    $report  = "============================================`n"
    $report += "  CheckMyPower v1.1 — Rapport`n"
    $report += "  Date : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"
    $report += "============================================`n`n"

    # ── SYSTEME ──
    $os   = Get-CimInstance Win32_OperatingSystem
    $cs   = Get-CimInstance Win32_ComputerSystem
    $bios = Get-CimInstance Win32_BIOS

    $osName      = $os.Caption
    $arch        = $os.OSArchitecture
    $build       = $os.BuildNumber
    $installDate = try { $os.InstallDate.ToString("yyyy-MM-dd") } catch { "Inconnu" }

    $pcModel  = "$($cs.Manufacturer) $($cs.Model)".Trim()
    $biosInfo = "$($bios.Manufacturer) $($bios.SMBIOSBIOSVersion)"

    $secureBoot = Get-SecureBootStatus
    $tpmStatus  = Get-TPMStatus
    $avName     = Get-AntivirusName
    $gpuDriver  = Get-GPUDriverInfo
    $sysDisk    = Get-SystemDiskInfo
    $powerInfo  = Get-PowerInfo

    # Activation Windows
    $activation = "Inconnu"
    try {
        $license = Get-CimInstance SoftwareLicensingProduct -ErrorAction Stop |
                   Where-Object { $_.PartialProductKey -and $_.LicenseStatus -eq 1 } |
                   Select-Object -First 1
        $activation = if ($license) { "Active" } else { "Non active" }
    } catch {}

    # Langue & Uptime
    $lang      = (Get-Culture).Name
    $uptime    = (Get-Date) - $os.LastBootUpTime
    $uptimeStr = "{0}j {1}h {2}min" -f $uptime.Days, $uptime.Hours, $uptime.Minutes
    $pcName    = $env:COMPUTERNAME
    $userName  = $env:USERNAME

    # Carte mere
    $mb     = Get-CimInstance Win32_BaseBoard -ErrorAction SilentlyContinue
    $mbInfo = if ($mb) { "$($mb.Manufacturer) $($mb.Product)" } else { "Inconnu" }
    $showMB = $true
    if ($mbInfo -match "Surface|Notebook|Laptop|Portable|Book" -or
        $mbInfo -eq "$($cs.Manufacturer) $($cs.Model)") {
        $showMB = $false
    }

    $sysText  = "  PC         : $pcModel`n"
    $sysText += "  BIOS       : $biosInfo`n"
    if ($showMB) { $sysText += "  Carte mere : $mbInfo`n" }
    $sysText += "  OS         : $osName ($arch) Build $build`n"
    $sysText += "  Install    : $installDate`n"
    $sysText += "  Activation : $activation`n"
    $sysText += "  Secure Boot: $secureBoot`n"
    $sysText += "  TPM        : $tpmStatus`n"
    $sysText += "  Antivirus  : $avName`n"
    $sysText += "  Pilote GPU : $($gpuDriver.Name) | v$($gpuDriver.Version) | $($gpuDriver.Date)`n"
    $sysText += "  Disque sys : $($sysDisk.Summary)`n"
    if ($sysDisk.Alert) { $sysText += "  Alerte disque: $($sysDisk.Alert)`n" }
    $sysText += "  Energie    : $powerInfo`n"
    $sysText += "  Langue     : $lang`n"
    $sysText += "  Uptime     : $uptimeStr`n"
    $sysText += "  Utilisateur: $userName@$pcName"

    $txtSystem.Text = $sysText
    $report += "[ SYSTEME ]`n$sysText`n`n"

    # ── CPU ──
    Set-Status "Analyse du processeur..." "#FFD700"

    $cpu     = Get-CimInstance Win32_Processor | Select-Object -First 1
    $cpuName = $cpu.Name.Trim()
    $cores   = $cpu.NumberOfCores
    $threads = $cpu.NumberOfLogicalProcessors
    $baseGHz = [math]::Round($cpu.MaxClockSpeed / 1000, 2)

    $boostGHz     = Get-CPUBoost $cpuName
    $cpuShort     = ""
    if ($cpuName -match "(i[3579]-\d{4,5}[A-Za-z]{0,4}\d?)") {
        $cpuShort = $Matches[1]
    }
    if (-not $cpuShort -and $cpuName -match "(Ryzen\s*\d\s+\d{4}[A-Za-z]{0,3})") {
        $cpuShort = $Matches[1] -replace '\s+',' '
    }
    $knownInTable = ($cpuShort -ne "" -and $script:cpuBoostTable.ContainsKey($cpuShort))

    if ($boostGHz) {
        $boostStr = if ($knownInTable) { "$boostGHz GHz" }
                    else { "$boostGHz GHz (detecte)" }
    } else {
        $boostStr = "N/A"
    }

    $knownScore = Get-CPUScore $cpuName

    $cpuInfo  = "  $cpuName`n"
    $cpuInfo += "  Coeurs: $cores  |  Threads: $threads`n"
    $cpuInfo += "  Base: $baseGHz GHz  |  Boost: $boostStr"

    # Score CPU
    [double]$cpuScore = 5.0
    if ($knownScore) {
        $cpuScore = $knownScore
    } else {
        $cpuScore = [math]::Min(10, [math]::Round(($cores * 0.4) + ($threads * 0.15) + ($baseGHz * 0.8), 1))
    }

    # Bonus CPU mobile haut de gamme (i7/i9 11e-12e gen)
    if ($cpuName -match 'i[79].*1[12]\d{2}') { $cpuScore = [Math]::Max($cpuScore, 6.0) }

    $txtCPU.Text = $cpuInfo
    Set-ScoreUI $txtCPUScore $txtCPUVerdict $barCPUFill $cpuScore 10 "#FF6A00"
    $cpuV    = Get-Verdict $cpuScore
    $report += "[ CPU ] Score: $cpuScore/10 ($($cpuV.Text))`n$cpuInfo`n`n"

    # ── RAM ──
    Set-Status "Analyse de la memoire RAM..." "#FFD700"

    $ramModules = @(Get-CimInstance Win32_PhysicalMemory)
    $nbSticks   = $ramModules.Count
    $totalRAM   = [math]::Round(($ramModules | Measure-Object -Property Capacity -Sum).Sum / 1GB)

    $ramInfo = "  Total : $totalRAM Go`n"

    $groups = $ramModules | Group-Object {
        $cap = [math]::Round($_.Capacity / 1GB, 1)
        $spd = $_.Speed
        $mfr = if ($_.Manufacturer -and $_.Manufacturer.Trim() -ne "") { $_.Manufacturer.Trim() } else { "Inconnu" }
        "$cap|$spd|$mfr"
    }

    $slotIndex = 1
    foreach ($g in $groups) {
        $count  = $g.Count
        $sample = $g.Group[0]
        $capGB  = [math]::Round($sample.Capacity / 1GB, 1)
        $speed  = $sample.Speed
        $smbType = $sample.SMBIOSMemoryType
        $ramType = Get-RAMType $smbType $speed
        $mfr    = if ($sample.Manufacturer -and $sample.Manufacturer.Trim() -ne "") {
                      $sample.Manufacturer.Trim()
                  } else { "Inconnu" }

        if ($count -gt 2) {
            $ramInfo += "  ${count}x ${capGB} Go  |  $ramType  |  $speed MHz  |  $mfr  (soudee)`n"
        }
        elseif ($count -eq 2) {
            $ramInfo += "  Slot $slotIndex : $capGB Go  |  $ramType  |  $speed MHz  |  $mfr`n"
            $slotIndex++
            $ramInfo += "  Slot $slotIndex : $capGB Go  |  $ramType  |  $speed MHz  |  $mfr`n"
            $slotIndex++
        }
        else {
            $ramInfo += "  Slot $slotIndex : $capGB Go  |  $ramType  |  $speed MHz  |  $mfr`n"
            $slotIndex++
        }
    }

    if ($nbSticks -gt 4) {
        $channelStr = "Multi-Channel (memoire soudee)"
    } elseif ($nbSticks -ge 2) {
        $channelStr = "Dual Channel (detecte)"
    } else {
        $channelStr = "Single Channel"
    }

    $ramInfo += "  Mode : $channelStr"

    # ── Score RAM ──
    [double]$ramScore = 2.0

    # 1) Base selon capacite
    if     ($totalRAM -ge 128) { $ramScore = 9.0 }
    elseif ($totalRAM -ge 64)  { $ramScore = 8.0 }
    elseif ($totalRAM -ge 32)  { $ramScore = 7.0 }
    elseif ($totalRAM -ge 24)  { $ramScore = 6.5 }
    elseif ($totalRAM -ge 16)  { $ramScore = 5.5 }
    elseif ($totalRAM -ge 12)  { $ramScore = 4.5 }
    elseif ($totalRAM -ge 8)   { $ramScore = 3.5 }
    elseif ($totalRAM -ge 4)   { $ramScore = 2.5 }

    # 2) Bonus vitesse
    $maxSpeed = ($ramModules | Measure-Object -Property Speed -Maximum).Maximum
    if     ($maxSpeed -ge 6400) { $ramScore += 1.0 }
    elseif ($maxSpeed -ge 5600) { $ramScore += 0.8 }
    elseif ($maxSpeed -ge 4800) { $ramScore += 0.6 }
    elseif ($maxSpeed -ge 3600) { $ramScore += 0.4 }
    elseif ($maxSpeed -ge 3200) { $ramScore += 0.3 }
    elseif ($maxSpeed -ge 2666) { $ramScore += 0.1 }

    # 3) Bonus Dual Channel
    if ($ramModules.Count -ge 2) { $ramScore += 0.3 }

    # 4) Plafond
    $ramScore = [math]::Min([math]::Round($ramScore, 1), 10.0)

    $txtRAM.Text = $ramInfo
    Set-ScoreUI $txtRAMScore $txtRAMVerdict $barRAMFill $ramScore 10 "#FF00FF"
    $ramV    = Get-Verdict $ramScore
    $report += "[ RAM ] Score: $ramScore/10 ($($ramV.Text))`n$ramInfo`n`n"

    # ── GPU GAMING ──

    Set-Status "Evaluation des performances gaming..." "#FFD700"

    $gpus    = @(Get-CimInstance Win32_VideoController)
    $mainGPU = $gpus | Where-Object { $_.Name -notmatch "Microsoft Basic|Remote" } | Select-Object -First 1
    if (-not $mainGPU) { $mainGPU = $gpus | Select-Object -First 1 }
    $gpuName = if ($mainGPU) { $mainGPU.Name.Trim() } else { "Inconnu" }

    $vramMB  = Get-VRAM
    $vramGB  = [math]::Round($vramMB / 1024, 1)
    $vramStr = if ($vramGB -ge 1) { "$vramGB Go" } else { "$vramMB Mo" }

    [double]$gamingScore = Get-GPUGamingScore $gpuName

    $isLaptopGPU = Test-IsLaptopGPUName $gpuName
    $gamingScore = [math]::Round([math]::Min(10, $gamingScore), 1)

    $gamingAdvice = if     ($gamingScore -ge 9) { "4K Ultra 60+ FPS — Haut de gamme absolu" }
                   elseif ($gamingScore -ge 7) { "1440p High/Ultra 60+ FPS — Excellent" }
                   elseif ($gamingScore -ge 5) { "1080p Medium/High 60 FPS — Correct" }
                   elseif ($gamingScore -ge 3) { "1080p Low/Medium — Jeux legers" }
                   else                        { "Jeux tres legers / iGPU" }

    $laptopNote = if ($isLaptopGPU) { " (variante Laptop — TDP reduit)" } else { "" }

    $gamingInfo  = "  $gpuName$laptopNote`n"
    $gamingInfo += "  Score Gaming : $gamingScore / 10`n"
    $gamingInfo += "  $gamingAdvice"

    $txtGPUGaming.Text = $gamingInfo
    Set-ScoreUI $txtGPUGamingScore $txtGPUGamingVerdict $barGPUGamingFill $gamingScore 10 "#FF4444"
    $gamV    = Get-Verdict $gamingScore
    $report += "[ GPU Gaming ] Score: $gamingScore/10 ($($gamV.Text))`n$gamingInfo`n`n"

    # ── GPU GENERAL (maintenant $gamingScore existe) ──
    Set-Status "Analyse de la carte graphique..." "#FFD700"

    $gpuInfo = "  $gpuName`n  VRAM : $vramStr"

    [double]$gpuGenScore = 1.0
    if     ($vramMB -ge 16000) { $gpuGenScore = 10.0 }
    elseif ($vramMB -ge 12000) { $gpuGenScore = 9.0  }
    elseif ($vramMB -ge 8000)  { $gpuGenScore = 7.5  }
    elseif ($vramMB -ge 6000)  { $gpuGenScore = 6.0  }
    elseif ($vramMB -ge 4000)  { $gpuGenScore = 5.0  }
    elseif ($vramMB -ge 2000)  { $gpuGenScore = 4.0  }
    elseif ($vramMB -ge 1000)  { $gpuGenScore = 3.0  }
    else                       { $gpuGenScore = 2.0  }

    # Ajustement par le score gaming
    $gamingAsGeneral = [math]::Round($gamingScore * 0.85 + 1.5, 1)
    $gpuGenScore = [math]::Max($gpuGenScore, [math]::Min(10.0, $gamingAsGeneral))

    if ($gpuName -match "RTX|GTX|RX [0-9]|Arc A[0-9]") {
        $gpuGenScore = [math]::Min($gpuGenScore + 1.0, 10.0)
    }

    $gpuGenScore = [math]::Round($gpuGenScore, 1)
    $txtGPU.Text = $gpuInfo
    Set-ScoreUI $txtGPUScore $txtGPUVerdict $barGPUFill $gpuGenScore 10 "#00AAFF"
    $gpuV    = Get-Verdict $gpuGenScore
    $report += "[ GPU General ] Score: $gpuGenScore/10 ($($gpuV.Text))`n$gpuInfo`n`n"

    # ── DISQUES ──
    Set-Status "Analyse des disques..." "#FFD700"

    $disks         = @(Get-PhysicalDisk)
    $diskLines     = ""
    $bestDiskScore = 0

    foreach ($d in $disks) {
        $model  = if ($d.FriendlyName) { $d.FriendlyName.Trim() } else { "Inconnu" }
        $sizeGB = [math]::Round($d.Size / 1GB)
        $bus    = "$($d.BusType)"
        $media  = "$($d.MediaType)"
        $looksNvmeModel = $model -match 'NVMe|NVME|\bSN\d{3,4}\b|SDBP|SDCPN|PM9A1|MZVL|MZVLB|MZAL|KXG|BG\d|PC SN|P[35]\s*Plus|980\s*PRO|990\s*PRO|970\s*EVO'

        # ── Detection intelligente du type de disque ──
        $typeStr  = "HDD"
        $isRAIDBus = ($bus -eq "RAID")
        # Beaucoup de machines (RST/VMD) remontent "RAID" sans volume RAID reel.
        $isLikelyRealRaid = $isRAIDBus -and ($model -match "RAID|Array|Virtual Disk|Volume|Intel.*RST|VROC|PERC|MegaRAID|Adaptec|LSI|HPE")
        $isRAID   = $isLikelyRealRaid
        $raidNote = ""

        # NVMe explicite
        if ($bus -eq "NVMe" -or $model -match "NVMe|NVME|nvme") {
            $typeStr = "SSD NVMe"
        }
        # RAID : detection avancee
        elseif ($isRAIDBus) {
            $raidNote = " (RAID)"
            if ($media -match "SSD" -or $model -match "SSD|NVMe|NVME|Samsung|WD_BLACK.*SN|Sabrent|Corsair.*MP|Firecuda.*5[2-3]0|980 PRO|990 PRO|P[3-5]|T[5-7]00|A[2-4]000|SN[5-8][5-9]0|Hynix|SK hynix|KIOXIA|Solidigm|Kingston.*NV|Crucial.*T[5-7]00|Intel.*P41|Phison") {
                if ($looksNvmeModel -or $model -match "SN[5-8][5-9]0|980 PRO|990 PRO|P[3-5]|Firecuda|MP[5-7]00|T[5-7]00|A[2-4]000|Hynix|KIOXIA|Solidigm|P41|Phison") {
                    $typeStr = "SSD NVMe"
                } else {
                    $typeStr = "SSD SATA"
                }
            }
            elseif ($media -match "Unspecified|Unknown" -or [string]::IsNullOrEmpty($media)) {
                # En RAID avec media inconnu, on reste prudent pour eviter les faux positifs NVMe.
                if ($model -match "Barracuda|WD Blue.*TB|Toshiba.*DT|Seagate.*Desktop|Ironwolf|WD Red|HGST|Hitachi") {
                    $typeStr = "HDD"
                }
                elseif ($looksNvmeModel -or $model -match "SN[5-8][5-9]0|980 PRO|990 PRO|P[3-5]|Firecuda|MP[5-7]00|T[5-7]00|A[2-4]000|Hynix|KIOXIA|Solidigm|P41|Phison") {
                    $typeStr = "SSD NVMe"
                }
                elseif ($model -match "SSD|Samsung|Crucial|Kingston|SanDisk|WD_BLACK|Intel") {
                    $typeStr = "SSD SATA"
                }
                else {
                    $typeStr = "Inconnu"
                }
            }
            else {
                $typeStr = "SSD SATA"
            }
            if (-not $isLikelyRealRaid) {
                $raidNote = ""
                if ($looksNvmeModel) {
                    $typeStr = "SSD NVMe"
                }
            }
        }
        # SSD SATA classique
        elseif ($media -match "SSD" -or ($bus -match "SATA" -and $media -notmatch "HDD")) {
            $typeStr = "SSD SATA"
        }
        # Media non specifie hors RAID
        elseif ($media -match "Unspecified" -and $bus -match "SATA") {
            if ($sizeGB -lt 4000 -and $model -notmatch "HDD|Barracuda|WD Blue.*TB|Toshiba.*DT|Seagate.*Desktop|Ironwolf|WD Red") {
                $typeStr = "SSD SATA"
            } else {
                $typeStr = "HDD"
            }
        }

        # Type affiche avec suffixe RAID
        $displayType = "$typeStr$raidNote"

        # ── Scoring disque ──
        $dScore = 1
        if ($typeStr -match "NVMe") {
            if     ($sizeGB -ge 2000) { $dScore = 10 }
            elseif ($sizeGB -ge 900)  { $dScore = 9  }
            elseif ($sizeGB -ge 450)  { $dScore = 8  }
            elseif ($sizeGB -ge 200)  { $dScore = 6  }
            else                      { $dScore = 5  }
            if ($isLikelyRealRaid -and $dScore -lt 10) { $dScore = [math]::Min(10, $dScore + 1) }
        }
        elseif ($typeStr -match "SSD") {
            if     ($sizeGB -ge 2000) { $dScore = 9 }
            elseif ($sizeGB -ge 900)  { $dScore = 8 }
            elseif ($sizeGB -ge 450)  { $dScore = 6 }
            elseif ($sizeGB -ge 200)  { $dScore = 5 }
            else                      { $dScore = 4 }
            if ($isLikelyRealRaid -and $dScore -lt 10) { $dScore = [math]::Min(10, $dScore + 1) }
        }
        elseif ($typeStr -eq "Inconnu") {
            if     ($sizeGB -ge 2000) { $dScore = 6 }
            elseif ($sizeGB -ge 900)  { $dScore = 5 }
            elseif ($sizeGB -ge 450)  { $dScore = 4 }
            else                      { $dScore = 3 }
        }
        else {
            if     ($sizeGB -ge 4000) { $dScore = 5 }
            elseif ($sizeGB -ge 2000) { $dScore = 4 }
            elseif ($sizeGB -ge 1000) { $dScore = 3 }
            else                      { $dScore = 2 }
        }

        if ($dScore -gt $bestDiskScore) { $bestDiskScore = $dScore }
        $diskLines += "  $model  |  $displayType  |  $sizeGB Go  |  Score: $dScore/10`n"
    }

    if ($bestDiskScore -eq 0) {
        $bestDiskScore = 1
        $diskLines     = "  Aucun disque detecte"
    }

    $txtDisk.Text = $diskLines.TrimEnd()
    Set-ScoreUI $txtDiskScore $txtDiskVerdict $barDiskFill $bestDiskScore 10 "#00FF88"
    $dkV     = Get-Verdict $bestDiskScore
    $report += "[ DISQUES ] Score: $bestDiskScore/10 ($($dkV.Text))`n$diskLines`n"

    # ── S.M.A.R.T ──
    Set-Status "Lecture des donnees S.M.A.R.T..." "#FFD700"

    $smartLines = @()
    try {
        $physDisks = @(Get-PhysicalDisk | Where-Object { $_.DeviceID -ne $null })
        foreach ($pd in $physDisks) {
            $sizeGB    = [math]::Round($pd.Size / 1GB)
            $health    = if ($pd.HealthStatus)      { $pd.HealthStatus }      else { "Inconnu" }
            $opStatus  = if ($pd.OperationalStatus)  { $pd.OperationalStatus }  else { "Inconnu" }

            $healthIcon = switch ($health) {
                "Healthy"   { [char]0x2705 }
                "Warning"   { [char]0x26A0 }
                "Unhealthy" { [char]0x274C }
                default     { [char]0x2753 }
            }

            $smartLines += "$healthIcon $($pd.FriendlyName) ($sizeGB Go)"
            $smartLines += "    Statut sante      : $health"
            $smartLines += "    Statut operation  : $opStatus"
            $busPd = "$($pd.BusType)"
            $modelPd = if ($pd.FriendlyName) { $pd.FriendlyName } else { "" }
            $looksNvmeModelPd = $modelPd -match 'NVMe|NVME|\bSN\d{3,4}\b|SDBP|SDCPN|PM9A1|MZVL|MZVLB|MZAL|KXG|BG\d|PC SN|P[35]\s*Plus|980\s*PRO|990\s*PRO|970\s*EVO'
            $isPdRaidBus = ($busPd -eq "RAID")
            $isPdLikelyRealRaid = $isPdRaidBus -and ($modelPd -match "RAID|Array|Virtual Disk|Volume|Intel.*RST|VROC|PERC|MegaRAID|Adaptec|LSI|HPE")
            $busDisplay = if ($isPdRaidBus -and -not $isPdLikelyRealRaid) {
                if ($looksNvmeModelPd) { "NVMe (via RST/VMD)" } else { "RAID (pilote/RST, pas de volume RAID detecte)" }
            } else { $busPd }
            $smartLines += "    Type de bus       : $busDisplay"

            # ── Type de media intelligent (RAID aware) ──
            $smartMedia = "$($pd.MediaType)"
            if ($isPdRaidBus) {
                if ($smartMedia -match "SSD" -or $pd.FriendlyName -match "NVMe|NVME|SSD|Samsung|WD_BLACK|Sabrent|Corsair|980|990|SN[5-8]|Hynix|KIOXIA|Solidigm|Kingston|Crucial|Intel.*P41|Phison") {
                    $smartMedia = "SSD (RAID)"
                }
                elseif ($smartMedia -match "Unspecified|Unknown") {
                    $smartMedia = "SSD probable (RAID)"
                }
                else {
                    $smartMedia = "$smartMedia (RAID)"
                }
                if (-not $isPdLikelyRealRaid) {
                    $smartMedia = $smartMedia -replace '\s*\(RAID\)$',''
                    $smartMedia = $smartMedia -replace '\s*probable\s*\(RAID\)$',' probable'
                }
            }
            $smartLines += "    Type de media     : $smartMedia"

            $hasCounters = $false
            try {
                $rel = Get-StorageReliabilityCounter -PhysicalDisk $pd -ErrorAction Stop

                if ($null -ne $rel.Temperature -and $rel.Temperature -gt 0) {
                    $tempC = $rel.Temperature
                    $tempStatus = if ($tempC -le 35) { "Excellent" }
                                  elseif ($tempC -le 45) { "Normal" }
                                  elseif ($tempC -le 55) { "Chaud" }
                                  else { "CRITIQUE!" }
                    $smartLines += "    Temperature       : ${tempC}C ($tempStatus)"
                    $hasCounters = $true
                }

                if ($null -ne $rel.PowerOnHours -and $rel.PowerOnHours -gt 0) {
                    $hours = $rel.PowerOnHours
                    $days  = [math]::Round($hours / 24)
                    $years = [math]::Round($hours / 8760, 1)
                    $smartLines += "    Heures ON         : $hours h (~${days}j / ~${years} ans)"
                    $hasCounters = $true
                }

                if ($null -ne $rel.StartStopCycleCount -and $rel.StartStopCycleCount -gt 0) {
                    $smartLines += "    Demarrages        : $($rel.StartStopCycleCount)"
                    $hasCounters = $true
                }

                if ($null -ne $rel.Wear -and $rel.Wear -ge 0) {
                    $wearPct    = $rel.Wear
                    $remainPct  = 100 - $wearPct
                    $wearStatus = if ($remainPct -ge 80) { "Excellent" }
                                  elseif ($remainPct -ge 50) { "Bon" }
                                  elseif ($remainPct -ge 20) { "Use" }
                                  else { "Critique!" }
                    $smartLines += "    Usure SSD         : ${wearPct}% (${wearStatus} — ${remainPct}% restant)"
                    $hasCounters = $true
                }

                if ($null -ne $rel.ReadErrorsTotal) {
                    $rErr = $rel.ReadErrorsTotal
                    $smartLines += "    Erreurs lecture    : $(if ($rErr -eq 0) { 'Aucune' } else { "$rErr !" })"
                    $hasCounters = $true
                }

                if ($null -ne $rel.WriteErrorsTotal) {
                    $wErr = $rel.WriteErrorsTotal
                    $smartLines += "    Erreurs ecriture  : $(if ($wErr -eq 0) { 'Aucune' } else { "$wErr !" })"
                    $hasCounters = $true
                }

                if ($null -ne $rel.ReadErrorsUncorrected -and $rel.ReadErrorsUncorrected -gt 0) {
                    $smartLines += "    Err. non corrigees: $($rel.ReadErrorsUncorrected) (ALERTE!)"
                    $hasCounters = $true
                }
            } catch {}

            if (-not $hasCounters) {
                $smartLines += "    Compteurs SMART   : Non disponibles (firmware verrouille)"
            }

            $smartLines += ""
        }
    } catch {
        $smartLines += "Impossible de lire les infos S.M.A.R.T"
    }

    $txtSMART.Text = ($smartLines -join "`n").TrimEnd()
    $report += "[ S.M.A.R.T ]`n" + ($smartLines -join "`n") + "`n`n"

    # ── SCORE GLOBAL ──
    Set-Status "Calcul du score global..." "#FFD700"

    [double]$globalScore = [math]::Round(
        ([double]$cpuScore      * 0.25) +
        ([double]$ramScore      * 0.20) +
        ([double]$gpuGenScore   * 0.15) +
        ([double]$gamingScore   * 0.15) +
        ([double]$bestDiskScore * 0.25)
    , 1)

    $globalColor = Get-ScoreColor $globalScore
    $globalV     = Get-Verdict $globalScore

    $txtScoreGlobal.Text         = "$globalScore"
    $txtScoreGlobal.Foreground   = $brushConv.ConvertFromString($globalColor)
    $txtGlobalVerdict.Text       = $globalV.Text
    $txtGlobalVerdict.Foreground = $brushConv.ConvertFromString($globalV.Color)
    $barGlobalFill.Width         = ($globalScore / 10) * 300
    $barGlobalFill.Fill          = $brushConv.ConvertFromString($globalColor)

    $report += "============================================`n"
    $report += "  SCORE GLOBAL : $globalScore / 10 ($($globalV.Text))`n"
    $report += "============================================`n"

    $script:lastReport = $report
    Set-Status "Analyse terminee — Score global : $globalScore / 10 ($($globalV.Text))" "#00FF88"
}

# ============================================================
#  BOUTONS
# ============================================================

$btnRefresh.Add_Click({ Invoke-Refresh })

$btnCopy.Add_Click({
    if ($script:lastReport) {
        [System.Windows.Clipboard]::SetText($script:lastReport)
        Set-Status "Rapport copie dans le presse-papiers !" "#FF00FF"
    } else {
        Set-Status "Aucun rapport. Lancez une analyse d'abord." "#FF4444"
    }
})

$btnExport.Add_Click({
    if ($script:lastReport) {
        $desktop  = [System.Environment]::GetFolderPath("Desktop")
        $filename = "CheckMyPower_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
        $filepath = Join-Path $desktop $filename
        $script:lastReport | Out-File -FilePath $filepath -Encoding UTF8
        Set-Status "Exporte sur le Bureau : $filename" "#00AAFF"
    } else {
        Set-Status "Aucun rapport. Lancez une analyse d'abord." "#FF4444"
    }
})

$btnCoffee.Add_Click({
    Start-Process "https://buymeacoffee.com/nicleox"
})

# ============================================================
#  LANCEMENT
# ============================================================

# Variables splash au niveau script
$script:splash    = $null
$script:splashTxt = $null

# Redefinir Set-Status pour mettre a jour le splash
function Set-Status($msg, $color) {
    $txtStatus.Text       = $msg
    $txtStatus.Foreground = $brushConv.ConvertFromString($color)
    if ($script:splash -ne $null -and $script:splash.IsVisible) {
        $script:splashTxt.Text = $msg
        [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke(
            [Action]{}, [System.Windows.Threading.DispatcherPriority]::Background
        )
    }
    [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke(
        [Action]{}, [System.Windows.Threading.DispatcherPriority]::Background
    )
}

# Cacher completement la fenetre principale
$window.WindowState = 'Minimized'
$window.ShowInTaskbar = $false

$window.Add_ContentRendered({

    # Creer le splash
    $splashXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="CheckMyPower - Analyse" Width="450" Height="200"
        WindowStartupLocation="CenterScreen" ResizeMode="NoResize"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        Topmost="True">
    <Border Background="#1a1a2e" CornerRadius="15" BorderBrush="#00FFFF" BorderThickness="2" Padding="30">
        <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
            <TextBlock Text="&#x26A1; CheckMyPower" FontSize="28" FontWeight="Bold"
                       Foreground="#00FFFF" HorizontalAlignment="Center" Margin="0,0,0,15"
                       FontFamily="Segoe UI Emoji"/>
            <TextBlock Name="splashStatus" Text="Initialisation..."
                       FontSize="14" Foreground="#AAAAAA" HorizontalAlignment="Center" Margin="0,0,0,15"/>
            <ProgressBar Width="300" Height="8" IsIndeterminate="True"
                         Foreground="#00FFFF" Background="#333333" BorderThickness="0"/>
        </StackPanel>
    </Border>
</Window>
"@

    $splashReader      = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($splashXaml))
    $script:splash     = [Windows.Markup.XamlReader]::Load($splashReader)
    $script:splashTxt  = $script:splash.FindName("splashStatus")

    $script:splash.Show()
    [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke(
        [Action]{}, [System.Windows.Threading.DispatcherPriority]::Background
    )

    # Lancer l analyse
    Invoke-Refresh

    # Fermer le splash
    $script:splash.Close()
    $script:splash = $null

    # Reveler la fenetre principale
    $window.ShowInTaskbar = $true
    $window.WindowState   = 'Normal'
    $window.Activate()
})

$window.ShowDialog() | Out-Null


