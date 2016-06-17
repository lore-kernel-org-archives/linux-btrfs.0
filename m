Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33289 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629AbcFQQkm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 12:40:42 -0400
Date: Fri, 17 Jun 2016 09:40:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH v2 14/20] xfs: test clearing reflink inode flag
Message-ID: <20160617164025.GF5740@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
 <146612805032.25024.3244105391915486280.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <146612805032.25024.3244105391915486280.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check that xfs_repair can clear the reflink inode flag.

v2: This is a reflink test; use _require_scratch_reflink

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/872     |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/872.out |   20 +++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 114 insertions(+)
 create mode 100755 tests/xfs/872
 create mode 100644 tests/xfs/872.out

diff --git a/tests/xfs/872 b/tests/xfs/872
new file mode 100755
index 0000000..e4c987e
--- /dev/null
+++ b/tests/xfs/872
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 872
+#
+# Create 100 reflinked files, CoW them all, and see if xfs_repair will
+# clear the reflink flag.  There was a buffer handling bug in xfs_repair
+# that (fortunately) triggered asserts in the rmap code when clearing
+# the reflink flag.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch_reflink
+
+rm -f $seqres.full
+
+nr=128 # spanning at least one inode chunk tickles a bug in xfs_repair
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 1 $SCRATCH_MNT/file.0 >> $seqres.full
+seq 1 $nr | while read i; do
+	_cp_reflink $SCRATCH_MNT/file.0 $SCRATCH_MNT/file.$i
+done
+sync
+
+echo "Check files"
+for i in 0 $((nr / 2)) $nr; do
+	md5sum $SCRATCH_MNT/file.$i | _filter_scratch
+	$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/file.$i | _filter_scratch
+done
+
+echo "CoW all files"
+seq 1 $nr | while read i; do
+	echo m >> $SCRATCH_MNT/file.$i
+done
+
+echo "Repair filesystem"
+_scratch_unmount
+_repair_scratch_fs >> $seqres.full
+_scratch_mount
+
+echo "Check files again"
+for i in 0 $((nr / 2)) $nr; do
+	md5sum $SCRATCH_MNT/file.$i | _filter_scratch
+	$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/file.$i | _filter_scratch
+done
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/872.out b/tests/xfs/872.out
new file mode 100644
index 0000000..316cb0a
--- /dev/null
+++ b/tests/xfs/872.out
@@ -0,0 +1,20 @@
+QA output created by 872
+Format filesystem
+Create files
+Check files
+8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.0
+[reflink] SCRATCH_MNT/file.0 
+8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.64
+[reflink] SCRATCH_MNT/file.64 
+8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.128
+[reflink] SCRATCH_MNT/file.128 
+CoW all files
+Repair filesystem
+Check files again
+8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.0
+[] SCRATCH_MNT/file.0 
+0f17fd72b7bbf5bda0ff433e6d1fc118  SCRATCH_MNT/file.64
+[] SCRATCH_MNT/file.64 
+0f17fd72b7bbf5bda0ff433e6d1fc118  SCRATCH_MNT/file.128
+[] SCRATCH_MNT/file.128 
+Done
diff --git a/tests/xfs/group b/tests/xfs/group
index 0f94794..ca36ad6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -304,3 +304,4 @@
 869 auto quick clone
 870 auto quick clone
 871 auto quick clone
+872 auto quick clone
