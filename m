Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:56437 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3KYVk3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 16:40:29 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id DA0529A06B2
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 14:40:28 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>, <hch@infradead.org>
Subject: [PATCH 2/2] xfstests: add a rename fsync test
Date: Mon, 25 Nov 2013 16:40:22 -0500
Message-ID: <1385415622-9303-2-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1385415622-9303-1-git-send-email-jbacik@fusionio.com>
References: <1385415622-9303-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs was screwing up rename+fsync, add some regression tests for the various
scenarios it was screwing up.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/322     | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/322.out |   7 ++++
 tests/generic/group   |   1 +
 3 files changed, 119 insertions(+)
 create mode 100644 tests/generic/322
 create mode 100644 tests/generic/322.out

diff --git a/tests/generic/322 b/tests/generic/322
new file mode 100644
index 0000000..1cea133
--- /dev/null
+++ b/tests/generic/322
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. 322
+#
+# Runs various rename fsync tests to cover some rename fsync corner cases.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fusion IO. All Rights Reserved.
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
+_clean_working_dir()
+{
+	_mount_flakey
+	rm -rf $SCRATCH_MNT/*
+	_unmount_flakey
+}
+
+# Btrfs wasn't making sure the new file after rename survived the fsync
+_rename_test()
+{
+	echo "fsync rename test"
+	_mount_flakey
+	$XFS_IO_PROG -f -c "pwrite 0 1M" -c "fsync" $SCRATCH_MNT/foo \
+		> $seqres.full 2>&1 || _fail "xfs_io failed"
+	mv $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+	_load_flakey_table $FLAKEY_DROP_WRITES
+	md5sum $SCRATCH_MNT/bar
+	_unmount_flakey
+
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
+	_mount_flakey
+	md5sum $SCRATCH_MNT/bar
+	_unmount_flakey
+	_check_scratch_fs $FLAKEY_DEV
+	[ $? -ne 0 ] && _fatal "fsck failed"
+}
+
+# Btrfs was dropping some of the modified extents in between fsyncs if we
+# renamed.
+_write_after_fsync_rename_test()
+{
+	echo "fsync rename test"
+	_mount_flakey
+	$XFS_IO_PROG -f -c "pwrite 0 1M" -c "fsync" -c "pwrite 2M 1M" \
+		-c "sync_range -b" $SCRATCH_MNT/foo > $seqres.full 2>&1 || _fail "xfs_io failed"
+	mv $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+	_load_flakey_table $FLAKEY_DROP_WRITES
+	md5sum $SCRATCH_MNT/bar
+	_unmount_flakey
+
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
+	_mount_flakey
+	md5sum $SCRATCH_MNT/bar
+	_unmount_flakey
+	_check_scratch_fs $FLAKEY_DEV
+	[ $? -ne 0 ] && _fatal "fsck failed"
+}
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+# Create a basic flakey device that will never error out
+_init_flakey
+
+_rename_test
+_clean_working_dir
+_write_after_fsync_rename_test
+
+status=0
+exit
diff --git a/tests/generic/322.out b/tests/generic/322.out
new file mode 100644
index 0000000..0d9f274
--- /dev/null
+++ b/tests/generic/322.out
@@ -0,0 +1,7 @@
+QA output created by 322
+fsync rename test
+ca539970d4b1fa1f34213ba675007381  /mnt/scratch/bar
+ca539970d4b1fa1f34213ba675007381  /mnt/scratch/bar
+fsync rename test
+d34ff04c17ef7068d78d0c4be49cfe57  /mnt/scratch/bar
+d34ff04c17ef7068d78d0c4be49cfe57  /mnt/scratch/bar
diff --git a/tests/generic/group b/tests/generic/group
index 25dddd8..f492461 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -124,3 +124,4 @@
 319 acl auto quick
 320 auto rw
 321 auto quick metadata log
+322 auto quick metadata log
-- 
1.8.3.1

