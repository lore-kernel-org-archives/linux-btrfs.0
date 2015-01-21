Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13739 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750809AbbAUGKp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Jan 2015 01:10:45 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: [PATCH] fstests: btrfs/082: Check return value of "btrfs filesystem show" command executed on umounted device.
Date: Wed, 21 Jan 2015 14:08:38 +0800
Message-ID: <1421820518-27797-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421820518-27797-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421820518-27797-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The return value should always be 0 if no problem happens, but
"btrfs filesystem show" executed on umounted device will always return 1
even there is no problem.

This testcase just checks it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/082     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/082.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 74 insertions(+)
 create mode 100755 tests/btrfs/082
 create mode 100644 tests/btrfs/082.out

diff --git a/tests/btrfs/082 b/tests/btrfs/082
new file mode 100755
index 0000000..d33e836
--- /dev/null
+++ b/tests/btrfs/082
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FS QA Test No. btrfs/082
+#
+# Check return value of "btrfs filesystem show" command executed on
+# umounted device.
+# It should return 0 if nothing wrong happens.
+#
+# Regression in v3.18 btrfs-progs and fixed by the following patch:
+#
+#    btrfs-progs: Fix wrong return value when executing 'fi show' on
+#    umounted device.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Fujitsu, Inc.  All Rights Reserved.
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
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter.btrfs
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_scratch_dev_pool
+
+rm -f $seqres.full
+
+FIRST_POOL_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
+TOTAL_DEVS=`echo $SCRATCH_DEV_POOL | wc -w`
+
+_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+_run_btrfs_util_prog filesystem show $FIRST_POOL_DEV | \
+	_filter_btrfs_filesystem_show $TOTAL_DEVS
+
+# success, all done
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
index e29999b..709664a 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -84,3 +84,4 @@
 079 auto rw metadata
 080 auto snapshot
 081 auto quick clone
+082 auto quick
-- 
1.8.3.1

