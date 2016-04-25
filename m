Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41332 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbcDZOEQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 10:04:16 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: test creating a symlink and then fsync its parent directory
Date: Mon, 25 Apr 2016 05:26:23 +0100
Message-Id: <1461558383-32254-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test creating a symlink, fsync its parent directory, power fail and mount
again the filesystem. After these steps the symlink should exist and its
content must match what we specified when we created it (must not be
empty or point to something else).

This is motivated by an issue in btrfs where after the log replay happens
we get empty symlinks, which not only does not make much sense from a
user's point of view, it's also not valid to have empty links in linux
(wgich is explicitly forbidden by the symlink(2) system call).

The issue in btrfs is fixed by the following patch for the linux kernel:

  "Btrfs: fix empty symlink after creating symlink and fsync parent dir"

Tested against ext3, ext4, xfs, f2fs, reiserfs and nilfs2.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/344     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/344.out |  4 +++
 tests/generic/group   |  1 +
 3 files changed, 89 insertions(+)
 create mode 100755 tests/generic/344
 create mode 100644 tests/generic/344.out

diff --git a/tests/generic/344 b/tests/generic/344
new file mode 100755
index 0000000..5dcf130
--- /dev/null
+++ b/tests/generic/344
@@ -0,0 +1,84 @@
+#! /bin/bash
+# FSQA Test No. 344
+#
+# Test creating a symlink, fsync its parent directory, power fail and mount
+# again the filesystem. After these steps the symlink should exist and its
+# content must match what we specified when we created it (must not be empty
+# or point to something else).
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
+mkdir $SCRATCH_MNT/testdir1
+# Make sure it's durably persisted.
+sync
+
+# Create our symlinks and fsync their parent directories.
+# We test both the case where the parent directory is new (not yet durably
+# persisted) and where the parent existed long time before.
+ln -s $SCRATCH_MNT/foo1 $SCRATCH_MNT/testdir1/bar1
+$XFS_IO_PROG -c fsync $SCRATCH_MNT/testdir1
+mkdir $SCRATCH_MNT/testdir2
+ln -s $SCRATCH_MNT/foo2 $SCRATCH_MNT/testdir2/bar2
+$XFS_IO_PROG -c fsync $SCRATCH_MNT/testdir2
+
+# After a power failure and mounting again the filesystem, we expect to see the
+# symlinks and we expect them to point to foo1 and foo2.
+_flakey_drop_and_remount
+
+echo "Symlink contents after log replay:"
+readlink $SCRATCH_MNT/testdir1/bar1 | _filter_scratch
+readlink $SCRATCH_MNT/testdir2/bar2 | _filter_scratch
+
+_unmount_flakey
+status=0
+exit
diff --git a/tests/generic/344.out b/tests/generic/344.out
new file mode 100644
index 0000000..0468b9c
--- /dev/null
+++ b/tests/generic/344.out
@@ -0,0 +1,4 @@
+QA output created by 344
+Symlink contents after log replay:
+SCRATCH_MNT/foo1
+SCRATCH_MNT/foo2
diff --git a/tests/generic/group b/tests/generic/group
index 0e5a82e..7ec82db 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -346,3 +346,4 @@
 341 auto quick metadata
 342 auto quick metadata
 343 auto quick metadata
+344 auto quick metadata
-- 
2.7.0.rc3

