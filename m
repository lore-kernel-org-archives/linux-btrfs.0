Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53781 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBNUJW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 15:09:22 -0500
Received: by mail-wi0-f179.google.com with SMTP id hn9so830713wib.6
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 12:09:20 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: add regression test for btrfs incremental send
Date: Fri, 14 Feb 2014 20:08:42 +0000
Message-Id: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test for a btrfs incremental send issue where we end up sending a
wrong section of data from a file extent if the corresponding file
extent is compressed and the respective file extent item has a non
zero data offset.

Fixed by the following linux kernel btrfs patch:

   Btrfs: use right clone root offset for compressed extents

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/040     |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/040.out |    1 +
 tests/btrfs/group   |    1 +
 3 files changed, 105 insertions(+)
 create mode 100755 tests/btrfs/040
 create mode 100644 tests/btrfs/040.out

diff --git a/tests/btrfs/040 b/tests/btrfs/040
new file mode 100755
index 0000000..c1f3d13
--- /dev/null
+++ b/tests/btrfs/040
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. btrfs/040
+#
+# Test for a btrfs incremental send issue where we end up sending a
+# wrong section of data from a file extent if the corresponding file
+# extent is compressed and the respective file extent item has a non
+# zero data offset.
+#
+# Fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: use right clone root offset for compressed extents
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=`mktemp -d`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+FSSUM_PROG=$here/src/fssum
+[ -x $FSSUM_PROG ] || _notrun "fssum not built"
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount "-o compress-force=lzo"
+
+run_check $XFS_IO_PROG -f -c "truncate 118811" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "fpunch 582007 864596" $SCRATCH_MNT/foo
+run_check $XFS_IO_PROG -c "pwrite -S 0x0d -b 39987 92267 39987" \
+	$SCRATCH_MNT/foo
+
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+	$SCRATCH_MNT/mysnap1
+
+run_check $XFS_IO_PROG -c "pwrite -S 0xe1 -b 38804 1119395 38804" \
+	$SCRATCH_MNT/foo
+run_check $XFS_IO_PROG -c "pwrite -S 0x0e -b 41125 80802 41125" \
+	$SCRATCH_MNT/foo
+
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+	$SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
+	$SCRATCH_MNT/mysnap2
+
+run_check $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+run_check $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $tmp/2.snap
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
+run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1 2>> $seqres.full
+
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
+run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2 2>> $seqres.full
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+status=0
+exit
diff --git a/tests/btrfs/040.out b/tests/btrfs/040.out
new file mode 100644
index 0000000..7740549
--- /dev/null
+++ b/tests/btrfs/040.out
@@ -0,0 +1 @@
+QA output created by 040
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 2ca2225..a687634 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -38,3 +38,4 @@
 033 auto quick
 034 auto quick
 036 auto quick
+040 auto quick
-- 
1.7.9.5

