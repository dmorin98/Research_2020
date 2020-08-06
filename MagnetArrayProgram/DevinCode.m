clear all
K = 1440
wl = 3 %w1idt1h 1
tl = 5 %t1hickness 1
wm = 2
tm = 5
wr = 3
tr = 5
spaceleft= 0.6146
spaceright= 0.4238
middlebend = 0.4868
z = 1
y = linspace(0,10);
%z goes to z+wl./2+spaceleft+wm./2

%y goes to (y+middlebend)
Bzm = K.*(-atan((z-wm./2)./(y+middlebend))+atan((z+wm./2)./(y+middlebend))+atan((z-wm./2)./((y+middlebend)+tm))-atan((z+wm/2)./((y+middlebend)+tm)))
Bym = K/2.*(log(((y+middlebend).^2+(z+wm/2).^2)/((y+middlebend).^2)+(z-wm/2).^2)-log((((y+middlebend)+tm).^2+(z+wm/2).^2)/(((y+middlebend)+tm).^2+(z-wm/2).^2)))

Bm = sqrt(Bym.^2+Bzm.^2)

%z goes to (z+spaceleft+wm/2+wl/2)
Bzl = K.*(-atan(((z+spaceleft+wm/2+wl/2)-wl./2)./(y))+atan(((z+spaceleft+wm/2+wl/2)+wl./2)./(y))+atan(((z+spaceleft+wm/2+wl/2)-wl./2)./(y+tl))-atan(((z+spaceleft+wm/2+wl/2)+wl/2)./(y+tl)))
Byl = K/2.*(log((y.^2+((z+spaceleft+wm/2+wl/2)+wl/2).^2)/((y).^2)+((z+spaceleft+wm/2+wl/2)-wl/2).^2)-log(((y+tl).^2+((z+spaceleft+wm/2+wl/2)+wl/2).^2)/((y+tl).^2+((z+spaceleft+wm/2+wl/2)-wl/2).^2)))
Bl = sqrt(Byl.^2+Bzl.^2)

%(z+spaceleft+wm/2+wl/2) goes to (z-spaceright-wm/2-wr/2)
Bzr = K.*(-atan(((z-spaceright-wm/2-wr/2)-wl./2)./(y))+atan(((z-spaceright-wm/2-wr/2)+wl./2)./(y))+atan(((z-spaceright-wm/2-wr/2)-wl./2)./(y+tl))-atan(((z-spaceright-wm/2-wr/2)+wl/2)./(y+tl)))
Byr = K/2.*(log((y.^2+((z-spaceright-wm/2-wr/2)+wl/2).^2)/((y).^2)+((z-spaceright-wm/2-wr/2)-wl/2).^2)-log(((y+tl).^2+((z-spaceright-wm/2-wr/2)+wl/2).^2)/((y+tl).^2+((z-spaceright-wm/2-wr/2)-wl/2).^2)))

Br = sqrt(Byr.^2+Bzr.^2)

B_total = Bl+Bm+Br
plot(y,Bm)