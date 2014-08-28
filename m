Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaH1Ns4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 09:48:56 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH 07/15 v2] btrfs: new case to run btrfs subvolume create/delete operations and scrub simultaneously
Date: Thu, 28 Aug 2014 21:47:48 +0800
Message-Id: <1409233676-22787-8-git-send-email-eguan@redhat.com>
In-Reply-To: <1409233676-22787-1-git-send-email-eguan@redhat.com>
References: <1409233676-22787-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs subvolume create/mount/umount/delete and btrfs scrub
operation simultaneously, with fsstress running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/btrfs/065     | 129 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/065.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 132 insertions(+)
 create mode 100755 tests/btrfs/065
 create mode 100644 tests/btrfs/065.out

diff --git a/tests/btrfs/065 b/tests/btrfs/065
new file mode 100755
index 0000000..0135510
--- /dev/null
+++ b/tests/btrfs/065
@@ -0,0 +1,129 @@
+#! /bin/bash
+# FSQA Test No. btrfs/065
+#
+# Run btrfs subvolume create/mount/umount/delete and btrfs scrub
+# operation simultaneously, with fsstress running in background.
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
+_require_scratch_dev_pool 4
+
+rm -f $seqres.full
+
+# test case array
+tcs=(
+	"-m single -d single"
+	"-m dup -d single"
+	"-m raid0 -d raid0"
+	"-m raid1 -d raid0"
+	"-m raid1 -d raid1"
+	"-m raid10 -d raid10"
+	"-m raid5 -d raid5"
+	"-m raid6 -d raid6"
+)
+
+run_test()
+{
+	local mkfs_opts=$1
+	local subvol_mnt=$tmp.mnt
+
+	echo "Test $mkfs_opts" >>$seqres.full
+
+	# dup only works on single device
+	if [[ "$mkfs_opts" =~ dup ]]; then
+		_scratch_mkfs $mkfs_opts >>$seqres.full 2>&1
+	else
+		_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
+	fi
+	# make sure we created btrfs with desired options
+	if [ $? -ne 0 ]; then
+		echo "mkfs $mkfs_opts failed"
+		return
+	fi
+	_scratch_mount >>$seqres.full 2>&1
+
+	args=`_scale_fsstress_args -p 20 -n 100 $FSSTRESS_AVOID -d $SCRATCH_MNT/stressdir`
+	echo "Run fsstress $args" >>$seqres.full
+	$FSSTRESS_PROG $args >/dev/null 2>&1 &
+	fsstress_pid=$!
+
+	echo -n "Start subvolume worker: " >>$seqres.full
+	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt >/dev/null 2>&1 &
+	subvol_pid=$!
+	echo "$subvol_pid" >>$seqres.full
+
+	echo -n "Start scrub worker: " >>$seqres.full
+	_btrfs_stress_scrub $SCRATCH_MNT >/dev/null 2>&1 &
+	scrub_pid=$!
+	echo "$scrub_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+
+	kill $subvol_pid $scrub_pid
+	wait
+	# wait for the scrub operation to finish
+	while ps aux | grep "scrub start" | grep -qv grep; do
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
+	# in case the subvolume is still mounted
+	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
+	_scratch_unmount
+	_check_scratch_fs
+}
+
+echo "Silence is golden"
+for t in "${tcs[@]}"; do
+	run_test "$t"
+done
+
+status=0
+exit
diff --git a/tests/btrfs/065.out b/tests/btrfs/065.out
new file mode 100644
index 0000000..94476cd
--- /dev/null
+++ b/tests/btrfs/065.out
@@ -0,0 +1,2 @@
+QA output created by 065
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index a214920..4685970 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -67,3 +67,4 @@
 062 auto balance remount compress
 063 auto balance replace
 064 auto subvol replace
+065 auto subvol scrub
-- 
1.8.3.1

