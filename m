Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34106 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbcC3JjD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 05:39:03 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/2] fstests: generic test for fsync after renaming directory
Date: Wed, 30 Mar 2016 10:38:42 +0100
Message-Id: <1459330722-3227-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that if we rename a directory, create a new file or directory that
has the old name of our former directory and is a child of the same
parent directory, fsync the new inode, power fail and mount the
filesystem, we see our first directory with the new name and no files
under it were lost.

This test is motivated by an issue found in btrfs which is fixed by the
following patch for the linux kernel:

  "Btrfs: fix file loss caused by fsync after rename and new inode"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/340     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/340.out | 21 ++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 115 insertions(+)
 create mode 100755 tests/generic/340
 create mode 100644 tests/generic/340.out

diff --git a/tests/generic/340 b/tests/generic/340
new file mode 100755
index 0000000..6fe6ee7
--- /dev/null
+++ b/tests/generic/340
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FSQA Test No. 340
+#
+# Test that if we rename a directory, create a new file or directory that has
+# the old name of our former directory and is a child of the same parent
+# directory, fsync the new inode, power fail and mount the filesystem, we see
+# our first directory with the new name and no files under it were lost.
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
+mkdir -p $SCRATCH_MNT/a/x
+$XFS_IO_PROG -f -c "pwrite -S 0xaf 0 32K" $SCRATCH_MNT/a/x/foo | _filter_xfs_io
+$XFS_IO_PROG -f -c "pwrite -S 0xba 0 32K" $SCRATCH_MNT/a/x/bar | _filter_xfs_io
+# Make sure everything done so far is durably persisted.
+sync
+
+echo "File digests before power failure:"
+md5sum $SCRATCH_MNT/a/x/foo | _filter_scratch
+md5sum $SCRATCH_MNT/a/x/bar | _filter_scratch
+
+# Now rename directory x to y and create a new directory that is also named x.
+# Then fsync the new directory. After a power failure, we must see directories
+# y and x and directory y has the same files (and with the same content) it had
+# before the power failure.
+mv $SCRATCH_MNT/a/x $SCRATCH_MNT/a/y
+mkdir $SCRATCH_MNT/a/x
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/x
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
+md5sum $SCRATCH_MNT/a/y/foo | _filter_scratch
+md5sum $SCRATCH_MNT/a/y/bar | _filter_scratch
+
+_unmount_flakey
+status=0
+exit
diff --git a/tests/generic/340.out b/tests/generic/340.out
new file mode 100644
index 0000000..f2fe4ca
--- /dev/null
+++ b/tests/generic/340.out
@@ -0,0 +1,21 @@
+QA output created by 340
+wrote 32768/32768 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests before power failure:
+b6ef98c3df97dfc5ff17266311c2fb9e  SCRATCH_MNT/a/x/foo
+41107c24d306bdc4fecac4007e9aa214  SCRATCH_MNT/a/x/bar
+Directory a/ contents after log replay:
+SCRATCH_MNT/a:
+x
+y
+
+SCRATCH_MNT/a/x:
+
+SCRATCH_MNT/a/y:
+bar
+foo
+File digests after log replay:
+b6ef98c3df97dfc5ff17266311c2fb9e  SCRATCH_MNT/a/y/foo
+41107c24d306bdc4fecac4007e9aa214  SCRATCH_MNT/a/y/bar
diff --git a/tests/generic/group b/tests/generic/group
index cd2a2b7..baaffdf 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -342,3 +342,4 @@
 337 auto quick metadata
 338 auto quick rw
 339 auto dir
+340 auto quick metadata
-- 
2.7.0.rc3

