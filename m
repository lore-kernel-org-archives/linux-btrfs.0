Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaHTRfX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 13:35:23 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH 07/15] btrfs: new case to run btrfs subvolume create/delete operations and scrub simultaneously
Date: Thu, 21 Aug 2014 01:33:56 +0800
Message-Id: <1408556044-907-9-git-send-email-eguan@redhat.com>
In-Reply-To: <1408556044-907-1-git-send-email-eguan@redhat.com>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs subvolume create/mount/umount/delete and btrfs scrub
operation simultaneously, with fsstress running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/btrfs/063     | 146 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/063.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 149 insertions(+)
 create mode 100755 tests/btrfs/063
 create mode 100644 tests/btrfs/063.out

diff --git a/tests/btrfs/063 b/tests/btrfs/063
new file mode 100755
index 0000000..68e6a25
--- /dev/null
+++ b/tests/btrfs/063
@@ -0,0 +1,146 @@
+#! /bin/bash
+# FSQA Test No. btrfs/063
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
+	local saved_mkfs_opts=$MKFS_OPTIONS
+	local subvol_mnt=$tmp.mnt
+
+	echo "Test $mkfs_opts" >>$seqres.full
+
+	MKFS_OPTIONS="$MKFS_OPTIONS $mkfs_opts"
+	# dup only works on single device
+	if [[ "$mkfs_opts" =~ dup ]]; then
+		_scratch_mkfs >>$seqres.full 2>&1
+	else
+		_scratch_pool_mkfs >>$seqres.full 2>&1
+	fi
+	local ret=$?
+	MKFS_OPTIONS=$saved_mkfs_opts
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
+	mkdir -p $subvol_mnt
+	(
+		while true; do
+			$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/subvol_$$
+			$MOUNT_PROG -o subvol=subvol_$$ $SCRATCH_DEV $subvol_mnt
+			$UMOUNT_PROG $subvol_mnt
+			$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/subvol_$$
+		done
+	) >/dev/null 2>&1 &
+	subvol_pid=$!
+	echo "$subvol_pid" >>$seqres.full
+
+	echo -n "Start scrub worker: " >>$seqres.full
+	(
+		while true; do
+			$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT >>$seqres.full 2>&1
+		done
+	) &
+	scrub_pid=$!
+	echo "$scrub_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+
+	kill $subvol_pid $scrub_pid
+	wait
+	# the scrub process might be still in D state and cannot be killed
+	# which could block umount, wait for it to finish
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
diff --git a/tests/btrfs/063.out b/tests/btrfs/063.out
new file mode 100644
index 0000000..de35fc5
--- /dev/null
+++ b/tests/btrfs/063.out
@@ -0,0 +1,2 @@
+QA output created by 063
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 0000845..0000b9d 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -65,3 +65,4 @@
 060 auto stress balance remount compress
 061 auto stress balance replace
 062 auto stress subvol replace
+063 auto stress subvol scrub
-- 
1.8.3.1

