Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53184 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbcCURud (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:50:33 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] fstests: test fsync on overlayfs merged directory
Date: Mon, 21 Mar 2016 17:50:25 +0000
Message-Id: <1458582625-22039-1-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1458581952-18638-1-git-send-email-fdmanana@kernel.org>
References: <1458581952-18638-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that calling fsync against a file using the merged directory does
not result in a crash nor fails unexpectedly.

This is motivated by a change in overlayfs that resulted in a crash
(invalid memory access) when the lower or upper directory belonged to
a btrfs file system. The overlayfs change came in commit 4bacc9c9234
(overlayfs: Make f_path always point to the overlay and f_inode to the
underlay). At the moment there are two patches in the linux-fsdevel
and linux-btrfs mailing lists to fix this problem:

  * vfs: add file_dentry()
  * Btrfs: fix crash/invalid memory access on fsync when using overlayfs

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Removed leftover comment from debugging.

 tests/overlay/002     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/002.out |  3 +++
 tests/overlay/group   |  1 +
 3 files changed, 78 insertions(+)
 create mode 100755 tests/overlay/002
 create mode 100644 tests/overlay/002.out

diff --git a/tests/overlay/002 b/tests/overlay/002
new file mode 100755
index 0000000..e5aa610
--- /dev/null
+++ b/tests/overlay/002
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test 002
+#
+# Test that calling fsync against a file using the merged directory does not
+# result in a crash nor fails unexpectedly.
+#
+# This is motivated by a change in overlayfs that resulted in a crash (invalid
+# memory access) when the lower or upper directory belonged to a btrfs file
+# system.
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
+
+here=`pwd`
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create our test file.
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir -p $lowerdir
+touch $lowerdir/foobar
+
+_scratch_mount
+
+# Write some data to our file and fsync it, using the merged directory path.
+# This should work and not result in a crash.
+$XFS_IO_PROG -c "pwrite 0 64k" -c "fsync" $SCRATCH_MNT/foobar | _filter_xfs_io
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/002.out b/tests/overlay/002.out
new file mode 100644
index 0000000..666e61e
--- /dev/null
+++ b/tests/overlay/002.out
@@ -0,0 +1,3 @@
+QA output created by 002
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/overlay/group b/tests/overlay/group
index 5056c3b..84d164e 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -4,3 +4,4 @@
 # - comment line before each group is "new" description
 #
 001 auto quick copyup
+002 auto quick metadata
-- 
2.7.0.rc3

