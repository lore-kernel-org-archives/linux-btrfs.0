Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54623 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaIYLaB (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 25 Sep 2014 07:30:01 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3] xfstests: generic: add dir fsync test, motivated by a btrfs bug
Date: Thu, 25 Sep 2014 13:29:39 +0100
Message-Id: <1411648179-7853-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1410213329-11043-1-git-send-email-fdmanana@suse.com>
References: <1410213329-11043-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by a bug found in btrfs when replaying a
directory from the fsync log. The issue was that if a directory
entry is both found in the persisted metadata and in the fsync
log, at log replay time the directory got set with a wrong i_size.
This had the consequence of not being able to rmdir empty
directories (failed with errno ENOTEMPTY).
This was fixed in btrfs with the following linux kernel patch:

     Btrfs: fix directory recovery from fsync log

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Replaced direct use of "xfs_io" with "$XFS_IO_PROG".

V3: Made the explanations more clear and mention what's the consequence
    of getting a directory's inode with an incorrect i_size on btrfs.
    Changed the test to not call the filesystem check (since it's already
    done by the test framework) and verify that an rmdir against an empty
    directory succeeds.

 tests/generic/326     | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/326.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 108 insertions(+)
 create mode 100755 tests/generic/326
 create mode 100644 tests/generic/326.out

diff --git a/tests/generic/326 b/tests/generic/326
new file mode 100755
index 0000000..e59c560
--- /dev/null
+++ b/tests/generic/326
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 326
+#
+# This test is motivated by a bug found in btrfs when replaying a directory
+# from the fsync log. The issue was that if a directory entry is both found
+# in the persisted metadata and in the fsync log, at log replay time the
+# directory got set with a wrong i_size. This had the consequence of not being
+# able to rmdir empty directories (failed with errno ENOTEMPTY).
+# This was fixed in btrfs with the following linux kernel patch:
+#
+#     Btrfs: fix directory recovery from fsync log
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
+mkdir $SCRATCH_MNT/test_dir
+touch $SCRATCH_MNT/test_dir/foo
+
+# Invoke sync here because it's necessary to trigger the original bug in btrfs.
+# The intention is that at log recovery time we have a dir entry for 'foo' both
+# in the fs/subvol tree and in the log tree - this is necessary to trigger the
+# bug on btrfs.
+sync
+
+touch $SCRATCH_MNT/test_dir/bar
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/test_dir
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/test_dir/bar
+
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+# In the original btrfs bug, log replay would update the directory's inode
+# i_size incorrectly - it would sum again the size of dentry 'foo' (3) to
+# the inode's i_size, which is incorrect because the dentry was already
+# persisted before (in the fs/subvol tree).
+_mount_flakey
+
+[ -f $SCRATCH_MNT/test_dir/foo ] || echo "file foo is missing"
+[ -f $SCRATCH_MNT/test_dir/bar ] || echo "file bar is missing"
+
+rm -f $SCRATCH_MNT/test_dir/foo
+rm -f $SCRATCH_MNT/test_dir/bar
+
+# In btrfs removing all entries from a directory should set the directory's
+# inode i_size to 0, but with this bug that didn't happen and this made
+# an rmdir fail with errno ENOTEMPTY (even though the directory had no more
+# entries in it).
+rmdir $SCRATCH_MNT/test_dir
+[ -d $SCRATCH_MNT/test_dir ] && echo "rmdir didn't succeed"
+
+_unmount_flakey
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/generic/326.out b/tests/generic/326.out
new file mode 100644
index 0000000..4ac0db5
--- /dev/null
+++ b/tests/generic/326.out
@@ -0,0 +1,2 @@
+QA output created by 326
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index bdcfd9d..cc5fecc 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -145,3 +145,4 @@
 323 auto aio stress
 324 auto fsr quick
 325 auto quick data log
+326 auto quick metadata log
-- 
1.9.1

