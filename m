From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH 1/3] Changed volume_df() to return all chunks with their offsets
Date: Tue, 22 Nov 2011 20:12:51 -0500
Message-ID: <4ECC4893.80506@cfl.rr.com>
References: <4EC67EAE.2090602@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC67EAE.2090602@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

volume_df() used to return a structure containing a dictionary named
"usage" that contained 3 chunks, keyed by their usage type ( sys, meta,
data ).  I changed this to an array named "chunks" that contains one entry
for every chunk found on the disk.  Each chunk still is a dictionary that
contains flags, size, and used, but now also contains voffset and poffset
entries giving their starting offset relative to the filesystem and disk
respectively.  The poffset is intended to be used to show the chunk at
the correct position in the disk graph, and the voffset is intended to
allow correlation with the filesystem graph.
- ---
 btrfsgui/gui/usagedisplay.py |   14 ++++++++++----
 btrfsgui/hlp/size.py         |   18 ++++++++----------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/btrfsgui/gui/usagedisplay.py b/btrfsgui/gui/usagedisplay.py
index ccfc148..e6ae9b4 100644
- --- a/btrfsgui/gui/usagedisplay.py
+++ b/btrfsgui/gui/usagedisplay.py
@@ -347,13 +347,19 @@ class UsageDisplay(Frame, Requester):
 		max_space = 0
 		for dev in self.fs["vols"]:
 			rv, text, obj = self.request("vol_df", self.fs["uuid"], dev["id"])
- -			dev["usage"] = obj
+			dev["vol_df"] = obj
 			if obj["size"] > max_space:
 				max_space = obj["size"]
 
 		y = 4
 		for i, dev in enumerate(self.fs["vols"]):
- -			obj = dev["usage"]
+			# Combine chunks with same flags
+			chunks = {}
+			for chunk in dev["vol_df"]["chunks"]:
+				if chunk["flags"] in chunks:
+					chunks[chunk["flags"]]["size"] += chunk["size"]
+					chunks[chunk["flags"]]["used"] += chunk["used"]
+				else: chunks[chunk["flags"]] = chunk
 			frame = LabelFrame(self.per_disk,
 							   text=dev["path"])
 			frame.grid(sticky=N+S+E+W)
@@ -371,8 +377,8 @@ class UsageDisplay(Frame, Requester):
 			bbox = self.per_disk.bbox(container)
 			y = bbox[3] + 4
 			raw_free += self.create_usage_box(canvas,
- -											  obj["usage"].values(),
- -											  size=obj["size"],
+											  chunks.values(),
+											  size=dev["vol_df"]["size"],
 											  max_size=max_space)
 		self.per_disk.configure(
 			scrollregion=(0, 0,
diff --git a/btrfsgui/hlp/size.py b/btrfsgui/hlp/size.py
index 0ec98c3..5ac89f4 100644
- --- a/btrfsgui/hlp/size.py
+++ b/btrfsgui/hlp/size.py
@@ -69,7 +69,7 @@ def volume_df(params):
 		res["size"] = data[1]
 		res["used"] = data[2]
 		res["uuid"] = btrfs.format_uuid(data[12])
- -		res["usage"] = {}
+		res["chunks"] = []
 
 		# Now, collect data on the block group types in use
 		last_offset = 0
@@ -124,20 +124,18 @@ def volume_df(params):
 				if header[2] != chunk_length:
 					raise HelperException("Chunk length inconsistent: chunk tree says {0} bytes, extent tree says {1} bytes".format(chunk_length, header[2]))
 				chunk_used = extent_info[0]
- -													  
- -				if chunk_type not in res["usage"]:
- -					res["usage"][chunk_type] = {
- -						"flags": chunk_type,
- -						"size": 0,
- -						"used": 0,
- -						}
- -				res["usage"][chunk_type]["size"] += ext_length
 				# We have a total of chunk_used space used, out of
 				# chunk_length in this block group. So
 				# chunk_used/chunk_length is the proportion of the BG
 				# used. We multiply that by the length of the dev_extent
 				# to get the amount of space used in the dev_extent.
- -				res["usage"][chunk_type]["used"] += chunk_used * ext_length / chunk_length
+				res["chunks"].append({
+								"flags": chunk_type,
+								"size": ext_length,
+								"used": chunk_used * ext_length / chunk_length,
+								"voffset": chunk_offset,
+								"poffset": ext_offset,
+								})
 
 	sys.stdout.write(json.dumps(res))
 	sys.stdout.write("\n")
- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7MSJMACgkQJ4UciIs+XuK8wwCghzZA+5DZGxSd3mnm5gY7pCs1
WncAn3nTtOsUswDaz2SC+Hxmp702/aQ2
=OpKV
-----END PGP SIGNATURE-----
