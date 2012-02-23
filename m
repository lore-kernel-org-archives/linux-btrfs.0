From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH][BTRFS-PROGS][Resubmit] Re: Btrfs filesystem resize syntax
Date: Thu, 23 Feb 2012 18:47:02 +0100
Message-ID: <201202231847.02474.kreijack@inwind.it>
References: <1455836.FFuBaU2UqE@bursa22>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, Hubert Kario <hka@qbs.com.pl>
To: chris.mason@oracle.com, Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1455836.FFuBaU2UqE@bursa22>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I am resubmitting an old patch, which has the aim to document the <devid> 
parameter of the btrfs filesystem resize command.

The patch is against the Mason master repo.

Hugo,  Chris, please apply 

You can pull the source from 
	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
	resize-help

Comments are welcome.

---------

diff --git a/btrfs.c b/btrfs.c
index 1def354..03c9bc4 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -103,7 +103,7 @@ static struct Command commands[] = {
 	  NULL
 	},
 	{ do_resize, 2,
-	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
+	  "filesystem resize", "[<devid>:][+/-]<newsize>[gkm]|max <filesystem>\n"
 		"Resize the file system. If 'max' is passed, the filesystem\n"
 		"will occupe all available space on the device.",
 	  NULL
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..a00d9bd 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -19,7 +19,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
+\fBbtrfs\fP \fBfilesystem resize\fP\fI [<devid>:][+/\-]<size>[gkm]|max 
<filesystem>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
@@ -166,7 +166,7 @@ Force a sync for the filesystem identified by 
\fI<path>\fR.
 .\" Some wording are extracted by the resize2fs man page
 .\"
 
-\fBfilesystem resize\fR\fI [+/\-]<size>[gkm]|max <path>\fR
+\fBfilesystem resize\fR\fI [<devid>:][+/\-]<size>[gkm]|max <path>\fR
 Resize a filesystem identified by \fI<path>\fR.
 The \fI<size>\fR parameter specifies the new size of the filesystem.
 If the prefix \fI+\fR or \fI\-\fR is present the size is increased or 
decreased
@@ -179,6 +179,10 @@ respectively.
 If 'max' is passed, the filesystem will occupy all available space on the
 volume(s).
 
+When the filesystem relies on multiple devices, it is possible to specify
+which one should be resized via the <devid> parameter.
+To know the <devid> of a device use the command \fBbtrfs filesystem show\fR.
+
 The \fBresize\fR command \fBdoes not\fR manipulate the size of underlying
 partition.  If you wish to enlarge/reduce a filesystem, you must make sure 
you
 can expand the partition before enlarging the filesystem and shrink the
@@ -209,7 +213,7 @@ If \fB--all-devices\fP is passed, all the devices under 
/dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 .TP
 
-\fBdevice balance\fR \fI<path>\fR
+\fBfilesystem balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP




On Wednesday, 22 February, 2012 18:37:24 Hubert Kario wrote:
> What happened to the patches to --help and man pages that did explain the
> multi-device use-case:
> 
>  btrfs filesystem resize [<devid>:][+/-]<newsize>[gkm]|max <filesystem>
> 
> (the <devid>: bit is missing)
> It is explained on the wiki:
> http://btrfs.ipv5.de/index.php?title=Btrfs(command)
> but I don't see those patches in Chris btrfs-progs tree.
> 
> Regards,
