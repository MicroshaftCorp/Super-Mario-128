--for i=1 to $.selectedVerts.count do 
--	$.selectedVerts[i].pos.z = 0.011

--for i in (polyop.getVertSelection selection[1]) do
--(
--polyop.moveVert selection[1] i [selection[i].pos.x,selection[i].pos.y,0.011] node:selection[1] --Say node:selection[1] otherwise offset is in local space.
--
--)

sel=polyop.getvertselection $ 
for i in sel do
(
pos=polyop.getvert $ i
polyop.setvert $ i [pos.x,pos.y,0.011] --50 is the specified height!
)