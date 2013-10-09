Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44123 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab3JICRs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 22:17:48 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com, jbacik@fusionio.com,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH V2] xfstest: an regression test for btrfs balance
Date: Wed, 9 Oct 2013 10:16:01 +0800
Message-Id: <1381284961-4509-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally, when executing "btrfs balance" right after
"btrfs subvolume snaphot" & "btrfs subvolume delete",
a kernel BUG arises.

This problem is caused by the patch:
[PATCH 1/2] Btrfs: fix for patch "cleanup: don't check
the same thing twice"
The commit id: 48475471728f060bfd2e686f592ef208d3ba8b7d
(in kernel/git/torvalds/linux.git)

handled by the patch:
[PATCH 2/3] Btrfs: fix oops caused by the space balance
and dead roots

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fusionio.com>

---
Changelog V1->V2
	change test number 319 -> 012
---
 tests/btrfs/012     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/012.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 74 insertions(+)
 create mode 100755 tests/btrfs/012
 create mode 100644 tests/btrfs/012.out

diff --git a/tests/btrfs/012 b/tests/btrfs/012
new file mode 100755
index 0000000..19a6c99
--- /dev/null
+++ b/tests/btrfs/012
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FS QA Test No. btrfs/012
+#
+# Btrfs balance tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fujitsu.  All Rights Reserved.
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
+here="`pwd`"
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_create_snapshot()
+{
+	for i in $(seq 20)
+	do
+		btrfs sub snapshot $SCRATCH_MNT $SCRATCH_MNT/snapshot0 >/dev/null
+		btrfs sub delete $SCRATCH_MNT/snapshot0 >/dev/null
+	done
+}
+
+_balance()
+{
+	for i in $(seq 20)
+	do
+		btrfs balance start $SCRATCH_MNT >/dev/null
+	done
+}
+
+#get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+
+_setup_testdir
+_require_scratch
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+echo "Tip: Run dmesg to see the error on failure"
+
+_create_snapshot &
+
+_balance &
+
+wait
+
+status=0
+exit
diff --git a/tests/btrfs/012.out b/tests/btrfs/012.out
new file mode 100644
index 0000000..93db6bb
--- /dev/null
+++ b/tests/btrfs/012.out
@@ -0,0 +1,2 @@
+QA output created by 012
+Tip: Run dmesg to see the error on failure
diff --git a/tests/btrfs/group b/tests/btrfs/group
index d2fe030..2d2d005 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -14,3 +14,4 @@
 009 auto quick
 010 auto quick
 011 auto
+012 auto
-- 
1.8.0.1

