Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49319 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbcBVRyh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 12:54:37 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: generic test for listing an inode's xattrs
Date: Mon, 22 Feb 2016 17:52:38 +0000
Message-Id: <1456163558-1148-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that the filesystem's implementation of the listxattrs system call
lists all the xattrs an inode has.

This test is motivated by a bug found in btrfs, which is fixed by the
following patch for the linux kernel:

  "Btrfs: fix listxattrs not listing all xattrs packed in the same item"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/337     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/337.out |  8 ++++++
 tests/generic/group   |  1 +
 3 files changed, 81 insertions(+)
 create mode 100755 tests/generic/337
 create mode 100644 tests/generic/337.out

diff --git a/tests/generic/337 b/tests/generic/337
new file mode 100755
index 0000000..1758871
--- /dev/null
+++ b/tests/generic/337
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FSQA Test No. 337
+#
+# Test that the filesystem's implementation of the listxattrs system call lists
+# all the xattrs an inode has.
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
+. ./common/attr
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_attrs
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# Create our test file with a few xattrs. The first 3 xattrs have a name that
+# when given as input to a crc32c function result in the same checksum. This
+# made btrfs list only one of the xattrs through listxattrs system call (because
+# it packs xattrs with the same name checksum into the same btree item).
+touch $SCRATCH_MNT/testfile
+$SETFATTR_PROG -n user.foobar -v 123 $SCRATCH_MNT/testfile
+$SETFATTR_PROG -n user.WvG1c1Td -v qwerty $SCRATCH_MNT/testfile
+$SETFATTR_PROG -n user.J3__T_Km3dVsW_ -v hello $SCRATCH_MNT/testfile
+$SETFATTR_PROG -n user.something -v pizza $SCRATCH_MNT/testfile
+$SETFATTR_PROG -n user.ping -v pong $SCRATCH_MNT/testfile
+
+# Now call getfattr with --dump, which calls the listxattrs system call.
+# It should list all the xattrs we have set before.
+$GETFATTR_PROG --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scratch
+
+status=0
+exit
diff --git a/tests/generic/337.out b/tests/generic/337.out
new file mode 100644
index 0000000..1cd92ff
--- /dev/null
+++ b/tests/generic/337.out
@@ -0,0 +1,8 @@
+QA output created by 337
+# file: SCRATCH_MNT/testfile
+user.J3__T_Km3dVsW_="hello"
+user.WvG1c1Td="qwerty"
+user.foobar="123"
+user.ping="pong"
+user.something="pizza"
+
diff --git a/tests/generic/group b/tests/generic/group
index a47e23d..b6b27f8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -339,3 +339,4 @@
 334 auto clone
 335 auto quick metadata
 336 auto quick metadata
+337 auto quick metadata
-- 
2.7.0.rc3

