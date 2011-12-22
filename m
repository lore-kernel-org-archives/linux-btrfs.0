From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] xfstests: add a new test to verify on disk ctime update for
 chattr
Date: Thu, 22 Dec 2011 11:55:03 +0800
Message-ID: <4EF2AA17.40400@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: xfs@oss.sgi.com,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We had a bug in btrfs which can be triggered by this test.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 277     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 277.out |    1 +
 group   |    1 +
 3 files changed, 73 insertions(+), 0 deletions(-)
 create mode 100755 277
 create mode 100644 277.out

diff --git a/277 b/277
new file mode 100755
index 0000000..8021214
--- /dev/null
+++ b/277
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FS QA Test No. 277
+#
+# Check if ctime update caused by chattr is written to disk
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Fujitsu.  All Rights Reserved.
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
+# creator
+owner=lizf@cn.fujitsu.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $SCRATCH_MNT/tmp*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+touch $SCRATCH_MNT/tmp
+_scratch_remount
+ctime1=`stat -c %z $SCRATCH_MNT/tmp`
+
+sleep 1
+chattr +A $SCRATCH_MNT/tmp
+chattr -A $SCRATCH_MNT/tmp
+ctime2=`stat -c %z $SCRATCH_MNT/tmp`
+
+_scratch_remount
+ctime3=`stat -c %z $SCRATCH_MNT/tmp`
+
+if [ "$ctime1" == "$ctime2" ]; then
+	echo "error: ctime not updated after chattr"
+elif [ "$ctime1" == "$ctime3" ]; then
+	echo "error: on disk ctime not updated"
+else
+	status=0
+fi
+
+exit
diff --git a/277.out b/277.out
new file mode 100644
index 0000000..9614b16
--- /dev/null
+++ b/277.out
@@ -0,0 +1 @@
+QA output created by 277
diff --git a/group b/group
index dd9f00d..99592d3 100644
--- a/group
+++ b/group
@@ -390,3 +390,4 @@ deprecated
 274 auto rw
 275 auto rw
 276 auto rw metadata
+277 auto ioctl quick metadata
-- 
1.7.3.1

