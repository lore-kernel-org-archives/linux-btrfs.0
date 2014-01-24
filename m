Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30541 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaAXJLT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 04:11:19 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: add regression test for transaction abortion when remounting
Date: Fri, 24 Jan 2014 17:09:56 +0800
Message-Id: <1390554597-11076-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs would get a transaction abortion when remounting RW to RO with
flushoncommit enabled.This test is to check if bug still exists.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/032     | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/032.out |  3 +++
 tests/btrfs/group   |  1 +
 3 files changed, 61 insertions(+)
 create mode 100755 tests/btrfs/032
 create mode 100644 tests/btrfs/032.out

diff --git a/tests/btrfs/032 b/tests/btrfs/032
new file mode 100755
index 0000000..0b666e5
--- /dev/null
+++ b/tests/btrfs/032
@@ -0,0 +1,57 @@
+#!/bin/bash
+# FS QA Test No. btrfs/032
+#
+# Regression test for transaction abortion when remounting RW to RO
+# with flushoncommit option enabled.
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
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount "-o flushoncommit"
+
+$XFS_IO_PROG -f -c "pwrite 0 10M" "$SCRATCH_MNT/tmpfile" | _filter_xfs_io
+
+_scratch_mount "-o remount,ro"
+
+status=0 ; exit
diff --git a/tests/btrfs/032.out b/tests/btrfs/032.out
new file mode 100644
index 0000000..bd0ac21
--- /dev/null
+++ b/tests/btrfs/032.out
@@ -0,0 +1,3 @@
+QA output created by 032
+wrote 10485760/10485760 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 2e2b8e1..7f48b04 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -34,3 +34,4 @@
 029 auto quick
 030 auto quick
 031 auto quick
+032 auto quick
-- 
1.8.3.1

