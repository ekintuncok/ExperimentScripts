function [pixX,pixY]= vaDeg2pix(vaDeg,scr)

cm= vaDeg2cm(vaDeg,scr);
[pixX,pixY] = cm2pix(cm,scr);
end
