Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58894 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbbFYNxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 09:53:39 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: generic test for truncating a file into the middle of a hole
Date: Thu, 25 Jun 2015 04:17:59 +0100
Message-Id: <1435202279-23573-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that after truncating a file into the middle of a hole causes the
new size of the file to be persisted after a clean unmount of the
filesystem (or after the inode is evicted). This is for the case where
all the data following the hole is not yet durably persisted, that is,
that data is only present in the page cache.

This test is motivated by an issue found in btrfs, which got fixed by
the patch titled:

  "Btrfs: fix shrinking truncate when the no_holes feature is enabled"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/094     | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/094.out | 11 +++++++
 tests/generic/group   |  1 +
 3 files changed, 103 insertions(+)
 create mode 100755 tests/generic/094
 create mode 100644 tests/generic/094.out

diff --git a/tests/generic/094 b/tests/generic/094
new file mode 100755
index 0000000..0876eb7
--- /dev/null
+++ b/tests/generic/094
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FSQA Test No. 094
+#
+# Test that after truncating a file into the middle of a hole causes the new
+# size of the file to be persisted after a clean unmount of the filesystem (or
+# after the inode is evicted). This is for the case where all the data following
+# the hole is not yet durably persisted, that is, that data is only present in
+# the page cache.
+#
+# This test is motivated by an issue found in btrfs.
+#
+#-----------------------------------------------------------------------
+#
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+# This test was motivated by an issue found in btrfs when the btrfs no-holes
+# feature is enabled (introduced in kernel 3.14). So enable the feature if the
+# fs being tested is btrfs.
+if [ $FSTYP == "btrfs" ]; then
+	_require_btrfs_fs_feature "no_holes"
+	_require_btrfs_mkfs_feature "no-holes"
+	MKFS_OPTIONS="$MKFS_OPTIONS -O no-holes"
+fi
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# Create our test file with some data and durably persist it.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" $SCRATCH_MNT/foo | _filter_xfs_io
+sync
+
+# Append some data to the file, increasing its size, and leave a hole between
+# the old size and the start offset if the following write. So our file gets
+# a hole in the range [128Kb, 256Kb[.
+$XFS_IO_PROG -c "pwrite -S 0xbb 256K 32K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Now truncate our file to a smaller size that is in the middle of the hole we
+# previously created. On most truncate implementations the data we appended
+# before gets discarded from memory (with truncate_setsize()) and never ends
+# up being written to disk.
+$XFS_IO_PROG -c "truncate 160K" $SCRATCH_MNT/foo
+
+_scratch_remount
+
+# We expect to see a file with a size of 160Kb, with the first 128Kb of data all
+# having the value 0xaa and the remaining 32Kb of data all having the value 0x00
+echo "File content after remount:"
+od -t x1 $SCRATCH_MNT/foo
+
+status=0
+exit
diff --git a/tests/generic/094.out b/tests/generic/094.out
new file mode 100644
index 0000000..47d1b63
--- /dev/null
+++ b/tests/generic/094.out
@@ -0,0 +1,11 @@
+QA output created by 094
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 32768/32768 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File content after remount:
+0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+0400000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0500000
diff --git a/tests/generic/group b/tests/generic/group
index ae40fed..c14ddb9 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -96,6 +96,7 @@
 091 rw auto quick
 092 auto quick prealloc
 093 attr cap udf auto
+094 auto quick metadata
 097 udf auto
 099 udf auto
 100 udf auto
-- 
2.1.3

