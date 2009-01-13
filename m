From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: [btrfs-progs 2/4] Add man/btrfsctl.8.in
Date: Tue, 13 Jan 2009 18:19:01 +0530
Message-ID: <20090113124901.GA15207@baloo.junglebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add man/btrfsctl.8.in

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@gmail.com>
---
 man/btrfsctl.8.in |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 man/btrfsctl.8.in

diff --git a/man/btrfsctl.8.in b/man/btrfsctl.8.in
new file mode 100644
index 0000000..e11f46a
--- /dev/null
+++ b/man/btrfsctl.8.in
@@ -0,0 +1,45 @@
+.TH BTRFSCTL 8 
+.SH NAME
+btrfsctl \- control a btrfs filesystem
+.SH SYNOPSIS
+.B btrfsctl
+[ \fB\-d\fP\fI file|directory \fP ]
+[ \fB\-s\fP\fI snapshot-name directory\fP ]
+[ \fB \-S\fP\fI subvolume-name directory\fP ]
+[ \fB \-r\fP\fI [+-]size\fP ]
+[ \fB \-A\fP\fI device\fP ]
+[ \fB \-a\fP ]
+[ \fB \-c\fP ]
+.SH DESCRIPTION
+.B btrfsctl
+is used to control the filesystem and the files and directories stored. It is the tool to create a new snapshot for the filesystem.
+.SH OPTIONS
+.TP
+\fB\-d\fR \fIfile|directory\fR
+Defragment a file or a directory. If the argument is a directory, the entire b-tree under the directory is defragged.
+.TP
+\fB\-s\fR \fIsnapshot-name directory\fR
+Creates a new \fIsnapshot\fP of the \fIdirectory\fP specified.
+.TP
+\fB\-S\fR \fIsubvolume-name directory\fR
+Creates a new subvolume.
+.TP
+\fB\-r\fR \fI[+|-]size\fR
+Resizes the filesystem with the \fIsize\fP specified. If the value is preceded with a signed symbol, the filesystem is resized with respect to the current filesystem size. \fIsize\fP can be suffixed by k,m or g to represent kilobytes, megabytes, or gigabytes respectively.
+.TP
+\fB\-A\fR \fIdevice\fR
+Scans the \fIdevice\fR for btrfs filesystem.
+.TP
+\fB\-a\fR
+Scans all devices present in the system for btrfs filesystem.
+.TP
+\fB\-c\fR
+Forces a filesystem sync.
+.SH AVAILABILITY
+.B btrfsctl
+is part of btrfs-progs. Btrfs is currently under heavy development, 
+and not suitable for for any uses other than benchmarking and review. 
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for 
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
-- 
1.6.0.2


-- 
Goldwyn
