Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:52882 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750801AbbBLQxv (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 12 Feb 2015 11:53:51 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: add generic test for fsync after creating hard link
Date: Thu, 12 Feb 2015 16:51:29 +0000
Message-Id: <1423759889-30546-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by an fsync issue discovered in btrfs.
The issue was that we could lose file data, that was previously
fsync'ed successfully, if we end up adding a hard link to our
inode and then persist the fsync log later via an fsync of other
inode for example.

The btrfs issue was fixed by the following linux kernel patch:

  Btrfs: fix fsync data loss after adding hard link to inode

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/042     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/042.out | 11 ++++++
 tests/generic/group   |  1 +
 3 files changed, 111 insertions(+)
 create mode 100755 tests/generic/042
 create mode 100644 tests/generic/042.out

diff --git a/tests/generic/042 b/tests/generic/042
new file mode 100755
index 0000000..615526e
--- /dev/null
+++ b/tests/generic/042
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 042
+#
+# This test is motivated by an fsync issue discovered in btrfs.
+# The issue was that we could lose file data, that was previously fsync'ed
+# successfully, if we end up adding a hard link to our inode and then persist
+# the fsync log later via an fsync of other inode for example.
+#
+# The btrfs issue was fixed by the following linux kernel patch:
+#
+#  Btrfs: fix fsync data loss after adding hard link to inode
+#
+#-----------------------------------------------------------------------
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
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -f $tmp.*
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
+_init_flakey
+_mount_flakey
+
+# Create one file with data and fsync it.
+# This made the btrfs fsync log persist the data and the inode metadata with
+# a correct inode->i_size (4096 bytes).
+$XFS_IO_PROG -f -c "pwrite -S 0xaa -b 4K 0 4K" -c "fsync" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Now add one hard link to our file. This made the btrfs code update the fsync
+# log, in memory only, with an inode metadata having a size of 0.
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/foo_link
+
+# Now force persistence of the fsync log to disk, for example, by fsyncing some
+# other file.
+touch $SCRATCH_MNT/bar
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+
+# Before a power loss or crash, we could read the 4Kb of data from our file as
+# expected.
+echo "File content before:"
+od -t x1 $SCRATCH_MNT/foo
+
+# Simulate a crash/power loss.
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+# After the fsync log replay, because the fsync log had a value of 0 for our
+# inode's i_size, we couldn't read anymore the 4Kb of data that we previously
+# wrote and fsync'ed. The size of the file became 0 after the fsync log replay.
+echo "File content after:"
+od -t x1 $SCRATCH_MNT/foo
+
+status=0
+exit
diff --git a/tests/generic/042.out b/tests/generic/042.out
new file mode 100644
index 0000000..a4ea5b6
--- /dev/null
+++ b/tests/generic/042.out
@@ -0,0 +1,11 @@
+QA output created by 042
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content before:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0010000
+File content after:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0010000
diff --git a/tests/generic/group b/tests/generic/group
index fb67b57..001ec80 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -44,6 +44,7 @@
 039 metadata auto quick
 040 metadata auto quick
 041 metadata auto quick
+042 metadata auto quick
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
2.1.3

