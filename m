From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH] explain filesystem resize devid option
Date: Wed, 9 Feb 2011 11:53:26 +0100
Message-ID: <201102091153.27190.kario@wit.edu.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Adds explanation to help message and man page how to use `filesystem resize'
to resize only a single device not all devices of a file system.

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
patch to apply cleanly requires my previous patches adding advanced help 
functionality

 btrfs.c        |   10 +++++++---
 man/btrfs.8.in |    6 ++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index bd6f6f8..a28a573 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -98,10 +98,14 @@ static struct Command commands[] = {
           NULL
 	},
 	{ do_resize, 2,
-	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
+	  "filesystem resize", "[<devid>:][+|-]<newsize>[gkm]|max <filesystem>\n"
 		"Resize the file system. If 'max' is passed, the filesystem\n"
-		"will occupe all available space on the device.",
-          NULL
+		"will occupy all available space on the device.",
+          "[<devid>:][+|-]<newsize>[gkm]|max <filesystem>\n"
+                "Resize the file system. If no <devid> is specified, change is\n"
+                "applied to every device in file system. If devid is specified\n"
+                "the change in size is applied only to selected device.\n"
+                "To get device numbers use `btrfs filesystem show\' command."
 	},
 	{ do_show_filesystem, 999,
 	  "filesystem show", "[<uuid>|<label>]\n"
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index cba2de1..afb9824 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -19,7 +19,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
+\fBbtrfs\fP \fBfilesystem resize\fP\fI [<devid>:][+|\-]<size>[gkm]|max <filesystem>\fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
 .PP
@@ -138,9 +138,11 @@ Force a sync for the filesystem identified by \fI<path>\fR.
 .\" Some wording are extracted by the resize2fs man page
 .\"
 
-\fBfilesystem resize\fR\fI [+/\-]<size>[gkm]|max <path>\fR
+\fBfilesystem resize\fR\fI [<devid>:][+|\-]<size>[gkm]|max <path>\fR
 Resize a filesystem identified by \fI<path>\fR.
 The \fI<size>\fR parameter specifies the new size of the filesystem.
+To change size of only one device the device id can be specified before \fI:\fR.
+Device identifiers are printed by \fBfilesystem show\fR command.
 If the prefix \fI+\fR or \fI\-\fR is present the size is increased or decreased
 by the quantity \fI<size>\fR.
 If no units are specified, the unit of the \fI<size>\fR parameter defaults to
-- 
1.7.4

