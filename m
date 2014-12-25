Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63172 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751590AbaLYCEd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 21:04:33 -0500
From: Xing Gu <gux.fnst@cn.fujitsu.com>
To: <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, <david@fromorbit.com>, <eguan@redhat.com>,
        <quwenruo@cn.fujitsu.com>, Xing Gu <gux.fnst@cn.fujitsu.com>
Subject: [PATCH v3] btrfs: add regression test for remount with thread_pool resized
Date: Thu, 25 Dec 2014 10:00:57 +0800
Message-ID: <1419472857-31867-1-git-send-email-gux.fnst@cn.fujitsu.com>
In-Reply-To: <1401439971-18589-1-git-send-email-gux.fnst@cn.fujitsu.com>
References: <1401439971-18589-1-git-send-email-gux.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for a btrfs issue of resizing 'thread_pool' when
remount the fs.

This regression was introduced by the following linux kernel commit:
    btrfs: Added btrfs_workqueue_struct implemented ordered
    execution based on kernel workqueue
    08a9ff3264181986d1d692a4e6fce3669700c9f8
And it was fixed by the following linux kernel commit:
    btrfs: fix crash in remount(thread_pool=) case
    800ee2247f483b6d05ed47ef3bbc90b56451746c

Signed-off-by: Xing Gu <gux.fnst@cn.fujitsu.com>
---
 tests/btrfs/082     | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/082.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 73 insertions(+)
 create mode 100755 tests/btrfs/082
 create mode 100644 tests/btrfs/082.out

diff --git a/tests/btrfs/082 b/tests/btrfs/082
new file mode 100755
index 0000000..987ffae
--- /dev/null
+++ b/tests/btrfs/082
@@ -0,0 +1,70 @@
+#!/bin/bash
+# FS QA Test No. btrfs/082
+#
+# Regression test for a btrfs issue of resizing 'thread_pool' when
+# remount the fs.
+#
+# This regression was introduced by the following linux kernel commit:
+#     btrfs: Added btrfs_workqueue_struct implemented ordered
+#     execution based on kernel workqueue
+#     08a9ff3264181986d1d692a4e6fce3669700c9f8
+# And it was fixed by the following linux kernel commit:
+#     btrfs: fix crash in remount(thread_pool=) case
+#     800ee2247f483b6d05ed47ef3bbc90b56451746c
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
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
+#
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
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null
+
+nr_null=`dmesg | grep -c "kernel NULL pointer dereference"`
+_scratch_mount "-o thread_pool=6"
+_scratch_mount "-o remount,thread_pool=10"
+new_null=`dmesg | grep -c "kernel NULL pointer dereference"`
+if [ $new_null -ne $nr_null ]; then
+	_fail "kernel bug detected, check dmesg for more infomation."
+fi
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/082.out b/tests/btrfs/082.out
new file mode 100644
index 0000000..2977f14
--- /dev/null
+++ b/tests/btrfs/082.out
@@ -0,0 +1,2 @@
+QA output created by 082
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e29999b..fd2fa76 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -84,3 +84,4 @@
 079 auto rw metadata
 080 auto snapshot
 081 auto quick clone
+082 auto quick remount
-- 
1.9.3

