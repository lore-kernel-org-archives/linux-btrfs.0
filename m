Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34138 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbcC3JjR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 05:39:17 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2] fstests: generic test for fsync after renaming file
Date: Wed, 30 Mar 2016 10:39:10 +0100
Message-Id: <1459330750-3284-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that if we rename a file, create a new file that has the old name
of the other file and is a child of the same parent directory, fsync the
new inode, power fail and mount the filesystem, we do not lose the first
file and that file has the name it was renamed to.

This test is motivated by an issue found in btrfs which is fixed by the
following patch for the linux kernel:

  "Btrfs: fix file loss caused by fsync after rename and new inode"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/341     | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/341.out | 15 +++++++++
 tests/generic/group   |  1 +
 3 files changed, 106 insertions(+)
 create mode 100755 tests/generic/341
 create mode 100644 tests/generic/341.out

diff --git a/tests/generic/341 b/tests/generic/341
new file mode 100755
index 0000000..b70bd95
--- /dev/null
+++ b/tests/generic/341
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FSQA Test No. 341
+#
+# Test that if we rename a file, create a new file that has the old name of the
+# other file and is a child of the same parent directory, fsync the new inode,
+# power fail and mount the filesystem, we do not lose the first file and that
+# file has the name it was renamed to.
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
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
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_dm_target flakey
+_require_metadata_journaling $SCRATCH_DEV
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+mkdir $SCRATCH_MNT/a
+$XFS_IO_PROG -f -c "pwrite -S 0xf1 0 16K" $SCRATCH_MNT/a/foo | _filter_xfs_io
+# Make sure everything done so far is durably persisted.
+sync
+
+# Now rename file foo to bar and create a new file named foo under the same
+# directory. After a power failure we must see the two files.
+mv $SCRATCH_MNT/a/foo $SCRATCH_MNT/a/bar
+$XFS_IO_PROG -f -c "pwrite -S 0xba 0 16K" $SCRATCH_MNT/a/foo | _filter_xfs_io
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/foo
+
+echo "File digests before log replay:"
+md5sum $SCRATCH_MNT/a/foo | _filter_scratch
+md5sum $SCRATCH_MNT/a/bar | _filter_scratch
+
+# Simulate a power failure and mount again the filesystem to trigger replay of
+# its journal/log.
+_flakey_drop_and_remount
+
+echo "Directory a/ contents after log replay:"
+ls -R $SCRATCH_MNT/a | _filter_scratch
+
+echo "File digests after log replay:"
+# Must match what we got before the power failure.
+md5sum $SCRATCH_MNT/a/foo | _filter_scratch
+md5sum $SCRATCH_MNT/a/bar | _filter_scratch
+
+_unmount_flakey
+status=0
+exit
diff --git a/tests/generic/341.out b/tests/generic/341.out
new file mode 100644
index 0000000..29c3566
--- /dev/null
+++ b/tests/generic/341.out
@@ -0,0 +1,15 @@
+QA output created by 341
+wrote 16384/16384 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 16384/16384 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests before log replay:
+9e5d56a1f9b2c93589f9d55480f971a1  SCRATCH_MNT/a/foo
+48c940ba3b8671d3d6ea74e4ccad8ca3  SCRATCH_MNT/a/bar
+Directory a/ contents after log replay:
+SCRATCH_MNT/a:
+bar
+foo
+File digests after log replay:
+9e5d56a1f9b2c93589f9d55480f971a1  SCRATCH_MNT/a/foo
+48c940ba3b8671d3d6ea74e4ccad8ca3  SCRATCH_MNT/a/bar
diff --git a/tests/generic/group b/tests/generic/group
index baaffdf..3ece496 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -343,3 +343,4 @@
 338 auto quick rw
 339 auto dir
 340 auto quick metadata
+341 auto quick metadata
-- 
2.7.0.rc3

