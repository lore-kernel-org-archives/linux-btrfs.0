From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH 3/3] Add radio knob to show space by position or combined
Date: Tue, 22 Nov 2011 20:13:06 -0500
Message-ID: <4ECC48A2.6050305@cfl.rr.com>
References: <4EC67EAE.2090602@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC67EAE.2090602@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The previous method was to show chunks combined by type.  This knob
allows the user to choose to show each individual chunk in its actual
position.
- ---
 btrfsgui/gui/usagedisplay.py |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/btrfsgui/gui/usagedisplay.py b/btrfsgui/gui/usagedisplay.py
index aff24da..fd8b1e2 100644
- --- a/btrfsgui/gui/usagedisplay.py
+++ b/btrfsgui/gui/usagedisplay.py
@@ -213,6 +213,22 @@ class UsageDisplay(Frame, Requester):
 		but.grid(row=2, column=1, sticky=W)
 		self.df_selection.set("alloc")
 
+		self.df_byposition = StringVar()
+		Label(box, text="Show allocated space").grid(row=3,column=0)
+		but = Radiobutton(
+			box, text="Combined",
+			variable=self.df_byposition,
+			command=self.change_display,
+			value="combined")
+		but.grid(row=3, column=1, sticky=W)
+		but = Radiobutton(
+			box, text="Individual",
+			variable=self.df_byposition,
+			command=self.change_display,
+			value="individual")
+		but.grid(row=4, column=1, sticky=W)
+		self.df_byposition.set("combined")
+
 		frm = LabelFrame(self, text="Volumes")
 		frm.columnconfigure(0, weight=1)
 		frm.rowconfigure(0, weight=1)
@@ -359,12 +375,17 @@ class UsageDisplay(Frame, Requester):
 		y = 4
 		for i, dev in enumerate(self.fs["vols"]):
 			# Combine chunks with same flags
- -			chunks = {}
- -			for chunk in dev["vol_df"]["chunks"]:
- -				if chunk["flags"] in chunks:
- -					chunks[chunk["flags"]]["size"] += chunk["size"]
- -					chunks[chunk["flags"]]["used"] += chunk["used"]
- -				else: chunks[chunk["flags"]] = chunk
+			if self.df_byposition.get() == "combined":
+				chunks = {}
+				for chunk in dev["vol_df"]["chunks"]:
+					if chunk["flags"] in chunks:
+						chunks[chunk["flags"]]["size"] += chunk["size"]
+						chunks[chunk["flags"]]["used"] += chunk["used"]
+					else: chunks[chunk["flags"]] = chunk
+				chunks = sorted(chunks.values(), key=usage_sort)
+			else:
+				chunks = [{"size": x["size"], "used": x["used"], "flags": x["flags"],
+						   "offset": x["poffset"]} for x in dev["vol_df"]["chunks"]]
 			frame = LabelFrame(self.per_disk,
 							   text=dev["path"])
 			frame.grid(sticky=N+S+E+W)
@@ -382,7 +403,7 @@ class UsageDisplay(Frame, Requester):
 			bbox = self.per_disk.bbox(container)
 			y = bbox[3] + 4
 			raw_free += self.create_usage_box(canvas,
- -											  sorted(chunks.values(), key=usage_sort),
+											  chunks,
 											  size=dev["vol_df"]["size"],
 											  max_size=max_space)
 		self.per_disk.configure(
- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7MSKIACgkQJ4UciIs+XuIx5QCfSHc4/8bPkQuiTGs0R3D6SyPK
6+cAn1n7HcLowmobT48hQc+iPjUqJEer
=Ljl6
-----END PGP SIGNATURE-----
