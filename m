From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 2/3] 264: Functional test case for the btrfs de-fragmentation
Date: Wed, 12 Oct 2011 12:52:53 +0800
Message-ID: <1318395174-4075-3-git-send-email-Anand.Jain@oracle.com>
References: <4E3BA2F7.4080500@oracle.com>
 <1318395174-4075-1-git-send-email-Anand.Jain@oracle.com>
Cc: chris.mason@oracle.com, Anand Jain <Anand.Jain@oracle.com>
To: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1318395174-4075-1-git-send-email-Anand.Jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

To verify the btrfs de-fragmentation does not fail

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 264     |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 264.out |    2 ++
 group   |    1 +
 3 files changed, 63 insertions(+), 0 deletions(-)
 create mode 100755 264
 create mode 100644 264.out

diff --git a/264 b/264
new file mode 100755
index 0000000..61efeb8
--- /dev/null
+++ b/264
@@ -0,0 +1,60 @@
+#! /bin/bash
+# FS QA Test No. 264
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
+_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+
+btrfs filesystem defragment $SCRATCH_MNT
+[ $? = 20 ] || _fail "Defragment failed"
+
+umount $SCRATCH_MNT || _fail "umount failed"
+
+echo "Silence is golden"
+status=0; exit
diff --git a/264.out b/264.out
new file mode 100644
index 0000000..eca790b
--- /dev/null
+++ b/264.out
@@ -0,0 +1,2 @@
+QA output created by 264
+Silence is golden
diff --git a/group b/group
index d86624f..b5863be 100644
--- a/group
+++ b/group
@@ -377,3 +377,4 @@ deprecated
 261 auto quick quota
 262 auto quick quota
 263 auto quick
+264 auto quick
-- 
1.7.7

