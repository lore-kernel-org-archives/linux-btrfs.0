From: WuBo <wu.bo@cn.fujitsu.com>
Subject: [PATCH v2 2/3] xfstests 274: add a prealloc and reserve test
Date: Tue, 08 Nov 2011 11:41:08 +0800
Message-ID: <4EB8A4D4.4000000@cn.fujitsu.com>
References: <4EB8A441.7090506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-fsdevel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EB8A441.7090506@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This test is for preallocation test. If the disk is full, just with a prealloc
file has some free space that prealloc early. We need to check whether the write
to the free space is success or not.

Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>
---
 274     |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 274.out |    5 +++
 group   |    1 +
 3 files changed, 97 insertions(+), 0 deletions(-)
 create mode 100755 274
 create mode 100644 274.out

diff --git a/274 b/274
new file mode 100755
index 0000000..b658004
--- /dev/null
+++ b/274
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test No. 274
+#
+# preallocation test
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
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
+#creator
+owner=wu.bo@cn.fujitsu.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0    # success is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $SCRATCH_MNT/* $tmp.*
+	_scratch_unmount
+}
+
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os IRIX Linux
+_require_scratch
+
+echo "------------------------------"
+echo "preallocation test"
+echo "------------------------------"
+
+rm -f $seq.full
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
+_scratch_mount
+
+rm -rf $SCRATCH_MNT/*
+cd $SCRATCH_MNT
+dd if=/dev/zero of=test bs=4K count=1 >/dev/null 2>&1
+if [ $? -ne 0 ]
+then
+	echo "create file err"
+	status=1
+	exit
+fi
+
+fallocate -n -o 4K -l 1M test >/dev/null 2>&1
+if [ $? -ne 0 ]
+then
+	echo "fallocate file err"
+	status=1
+	exit
+fi
+
+dd if=/dev/zero of=tmp1 bs=1M >/dev/null 2>&1
+dd if=/dev/zero of=tmp2 bs=4K >/dev/null 2>&1
+sync
+
+dd if=/dev/zero of=test seek=1 bs=4K count=2 conv=notrunc >/dev/null 2>&1
+if [ $? -ne 0 ]
+then
+	echo "fill prealloc range err"
+	status=1
+	exit
+fi
+
+echo "done"
+exit
diff --git a/274.out b/274.out
new file mode 100644
index 0000000..edbf3cc
--- /dev/null
+++ b/274.out
@@ -0,0 +1,5 @@
+QA output created by 274
+------------------------------
+preallocation test
+------------------------------
+done
diff --git a/group b/group
index b8245bf..44a9999 100644
--- a/group
+++ b/group
@@ -387,3 +387,4 @@ deprecated
 271 auto rw quick
 272 auto enospc rw
 273 auto rw
+274 auto rw
-- 
1.7.3.1
