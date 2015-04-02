Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39554 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752626AbbDBKuY (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 2 Apr 2015 06:50:24 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] fstests: regression test for btrfs file range cloning
Date: Thu,  2 Apr 2015 11:49:29 +0100
Message-Id: <1427971769-13224-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1427481068-27414-1-git-send-email-fdmanana@suse.com>
References: <1427481068-27414-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test btrfs file range cloning with the same file as a source and
destination.

This tests a specific scenario where the extent layout of the file
confused the clone ioctl implementation making it return -EEXIST to
userspace. This issue was fixed by the following linux kernel patch:

   Btrfs: fix range cloning when same inode used as source and destination

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Rebased against latest master, which implied changing the test's number,
    and added steps to test for the case where different source and destination
    files are used, just to verify if produces exactly the same result as the
    case where the same file is used as source and destination.

 tests/btrfs/088     | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/088.out |  20 +++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 141 insertions(+)
 create mode 100755 tests/btrfs/088
 create mode 100644 tests/btrfs/088.out

diff --git a/tests/btrfs/088 b/tests/btrfs/088
new file mode 100755
index 0000000..ac0a459
--- /dev/null
+++ b/tests/btrfs/088
@@ -0,0 +1,120 @@
+#! /bin/bash
+# FS QA Test No. btrfs/088
+#
+# Test btrfs file range cloning with the same file as a source and destination.
+#
+# This tests a specific scenario where the extent layout of the file confused
+# the clone ioctl implementation making it return -EEXIST to userspace.
+# This issue was fixed by the following linux kernel patch:
+#
+#    Btrfs: fix range cloning when same inode used as source and destination
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
+# Author: Filipe Manana <fdmanana@suse.com>
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
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
+_require_cloner
+_need_to_be_root
+
+rm -f $seqres.full
+
+# Create a file with an extent layout that confused the btrfs clone ioctl
+# implementation. The first extent item that is cloned by the second call
+# to the cloner program will have only a trailing part of it referenced by
+# a new extent item, since the source offset starts in the middle of that
+# extent. This confused the clone ioctl because after inserting this new
+# extent item it would immediately after process it again thinking it
+# corresponded to an extent that existed before - this made it attempt to
+# insert a duplicated extent item pointing to the same extent again, which
+# made it return an -EEXIST error to userspace and turn the filesystem to
+# readonly mode (since the current transaction got aborted).
+test_clone()
+{
+	local bs=$1
+
+	$XFS_IO_PROG -f -c "pwrite -S 0xaa $((2 * $bs)) $((2 * $bs))" \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+
+	$CLONER_PROG -s $((3 * $bs)) -d $((267 * $bs)) -l 0 $SCRATCH_MNT/foo \
+		$SCRATCH_MNT/foo
+	$CLONER_PROG -s $((217 * $bs)) -d $((95 * $bs)) -l 0 $SCRATCH_MNT/foo \
+		$SCRATCH_MNT/foo
+
+	echo "File digest after clone operations using same file as source and destination"
+	md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+	# Test cloning using different source and destination files for the
+	# same exact data - it must produce the exact same result as the case
+	# before.
+	$XFS_IO_PROG -f -c "pwrite -S 0xaa $((2 * $bs)) $((2 * $bs))" \
+		$SCRATCH_MNT/a | _filter_xfs_io
+	cp $SCRATCH_MNT/a $SCRATCH_MNT/b
+
+	$CLONER_PROG -s $((3 * $bs)) -d $((267 * $bs)) -l 0 $SCRATCH_MNT/a \
+		$SCRATCH_MNT/b
+
+	cp $SCRATCH_MNT/b $SCRATCH_MNT/foo2
+	$CLONER_PROG -s $((217 * $bs)) -d $((95 * $bs)) -l 0 $SCRATCH_MNT/b \
+		$SCRATCH_MNT/foo2
+
+	echo "File digest after clone operations using different files as source and destination"
+	md5sum $SCRATCH_MNT/foo2 | _filter_scratch
+
+}
+
+# Make sure the test passes offsets and lengths to the btrfs clone ioctl that
+# are multiples of the fs block size. Currently the block size on btrfs must
+# be a multiple of the page size, so use a 64Kb fs block size in order to be
+# able to test on every platform supported by linux.
+bs=$((64 * 1024))
+
+echo "Testing without the no-holes feature"
+_scratch_mkfs "-O ^no-holes -l $bs" >>$seqres.full 2>&1
+_scratch_mount
+test_clone $bs
+_check_scratch_fs
+
+echo -e "\nTesting with the no-holes feature"
+_scratch_unmount
+_scratch_mkfs "-O no-holes -l $bs" >>$seqres.full 2>&1
+_scratch_mount
+test_clone $bs
+
+status=0
+exit
diff --git a/tests/btrfs/088.out b/tests/btrfs/088.out
new file mode 100644
index 0000000..50f49d7
--- /dev/null
+++ b/tests/btrfs/088.out
@@ -0,0 +1,20 @@
+QA output created by 088
+Testing without the no-holes feature
+wrote 131072/131072 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest after clone operations using same file as source and destination
+cc3cc722ad761bd10488a0f1232ead19  SCRATCH_MNT/foo
+wrote 131072/131072 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest after clone operations using different files as source and destination
+cc3cc722ad761bd10488a0f1232ead19  SCRATCH_MNT/foo2
+
+Testing with the no-holes feature
+wrote 131072/131072 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest after clone operations using same file as source and destination
+cc3cc722ad761bd10488a0f1232ead19  SCRATCH_MNT/foo
+wrote 131072/131072 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest after clone operations using different files as source and destination
+cc3cc722ad761bd10488a0f1232ead19  SCRATCH_MNT/foo2
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 4bed1db..73ef2ea 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -90,3 +90,4 @@
 085 auto quick metadata subvol
 086 auto quick clone
 087 auto quick send
+088 auto quick clone
-- 
2.1.3

