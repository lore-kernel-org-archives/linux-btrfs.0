Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36503 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaIHUzw (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 8 Sep 2014 16:55:52 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] xfstests: generic: add dir fsync test, motivated by a btrfs bug
Date: Mon,  8 Sep 2014 22:55:29 +0100
Message-Id: <1410213329-11043-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by a bug found in btrfs when fsync'ing a
directory. The issue was that if a directory entry is both found
in the persisted metadata and in the fsync log, at log replay time
the directory got set ith a wrong i_size. This was fixed in btrfs
with the following linux kernel patch:

     Btrfs: fix directory recovery from fsync log

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/326     | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/326.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 98 insertions(+)
 create mode 100755 tests/generic/326
 create mode 100644 tests/generic/326.out

diff --git a/tests/generic/326 b/tests/generic/326
new file mode 100755
index 0000000..47f4558
--- /dev/null
+++ b/tests/generic/326
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 326
+#
+# This test is motivated by a bug found in btrfs when fsync'ing a directory.
+# The issue was that if a directory entry is both found in the persisted
+# metadata and in the fsync log, at log replay time the directory got set
+# with a wrong i_size. This was fixed in btrfs with the following linux
+# kernel patch:
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
+touch $SCRATCH_MNT/foo
+
+# Invoke sync here because it's necessary to trigger the original bug in btrfs.
+# The intention is that at log recovery time we have a dir entry for 'foo' both
+# in the fs/subvol tree and in the log tree - this is necessary to trigger the
+# bug on btrfs.
+sync
+
+touch $SCRATCH_MNT/bar
+xfs_io -c "fsync" $SCRATCH_MNT
+xfs_io -c "fsync" $SCRATCH_MNT/bar
+
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+_check_scratch_fs $FLAKEY_DEV
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+[ -f $SCRATCH_MNT/foo ] || echo "file foo is missing"
+[ -f $SCRATCH_MNT/bar ] || echo "file bar is missing"
+
+_unmount_flakey
+
+# In the original btrfs bug, the filesystem consistency check failed here
+# because the directory inode got set with a wrong i_size by the log replay
+# at mount time (dentry 'foo' was accounted for twice).
+_check_scratch_fs $FLAKEY_DEV
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

