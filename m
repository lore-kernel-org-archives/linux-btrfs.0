From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH 2/3] Update UsageDisplay to be capable of displaying all chunks
 by position
Date: Tue, 22 Nov 2011 20:12:58 -0500
Message-ID: <4ECC489A.8000602@cfl.rr.com>
References: <4EC67EAE.2090602@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC67EAE.2090602@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Previously the input_data to create_usage_box was assumed to be a list of
3 chunks, one of each type: data, meta, sys.  Now the list can contain any
number of entries and they will each be displayed.  If the entries contain
the key "offset", then they will be shown at the appropriate location based
on that offset, with any gaps filled in by unused space ( they are thus
assumed to be in order ).  Without the offset key, they will be displayed
in order, with no gaps.
- ---
 btrfsgui/gui/usagedisplay.py |   65 ++++++++++++++++++++++-------------------
 1 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/btrfsgui/gui/usagedisplay.py b/btrfsgui/gui/usagedisplay.py
index e6ae9b4..aff24da 100644
- --- a/btrfsgui/gui/usagedisplay.py
+++ b/btrfsgui/gui/usagedisplay.py
@@ -243,52 +243,48 @@ class UsageDisplay(Frame, Requester):
 		'size' or 'free' should be provided. If 'size' is set, the
 		amount of free space computed is returned; otherwise the
 		return value is arbitrary."""
- -
 		# Calculate the overall width of the box we are going to draw
 		width = DF_BOX_WIDTH
 		if max_size is not None:
 			width = width * size / max_size
- -
+		box = SplitBox(orient=SplitBox.HORIZONTAL)
+		nextpos = 0
 		# Categorise the data
- -		data = SplitBox(orient=SplitBox.VERTICAL)
- -		meta = SplitBox(orient=SplitBox.VERTICAL)
- -		sys = SplitBox(orient=SplitBox.VERTICAL)
- -		freebox = SplitBox(orient=SplitBox.VERTICAL)
- -		for bg_type in input_data:
- -			repl = btrfs.replication_type(bg_type["flags"])
- -			usage = btrfs.usage_type(bg_type["flags"])
+		for chunk in input_data:
+			if not "offset" in chunk:
+				chunk["offset"] = nextpos
+			if nextpos <= chunk["offset"]:
+				freesize = chunk["offset"] - nextpos
+				freebox = SplitBox(orient=SplitBox.VERTICAL)
+				freebox.append((freesize, { "fill": COLOUR_UNUSED }))
+			nextpos = chunk["offset"] + chunk["size"]
+			if size is not None:
+				size -= chunk["size"]
+			chunkbox = SplitBox(orient=SplitBox.VERTICAL)
+
+			repl = btrfs.replication_type(chunk["flags"])
+			usage = btrfs.usage_type(chunk["flags"])
 
 			if usage == "data":
- -				destination = data
 				col = COLOURS[repl][0]
 			if usage == "meta":
- -				destination = meta
 				col = COLOURS[repl][1]
 			if usage == "sys":
- -				destination = sys
 				col = COLOURS[repl][2]
 
 			usedfree = SplitBox(orient=SplitBox.HORIZONTAL)
- -			usedfree.append((bg_type["used"],
+			usedfree.append((chunk["used"],
 							 { "fill": col }))
- -			usedfree.append((bg_type["size"]-bg_type["used"],
+			usedfree.append((chunk["size"]-chunk["used"],
 							 { "fill": col, "stripe": fade(col) }))
- -			destination.append((usedfree.total, usedfree))
- -			if size is not None:
- -				size -= bg_type["size"]
+			chunkbox.append((usedfree.total, usedfree))
+			box.append((chunkbox.total, chunkbox))
 
- -		if size is not None:
- -			freebox.append((size, { "fill": COLOUR_UNUSED }))
- -		elif free is not None:
+		if size is not None and nextpos < size:
+			free = size - nextpos
+		if free is not None:
+			freebox = SplitBox(orient=SplitBox.VERTICAL)
 			freebox.append((free, { "fill": COLOUR_UNUSED }))
- -
- -		# total is our whole block
- -		# *_total are the three main divisions
- -		box = SplitBox(orient=SplitBox.HORIZONTAL)
- -		box.append((sys.total, sys))
- -		box.append((meta.total, meta))
- -		box.append((data.total, data))
- -		if size is not None or free is not None:
 			box.append((freebox.total, freebox))
 
 		box.set_position(DF_BOX_PADDING, DF_BOX_PADDING,
@@ -329,6 +325,15 @@ class UsageDisplay(Frame, Requester):
 
 	@ex_handler
 	def update_display(self):
+		def usage_sort(chunk):
+			usage = btrfs.usage_type(chunk["flags"])
+			if usage == "sys":
+				return 0
+			if usage == "meta":
+				return 1
+			if usage == "data":
+				return 2
+
 		if not self.stale:
 			return
 
@@ -377,7 +382,7 @@ class UsageDisplay(Frame, Requester):
 			bbox = self.per_disk.bbox(container)
 			y = bbox[3] + 4
 			raw_free += self.create_usage_box(canvas,
- -											  chunks.values(),
+											  sorted(chunks.values(), key=usage_sort),
 											  size=dev["vol_df"]["size"],
 											  max_size=max_space)
 		self.per_disk.configure(
@@ -389,4 +394,4 @@ class UsageDisplay(Frame, Requester):
 		kwargs = {}
 		if self.df_selection.get() == "raw":
 			kwargs["free"] = raw_free
- -		self.create_usage_box(self.df_display, obj, **kwargs)
+		self.create_usage_box(self.df_display, sorted(obj, key=usage_sort), **kwargs)
- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7MSJoACgkQJ4UciIs+XuInWQCgunltRDcrr+wVzlSUzVXiXEjw
/nIAn2la0tdjlZdkSYcChg87Tw/JS0Ek
=8XRk
-----END PGP SIGNATURE-----
