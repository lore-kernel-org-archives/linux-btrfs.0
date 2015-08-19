Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54764 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbbHSKMS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 06:12:18 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: btrfs regression test for fsync after extent cloning
Date: Wed, 19 Aug 2015 11:12:08 +0100
Message-Id: <1439979128-14169-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that if we fsync a file that got one extent partially cloned into a
lower file offset, after a power failure our file has the same content it
had before the power failure and after the extent cloning operation.

This test is motivated by an issue found in btrfs that is fixed by the
linux kernel patch titled:

  "Btrfs: fix file read corruption after extent cloning and fsync"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/098     | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/098.out |   7 +++
 tests/btrfs/group   |   1 +
 3 files changed, 131 insertions(+)
 create mode 100755 tests/btrfs/098
 create mode 100644 tests/btrfs/098.out

diff --git a/tests/btrfs/098 b/tests/btrfs/098
new file mode 100755
index 0000000..c412c73
--- /dev/null
+++ b/tests/btrfs/098
@@ -0,0 +1,123 @@
+#! /bin/bash
+# FSQA Test No. 098
+#
+# Test that if we fsync a file that got one extent partially cloned into a
+# lower file offset, after a power failure our file has the same content it
+# had before the power failure and after the extent cloning operation.
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
+# Create our test file with a single 100K extent starting at file offset 800K.
+# We fsync the file here to make the fsync log tree gets a single csum item that
+# covers the whole 100K extent, which causes the second fsync, done after the
+# cloning operation below, to not leave in the log tree two csum items covering
+# two sub-ranges ([0, 20K[ and [20K, 100K[)) of our extent.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 800K 100K"  \
+		-c "fsync"                     \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Now clone part of our extent into file offset 400K. This adds a file extent
+# item to our inode's metadata that points to the 100K extent we created before,
+# using a data offset of 20K and a data length of 20K, so that it refers to
+# the sub-range [20K, 40K[ of our original extent.
+$CLONER_PROG -s $((800 * 1024 + 20 * 1024)) -d $((400 * 1024)) \
+	-l $((20 * 1024)) $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+# Now fsync our file to make sure the extent cloning is durably persisted. This
+# fsync will not add a second csum item to the log tree containing the checksums
+# for the blocks in the sub-range [20K, 40K[ of our extent, because there was
+# already a csum item in the log tree covering the whole extent, added by the
+# first fsync we did before.
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
+# The fsync log replay first processes the file extent item corresponding to the
+# file offset 400K (the one which refers to the [20K, 40K[ sub-range of our 100K
+# extent) and then processes the file extent item for file offset 800K. It used
+# to happen that when processing the later, it erroneously left in the csum tree
+# 2 csum items that overlapped each other, 1 for the sub-range [20K, 40K[ and 1
+# for the whole range of our extent. This introduced a problem where subsequent
+# lookups for the checksums of blocks within the range [40K, 100K[ of our extent
+# would not find anything because lookups in the csum tree ended up looking only
+# at the smaller csum item, the one covering the subrange [20K, 40K[. This made
+# read requests assume an expected checksum with a value of 0 for those blocks,
+# which caused checksum verification failure when the read operations finished.
+# However those checksum failure did not result in read requests returning an
+# error to user space (like -EIO for e.g.) because the expected checksum value
+# had the special value 0, and in that case btrfs set all bytes of the
+# corresponding pages with the value 0x01 and produce the following warning in
+# dmesg/syslog:
+#
+#  "BTRFS warning (device dm-0): csum failed ino 257 off 917504 csum 1322675045\
+#    expected csum 0"
+#
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+echo "File digest after log replay:"
+# Must match the same digest he had after cloning the extent and before the
+# power failure happened.
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/btrfs/098.out b/tests/btrfs/098.out
new file mode 100644
index 0000000..3aa0772
--- /dev/null
+++ b/tests/btrfs/098.out
@@ -0,0 +1,7 @@
+QA output created by 098
+wrote 102400/102400 bytes at offset 819200
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest before power failure:
+39b386375971248740ed8651d5a2ed9f  SCRATCH_MNT/foo
+File digest after log replay:
+39b386375971248740ed8651d5a2ed9f  SCRATCH_MNT/foo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e13865a..13cf0d7 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -100,3 +100,4 @@
 095 auto quick metadata
 096 auto quick clone
 097 auto quick send clone
+098 auto quick metadata clone
-- 
2.1.3

