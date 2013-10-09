Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48412 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3JITEk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 15:04:40 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4AB737C068B
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Oct 2013 13:04:40 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH] xfstests: btrfs/016: a regression test for subvolume rename
Date: Wed, 9 Oct 2013 15:04:37 -0400
Message-ID: <1381345477-7902-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a regression where we could no longer rename a subvolume into
another subvolume.  This is a test case to do just that to make sure we don't
regress on this again.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/016     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/016.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 64 insertions(+)
 create mode 100644 tests/btrfs/016
 create mode 100644 tests/btrfs/016.out

diff --git a/tests/btrfs/016 b/tests/btrfs/016
new file mode 100644
index 0000000..09a8b8b
--- /dev/null
+++ b/tests/btrfs/016
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test No. btrfs/016
+#
+# Regression test to make sure we can move a subvol into another subvol
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fusion IO.  All Rights Reserved.
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
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+	rm -f $tmp.*
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
+rm -f $seqres.full
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/test1 >> $seqres.full 2>&1 \
+	|| _fail "couldn't create test1"
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/test2 >> $seqres.full 2>&1 \
+	|| _fail "couldn't create test1"
+mv $SCRATCH_MNT/test1 $SCRATCH_MNT/test2 || _fail "Problem doing move"
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/016.out b/tests/btrfs/016.out
new file mode 100644
index 0000000..aa2526b
--- /dev/null
+++ b/tests/btrfs/016.out
@@ -0,0 +1,2 @@
+QA output created by 016
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index dc5bbea..65d93b9 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -18,3 +18,4 @@
 013 auto quick
 014 auto quick
 015 auto quick
+016 auto quick
-- 
1.8.3.1

