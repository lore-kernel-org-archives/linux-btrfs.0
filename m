Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20095 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaHOPM6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Aug 2014 11:12:58 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstest: add tests/btrfs/059 to test seed operations
Date: Fri, 15 Aug 2014 23:16:21 +0800
Message-Id: <1408115781-4876-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test contains a set of 5 sub test cases which will tests
the device add and replacement on a seed FS. The kernel messages
are checked at the end of the each of the 5 test cases to see
if there are any kernel warnings or bugs reported. As in general
btrfs do report warning when device counts such as num_devices
and rw_devices appears to be wrong.

Since the tests has to deal with the replace, it would need
up to five scratch device with same size.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/059     | 263 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/059.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 266 insertions(+)
 create mode 100755 tests/btrfs/059
 create mode 100644 tests/btrfs/059.out

diff --git a/tests/btrfs/059 b/tests/btrfs/059
new file mode 100755
index 0000000..28dc3a3
--- /dev/null
+++ b/tests/btrfs/059
@@ -0,0 +1,263 @@
+#! /bin/bash
+# FS QA Test No. 059
+#
+# Tests the volume operation with seed and verify that rw_devices and
+# num_devices doesn't get screwed up in the process. This could be loosely
+# verified (as of now) by checking the if there is any WARNINGS/BUG
+# reported in the system logs.
+#
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
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
+	umount $SCRATCH_MNT > /dev/null 2>&1
+	cd /
+	rm -f $tmp.tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+BTRFSTUNE="`set_prog_path btrfstune`"
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_dev_pool 5
+_require_command $BTRFSTUNE btrfstune
+
+tmp=/tmp/$$
+rm -f $seqres.full
+rm -f $tmp.tmp
+
+# dev1 is also the SCRATCH_DEV
+dev1="`echo $SCRATCH_DEV_POOL | cut -d" " -f1`"
+
+dev2="`echo $SCRATCH_DEV_POOL | cut -d" " -f2`"
+dev3="`echo $SCRATCH_DEV_POOL | cut -d" " -f3`"
+dev4="`echo $SCRATCH_DEV_POOL | cut -d" " -f4`"
+dev5="`echo $SCRATCH_DEV_POOL | cut -d" " -f5`"
+
+run_test_case=""
+notrun_list=''
+
+#single dev seed fs
+test1()
+{
+	run_test_case="test1"
+	echo $run_test_case >> $seqres.full
+
+	#_scratch_mkfs takes dev1 by default
+	_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+	$BTRFSTUNE -S 1 $dev1
+
+	_scratch_mount > /dev/null 2>&1
+	$BTRFS_UTIL_PROG dev add $dev2 $SCRATCH_MNT -f >> $seqres.full\
+						|| _fail "dev add failed"
+	$BTRFS_UTIL_PROG replace start -B $dev1 $dev3 $SCRATCH_MNT -f >> $seqres.full\
+						|| _fail "replace failed"
+	_scratch_unmount
+
+	return 0
+}
+
+
+# multi devs seed fs
+test2()
+{
+	run_test_case="test2"
+	mkfs_option="-d raid1 -m raid1"
+	echo $run_test_case >> $seqres.full
+
+	#_scratch_mkfs takes dev1 by default
+	_scratch_mkfs $mkfs_option $dev2 >> $seqres.full 2>&1\
+			|| _fail "mkfs failed for $run_test_case"
+
+	$BTRFSTUNE -S 1 $dev1
+	_scratch_mount > /dev/null 2>&1
+
+	$BTRFS_UTIL_PROG dev add $dev3 $SCRATCH_MNT -f
+
+	$BTRFS_UTIL_PROG replace start -B $dev1 $dev4 $SCRATCH_MNT -f >> $seqres.full\
+						|| _fail "replace failed"
+	$BTRFS_UTIL_PROG replace start -B $dev2 $dev5 $SCRATCH_MNT -f >> $seqres.full\
+						|| _fail "replace failed"
+
+	_scratch_unmount
+
+	return 0
+}
+
+
+#nested seed fs
+test3()
+{
+	run_test_case="test3"
+	echo $run_test_case >> $seqres.full
+
+	#dev1
+	_scratch_mkfs >> $seqres.full 2>&1\
+			|| _fail "mkfs failed for $run_test_case"
+	$BTRFSTUNE -S 1 $dev1
+	_scratch_mount > /dev/null 2>&1
+
+	#dev2
+	$BTRFS_UTIL_PROG dev add $dev2 $SCRATCH_MNT -f
+	_scratch_unmount
+	$BTRFSTUNE -S 1 $dev2
+	mount $dev2 $SCRATCH_MNT > /dev/null 2>&1
+
+	#dev3
+	$BTRFS_UTIL_PROG dev add $dev3 $SCRATCH_MNT -f
+	umount $SCRATCH_MNT
+	$BTRFSTUNE -S 1 $dev3
+	mount $dev3 $SCRATCH_MNT > /dev/null 2>&1
+
+	#dev4
+	$BTRFS_UTIL_PROG dev add $dev4 $SCRATCH_MNT -f
+
+	#replace
+	$BTRFS_UTIL_PROG replace start -B $dev2 $dev5 $SCRATCH_MNT -f >> $seqres.full\
+							|| _fail "replace failed"
+
+	umount $SCRATCH_MNT
+
+	return 0
+}
+
+#nested seed fs plus recursive replace
+test4()
+{
+	run_test_case="test4"
+	echo $run_test_case >> $seqres.full
+
+	#dev1
+	_scratch_mkfs >> $seqres.full 2>&1\
+			|| _fail "mkfs failed for $run_test_case"
+	$BTRFSTUNE -S 1 $dev1
+	_scratch_mount > /dev/null 2>&1
+
+	#dev2
+	$BTRFS_UTIL_PROG dev add $dev2 $SCRATCH_MNT -f
+	_scratch_unmount
+	$BTRFSTUNE -S 1 $dev2
+	mount $dev2 $SCRATCH_MNT > /dev/null 2>&1
+
+	#dev3
+	$BTRFS_UTIL_PROG dev add $dev3 $SCRATCH_MNT -f
+	umount $SCRATCH_MNT
+	$BTRFSTUNE -S 1 $dev3
+	mount $dev3 $SCRATCH_MNT > /dev/null 2>&1
+
+	#dev4
+	$BTRFS_UTIL_PROG dev add $dev4 $SCRATCH_MNT -f
+
+	#replace
+	$BTRFS_UTIL_PROG replace start -B $dev2 $dev5 $SCRATCH_MNT -f >> $seqres.full\
+							|| _fail "replace failed"
+
+	# since we have only 5 devs reuse released dev2 above
+	$BTRFS_UTIL_PROG replace start -B $dev1 $dev2 $SCRATCH_MNT -f >> $seqres.full\
+							|| _fail "replace failed"
+
+	# since we have only 5 devs reuse released dev1 above
+	$BTRFS_UTIL_PROG replace start -B $dev3 $dev1 $SCRATCH_MNT -f >> $seqres.full\
+							|| _fail "replace failed"
+
+	umount $SCRATCH_MNT
+
+	return 0
+}
+
+#test replace missing seed dev
+test5()
+{
+	run_test_case="test5"
+	mkfs_option="-d raid1 -m raid1"
+	echo $run_test_case >> $seqres.full
+
+	#_scratch_mkfs takes dev1 by default
+	_scratch_mkfs $mkfs_option $dev2 >> $seqres.full 2>&1\
+			|| _fail "mkfs failed for $run_test_case"
+
+	$BTRFSTUNE -S 1 $dev1
+
+	# this how we create a missing device in the kernel
+	wipefs -a $dev2 > /dev/null 2>&1
+
+	_scratch_mount "-o degraded" > /dev/null 2>&1
+
+	$BTRFS_UTIL_PROG dev add $dev2 $SCRATCH_MNT -f >> $seqres.full\
+						|| _fail "replace failed"
+	$BTRFS_UTIL_PROG replace start -B 1 $dev3 $SCRATCH_MNT -f >> $seqres.full\
+						|| _fail "replace failed"
+	$BTRFS_UTIL_PROG replace start -B 2 $dev4 $SCRATCH_MNT -f >> $seqres.full\
+						|| _fail "replace failed"
+	_scratch_unmount
+
+	return 0
+}
+
+check_size()
+{
+	num_uniq_sz=`fdisk -s $2 | cut -d":" -f2 | uniq | wc -l`
+	if [ $num_uniq_sz -gt 1 ]; then
+		notrun_list="$notrun_list $1"
+		return 1
+	fi
+	return 0
+}
+
+check_result()
+{
+	num_err_found=$(dmesg | grep -c "WARNING\|BUG")
+	if [ $num_err_found -ne 0 ]; then
+		echo "----- syslog at the end of $run_test_case -----" >> $seqres.full
+		dmesg >> $seqres.full
+		_fail "At the end of the tests kernel reported WARNING/BUG"
+	fi
+	dmesg -c > /dev/null
+}
+
+echo "Test seed devices operations"
+dmesg -c > /dev/null
+
+check_size "test1" "$dev1 $dev3" && test1 && check_result
+check_size "test2" "$dev1 $dev2 $dev4 $dev5" && test2 && check_result
+check_size "test3" "$dev2 $dev5" && test3 && check_result
+check_size "test4" "$dev1 $dev2 $dev3 $dev5" && test4 && check_result
+check_size "test5" "$dev1 $dev2 $dev3 $dev4" && test5 && check_result
+
+if [ -n "$notrun_list" ]; then
+	_notrun "subtest $notrun_list/test[1-5] weren't run, need same size devices"
+fi
+status=0
+exit
diff --git a/tests/btrfs/059.out b/tests/btrfs/059.out
new file mode 100644
index 0000000..6b44115
--- /dev/null
+++ b/tests/btrfs/059.out
@@ -0,0 +1,2 @@
+QA output created by 059
+Test seed devices operations
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 3fa9778..68b5c79 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -61,3 +61,4 @@
 056 auto quick
 057 auto quick
 058 auto quick
+059 auto quick
-- 
2.0.0.153.g79dcccc

