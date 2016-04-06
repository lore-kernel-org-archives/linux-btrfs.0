Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50259 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbcDFWME (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Apr 2016 18:12:04 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: generic test for fsync after adding a link and moving other inode
Date: Wed,  6 Apr 2016 23:11:56 +0100
Message-Id: <1459980716-4705-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that if we create a hard link for a file F in some directory A,
then move some directory or file B from its parent directory C into
directory A, fsync file F, power fail and mount the filesystem, the
directory/file B is located only at directory A and both links for
file F exist.

This test is motivated by an issue found in btrfs which is fixed by the
following patch for the linux kernel:

  Btrfs: fix for incorrect directory entries after fsync log replay

Tested against ext3/4, xfs, reiserfs and f2fs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/343     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/343.out | 11 +++++++
 tests/generic/group   |  1 +
 3 files changed, 98 insertions(+)
 create mode 100755 tests/generic/343
 create mode 100644 tests/generic/343.out

diff --git a/tests/generic/343 b/tests/generic/343
new file mode 100755
index 0000000..bc7980c
--- /dev/null
+++ b/tests/generic/343
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FSQA Test No. 343
+#
+# Test that if we create a hard link for a file F in some directory A, then move
+# some directory or file B from its parent directory C into directory A, fsync
+# file F, power fail and mount the filesystem, the directory/file B is located
+# only at directory A and both links for file F exist.
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
+# Create our test directories and files.
+mkdir $SCRATCH_MNT/x
+mkdir $SCRATCH_MNT/y
+touch $SCRATCH_MNT/x/foo
+mkdir $SCRATCH_MNT/y/z
+touch $SCRATCH_MNT/y/foo2
+
+# Make sure everything is durably persisted.
+sync
+
+# Now add a link to foo at directory x, move directory z and file foo2 from
+# directory y to directory x and fsync foo's inode. We expect that after a
+# log replay we see the new link for foo's inode and that z and foo2 are only
+# located at directory x.
+ln $SCRATCH_MNT/x/foo $SCRATCH_MNT/x/bar
+mv $SCRATCH_MNT/y/z $SCRATCH_MNT/x/z
+mv $SCRATCH_MNT/y/foo2 $SCRATCH_MNT/x/foo2
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/x/bar
+_flakey_drop_and_remount
+
+echo "Filesystem contents after log replay:"
+ls -R $SCRATCH_MNT/x $SCRATCH_MNT/y | _filter_scratch
+
+_unmount_flakey
+status=0
+exit
diff --git a/tests/generic/343.out b/tests/generic/343.out
new file mode 100644
index 0000000..4c85f1f
--- /dev/null
+++ b/tests/generic/343.out
@@ -0,0 +1,11 @@
+QA output created by 343
+Filesystem contents after log replay:
+SCRATCH_MNT/x:
+bar
+foo
+foo2
+z
+
+SCRATCH_MNT/x/z:
+
+SCRATCH_MNT/y:
diff --git a/tests/generic/group b/tests/generic/group
index ef1a423..0e5a82e 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -345,3 +345,4 @@
 340 auto
 341 auto quick metadata
 342 auto quick metadata
+343 auto quick metadata
-- 
2.7.0.rc3

