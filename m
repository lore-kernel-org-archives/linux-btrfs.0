From: WuBo <wu.bo@cn.fujitsu.com>
Subject: [PATCH 1/3] xfstests 264: add a copy and reserve test
Date: Thu, 03 Nov 2011 11:08:55 +0800
Message-ID: <4EB205C7.6010906@cn.fujitsu.com>
References: <4EB20505.7070005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-fsdevel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EB20505.7070005@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This test is a stress test. It creates a set of threads for coping small files 
into disk. I use a 2G disk for test, the ENOSPC arises usually but the disk is 
not full under kenerl 3.0 with intel64.

Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>
---
 264     |  158 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 264.out |    6 ++
 group   |    1 +
 3 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100755 264
 create mode 100644 264.out

diff --git a/264 b/264
new file mode 100755
index 0000000..8df56c2
--- /dev/null
+++ b/264
@@ -0,0 +1,158 @@
+#! /bin/bash
+# FS QA Test No. 264
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
+	rm -rf $TEST_DIR/* $tmp.*
+	
+	if [ $_resize -eq 1 ]
+	then
+		btrfs filesystem resize ${_old}B $TEST_DIR > /dev/null 2>&1
+	fi
+	
+	_cleanup_testdir
+}
+
+. ./common.rc
+. ./common.filter
+
+threads=0  # will be set later
+count=1
+
+_threads_set()
+{
+	_cpu_num=`cat /proc/cpuinfo | grep "processor" | wc -l`
+	threads=$(( $_cpu_num * 50 ))
+	if [ $threads -gt 200 ]
+	then
+		threads=200
+	fi
+
+	echo "create $threads threads to run..."
+}
+
+_file_create()
+{
+	_i=0
+
+	if ! mkdir $TEST_DIR/origin
+	then
+		echo "mkdir origin err"
+		status=1
+		exit
+	fi
+
+	cd $TEST_DIR/origin
+
+	_disksize=`df --block-size=1 | grep $TEST_DEV | awk '{print $2}'`
+	_disksize=$(( $_disksize / 3 ))
+	_num=$(( $_disksize / $count / $threads / 4096 ))
+	_count=$count
+	while [ $_i -lt $_num ]
+	do
+		dd if=/dev/zero of=file_$_i bs=4096 count=$_count > /dev/null 2>&1
+		_i=$(( $_i + 1 ))
+	done
+
+	cd $here
+}
+
+_porter()
+{
+	_suffix=$1
+
+	if ! mkdir $TEST_DIR/sub_$_suffix
+	then
+		echo "mkdir sub_xxx err"
+		status=1
+		exit
+	fi
+
+	cp -r $TEST_DIR/origin $TEST_DIR/sub_$_suffix
+
+	sync
+}
+
+_do_workload()
+{
+	_pid=1
+	
+	rm -rf $TEST_DIR/*
+
+	_threads_set
+	_file_create
+
+	_threads=$threads
+
+	while [ $_pid -lt $_threads ]
+	do
+		_porter $_pid &
+
+		_pid=$(( $_pid + 1 ))
+	done
+
+	wait
+}
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os IRIX Linux
+
+_setup_testdir
+_check_test_fs
+
+echo "------------------------------"
+echo "start the workload"
+echo "------------------------------"
+	
+_resize=0
+_new=$(( 2 * 1024 * 1024 * 1024 )) # 2G
+_old=`df --block-size=1 | grep $TEST_DEV | awk '{print $2}'`
+if [ $_new -lt $_old ]
+then
+	btrfs filesystem resize ${_new}B $TEST_DIR > /dev/null 2>&1
+	if [ $? -ne 0 ]
+	then
+		echo "btrfs filesystem resize err"
+		status=1
+		exit
+	fi
+	_resize=1
+fi
+
+_do_workload
+
+echo "done"
+exit
diff --git a/264.out b/264.out
new file mode 100644
index 0000000..b218578
--- /dev/null
+++ b/264.out
@@ -0,0 +1,6 @@
+QA output created by 264
+------------------------------
+start the workload
+------------------------------
+create 100 threads to run...
+done
diff --git a/group b/group
index 2a8970c..301aaec 100644
--- a/group
+++ b/group
@@ -377,3 +377,4 @@ deprecated
 261 auto quick quota
 262 auto quick quota
 263 rw auto quick
+264 auto rw
-- 
1.7.3.1
