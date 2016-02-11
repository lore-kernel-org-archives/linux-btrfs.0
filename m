Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20723 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbcBKXmr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:47 -0500
Subject: [PATCH 30/32] xfs: ensure that we don't crash when freeing the ag
 reservations on a ro mount
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 11 Feb 2016 15:42:41 -0800
Message-ID: <20160211234241.2202.1427.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig discovered that the kernel crashed trying to free
the refcount btree per-ag reservation on a ro mount (because we don't
create the reservation except for rw mounts and ro->rw remounts).  So,
test this to make sure we never do that again. :)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/247     |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/247.out |    2 ++
 tests/xfs/group   |    1 +
 3 files changed, 60 insertions(+)
 create mode 100755 tests/xfs/247
 create mode 100644 tests/xfs/247.out


diff --git a/tests/xfs/247 b/tests/xfs/247
new file mode 100755
index 0000000..1581dd3
--- /dev/null
+++ b/tests/xfs/247
@@ -0,0 +1,57 @@
+#! /bin/bash
+# FS QA Test No. 247
+#
+# Mount a reflink/rmap filesystem ro (so the per-AG reservation isn't
+# created) and unmount, to ensure that we free correctly.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount -o ro >> $seqres.full 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/247.out b/tests/xfs/247.out
new file mode 100644
index 0000000..a65574f
--- /dev/null
+++ b/tests/xfs/247.out
@@ -0,0 +1,2 @@
+QA output created by 247
+Format and mount
diff --git a/tests/xfs/group b/tests/xfs/group
index f6c7db8..6f43c79 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -244,6 +244,7 @@
 244 auto quota quick
 245 auto quick clone
 246 auto quick clone
+247 auto quick clone
 250 auto quick rw prealloc metadata
 252 auto quick prealloc
 253 auto quick

