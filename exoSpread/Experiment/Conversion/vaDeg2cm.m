function [cm] = vaDeg2cm (vaDeg,scr)

cm = (2*scr.dist*tan(0.5*pi/180))*vaDeg;
end