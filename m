From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH 1/2] btrfs-progs: removed extraneous whitespace from mkfs man page
Date: Mon,  9 Jan 2012 10:18:55 -0500
Message-ID: <1326122336-23363-1-git-send-email-psusi@cfl.rr.com>
Cc: Phillip Susi <psusi@cfl.rr.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There were extra spaces around some of the arguments in the man
page for mkfs.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
---
 man/mkfs.btrfs.8.in |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 432db1b..542e6cf 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -5,15 +5,16 @@ mkfs.btrfs \- create an btrfs filesystem
 .B mkfs.btrfs
 [ \fB\-A\fP\fI alloc-start\fP ]
 [ \fB\-b\fP\fI byte-count\fP ]
-[ \fB \-d\fP\fI data-profile\fP ]
-[ \fB \-l\fP\fI leafsize\fP ]
-[ \fB \-L\fP\fI label\fP ]
-[ \fB \-m\fP\fI metadata profile\fP ]
-[ \fB \-M\fP\fI mixed data+metadata\fP ]
-[ \fB \-n\fP\fI nodesize\fP ]
-[ \fB \-s\fP\fI sectorsize\fP ]
-[ \fB \-h\fP ]
-[ \fB \-V\fP ] \fI device\fP [ \fI device ...\fP ]
+[ \fB\-d\fP\fI data-profile\fP ]
+[ \fB\-l\fP\fI leafsize\fP ]
+[ \fB\-L\fP\fI label\fP ]
+[ \fB\-m\fP\fI metadata profile\fP ]
+[ \fB\-M\fP\fI mixed data+metadata\fP ]
+[ \fB\-n\fP\fI nodesize\fP ]
+[ \fB\-s\fP\fI sectorsize\fP ]
+[ \fB\-h\fP ]
+[ \fB\-V\fP ]
+\fI device\fP [ \fIdevice ...\fP ]
 .SH DESCRIPTION
 .B mkfs.btrfs
 is used to create an btrfs filesystem (usually in a disk partition, or an array
-- 
1.7.5.4

