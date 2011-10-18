From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 2/3] 265: Functional test case for the btrfs de-fragmentation
Date: Tue, 18 Oct 2011 14:28:55 +0800
Message-ID: <1318919336-32206-3-git-send-email-Anand.Jain@oracle.com>
References: <20111013005652.GM3159@dastard>
 <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
Cc: Anand Jain <Anand.Jain@oracle.com>
To: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, david@fromorbit.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

To verify the btrfs de-fragmentation does not fail.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 265     |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 265.out |    2 ++
 group   |    1 +
 3 files changed, 63 insertions(+), 0 deletions(-)
 create mode 100755 265
 create mode 100644 265.out

diff --git a/265 b/265
new file mode 100755
index 0000000..81ec69d
--- /dev/null
+++ b/265
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 265
+#
+# btrfs defragmentation tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Oracle.  All Rights Reserved.
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
+# creator
+owner=anand.jain@oracle.com
+
+seq=`basename $0`
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
+. ./common.rc
+. ./common.filter
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+_populate_fs -n 1 -f 20 -d 10 -r $SCRATCH_MNT -s 10
+
+btrfs filesystem defragment $SCRATCH_MNT
+[ $? = 20 ] || _fail "Defragment failed"
+
+umount $SCRATCH_MNT || _fail "umount failed"
+
+echo "Silence is golden"
+status=0; exit
diff --git a/265.out b/265.out
new file mode 100644
index 0000000..9fa4eb0
--- /dev/null
+++ b/265.out
@@ -0,0 +1,2 @@
+QA output created by 265
+Silence is golden
diff --git a/group b/group
index cfbae8c..6bac8b5 100644
--- a/group
+++ b/group
@@ -378,3 +378,4 @@ deprecated
 262 auto quick quota
 263 rw auto quick
 264 auto quick
+265 auto quick
-- 
1.7.7

