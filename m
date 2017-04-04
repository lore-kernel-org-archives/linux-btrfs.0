Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752205AbdDDONr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Apr 2017 10:13:47 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] generic: test for number of bytes used by files after buffered writes
Date: Tue,  4 Apr 2017 03:23:35 +0100
Message-Id: <1491272615-3795-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that a filesystem's implementation of the stat(2) system call
reports correct values for the number of blocks allocated for a file
when there are delayed allocations.

This test is motivated by a bug in btrfs which is fixed by the following
path for the linux kernel:

 "Btrfs: fix reported number of inode blocks"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/422     | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/422.out |  41 ++++++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 168 insertions(+)
 create mode 100755 tests/generic/422
 create mode 100644 tests/generic/422.out

diff --git a/tests/generic/422 b/tests/generic/422
new file mode 100755
index 0000000..20cd54a
--- /dev/null
+++ b/tests/generic/422
@@ -0,0 +1,126 @@
+#! /bin/bash
+# FS QA Test No. generic/422
+#
+# Test that a filesystem's implementation of the stat(2) system call reports
+# correct values for the number of blocks allocated for a file when there are
+# delayed allocations.
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2017 SUSE Linux Products GmbH. All Rights Reserved.
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_scratch
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 64K" $SCRATCH_MNT/foo1 | _filter_xfs_io
+$XFS_IO_PROG -f \
+     -c "pwrite -S 0xaa 0 64K" \
+     -c "truncate 128K" \
+     $SCRATCH_MNT/foo2 | _filter_xfs_io
+$XFS_IO_PROG -f \
+     -c "falloc -k 0 128K" \
+     -c "pwrite -S 0xaa 0 64K" \
+     $SCRATCH_MNT/foo3 | _filter_xfs_io
+touch $SCRATCH_MNT/foo4
+
+# Make sure everything done so far is durably persisted.
+sync
+
+# Now overwrite the extent of the first file.
+$XFS_IO_PROG -c "pwrite -S 0xff 0 64K" $SCRATCH_MNT/foo1 | _filter_xfs_io
+
+# Write to a hole of the second file.
+$XFS_IO_PROG -c "pwrite -S 0xff 64K 64K" $SCRATCH_MNT/foo2 | _filter_xfs_io
+# Write again to the same location, just to test that the fs will not account
+# the same write twice.
+$XFS_IO_PROG -c "pwrite -S 0x20 64K 64K" $SCRATCH_MNT/foo2 | _filter_xfs_io
+
+# Write beyond eof of the third file into the pre-allocated extent.
+$XFS_IO_PROG -c "pwrite -S 0xff 64K 64K" $SCRATCH_MNT/foo3 | _filter_xfs_io
+
+# Do a buffered write immediately followed by a direct IO write, without a
+# fsync in between, just to test that page invalidation does not lead to an
+# incorrect number of file blocks reported.
+$XFS_IO_PROG -c "pwrite -S 0xab 0 64K" $SCRATCH_MNT/foo4 | _filter_xfs_io
+$XFS_IO_PROG -d -c "pwrite -S 0xef 0 64K" $SCRATCH_MNT/foo4 | _filter_xfs_io
+
+echo
+echo "Before writeback"
+echo
+
+echo "Space used by file foo1:"
+du -h $SCRATCH_MNT/foo1 | _filter_scratch
+
+echo "Space used by file foo2:"
+du -h $SCRATCH_MNT/foo2 | _filter_scratch
+
+echo "Space used by file foo3:"
+du -h $SCRATCH_MNT/foo3 | _filter_scratch
+
+echo "Space used by file foo4:"
+du -h $SCRATCH_MNT/foo4 | _filter_scratch
+
+sync
+
+# We expect the same file sizes reported by 'du' after writeback finishes.
+echo
+echo "After writeback"
+echo
+
+echo "Space used by file foo1:"
+du -h $SCRATCH_MNT/foo1 | _filter_scratch
+
+echo "Space used by file foo2:"
+du -h $SCRATCH_MNT/foo2 | _filter_scratch
+
+echo "Space used by file foo3:"
+du -h $SCRATCH_MNT/foo3 | _filter_scratch
+
+echo "Space used by file foo4:"
+du -h $SCRATCH_MNT/foo4 | _filter_scratch
+
+status=0
+exit
diff --git a/tests/generic/422.out b/tests/generic/422.out
new file mode 100644
index 0000000..3696088
--- /dev/null
+++ b/tests/generic/422.out
@@ -0,0 +1,41 @@
+QA output created by 422
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+
+Before writeback
+
+Space used by file foo1:
+64K	SCRATCH_MNT/foo1
+Space used by file foo2:
+128K	SCRATCH_MNT/foo2
+Space used by file foo3:
+128K	SCRATCH_MNT/foo3
+Space used by file foo4:
+64K	SCRATCH_MNT/foo4
+
+After writeback
+
+Space used by file foo1:
+64K	SCRATCH_MNT/foo1
+Space used by file foo2:
+128K	SCRATCH_MNT/foo2
+Space used by file foo3:
+128K	SCRATCH_MNT/foo3
+Space used by file foo4:
+64K	SCRATCH_MNT/foo4
diff --git a/tests/generic/group b/tests/generic/group
index 3c7c5e4..d747385 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -424,3 +424,4 @@
 419 auto quick encrypt
 420 auto quick punch
 421 auto quick encrypt dangerous
+422 auto quick
-- 
2.7.0.rc3

