From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 4/5] 265: Functional test case for the btrfs raid operations
Date: Thu, 20 Oct 2011 23:41:21 +0800
Message-ID: <1319125282-17062-5-git-send-email-Anand.Jain@oracle.com>
References: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
 <1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
Cc: Anand Jain <Anand.Jain@oracle.com>
To: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

This will verify the various raid features in btrfs and device
replacement functionality.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 265     |  187 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 265.out |    2 +
 group   |    1 +
 3 files changed, 190 insertions(+), 0 deletions(-)
 create mode 100755 265
 create mode 100644 265.out

diff --git a/265 b/265
new file mode 100755
index 0000000..10f214f
--- /dev/null
+++ b/265
@@ -0,0 +1,187 @@
+#! /bin/bash
+# FS QA Test No. 265
+#
+# btrfs vol tests
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
+dev_removed=0
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+    if [ $dev_removed == 1 ]; then
+        umount $SCRATCH_MNT
+        _devmgt_add "${DEVHTL}"
+    fi
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
+_require_scratch_dev_pool
+_require_deletable_scratch_dev_pool
+
+# Test cases related to raid in btrfs
+_test_raid0()
+{
+	export MKFS_OPTIONS="-m raid0 -d raid0"
+	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
+	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
+	umount $SCRATCH_MNT
+}
+
+_test_raid1()
+{
+	export MKFS_OPTIONS="-m raid1 -d raid1"
+	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
+	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
+	umount $SCRATCH_MNT
+}
+
+_test_raid10()
+{
+	export MKFS_OPTIONS="-m raid10 -d raid10"
+	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
+	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
+	umount $SCRATCH_MNT
+}
+
+_test_single()
+{
+	export MKFS_OPTIONS="-m single -d single"
+	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
+	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
+	umount $SCRATCH_MNT
+}
+
+_test_add()
+{
+	local i
+	local devs[]="( $SCRATCH_DEV_POOL )"
+	local n=${#devs[@]}
+
+	n=$(($n-1))
+
+	export MKFS_OPTIONS=""
+	_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
+	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
+	for i in `seq 1 $n`; do
+		btrfs device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
+	done
+	btrfs filesystem balance $SCRATCH_MNT || _fail "balance failed"
+	umount $SCRATCH_MNT
+}
+
+_test_replace()
+{
+	local i
+	local devs=( $SCRATCH_DEV_POOL )
+	local n=${#devs[@]}
+	local ds
+	local d
+	local DEVHTL=""
+
+	# exclude the last disk in the disk pool
+	n=$(($n-1))
+	ds=${devs[@]:0:$n}
+
+	export MKFS_OPTIONS="-m raid1 -d raid1"
+	_scratch_mkfs "$ds" > /dev/null 2>&1 || _fail "tr: mkfs failed"
+	_scratch_mount
+	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
+	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
+
+	#pick the 2nd last disk 
+	ds=${devs[@]:$(($n-1)):1}
+
+	# retrive the HTL for this scsi disk
+	d=`echo $ds|cut -d"/" -f3`
+	DEVHTL=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
+
+	#fail disk
+	_devmgt_remove ${DEVHTL}
+	dev_removed=1
+
+	btrfs fi show $SCRATCH_DEV | grep "Some devices missing" > /dev/null || _fail \
+							"btrfs did not report device missing"
+
+	# add a new disk to btrfs
+	ds=${devs[@]:$(($n)):1}
+	btrfs device add ${ds} $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev add failed"
+	# in some system balance fails if there is no delay (a bug)
+	# putting sleep 10 to work around as of now
+	# sleep 10
+	btrfs fi balance $SCRATCH_MNT || _fail "dev balance failed"
+
+	# cleaup. add the removed disk
+	umount $SCRATCH_MNT
+	_devmgt_add "${DEVHTL}"
+	dev_removed=0
+}
+
+_test_remove()
+{
+	_scratch_mkfs "$SCRATCH_DEV_POOL" > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
+	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
+
+	# pick last dev in the list
+	dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
+	btrfs device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
+	btrfs fi show $SCRATCH_DEV 2>&1 | grep $dev_del > /dev/null && _fail "btrfs still shows the deleted dev"
+	umount $SCRATCH_MNT
+}
+
+_test_raid0
+_test_raid1
+_test_raid10
+_test_single
+_test_add
+_test_replace
+_test_remove
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
index d2abe42..94ddef6 100644
--- a/group
+++ b/group
@@ -378,3 +378,4 @@ deprecated
 262 auto quick quota
 263 rw auto quick
 264 auto
+265 auto
-- 
1.7.7

