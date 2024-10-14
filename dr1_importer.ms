clearlistener()
try(DestroyDialog deadrising_imp)catch(readrising_imp)
rollout deadrising_imp "Dead Rising" (
	
	button btn1 "Import" width:120 height:30
	checkbox chk1 "Clear Scene" checked:true
	spinner spn1 "Scale" range:[-999999999.0, 999999999.0, 0.393700787] type:#float scale:0.01 align:#left
	label lbl1 ""
	label lbl2 "Written By mariokart64n"
	
	fn ReadFixedString bstream fixedLen = (
		local str = ""
		for i = 1 to fixedLen do (
			str += bit.intAsChar (ReadByte bstream #unsigned)
			)
		str
		)
	fn ReadBEshort fstream = (
		bit.swapBytes (readshort fstream #unsigned) 1 2
		)
	fn readBElong fstream = (
		local long = readlong fstream #unsigned
		long = bit.swapBytes long 1 4
		long = bit.swapBytes long 2 3
		long
		)
	fn ReadBEfloat fstream = (
		local fpt = readfloat fstream
		local itger = bit.floatAsInt fpt
		local hih = bit.intashex itger
		while hih.count < 8 do hih = "0" + hih
		local shn = (substring hih 7 2) + \
					(substring hih 5 2) + \
					(substring hih 3 2) + \
					(substring hih 1 2)
		(bit.intAsFloat (bit.hexasint shn))
		)
	 fn readBEHalfFloat Fstream = (
		local BH  = readByte Fstream #unsigned
		local BL  = readByte Fstream #unsigned
		local N = BH*256 + BL
		local S = floor((mod N 65536) / 32768)
		local Ef = floor((mod N 32768) / 1024)
		local M = mod N 1024
		if (Ef==0)AND(M==0) then return ( (-1.0)^S * 0.0 )
		if (Ef==0)AND(M!=0) then return ( (-1.0)^S * 2.0^-14 * (M / 2.0^10) )
		if (Ef>0)AND(Ef<31) then return ( (-1.0)^S * 2.0^(Ef-15) * (1 + M/2.0^10) )
		if (Ef==31)AND(M==0) then return ( (-1.0)^S * 1/0.0 )
		if (Ef==31)AND(M!=0) then return 0	--hack-- should be #inf   
		)--end fn ReadBEHalfFloat
	fn writeDDSheader streamin texW texH texM texC = (
		local texP=0
		writelong streamin 0x20534444 #unsigned -- File ID
		writelong streamin 0x7C #unsigned -- Header Size
		case texC of ( -- dwFlags
			("DXT1"): (writelong streamin 0x00081007 #unsigned;texP=((texW*texH)/0x02))
			("DXT3"): (writelong streamin 0x00081007 #unsigned;texP=(texW*texH))
			("DXT5"): (writelong streamin 0x00081007 #unsigned;texP=(texW*texH))
			("ATI1"): (writelong streamin 0x000A1007 #unsigned;texP=(texW*texH)/2;texM=1)
			("ATI2"): (writelong streamin 0x000A1007 #unsigned;texP=(texW*texH);texM=1)
			("P8"): (writelong streamin 0x000A1007 #unsigned;texP=((texW*texH)/0x02))
			("ARGB16"): (writelong streamin 0x00081007 #unsigned;texP=(((texW*texH)/0x8)*0x10))
			("ARGB32"): (writelong streamin 0x00081007 #unsigned;texP=(((texW*texH)/0x4)*0x10))
			)
		writelong streamin texW #unsigned -- Texture Width
		writelong streamin texH #unsigned -- Texture Height
		writelong streamin texP #unsigned -- Pitch (#of bytes in a single row across the texture)
		writelong streamin 0x00 #unsigned -- Image Depth? Not Used, for Image Volume
		writelong streamin texM #unsigned -- Texture MIP Count
		for i = 1 to 11 do ( -- Reserved Space
			writelong streamin 0x00 #unsigned
			)
		writelong streamin 0x20 #unsigned -- Size of PIXEL_FORMAT info, always 32bytes;
		case texC of (
			("DXT1"): (
				writelong streamin 0x04;writelong streamin 0x31545844 #unsigned
				writelong streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writelong streamin 0x00001000 #unsigned
				)
			("DXT3"): (
				writelong streamin 0x04;writelong streamin 0x33545844 #unsigned
				writelong streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writelong streamin 0x00001000 #unsigned
				)
			("DXT5"): (
				writelong streamin 0x04;writelong streamin 0x35545844 #unsigned
				writelong streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writelong streamin 0x00001000 #unsigned
				)
			("ATI1"): (
				writelong streamin 0x04;writelong streamin 0x31495441 #unsigned
				writelong streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writelong streamin 0x00401008 #unsigned
				)
			("ATI2"): (
				writelong streamin 0x04;writelong streamin 0x32495441 #unsigned
				writelong streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writelong streamin 0x00401008 #unsigned
				)
			("P8"): (
				writelong streamin 0x20;writelong streamin 0x20203850 #unsigned
				writelong streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writelong streamin 0x00401008 #unsigned
				)
			("ARGB16"): (
				writelong streamin 0x41;writelong streamin 0x00000000 #unsigned
				writelong streamin 0x10;writebyte streamin 0x00;writebyte streamin 0x0F;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0xF0;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x0F;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0xF0;writebyte streamin 0x00
				writebyte streamin 0x00;writelong streamin 0x00001000 #unsigned
				)
			("ARGB32"): (
				writelong streamin 0x41;writelong streamin 0x00000000 #unsigned
				writelong streamin 0x20;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0xFF
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0xFF;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0xFF;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00;writebyte streamin 0x00
				writebyte streamin 0xFF;writelong streamin 0x00001000 #unsigned
				)
			)
		for i = 1 to 4 do (
			writelong streamin 0x00 #unsigned
			)
		) -- Reserved Space for CAPS
	fn read fsource clear_scene:true mscale:3.93700787 = (
		local st = timestamp() -- Get start time in milliseconds
		
		if (fsource != undefined) and (doesFileExist fsource) then (
			
			if clear_scene do (delete objects)
			
			local fpath = getFilenamePath fsource
			local fname = getFilenameFile fsource
			local fsize = getFileSize fsource
			local f = fopen fsource "rb"
			
			-- Re-fetch file size after opening the file
			fsize = getFileSize fsource
			
			local fileID = readlong f #unsigned
			
			case fileID of (
				0x4D4F4400: ( -- Handle file ID 0x4D4F4400
					
					-- Read header information
					local ukn001 = readBEshort f -- Header size?
					local ukn002 = readBEshort f -- Bone count?
					local ukn003 = readBEshort f -- Mesh count?
					local ukn004 = readBEshort f -- Material count?
					
					local ukn005 = readBElong f -- Vertex count
					local ukn006 = readBElong f -- Face count
					local ukn007 = readBElong f
					local ukn008 = readBElong f
					local ukn009 = readBElong f
					
					local ukn010 = readBElong f -- Count, String Count, Texture count
					local ukn011 = readBElong f -- Always 0?
					local ukn012 = readBElong f -- Bone offset
					local ukn013 = readBElong f -- Offset, String table
					
					local ukn014 = readBElong f -- Mesh info offset
					local ukn015 = readBElong f -- Offset, vertices
					local ukn016 = readBElong f -- Always 0?
					local ukn017 = readBElong f -- Offset, faces
					
					-- Read bounding sphere
					local ukn018 = readBEfloat f
					local ukn019 = readBEfloat f
					local ukn020 = readBEfloat f
					local ukn021 = readBEfloat f
					
					-- Read min bounds
					local ukn022 = readBEfloat f
					local ukn023 = readBEfloat f
					local ukn024 = readBEfloat f
					local ukn025 = readBEfloat f
					
					-- Read max bounds
					local ukn026 = readBEfloat f
					local ukn027 = readBEfloat f
					local ukn028 = readBEfloat f
					local ukn029 = readBEfloat f
					
					local boundbox = [ukn026, -ukn028, ukn027] - [ukn022, -ukn024, ukn023]
					
					-- Process bones
					fseek f ukn012 #seek_set
					for i = 1 to ukn002 do ( -- Each bone is 24 bytes long
						local bindex = readbyte f
						local bparent = readbyte f
						fseek f (4 * 5.5) #seek_cur -- Skip remaining bytes
						)
					
					-- Read texture names
					fseek f ukn013 #seek_set
					local texNames = #()
					texNames[ukn010] = ""
					for i = 1 to ukn010 do (
						texNames[i] = readFixedString f 64
						)
					
					-- Read mesh information
					fseek f ukn014 #seek_set
					for i = 1 to ukn003 do (
						local getPos = (ftell f) + 80
						local ukn01 = readBEshort f
						fseek f getPos #seek_set
						)
					
					-- Initialize arrays for vertices, UVs, normals, and faces
					local vertArray = #()
					local uvwArray = #()
					local normArray = #()
					local faceArray = #()
					
					-- Read additional bytes (purpose unclear from context)
					local a = readbyte f #unsigned
					local b = readbyte f #unsigned
					
					-- Read vertices
					fseek f ukn015 #seek_set
					for i = 1 to ukn005 do (
						local getPos = (ftell f) + 32
						-- Read vertex positions
						local vx = (((ReadBEshort f as float) / 0xffff) * (abs boundbox[1]) - (abs (boundbox[1] / 2))) * mscale
						local vy = ((ReadBEshort f as float) / 0xffff) * (abs boundbox[3]) * mscale
						local vz = (((ReadBEshort f as float) / 0xffff) * (abs boundbox[2]) - (abs (boundbox[2] / 2))) * mscale
						
						-- Read additional vertex data
						local wtf = readshort f
						local b1 = readbyte f #unsigned
						local b2 = readbyte f #unsigned	
						local b3 = readbyte f #unsigned
						local b4 = readbyte f #unsigned
						local w1 = readbyte f #unsigned
						local w2 = readbyte f #unsigned	
						local w3 = readbyte f #unsigned
						local w4 = readbyte f #unsigned
						
						fseek f 8 #seek_cur -- Skip remaining bytes
						
						-- Read texture coordinates
						local tu = ReadBEHalfFloat f
						local tv = ReadBEHalfFloat f 	
						
						-- Append to vertex and UV arrays
						append vertArray [vx, -vz, vy]
						append uvwArray [tu, (-tv + 1), 0]
						
						-- Reset file position
						fseek f getPos #seek_set
						)
					
					-- Read faces
					fseek f ukn017 #seek_set
					local StartDirection = -1
					local f1 = (readBEshort f) + 1
					local f2 = (readBEshort f) + 1
					if f1 >= ukn005 do f1 = 1
					if f2 >= ukn005 do f2 = 1
					local FaceDirection = StartDirection
					local IndexCounter = 2
					
					do (
						local f3 = readBEshort f
						IndexCounter += 1
						
						if f3 >= ukn005 then (
							f1 = (readBEshort f) + 1
							f2 = (readBEshort f) + 1
							if f1 >= ukn005 do f1 = 1
							if f2 >= ukn005 do f2 = 1
							FaceDirection = StartDirection
							IndexCounter += 2
							) else (
							f3 += 1
							FaceDirection = -FaceDirection
							if (f1 != f2) AND (f2 != f3) AND (f3 != f1) then (
								if FaceDirection > 0 then append faceArray [f1, f2, f3]
								else append faceArray [f1, f3, f2]
								)
							f1 = f2
							f2 = f3
							)
						) while (IndexCounter != (ukn006 - 1))
					
					-- Create and configure mesh
					local msh = mesh vertices:vertArray faces:faceArray
					msh.numTVerts = vertArray.count
					buildTVFaces msh
					msh.displayByLayer = false
					msh.backfacecull = on
					
					for j = 1 to vertArray.count do (
						setTVert msh j uvwArray[j]
						)
					
					for j = 1 to faceArray.count do (
						setTVFace msh j faceArray[j]
						)
					
					-- Uncomment and implement normals if needed
					-- for j = 1 to vertArray.count do setNormal msh j normArray[j]
					
					convertTo msh PolyMeshObject
					
					print ("Last Read @ 0x" + (bit.intAsHex (ftell f) as string))
					print ("Done! (" + (((timestamp() - st) / 60) as string) + " Seconds)")
					
					fclose f
					)
				
				0x54455800: ( -- Handle file ID 0x54455800
					local ukn01 = readbyte f #unsigned
					local ukn02 = readbyte f #unsigned -- Flags??
					local ukn03 = readbyte f #unsigned
					local ukn04 = readbyte f #unsigned
					local texH = readBElong f
					local texW = readBElong f
					local ukn05 = readlong f
					local ukn06 = readbyte f #unsigned
					local ukn07 = readbyte f #unsigned
					local ukn08 = readbyte f #unsigned
					local texC = readbyte f #unsigned -- Compression?
					
					fseek f (ukn03 * 4) #seek_cur
					local getPos = ftell f
					print texC -- Corrected typo from texCe to texC
					
					-- Determine texture compression format
					case of (
						(texC == 0x52): (texC = "DXT1")
						(texC == 0x53): (texC = "DXT3")
						(texC == 0x54): (texC = "DXT5")
						(texC == 0x86): (texC = "ARGB32")
						(texC == 0x4A): (texC = "ARGB16")
						(texC == 0x71): (texC = "ATI2")
						(texC == 0x7B): (texC = "ATI1")
						(texC == 0x7C): (texC = "ATI1")
						)
					
					local xinfo = (" [" + texC + " - " + (texH as string) + " x " + (texW as string) + "]")
					
					-- Create and write DDS file
					local s = fopen (fpath + fname + xinfo + ".dds") "wb"
					writeDDSheader s texW texH 0 texC
					for i = 1 to ((fsize - getPos) / 2) do (
						writeshort s (readBEshort f) #unsigned
						)
					
					-- Close both files
					fclose s
					fclose f
					)
				)
			) else (
			print "Aborted."
			)
		)
	on btn1 pressed do (
		read (
			GetOpenFileName caption:"DR1 MOD Importer" types: "All Files (*.272743838)|*.272743838;*.mod|All Files (*.*)|*.*|"
			) clear_scene:chk1.checked mscale:spn1.value
		)
	)
CreateDialog deadrising_imp

/*
deadrising_imp.read(
	"C:\\file.mod"
	GetOpenFileName caption:"DR1 MOD Importer" types: "All Files (*.272743838)|*.272743838;*.mod|All Files (*.*)|*.*|"
	)
*/