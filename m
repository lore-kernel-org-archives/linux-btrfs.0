Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49654 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbbGIXrd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 19:47:33 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com,
        Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: btrfs test to exercise shared extent reference accounting
Date: Thu,  9 Jul 2015 15:51:13 +0100
Message-Id: <1436453473-27509-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Regression test for adding and dropping an equal number of references
for file extents. Verify that if we drop N references for a file extent
and we add too N new references for that same file extent in the same
transaction, running the delayed references (which always happens at
transaction commit time) does not fail.

The regression was introduced in the 4.2-rc1 Linux kernel and fixed by
the patch titled: "Btrfs: fix order by which delayed references are run".

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/095     | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/095.out |   9 ++++
 tests/btrfs/group   |   1 +
 3 files changed, 163 insertions(+)
 create mode 100755 tests/btrfs/095
 create mode 100644 tests/btrfs/095.out

diff --git a/tests/btrfs/095 b/tests/btrfs/095
new file mode 100755
index 0000000..e68f2bf
--- /dev/null
+++ b/tests/btrfs/095
@@ -0,0 +1,153 @@
+#! /bin/bash
+# FSQA Test No. 095
+#
+# Regression test for adding and dropping an equal number of references for
+# file extents. Verify that if we drop N references for a file extent and we
+# add too N new references for that same file extent in the same transaction,
+# running the delayed references (always happens at transaction commit time)
+# does not fail.
+#
+# The regression was introduced in the 4.2-rc1 Linux kernel.
+#
+#-----------------------------------------------------------------------
+#
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_dm_flakey
+_require_cloner
+_require_metadata_journaling $SCRATCH_DEV
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+# Create prealloc extent covering range [160K, 620K[
+$XFS_IO_PROG -f -c "falloc 160K 460K" $SCRATCH_MNT/foo
+
+# Now write to the last 80K of the prealloc extent plus 40K to the unallocated
+# space that immediately follows it. This creates a new extent of 40K that spans
+# the range [620K, 660K[.
+$XFS_IO_PROG -c "pwrite -S 0xaa 540K 120K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# At this point, there are now 2 back references to the prealloc extent in our
+# extent tree. Both are for our file offset 160K and one relates to a file
+# extent item with a data offset of 0 and a length of 380K, while the other
+# relates to a file extent item with a data offset of 380K and a length of 80K.
+
+# Make sure everything done so far is durably persisted (all back references are
+# in the extent tree, etc).
+sync
+
+# Now clone all extents of our file that cover the offset 160K up to its eof
+# (660K at this point) into itself at offset 2M. This leaves a hole in the file
+# covering the range [660K, 2M[. The prealloc extent will now be referenced by
+# the file twice, once for offset 160K and once for offset 2M. The 40K extent
+# that follows the prealloc extent will also be referenced twice by our file,
+# once for offset 620K and once for offset 2M + 460K.
+$CLONER_PROG -s $((160 * 1024)) -d $((2 * 1024 * 1024)) -l 0 $SCRATCH_MNT/foo \
+	$SCRATCH_MNT/foo
+
+# Now create one new extent in our file with a size of 100Kb. It will span the
+# range [3M, 3M + 100K[. It also will cause creation of a hole spanning the
+# range [2M + 460K, 3M[. Our new file size is 3M + 100K.
+$XFS_IO_PROG -c "pwrite -S 0xbb 3M 100K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# At this point, there are now (in memory) 4 back references to the prealloc
+# extent.
+#
+# Two of them are for file offset 160K, related to file extent items
+# matching the file offsets 160K and 540K respectively, with data offsets of
+# 0 and 380K respectively, and with lengths of 380K and 80K respectively.
+#
+# The other two references are for file offset 2M, related to file extent items
+# matching the file offsets 2M and 2M + 380K respectively, with data offsets of
+# 0 and 380K respectively, and with lengths of 389K and 80K respectively.
+#
+# The 40K extent has 2 back references, one for file offset 620K and the other
+# for file offset 2M + 460K.
+#
+# The 100K extent has a single back reference and it relates to file offset 3M.
+
+# Now clone our 100K extent into offset 600K. That offset covers the last 20K
+# of the prealloc extent, the whole 40K extent and 40K of the hole starting at
+# offset 660K.
+$CLONER_PROG -s $((3 * 1024 * 1024)) -d $((600 * 1024)) -l $((100 * 1024)) \
+	$SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+# At this point there's only one reference to the 40K extent, at file offset
+# 2M + 460K, we have 4 references for the prealloc extent (2 for file offset
+# 160K and 2 for file offset 2M) and 2 references for the 100K extent (1 for
+# file offset 3M and a new one for file offset 600K).
+
+# Now fsync our file to make all its new data and metadata updates are durably
+# persisted and present if a power failure/crash happens after a successful
+# fsync and before the next transaction commit.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
+
+echo "File digest before power failure:"
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+# Silently drop all writes and ummount to simulate a crash/power failure.
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+# Allow writes again, mount to trigger log replay and validate file contents.
+# During log replay, the btrfs delayed references implementation used to run the
+# deletion of back references before the addition of new back references, which
+# made the addition fail as it didn't find the key in the extent tree that it
+# was looking for. The failure triggered by this test was related to the 40K
+# extent, which got 1 reference dropped and 1 reference added during the fsync
+# log replay - when running the delayed references at transaction commit time,
+# btrfs was applying the deletion before the insertion, resulting in a failure
+# of the insertion that ended up turning the fs into read-only mode.
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+echo "File digest after log replay:"
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/btrfs/095.out b/tests/btrfs/095.out
new file mode 100644
index 0000000..e93435c
--- /dev/null
+++ b/tests/btrfs/095.out
@@ -0,0 +1,9 @@
+QA output created by 095
+wrote 122880/122880 bytes at offset 552960
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 102400/102400 bytes at offset 3145728
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest before power failure:
+beaf47c36659ac29bb9363fb8ffa10a1  SCRATCH_MNT/foo
+File digest after log replay:
+beaf47c36659ac29bb9363fb8ffa10a1  SCRATCH_MNT/foo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index ffe18bf..79feea9 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -96,3 +96,4 @@
 092 auto quick send
 093 auto quick clone
 094 auto quick send
+095 auto quick metadata
-- 
2.1.3

