Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:49058 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaBCQjm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Feb 2014 11:39:42 -0500
Received: by mail-we0-f176.google.com with SMTP id q58so2500954wes.35
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Feb 2014 08:39:41 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH RESEND] xfstests: add test for btrfs incremental send data corruption
Date: Mon,  3 Feb 2014 16:39:20 +0000
Message-Id: <1391445560-3737-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs incremental send had an issue where it would detect a non-existent
file hole and then overwrite the file section that hole covers with zeroes,
overriding file data that it shouldn't.

The respective btrfs kernel patch that fixed this issue is titled:

   Btrfs: fix send file hole detection leading to data corruption
   (https://patchwork.kernel.org/patch/3544831/)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---

This is a patch resend, without any changes to the test, since Dave Chinner told
in his last e-mail to resend any patches that he might have missed on the last
patch merge party.

 tests/btrfs/034     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/034.out |    6 +++
 tests/btrfs/group   |    1 +
 3 files changed, 108 insertions(+)
 create mode 100755 tests/btrfs/034
 create mode 100644 tests/btrfs/034.out

diff --git a/tests/btrfs/034 b/tests/btrfs/034
new file mode 100755
index 0000000..db792de
--- /dev/null
+++ b/tests/btrfs/034
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test No. btrfs/034
+#
+# Test for a btrfs incremental send data corruption issue due to
+# bad detection of file holes.
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
+tmp=`mktemp -d`
+
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
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# Create a file such that its file extent items span at least 3 btree leafs.
+# This is necessary to trigger a btrfs incremental send bug where file hole
+# detection was not correct, leading to data corruption by overriding latest
+# data regions of a file with zeroes.
+
+run_check $XFS_IO_PROG -f -c "truncate 104857600" $SCRATCH_MNT/foo
+
+for ((i = 0; i < 940; i++))
+do
+    OFFSET=$((32768 + i * 8192))
+    LEN=$((OFFSET + 8192))
+    run_check $XFS_IO_PROG -c "falloc -k $OFFSET $LEN" $SCRATCH_MNT/foo
+    run_check $XFS_IO_PROG -c "pwrite -S 0xf0 $OFFSET 4096" $SCRATCH_MNT/foo
+done
+
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+    $SCRATCH_MNT/mysnap1
+
+run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+run_check $XFS_IO_PROG -c "truncate 3882008" $SCRATCH_MNT/foo
+
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+    $SCRATCH_MNT/mysnap2
+
+run_check $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+run_check $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+    -f $tmp/2.snap
+
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
+md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
+
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+status=0
+exit
diff --git a/tests/btrfs/034.out b/tests/btrfs/034.out
new file mode 100644
index 0000000..808e6b4
--- /dev/null
+++ b/tests/btrfs/034.out
@@ -0,0 +1,6 @@
+QA output created by 034
+9023ed93111c422d82e9cd54043a6fb0  SCRATCH_MNT/foo
+8e58ce8749d203f29f6b8f6990da722f  SCRATCH_MNT/mysnap1/foo
+9023ed93111c422d82e9cd54043a6fb0  SCRATCH_MNT/mysnap2/foo
+8e58ce8749d203f29f6b8f6990da722f  SCRATCH_MNT/mysnap1/foo
+9023ed93111c422d82e9cd54043a6fb0  SCRATCH_MNT/mysnap2/foo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index b29236c..f9f062f 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -36,3 +36,4 @@
 031 auto quick
 032 auto quick
 033 auto quick
+034 auto quick
-- 
1.7.9.5

