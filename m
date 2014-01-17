Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18324 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaAQNDI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 08:03:08 -0500
From: Koen De Wit <koen.de.wit@oracle.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, Koen De Wit <koen.de.wit@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH RESEND] xfstests: btrfs/030: sparse copy between different filesystems/mountpoints
Date: Fri, 17 Jan 2014 14:02:57 +0100
Message-Id: <1389963777-29051-1-git-send-email-koen.de.wit@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check if creating a sparse copy ("reflink") of a file on btrfs
expectedly fails when it's done between different filesystems or
different mount points of the same filesystem.

For both situations, these actions are executed:
   - Copy a file with the reflink=auto option.
     A normal copy should be created.
   - Copy a file with the reflink=always option. Should result in
     error.

[sandeen: mostly cosmetic changes]

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Originally submitted as test 301, btrfs/311

The functions _require_cp_reflink() and _verify_reflink() in common/rc
have been submitted with btrfs/027

diff --git a/tests/btrfs/030 b/tests/btrfs/030
new file mode 100644
index 0000000..7bbc89a
--- /dev/null
+++ b/tests/btrfs/030
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 030
+#
+# Check if creating a sparse copy ("reflink") of a file on btrfs
+# expectedly fails when it's done between different filesystems or
+# different mount points of the same filesystem.
+#
+# For both situations, these actions are executed:
+#    - Copy a file with the reflink=auto option.
+#      A normal copy should be created.
+#    - Copy a file with the reflink=always option. Should result in
+#      error.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
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
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    umount $SCRATCH_MNT &>/dev/null
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+
+_require_scratch
+_require_cp_reflink
+
+SOURCE_DIR=$TEST_DIR/test-$seq
+CROSS_DEV_DIR=$SCRATCH_MNT/test-$seq
+# mount point & target for twice-mounted device
+TEST_DIR2=$TEST_DIR/mount2
+DUAL_MOUNT_DIR=$SCRATCH_MNT/test-bis-$seq
+
+rm -rf $SOURCE_DIR
+mkdir $SOURCE_DIR
+
+rm -f $seqres.full
+
+_scratch_mkfs
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $SOURCE_DIR/original \
+ >> $seqres.full
+
+_filter_testdirs()
+{
+    _filter_test_dir | _filter_scratch
+}
+
+_create_reflinks_to()
+{
+    # auto reflink, should fall back to non-reflink
+    rm -rf $1; mkdir $1
+    echo "reflink=auto:"
+    cp --reflink=auto $SOURCE_DIR/original $1/copy
+    md5sum $SOURCE_DIR/original | _filter_testdirs
+    md5sum $1/copy | _filter_testdirs
+
+    # always reflink, should fail outright
+    rm -rf $1; mkdir $1
+    echo "reflink=always:"
+    cp --reflink=always $SOURCE_DIR/original $1/copyfail \
+        2>&1 | _filter_testdirs
+
+    # The failed target actually gets created by cp:
+    ls $1/copyfail | _filter_testdirs
+}
+
+echo "test reflinks across different devices"
+_scratch_mount
+_create_reflinks_to $CROSS_DEV_DIR
+_scratch_unmount
+
+echo "test reflinks across different mountpoints of same device"
+mount $TEST_DEV $SCRATCH_MNT || _fail "Couldn't double-mount $TEST_DEV"
+_create_reflinks_to $DUAL_MOUNT_DIR
+umount $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/030.out b/tests/btrfs/030.out
new file mode 100644
index 0000000..923a6e1
--- /dev/null
+++ b/tests/btrfs/030.out
@@ -0,0 +1,15 @@
+QA output created by 030
+test reflinks across different devices
+reflink=auto:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-030/original
+42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/test-030/copy
+reflink=always:
+cp: failed to clone 'SCRATCH_MNT/test-030/copyfail': Invalid cross-device link
+SCRATCH_MNT/test-030/copyfail
+test reflinks across different mountpoints of same device
+reflink=auto:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-030/original
+42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/test-bis-030/copy
+reflink=always:
+cp: failed to clone 'SCRATCH_MNT/test-bis-030/copyfail': Invalid cross-device link
+SCRATCH_MNT/test-bis-030/copyfail
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 87e7bca..9231f7b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -27,3 +27,4 @@
 022 auto
 023 auto
 024 auto quick
+030 auto quick
-- 
1.7.1

