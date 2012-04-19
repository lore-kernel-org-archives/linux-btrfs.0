From: James Daniel Smith <smithjd15@gmail.com>
Subject: btrfs-progs
Date: Thu, 19 Apr 2012 16:26:55 -0600
Message-ID: <14055805.ZYpkv1DjiU@linux-lt2.site>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart6453164.JElyF2Ad96"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart6453164.JElyF2Ad96
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Here are a couple of cleanup patches. Please apply newline first.

Thanks!

-- 
James Smith

CT.Networks
I.T. Consultant / Networking Systems Analyst
smithjd15@gmail.com
--nextPart6453164.JElyF2Ad96
Content-Disposition: attachment; filename="btrfscleanup.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="btrfscleanup.diff"

--- btrfs-progs/btrfs.c	2012-04-19 15:34:20.188146191 -0600
+++ btrfs.c	2012-04-19 15:37:43.680140829 -0600
@@ -105,7 +105,7 @@
 	{ do_resize, 2,
 	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
 		"Resize the file system. If 'max' is passed, the filesystem\n"
-		"will occupe all available space on the device.",
+		"will occupy all available space on the device.",
 	  NULL
 	},
 	{ do_show_filesystem, 999,
@@ -155,7 +155,7 @@
 	},
 	{ do_scan, 999, 
 	  "device scan", "[<device>...]\n"
-		"Scan all device for or the passed device for a btrfs\n"
+		"Scan all devices or the passed device for a btrfs\n"
 		"filesystem.",
 	  NULL
 	},
@@ -171,12 +171,12 @@
 	},
 	{ do_ino_to_path, -2,
 	  "inspect-internal inode-resolve", "[-v] <inode> <path>\n"
-		"get file system paths for the given inode.\n",
+		"Get file system paths for the given inode.\n",
 	  NULL
 	},
 	{ do_logical_to_ino, -2,
 	  "inspect-internal logical-resolve", "[-v] [-P] <logical> <path>\n"
-		"get file system paths for the given logical address.\n",
+		"Get file system paths for the given logical address.\n",
 	  NULL
 	},
 	{ 0, 0, 0, 0 }
--nextPart6453164.JElyF2Ad96
Content-Disposition: attachment; filename="btrfsnewline.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="btrfsnewline.diff"

--- btrfs-progs/btrfs.c	2012-04-19 15:34:20.188146191 -0600
+++ btrfs.c	2012-04-19 15:40:43.681136087 -0600
@@ -95,7 +95,7 @@
 		"-t size    minimal size of file to be considered for defragmenting\n"
 	},
 	{ do_get_default_subvol, 1, "subvolume get-default", "<path>\n"
-		"get the default subvolume of a filesystem."
+		"get the default subvolume of a filesystem.\n"
 	},
 	{ do_fssync, 1,
 	  "filesystem sync", "<path>\n"
@@ -171,7 +171,7 @@
 	},
 	{ do_ino_to_path, -2,
 	  "inspect-internal inode-resolve", "[-v] <inode> <path>\n"
-		"get file system paths for the given inode.",
+		"get file system paths for the given inode.\n",
 	  NULL
 	},
 	{ do_logical_to_ino, -2,
--nextPart6453164.JElyF2Ad96--

