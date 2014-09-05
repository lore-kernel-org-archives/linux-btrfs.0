Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:43590 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaIERVU (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 5 Sep 2014 13:21:20 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] xfstests: generic: add test for double msync, motivated by a btrfs bug
Date: Fri,  5 Sep 2014 19:15:17 +0100
Message-Id: <1409940917-14718-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by a btrfs issue where a ranged fsync would
prevent a subsequent fsync from persisting any extents that were
dirty at the time of the first fsync but that were outside the range
of that first fsync (which should have been persisted by the second
fsync).

This bug in btrfs is fixed by the following linux kernel patch:

     Btrfs: fix fsync data loss after a ranged fsync

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/325     | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/325.out |  19 +++++++++
 tests/generic/group   |   1 +
 3 files changed, 126 insertions(+)
 create mode 100755 tests/generic/325
 create mode 100644 tests/generic/325.out

diff --git a/tests/generic/325 b/tests/generic/325
new file mode 100755
index 0000000..c47e372
--- /dev/null
+++ b/tests/generic/325
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 325
+#
+# Make some pages/extents of a file dirty, do a ranged fsync that covers
+# only some of the dirty pages/extents, and then do a regular fsync (or
+# another ranged fsync that covers the remaining dirty pages/extents).
+# Verify after that all extents were persisted.
+#
+# This test is motivated by a btrfs issue where the first ranged fsync
+# would prevent the following fsync from persisting the remaining dirty
+# pages/extents. This was fixed by the following btrfs kernel patch:
+#
+#     Btrfs: fix fsync data loss after a ranged fsync
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
+# Create the file first.
+$XFS_IO_PROG -f -c "pwrite -S 0xff 0 64K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Now sync the file data to disk using 'sync' and not an fsync. This is because
+# in btrfs the first fsync clears the btrfs inode full fsync flag, which must
+# be set when the first msync below happens in order to trigger the bug.
+sync
+
+# Now update the first 4Kb and the last 4Kb of the file, using memory mapped IO
+# because an msync(), since the linux kernel commit
+# 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8, invokes a ranged fsync.
+#
+# After those writes, msync a range covering the first 4Kb and then after
+# perform a msync with a range covering the last 4Kb of the file.
+# This second msync() used to be a no-op for that btrfs bug (and the first fsync
+# didn't log the last 4Kb extent as expected too).
+$XFS_IO_PROG \
+	-c "mmap -w 0 64K"         \
+	-c "mwrite -S 0xaa 0 4K"   \
+	-c "mwrite -S 0xbb 60K 4K" \
+	-c "msync -s 0K 16K"       \
+	-c "msync -s 32K 32K"      \
+	-c "munmap"                \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+echo "File content before crash/reboot:"
+od -t x1 $SCRATCH_MNT/foo
+
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+echo "File content after crash/reboot and fs mount:"
+od -t x1 $SCRATCH_MNT/foo
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/generic/325.out b/tests/generic/325.out
new file mode 100644
index 0000000..9a78c3e
--- /dev/null
+++ b/tests/generic/325.out
@@ -0,0 +1,19 @@
+QA output created by 325
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content before crash/reboot:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0010000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0170000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+*
+0200000
+File content after crash/reboot and fs mount:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0010000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0170000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+*
+0200000
diff --git a/tests/generic/group b/tests/generic/group
index b763193..bdcfd9d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -144,3 +144,4 @@
 322 auto quick metadata log
 323 auto aio stress
 324 auto fsr quick
+325 auto quick data log
-- 
1.9.1

