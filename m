Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37905 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756548AbbAFUVe (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Tue, 6 Jan 2015 15:21:34 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: add generic test for fsync after unlink
Date: Tue,  6 Jan 2015 20:21:20 +0000
Message-Id: <1420575680-9809-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by an fsync issue discovered in btrfs.
The issue was that after fsyncing an inode that got its link count
decremented, and the new link count is greater than zero, after the
fsync log replay the inode's parent directory metadata became
inconsistent - it had a wrong i_size which prevented the directory
from ever being removed (rmdir always failed with -ENOTEMPTY, even
if the directory had no more child inodes).

The btrfs issue was fixed by the following linux kernel patch:

    Btrfs: fix directory inconsistency after fsync log replay

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/039     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/039.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 105 insertions(+)
 create mode 100755 tests/generic/039
 create mode 100644 tests/generic/039.out

diff --git a/tests/generic/039 b/tests/generic/039
new file mode 100755
index 0000000..85646f9
--- /dev/null
+++ b/tests/generic/039
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 039
+#
+# This test is motivated by an fsync issue discovered in btrfs.
+# The issue was that after fsyncing an inode that got its link count
+# decremented, and the new link count is greater than zero, after the
+# fsync log replay the inode's parent directory metadata became
+# inconsistent - it had a wrong i_size which prevented the directory
+# from ever being removed (rmdir always failed with -ENOTEMPTY, even
+# if the directory had no more child inodes).
+#
+# The btrfs issue was fixed by the following linux kernel patch:
+#
+#    Btrfs: fix directory inconsistency after fsync log replay
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
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
+here=`pwd`
+status=1	# failure is the default!
+
+_cleanup()
+{
+	_cleanup_flakey
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_dm_flakey
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+_init_flakey
+_mount_flakey
+
+# Create a test file with 2 hard links.
+mkdir -p $SCRATCH_MNT/a/b
+echo "hello world" > $SCRATCH_MNT/a/b/foo
+ln $SCRATCH_MNT/a/b/foo $SCRATCH_MNT/a/b/bar
+
+# Make sure all metadata and data are durably persisted.
+sync
+
+# Now remove one of the hard links and fsync the inode.
+rm -f $SCRATCH_MNT/a/b/bar
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/b/foo
+
+# Simulate a crash/power loss. This makes sure the next mount
+# will see an fsync log and will replay that log.
+
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+# Remove the last hard link of the file and attempt to remove its parent
+# directory - this failed in btrfs because the fsync log and replay code
+# didn't decrement the parent directory's i_size - this made the btrfs
+# rmdir implementation always fail with -ENOTEMPTY.
+#
+# The parent directory's metadata inconsistency was also detected by btrfs'
+# fsck tool, which is run automatically by the fstests framework when the
+# test finishes.
+rm -f $SCRATCH_MNT/a/b/foo
+rmdir $SCRATCH_MNT/a/b
+rmdir $SCRATCH_MNT/a
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/039.out b/tests/generic/039.out
new file mode 100644
index 0000000..d4e7ef6
--- /dev/null
+++ b/tests/generic/039.out
@@ -0,0 +1,2 @@
+QA output created by 039
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 1e89848..6af5a1a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -41,6 +41,7 @@
 036 auto aio rw stress
 037 metadata auto quick
 038 auto stress
+039 metadata auto quick
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
2.1.3

