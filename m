Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbaIZEV3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 00:21:29 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH v4 05/15] btrfs: new case to run btrfs balance and device replace operations simultaneously
Date: Fri, 26 Sep 2014 12:14:51 +0800
Message-Id: <1411704901-12723-6-git-send-email-eguan@redhat.com>
In-Reply-To: <1411704901-12723-1-git-send-email-eguan@redhat.com>
References: <1411704901-12723-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs balance and replace operations simultaneously with fsstress
running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/rc           |  73 +++++++++++++++++++++++++++++++
 tests/btrfs/063     | 122 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/063.out |   2 +
 tests/btrfs/group   |   1 +
 4 files changed, 198 insertions(+)
 create mode 100755 tests/btrfs/063
 create mode 100644 tests/btrfs/063.out

diff --git a/common/rc b/common/rc
index b19533f..28c07f6 100644
--- a/common/rc
+++ b/common/rc
@@ -2163,6 +2163,24 @@ _require_scratch_dev_pool()
 	done
 }
 
+# ensure devices in SCRATCH_DEV_POOL are of the same size
+# must be called after _require_scratch_dev_pool
+_require_scratch_dev_pool_equal_size()
+{
+	local _size
+	local _newsize
+	local _dev
+
+	# SCRATCH_DEV has been set to the first device in SCRATCH_DEV_POOL
+	_size=`_get_device_size $SCRATCH_DEV`
+	for _dev in $SCRATCH_DEV_POOL; do
+		_newsize=`_get_device_size $_dev`
+		if [ $_size -ne $_newsize ]; then
+			_notrun "This test requires devices in SCRATCH_DEV_POOL have the same size"
+		fi
+	done
+}
+
 # We will check if the device is deletable
 _require_deletable_scratch_dev_pool()
 {
@@ -2634,6 +2652,61 @@ _btrfs_stress_remount_compress()
 	done
 }
 
+# stress btrfs by replacing devices in a loop
+# Note that at least 3 devices are needed in SCRATCH_DEV_POOL and the last
+# device should be free(not used by btrfs)
+_btrfs_stress_replace()
+{
+	local btrfs_mnt=$1
+
+	# The device number in SCRATCH_DEV_POOL should be at least 3,
+	# one is SCRATCH_DEV, one is to be replaced, one is free device
+	# we won't replace SCRATCH_DEV, see below for reason
+	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt 3 ]; then
+		echo "_btrfs_stress_replace requires at least 3 devices in SCRATCH_DEV_POOL"
+		return
+	fi
+
+	# take the last device as the first free_dev
+	local free_dev="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $NF}'`"
+
+	# free_dev should be really free
+	if $BTRFS_UTIL_PROG filesystem show $btrfs_mnt | grep -q "$free_dev"; then
+		echo "_btrfs_stress_replace: $free_dev is used by btrfs"
+		return
+	fi
+
+	# dev_pool is device list being currently used by btrfs (excluding SCRATCH_DEV)
+	# and can be replaced. We don't replace SCRATCH_DEV because it will be used in
+	# _scratch_mount and _check_scratch_fs etc.
+	local dev_pool=`echo $SCRATCH_DEV_POOL | sed -e "s# *$SCRATCH_DEV *##" \
+			-e "s# *$free_dev *##"`
+
+	# set the first device in dev_pool as the first src_dev to be replaced
+	local src_dev=`echo $dev_pool | $AWK_PROG '{print $1}'`
+
+	echo "dev_pool=$dev_pool"
+	echo "free_dev=$free_dev, src_dev=$src_dev"
+	while true; do
+		echo "Replacing $src_dev with $free_dev"
+		$BTRFS_UTIL_PROG replace start -fB $src_dev $free_dev $btrfs_mnt
+		if [ $? -ne 0 ]; then
+			# don't update src_dev and free_dev if replace failed
+			continue
+		fi
+		dev_pool="$dev_pool $free_dev"
+		dev_pool=`echo $dev_pool | sed -e "s# *$src_dev *##"`
+		free_dev=$src_dev
+		src_dev=`echo $dev_pool | $AWK_PROG '{print $1}'`
+	done
+}
+
+# return device size in kb
+_get_device_size()
+{
+	grep `_short_dev $1` /proc/partitions | awk '{print $3}'
+}
+
 init_rc()
 {
 	if [ "$iam" == new ]
diff --git a/tests/btrfs/063 b/tests/btrfs/063
new file mode 100755
index 0000000..94adc21
--- /dev/null
+++ b/tests/btrfs/063
@@ -0,0 +1,122 @@
+#! /bin/bash
+# FSQA Test No. btrfs/063
+#
+# Run btrfs balance and replace operations simultaneously with fsstress
+# running in background.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2014 Red Hat Inc. All rights reserved.
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
+status=1
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+# we check scratch dev after each loop
+_require_scratch_nocheck
+_require_scratch_dev_pool 5
+_require_scratch_dev_pool_equal_size
+_btrfs_get_profile_configs replace
+
+rm -f $seqres.full
+
+run_test()
+{
+	local mkfs_opts=$1
+	local saved_scratch_dev_pool=$SCRATCH_DEV_POOL
+
+	echo "Test $mkfs_opts" >>$seqres.full
+
+	# remove the last device from the SCRATCH_DEV_POOL list so
+	# _scratch_pool_mkfs won't use all devices in pool
+	local last_dev="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $NF}'`"
+	SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | sed -e "s# *$last_dev *##"`
+	_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
+	# make sure we created btrfs with desired options
+	if [ $? -ne 0 ]; then
+		echo "mkfs $mkfs_opts failed"
+		SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+		return
+	fi
+	_scratch_mount >>$seqres.full 2>&1
+	SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+
+	args=`_scale_fsstress_args -p 20 -n 100 $FSSTRESS_AVOID -d $SCRATCH_MNT/stressdir`
+	echo "Run fsstress $args" >>$seqres.full
+	$FSSTRESS_PROG $args >/dev/null 2>&1 &
+	fsstress_pid=$!
+
+	echo -n "Start balance worker: " >>$seqres.full
+	_btrfs_stress_balance $SCRATCH_MNT >/dev/null 2>&1 &
+	balance_pid=$!
+	echo "$balance_pid" >>$seqres.full
+
+	echo -n "Start replace worker: " >>$seqres.full
+	_btrfs_stress_replace $SCRATCH_MNT >>$seqres.full 2>&1 &
+	replace_pid=$!
+	echo "$replace_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+	kill $balance_pid $replace_pid
+	wait
+	# wait for the balance and replace operations to finish
+	while ps aux | grep "balance start" | grep -qv grep; do
+		sleep 1
+	done
+	while ps aux | grep "replace start" | grep -qv grep; do
+		sleep 1
+	done
+
+	echo "Scrub the filesystem" >>$seqres.full
+	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT >>$seqres.full 2>&1
+	if [ $? -ne 0 ]; then
+		echo "Scrub find errors in \"$mkfs_opts\" test" | tee -a $seqres.full
+	fi
+
+	_scratch_unmount
+	# we called _require_scratch_nocheck instead of _require_scratch
+	# do check after test for each profile config
+	_check_scratch_fs
+}
+
+echo "Silence is golden"
+for t in "${_btrfs_profile_configs[@]}"; do
+	run_test "$t"
+done
+
+status=0
+exit
diff --git a/tests/btrfs/063.out b/tests/btrfs/063.out
new file mode 100644
index 0000000..de35fc5
--- /dev/null
+++ b/tests/btrfs/063.out
@@ -0,0 +1,2 @@
+QA output created by 063
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 7aa9bf3..e234bc2 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -65,3 +65,4 @@
 060 auto balance scrub
 061 auto balance defrag compress
 062 auto balance remount compress
+063 auto balance replace
-- 
1.8.3.1

