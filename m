Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaH1NtF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 09:49:05 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH 11/15 v2] btrfs: new case to run device replace and defrag operations simultaneously
Date: Thu, 28 Aug 2014 21:47:52 +0800
Message-Id: <1409233676-22787-12-git-send-email-eguan@redhat.com>
In-Reply-To: <1409233676-22787-1-git-send-email-eguan@redhat.com>
References: <1409233676-22787-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs replace operations and defrag simultaneously with fsstress
running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/btrfs/069     | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/069.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 136 insertions(+)
 create mode 100755 tests/btrfs/069
 create mode 100644 tests/btrfs/069.out

diff --git a/tests/btrfs/069 b/tests/btrfs/069
new file mode 100755
index 0000000..daaf062
--- /dev/null
+++ b/tests/btrfs/069
@@ -0,0 +1,133 @@
+#! /bin/bash
+# FSQA Test No. btrfs/069
+#
+# Run btrfs replace operations and defrag simultaneously with fsstress
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
+	rm -fr $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_scratch_dev_pool 5
+_require_scratch_dev_pool_equal_size
+
+rm -f $seqres.full
+
+# test case array
+tcs=(
+	"-m single -d single"
+	"-m raid0 -d raid0"
+	"-m raid1 -d raid0"
+	"-m raid1 -d raid1"
+	"-m raid10 -d raid10"
+#	"-m raid5 -d raid5"	# raid5 does not support replace operation yet
+#	"-m raid6 -d raid6"	# raid6 does not support replace operation yet
+)
+
+run_test()
+{
+	local mkfs_opts=$1
+	local with_compress=$2
+	local saved_scratch_dev_pool=$SCRATCH_DEV_POOL
+
+	echo "Test $mkfs_opts with $with_compress" >>$seqres.full
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
+	echo -n "Start replace worker: " >>$seqres.full
+	_btrfs_stress_replace $SCRATCH_MNT >>$seqres.full 2>&1 &
+	replace_pid=$!
+	echo "$replace_pid" >>$seqres.full
+
+	echo -n "Start defrag worker: " >>$seqres.full
+	_btrfs_stress_defrag $SCRATCH_MNT $with_compress >/dev/null 2>&1 &
+	defrag_pid=$!
+	echo "$defrag_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+	kill $replace_pid $defrag_pid
+	wait
+
+	# wait for the defrag and replace operations to finish
+	while ps aux | grep "btrfs filesystem defrag" | grep -qv grep; do
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
+	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT >/dev/null 2>&1
+	_scratch_unmount
+	_check_scratch_fs
+}
+
+echo "Silence is golden"
+for t in "${tcs[@]}"; do
+	run_test "$t" nocompress
+	run_test "$t" compress
+done
+
+status=0
+exit
diff --git a/tests/btrfs/069.out b/tests/btrfs/069.out
new file mode 100644
index 0000000..532a929
--- /dev/null
+++ b/tests/btrfs/069.out
@@ -0,0 +1,2 @@
+QA output created by 069
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 1e83505..53f5f4b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -71,3 +71,4 @@
 066 auto subvol defrag compress
 067 auto subvol remount compress
 068 auto replace scrub
+069 auto replace defrag compress
-- 
1.8.3.1

