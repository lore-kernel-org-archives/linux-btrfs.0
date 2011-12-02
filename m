From: Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] Btrfs-progs: Fix some typos in btrfs man page
Date: Fri,  2 Dec 2011 22:34:41 +0100
Message-ID: <1322861681-3607-1-git-send-email-arnd@arndnet.de>
Cc: linux-btrfs@vger.kernel.org, Arnd Hannemann <arnd@arndnet.de>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

	This Patch fixes some minor typos in the btrfs man page.

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 man/btrfs.8.in |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..bafca8d 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -137,7 +137,7 @@ is similar to \fBsubvolume list\fR command.
 Defragment file data and/or directory metadata. To defragment all files in a
 directory you have to specify each one on its own or use your shell wildcards.
 
-The start position and the number of bytes to deframention can be specified by \fIstart\fR and \fIlen\fR. Any extent bigger than \fIthresh\fR will be considered already defragged. Use 0 to take the kernel default, and use 1 to say eveery single extent must be rewritten. You can also turn on compression in defragment operations.
+The start position and the number of bytes to defragmention can be specified by \fIstart\fR and \fIlen\fR. Any extent bigger than \fIthresh\fR will be considered already defragged. Use 0 to take the kernel default, and use 1 to say every single extent must be rewritten. You can also turn on compression in defragment operations.
 
 \fB-v\fP be verbose
 
@@ -291,7 +291,7 @@ Resolves an <inode> in subvolume <path> to all filesystem paths.
 
 \fIOptions\fR
 .IP -v 5
-verbose mode. print count of returned paths and ioctl() return value
+verbose mode. Print count of returned paths and ioctl() return value.
 .RE
 .TP
 
@@ -305,11 +305,11 @@ By default, each inode is then resolved to a file system path (similar to the
 .IP -P 5
 skip the path resolving and print the inodes instead
 .IP -v 5
-verbose mode. print count of returned paths and all ioctl() return values
+verbose mode. Print count of returned paths and all ioctl() return values.
 .RE
 
 .SH EXIT STATUS
-\fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
+\fBbtrfs\fR returns a zero exit status if it succeeds. Non zero is returned in
 case of failure.
 
 .SH AVAILABILITY
-- 
1.7.5.4

