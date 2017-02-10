# source C:/backup/SE_model_for_Proton_transfer_reaction/Figures_Final_publication/Dimer_structures/line_dimer_structure.tcl
mol delete all
cd C:/backup/SE_model_for_Proton_transfer_reaction/Figures_Final_publication/Dimer_structures
set cylinderRadius 0.03
set coneRadius 0.0

mol new C:/backup/SE_model_for_Proton_transfer_reaction/Figures_Final_publication/Dimer_structures/water_dimer_6atoms.xyz

set molID [molinfo top]

color Display Background white

mol modstyle 0 $molID CPK 1.000000 0.200000 172.000000 172.000000


proc vmd_draw_arrow {mol start end cylinderRadius coneRadius} {
    # an arrow is made of a cylinder and a cone
    set middle [vecadd $start [vecscale 0.95 [vecsub $end $start]]]
    graphics $mol cylinder $start $middle radius $cylinderRadius
    graphics $mol cone $middle $end radius $coneRadius
}

draw delete all
# drawing black color line http://www.ks.uiuc.edu/Research/vmd/vmd-1.7.1/ug/node169.html
draw color black

# drawing arrows
#vmd_draw_arrow $molID {-1.523613    0.627716   -0.591215} {2.59223077    1.01545107    0.25606981} $cylinderRadius $coneRadius
#vmd_draw_arrow $molID {1.323132    0.895895   -0.005186} {2.18216211    0.01513901   -0.42510999} $cylinderRadius $coneRadius

# Revised figure
vmd_draw_arrow $molID {-1.523613    0.627716   -0.591215} {1.323132    0.895895   -0.005186} $cylinderRadius $coneRadius
vmd_draw_arrow $molID {1.323132    0.895895   -0.005186} {2.18216211    0.01513901   -0.42510999} $cylinderRadius $coneRadius



# rendering 
#render TachyonInternal vmdscene.tga explorer %s
#render Tachyon scene.dat "tachyon -aasamples 12 %s -format BMP -res 1500 1200 -o %s.bmp"

#"C:\Program/ Files/ (x86)\University/ /of /Illinois\VMD\\tachyon_WIN32.exe" -aasamples 12 %s -format BMP -o %s.bmp -res 4096 2048

display shadows on
display ambientocclusion on

#render Tachyon C:/backup/SE_model_for_Proton_transfer_reaction/Figures_Final_publication/Dimer_structures/water_dimer "C:\Program Files (x86)\University of Illinois\VMD\\tachyon_WIN32.exe" -aasamples 12 %s -format BMP -o %s.bmp -res 4096 2048
# Rendering Tachyon Give name without extension. 
# Rendering options -aasamples 12 %s -format BMP -o %s.bmp -res 4096 2048

