From: WuBo <wu.bo@cn.fujitsu.com>
Subject: [PATCH v2 1/3] xfstests 273: add a copy and reserve test
Date: Tue, 08 Nov 2011 11:40:38 +0800
Message-ID: <4EB8A4B6.3030604@cn.fujitsu.com>
References: <4EB8A441.7090506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-fsdevel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EB8A441.7090506@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This test is a stress test. It creates a set of threads for coping small files 
into disk. I use a 2G disk for test, the ENOSPC arises usually but the disk is 
not full under kenerl 3.0 with intel64.

Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>
---
 273     |  145 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 273.out |    4 ++
 group   |    1 +
 3 files changed, 150 insertions(+), 0 deletions(-)
 create mode 100755 273
 create mode 100644 273.out

diff --git a/273 b/273
new file mode 100755
index 0000000..2965132
--- /dev/null
+++ b/273
@@ -0,0 +1,145 @@
+#! /bin/bash
+# FS QA Test No. 273
+#
+# reservation test with heavy cp workload
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
+status=0	# success is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $SCRATCH_MNT/* $tmp.*
+	_scratch_unmount
+}
+
+. ./common.rc
+. ./common.filter
+
+threads=50
+count=1
+
+_threads_set()
+{
+	_cpu_num=`cat /proc/cpuinfo | grep "processor" | wc -l`
+	threads=$(($_cpu_num * 50))
+	if [ $threads -gt 200 ]
+	then
+		threads=200
+	fi
+}
+
+_file_create()
+{
+	_i=0
+
+	if ! mkdir $SCRATCH_MNT/origin
+	then
+		echo "mkdir origin err"
+		status=1
+		exit
+	fi
+
+	cd $SCRATCH_MNT/origin
+
+	_disksize=`df --block-size=1 | grep $SCRATCH_DEV | awk '{print $2}'`
+	_disksize=$(($_disksize / 3))
+	_num=$(($_disksize / $count / $threads / 4096))
+	_count=$count
+	while [ $_i -lt $_num ]
+	do
+		dd if=/dev/zero of=file_$_i bs=4096 count=$_count >/dev/null 2>&1
+		_i=$(($_i + 1))
+	done
+
+	cd $here
+}
+
+_porter()
+{
+	_suffix=$1
+
+	if ! mkdir $SCRATCH_MNT/sub_$_suffix
+	then
+		echo "mkdir sub_xxx err"
+		status=1
+		exit
+	fi
+
+	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>&1
+	if [ $? -ne 0 ]
+	then
+		echo "_porter $_suffix not complete"
+	fi
+	
+	sync
+}
+
+_do_workload()
+{
+	_pids=""
+	_pid=1
+	
+	rm -rf $SCRATCH_MNT/*
+
+	_threads_set
+	_file_create
+
+	_threads=$threads
+
+	while [ $_pid -lt $_threads ]
+	do
+		_porter $_pid &
+		_pids="$_pids $!"
+		_pid=$(($_pid + 1))
+	done
+
+	wait $_pids
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os IRIX Linux
+_require_scratch
+
+echo "------------------------------"
+echo "start the workload"
+echo "------------------------------"
+
+rm -f $seq.full
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
+_scratch_mount
+
+_do_workload
+
+_check_scratch_fs
+status=$?
+exit
diff --git a/273.out b/273.out
new file mode 100644
index 0000000..146af43
--- /dev/null
+++ b/273.out
@@ -0,0 +1,4 @@
+QA output created by 273
+------------------------------
+start the workload
+------------------------------
diff --git a/group b/group
index 616cbdd..b8245bf 100644
--- a/group
+++ b/group
@@ -386,3 +386,4 @@ deprecated
 270 auto quota rw prealloc ioctl enospc
 271 auto rw quick
 272 auto enospc rw
+273 auto rw
-- 
1.7.3.1
