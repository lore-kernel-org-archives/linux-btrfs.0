From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH] man: fix btrfs man page formatting
Date: Tue,  1 May 2012 01:54:08 +0200
Message-ID: <1335830048-7839-1-git-send-email-kario@wit.edu.pl>
Cc: Hubert Kario <kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
 man/btrfs.8.in |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index a840f7e..d410093 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -156,6 +156,8 @@ The start position and the number of bytes to deframention can be specified by \
 NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data, don't 
 use it if you use snapshots, have de-duplicated your data or made copies with 
 \fBcp --reflink\fP.
+.TP
+
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
 List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 .TP
-- 
1.7.10

