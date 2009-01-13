From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: [btrfs-progs 1/4] Add man/mkfs.btrfs.8.in
Date: Tue, 13 Jan 2009 18:18:02 +0530
Message-ID: <20090113124802.GA15169@baloo.junglebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add man/mkfs.btrfs.8.in
Kept the name with the name in, so that further processing such as
BUILD_DATE BUILD_VERSION etc. could be included later.

All man pages included in the man directory to avoid file cluttering.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 man/mkfs.btrfs.8.in |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)
 create mode 100644 man/mkfs.btrfs.8.in

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
new file mode 100644
index 0000000..f506665
--- /dev/null
+++ b/man/mkfs.btrfs.8.in
@@ -0,0 +1,63 @@
+.TH MKFS.BTRFS 8 
+.SH NAME
+mkfs.btrfs \- create an btrfs filesystem
+.SH SYNOPSIS
+.B mkfs.btrfs
+[ \fB\-A\fP\fI alloc-start\fP ]
+[ \fB\-b\fP\fI byte-count\fP ]
+[ \fB \-d\fP\fI data-profile\fP ]
+[ \fB \-l\fP\fI leafsize\fP ]
+[ \fB \-L\fP\fI label\fP ]
+[ \fB \-m\fP\fI metadata profile\fP ]
+[ \fB \-n\fP\fI nodesize\fP ]
+[ \fB \-s\fP\fI sectorsize\fP ]
+[ \fB \-h\fP ]
+[ \fB \-V\fP ] \fI device\fP [ \fI device ...\fP ]
+.SH DESCRIPTION
+.B mkfs.btrfs
+is used to create an btrfs filesystem (usually in a disk partition, or an array
+of disk partitions).
+.I device
+is the special file corresponding to the device (e.g \fI/dev/sdXX\fP ). 
+If multiple \fI devices \fP are specified, btrfs is created 
+spanning across the specified \fI devices\fP.
+.SH OPTIONS
+.TP
+\fB\-A\fR, \fB\-\-alloc\-start \fIoffset\fR
+Specify the offset from the start of the device to start the btrfs filesystem. The default value is zero, or the start of the device.
+.TP
+\fB\-b\fR, \fB\-\-byte\-count \fIsize\fR
+Specify the size of the resultant filesystem. If this option is not used, 
+mkfs.btrfs uses all the available storage for the filesystem.
+.TP
+\fB\-d\fR, \fB\-\-data \fItype\fR
+Specify how the data must be spanned across the devices specified. Valid 
+values are raid0, raid1, raid10 or single.
+.TP
+\fB\-l\fR, \fB\-\-leafsize \fIsize\fR
+Specify the leaf size, the least data item in which btrfs stores data. The
+default value is the page size.
+.TP
+\fB\-L\fR, \fB\-\-label \fIname\fR
+Specify a label for the filesystem. 
+.TP
+\fB\-m\fR, \fB\-\-metadata \fIprofile\fR
+Specify how metadata must be spanned across the devices specified. Valid
+values are raid0, raid1, raid10 or single.
+.TP
+\fB\-n\fR, \fB\-\-nodesize \fIsize\fR
+Specify the nodesize. By default the value is set to the pagesize.
+.TP
+\fB\-s\fR, \fB\-\-sectorsize \fIsize\fR
+Specify the sectorsize, the minimum block allocation.
+.TP
+\fB\-V\fR, \fB\-\-version\fR
+Print the \fBmkfs.btrfs\fP version and exit.
+.SH AVAILABILITY
+.B mkfs.btrfs
+is part of btrfs-progs. Btrfs is currently under heavy development, 
+and not suitable for for any uses other than benchmarking and review. 
+Please refer to the btrfs wiki 
+http://btrfs.wiki.kernel.org for further details.
+.SH SEE ALSO
+.BR btrfsck (8)
-- 
1.6.0.2


-- 
Goldwyn
