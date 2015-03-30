Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48683 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752633AbbC3RZn (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 30 Mar 2015 13:25:43 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: test for btrfs cloning of zero length ranges
Date: Mon, 30 Mar 2015 18:24:44 +0100
Message-Id: <1427736284-29469-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test cloning a file range with a length of zero into a destination offset
greater than zero.

This made btrfs create an extent state record with a start offset greater than
the end offset, resulting in chaos such as an infinite loop when evicting an
inode.

This issue was fixed by the following linux kernel patch:

   Btrfs: fix inode eviction infinite loop after cloning into it

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/086     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/086.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 80 insertions(+)
 create mode 100755 tests/btrfs/086
 create mode 100644 tests/btrfs/086.out

diff --git a/tests/btrfs/086 b/tests/btrfs/086
new file mode 100755
index 0000000..d7dd715
--- /dev/null
+++ b/tests/btrfs/086
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test No. btrfs/086
+#
+# Test cloning a file range with a length of zero into a destination offset
+# greater than zero.
+#
+# This made btrfs create an extent state record with a start offset greater than
+# the end offset, resulting in chaos such as an infinite loop when evicting an
+# inode.
+#
+# This issue was fixed by the following linux kernel patch:
+#
+#   Btrfs: fix inode eviction infinite loop after cloning into it
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
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_cloner
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+touch $SCRATCH_MNT/foo
+touch $SCRATCH_MNT/bar
+
+# Now attempt to clone foo into bar. Because we pass a length of zero, the
+# clone ioctl will adjust the length to match the size of the file foo (minus
+# the source offset which is zero) - because the adjusted length value is
+# zero, it made btrfs create an extent state record for file bar with a start
+# offset (4096) greater then its end offset (4095), which is something never
+# supposed to happen and for example it made inode eviction enter an infinite
+# loop that dumped a warning trace on each iteration.
+$CLONER_PROG -s 0 -d 4096 -l 0 $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+echo "bar file size after clone operation: $(stat -c %s $SCRATCH_MNT/bar)"
+
+status=0
+exit
diff --git a/tests/btrfs/086.out b/tests/btrfs/086.out
new file mode 100644
index 0000000..1ae87ba
--- /dev/null
+++ b/tests/btrfs/086.out
@@ -0,0 +1,2 @@
+QA output created by 086
+bar file size after clone operation: 0
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 81d462f..92bc0f9 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -88,3 +88,4 @@
 083 auto quick send
 084 auto quick send
 085 auto quick send
+086 auto quick clone
-- 
2.1.3

