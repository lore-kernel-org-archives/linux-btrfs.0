Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44414 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaIKJqZ (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 11 Sep 2014 05:46:25 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] xfstests: btrfs: add test regarding clearing compression flag/property
Date: Thu, 11 Sep 2014 11:45:34 +0100
Message-Id: <1410432334-21796-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for btrfs where removing the flag FS_COMPR_FL
(chattr -c) from an inode wouldn't clear its compression property.
This was fixed in the following linux kernel patch:

  Btrfs: add missing compression property remove in btrfs_ioctl_setflags

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/059     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/059.out | 11 +++++++
 tests/btrfs/group   |  1 +
 3 files changed, 97 insertions(+)
 create mode 100755 tests/btrfs/059
 create mode 100644 tests/btrfs/059.out

diff --git a/tests/btrfs/059 b/tests/btrfs/059
new file mode 100755
index 0000000..3379ead
--- /dev/null
+++ b/tests/btrfs/059
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FS QA Test No. btrfs/059
+#
+# Regression test for btrfs where removing the flag FS_COMPR_FL (chattr -c)
+# from an inode wouldn't clear its compression property.
+# This was fixed in the following linux kernel patch:
+#
+#     Btrfs: add missing compression property remove in btrfs_ioctl_setflags
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
+tmp=/tmp/$$
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_test
+_require_scratch
+_require_btrfs "property"
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+mkdir $SCRATCH_MNT/testdir
+echo "Setting compression flag in the directory..."
+chattr +c $SCRATCH_MNT/testdir
+echo "Directory compression property value:"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir compression
+
+touch $SCRATCH_MNT/testdir/file1
+echo "file1 compression property value:"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+
+echo "Clearing compression flag from directory..."
+chattr -c $SCRATCH_MNT/testdir
+echo "Directory compression property value:"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir compression
+
+touch $SCRATCH_MNT/testdir/file2
+echo "file2 compression property value:"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file2 compression
+
+touch $SCRATCH_MNT/testdir/file1
+echo "file1 compression property value:"
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+
+status=0
+exit
diff --git a/tests/btrfs/059.out b/tests/btrfs/059.out
new file mode 100644
index 0000000..9ec9a53
--- /dev/null
+++ b/tests/btrfs/059.out
@@ -0,0 +1,11 @@
+QA output created by 059
+Setting compression flag in the directory...
+Directory compression property value:
+compression=zlib
+file1 compression property value:
+compression=zlib
+Clearing compression flag from directory...
+Directory compression property value:
+file2 compression property value:
+file1 compression property value:
+compression=zlib
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 3fa9778..68b5c79 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -61,3 +61,4 @@
 056 auto quick
 057 auto quick
 058 auto quick
+059 auto quick
-- 
1.9.1

