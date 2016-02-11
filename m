Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19963 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbcBKXme (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:34 -0500
Subject: [PATCH 28/32] xfs: test xfs_getbmapx behavior with shared extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 11 Feb 2016 15:42:28 -0800
Message-ID: <20160211234228.2202.88430.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make sure that xfs_getbmapx behaves properly w.r.t. shared extents
and CoW fork reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |   19 ++++++
 tests/xfs/243     |  165 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/243.out |   26 ++++++++
 tests/xfs/245     |   95 +++++++++++++++++++++++++++++++
 tests/xfs/245.out |   12 ++++
 tests/xfs/246     |   65 +++++++++++++++++++++
 tests/xfs/246.out |    6 ++
 tests/xfs/group   |    3 +
 8 files changed, 391 insertions(+)
 create mode 100755 tests/xfs/243
 create mode 100644 tests/xfs/243.out
 create mode 100755 tests/xfs/245
 create mode 100644 tests/xfs/245.out
 create mode 100755 tests/xfs/246
 create mode 100644 tests/xfs/246.out


diff --git a/common/rc b/common/rc
index 7e83d6e..52c4a36 100644
--- a/common/rc
+++ b/common/rc
@@ -3075,6 +3075,25 @@ _require_xfs_scratch_rmapbt()
 	_scratch_unmount
 }
 
+_xfs_bmapx_find() {
+	case "$1" in
+	"attr")
+		param="a"
+		;;
+	"cow")
+		param="c"
+		;;
+	*)
+		param="e"
+		;;
+	esac
+	shift
+	file="$1"
+	shift
+
+	"$XFS_IO_PROG" -c "bmap -${param}lpv" "$file" | grep -c "$@"
+}
+
 _get_total_inode()
 {
 	if [ -z "$1" ]; then
diff --git a/tests/xfs/243 b/tests/xfs/243
new file mode 100755
index 0000000..629173e
--- /dev/null
+++ b/tests/xfs/243
@@ -0,0 +1,165 @@
+#! /bin/bash
+# FS QA Test No. 243
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Set cowextsize hint.
+#   - Create a file with the following repeating sequence of blocks:
+#     1. reflinked
+#     2. unwritten
+#     3. hole
+#     4. regular block
+#     5. delalloc
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesize" $testdir/file3 >> $seqres.full
+# 0 blocks are reflinked
+seq 0 5 $nr | while read f; do
+	_reflink_range $testdir/file1 $((blksz * f)) $testdir/file3 $((blksz * f)) $blksz >> $seqres.full
+	_pwrite_byte 0x61 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
+done
+# 1 blocks are unwritten
+seq 1 5 $nr | while read f; do
+	$XFS_IO_PROG -f -c "falloc $((blksz * f)) $blksz" $testdir/file3 >> $seqres.full
+	_pwrite_byte 0x00 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
+done
+# 2 blocks are holes
+seq 2 5 $nr | while read f; do
+	_pwrite_byte 0x00 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
+done
+# 3 blocks are regular
+seq 3 5 $nr | while read f; do
+	_pwrite_byte 0x71 $((blksz * f)) $blksz $testdir/file3 >> $seqres.full
+	_pwrite_byte 0x71 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
+done
+sync
+# 4 blocks are delalloc (do later)
+seq 4 5 $nr | while read f; do
+	_pwrite_byte 0x62 $((blksz * f)) $blksz $testdir/file3 >> $seqres.full
+	_pwrite_byte 0x62 $((blksz * f)) $blksz $testdir/file3.chk >> $seqres.full
+done
+
+# 10 blocks are cow'd
+seq 0 10 $((nr/2)) | while read f; do
+	_pwrite_byte 0x61 $((blksz * f)) 1 $testdir/file3 >> $seqres.full
+	_pwrite_byte 0x61 $((blksz * f)) 1 $testdir/file3.chk >> $seqres.full
+done
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Dump extents"
+$XFS_IO_PROG -c "cowextsize" $testdir/file3 | _filter_scratch
+echo "Delayed allocation CoW extents:"
+test $(_xfs_bmapx_find cow $testdir/file3 delalloc) -gt 0 || \
+	echo "Expected to find a delalloc CoW extent"
+echo "Shared data extents:"
+test $(_xfs_bmapx_find data $testdir/file3 '100000$') -gt 0 || \
+	echo "Expected to find a shared data extent"
+echo "Unwritten data extents:"
+test $(_xfs_bmapx_find data $testdir/file3 '10000$') -gt 0 || \
+	echo "Expected to find an unwritten data extent"
+echo "Hole data extents:"
+test $(_xfs_bmapx_find data $testdir/file3 hole) -gt 0 || \
+	echo "Expected to find a hole data extent"
+echo "Regular data extents:"
+test $(_xfs_bmapx_find data $testdir/file3 '000000$') -gt 0 || \
+	echo "Expected to find a regular data extent"
+
+sync
+
+echo "Dump extents after sync"
+$XFS_IO_PROG -c "cowextsize" $testdir/file3 | _filter_scratch
+echo "Delayed allocation CoW extents:"
+test $(_xfs_bmapx_find cow $testdir/file3 -v hole ) -gt 0 || \
+	echo "Expected to find a regular CoW extent"
+echo "Real CoW extents:"
+test $(_xfs_bmapx_find cow $testdir/file3 delalloc ) -eq 0 || \
+	echo "Expected to find zero delalloc CoW extent"
+echo "Shared data extents:"
+test $(_xfs_bmapx_find data $testdir/file3 '100000$') -gt 0 || \
+	echo "Expected to find a shared data extent"
+echo "Unwritten data extents:"
+test $(_xfs_bmapx_find data $testdir/file3 '10000$') -gt 0 || \
+	echo "Expected to find an unwritten data extent"
+echo "Hole data extents:"
+test $(_xfs_bmapx_find data $testdir/file3 hole) -gt 0 || \
+	echo "Expected to find a hole data extent"
+echo "Regular data extents:"
+test $(_xfs_bmapx_find data $testdir/file3 '000000$') -gt 0 || \
+	echo "Expected to find a regular data extent"
+
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/243.out b/tests/xfs/243.out
new file mode 100644
index 0000000..e6e5326
--- /dev/null
+++ b/tests/xfs/243.out
@@ -0,0 +1,26 @@
+QA output created by 243
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-243/file1
+d0fda5bf5d4fd70904ef1c1c56db28d0  SCRATCH_MNT/test-243/file3
+d0fda5bf5d4fd70904ef1c1c56db28d0  SCRATCH_MNT/test-243/file3.chk
+Dump extents
+[1048576] SCRATCH_MNT/test-243/file3
+Delayed allocation CoW extents:
+Shared data extents:
+Unwritten data extents:
+Hole data extents:
+Regular data extents:
+Dump extents after sync
+[1048576] SCRATCH_MNT/test-243/file3
+Delayed allocation CoW extents:
+Real CoW extents:
+Shared data extents:
+Unwritten data extents:
+Hole data extents:
+Regular data extents:
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-243/file1
+d0fda5bf5d4fd70904ef1c1c56db28d0  SCRATCH_MNT/test-243/file3
+d0fda5bf5d4fd70904ef1c1c56db28d0  SCRATCH_MNT/test-243/file3.chk
diff --git a/tests/xfs/245 b/tests/xfs/245
new file mode 100755
index 0000000..6da701d
--- /dev/null
+++ b/tests/xfs/245
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 245
+#
+# Make sure that reflink deals with extents going beyond EOF.
+# - fallocate 256k in file1
+# - pwrite 252-257k to cause it to speculatively prealloc file1
+# - reflink file1 to file2
+# - compare file[12]
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
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_cp_reflink
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "falloc 0 256k" -c "pwrite 252k 6k" $testdir/file1 >> $seqres.full
+_scratch_remount
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "Unwritten data extents"
+test $(_xfs_bmapx_find data $testdir/file1 '10000$') -gt 0 || \
+	echo "Expected to find an unwritten file1 extent"
+echo "Shared data extents"
+test $(_xfs_bmapx_find data $testdir/file1 '100000$') -gt 0 || \
+	echo "Expected to find a shared data extent"
+
+echo "Hole data extents"
+test $(_xfs_bmapx_find data $testdir/file2 'hole') -gt 0 || \
+	echo "Expected to find a hole data extent"
+echo "Shared data extents"
+test $(_xfs_bmapx_find data $testdir/file2 '100000$') -gt 0 || \
+	echo "Expected to find a shared data extent"
+
+echo "Hole cow extents"
+test $(_xfs_bmapx_find cow $testdir/file1 'hole') -gt 0 || \
+	echo "Expected to find a hole cow extent"
+echo "Hole cow extents"
+test $(_xfs_bmapx_find cow $testdir/file2 'hole') -gt 0 || \
+	echo "Expected to find a hole cow extent"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/245.out b/tests/xfs/245.out
new file mode 100644
index 0000000..9a5fa5f
--- /dev/null
+++ b/tests/xfs/245.out
@@ -0,0 +1,12 @@
+QA output created by 245
+Format and mount
+Create the original files
+Compare files
+b0b91e1a18165fcd6549f2f5f3ef4823  SCRATCH_MNT/test-245/file1
+b0b91e1a18165fcd6549f2f5f3ef4823  SCRATCH_MNT/test-245/file2
+Unwritten data extents
+Shared data extents
+Hole data extents
+Shared data extents
+Hole cow extents
+Hole cow extents
diff --git a/tests/xfs/246 b/tests/xfs/246
new file mode 100755
index 0000000..13b0c98
--- /dev/null
+++ b/tests/xfs/246
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 246
+#
+# Create an empty file and try to query the (nonexistant) CoW fork.
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
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+touch $testdir/file1
+sync
+
+echo "Dump extents after sync"
+echo "Hole CoW extents:"
+$XFS_IO_PROG -c "bmap -clpv" $testdir/file1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/246.out b/tests/xfs/246.out
new file mode 100644
index 0000000..c543e74
--- /dev/null
+++ b/tests/xfs/246.out
@@ -0,0 +1,6 @@
+QA output created by 246
+Format and mount
+Create the original files
+Dump extents after sync
+Hole CoW extents:
+SCRATCH_MNT/test-246/file1: no extents
diff --git a/tests/xfs/group b/tests/xfs/group
index c0ce1f4..f6c7db8 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -240,7 +240,10 @@
 240 auto quick clone
 241 auto quick clone
 242 auto quick prealloc
+243 auto quick clone
 244 auto quota quick
+245 auto quick clone
+246 auto quick clone
 250 auto quick rw prealloc metadata
 252 auto quick prealloc
 253 auto quick

