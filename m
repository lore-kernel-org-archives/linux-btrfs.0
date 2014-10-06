Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaJFKFc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 06:05:32 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH v5 08/15] btrfs: new case to run btrfs subvolume create/delete and defrag operations simultaneously
Date: Mon,  6 Oct 2014 18:04:47 +0800
Message-Id: <1412589894-10675-9-git-send-email-eguan@redhat.com>
In-Reply-To: <1412589894-10675-1-git-send-email-eguan@redhat.com>
References: <1412589894-10675-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs subvolume create/mount/umount/delete and btrfs defrag
operations simultaneously, with fsstress running in backgound.

Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/btrfs/067     | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/067.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 120 insertions(+)
 create mode 100755 tests/btrfs/067
 create mode 100644 tests/btrfs/067.out

diff --git a/tests/btrfs/067 b/tests/btrfs/067
new file mode 100755
index 0000000..2c1e284
--- /dev/null
+++ b/tests/btrfs/067
@@ -0,0 +1,117 @@
+#! /bin/bash
+# FSQA Test No. btrfs/067
+#
+# Run btrfs subvolume create/mount/umount/delete and btrfs defrag
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
+_require_scratch_dev_pool 4
+_btrfs_get_profile_configs
+
+rm -f $seqres.full
+
+run_test()
+{
+	local mkfs_opts=$1
+	local with_compress=$2
+	local subvol_mnt=$TEST_DIR/$seq.mnt
+
+	echo "Test $mkfs_opts with $with_compress" >>$seqres.full
+
+	_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
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
+	echo -n "Start defrag worker: " >>$seqres.full
+	_btrfs_stress_defrag $SCRATCH_MNT $with_compress >/dev/null 2>&1 &
+	defrag_pid=$!
+	echo "$defrag_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+
+	kill $subvol_pid $defrag_pid
+	wait
+	# wait for btrfs defrag process to exit, otherwise it will block umount
+	while ps aux | grep "btrfs filesystem defrag" | grep -qv grep; do
+		sleep 1
+	done
+
+	echo "Scrub the filesystem" >>$seqres.full
+	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT >>$seqres.full 2>&1
+	if [ $? -ne 0 ]; then
+		echo "Scrub find errors in \"$mkfs_opts\" test" | tee -a $seqres.full
+	fi
+
+	# in case the subvolume is still mounted
+	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
+	_scratch_unmount
+	# we called _require_scratch_nocheck instead of _require_scratch
+	# do check after test for each profile config
+	_check_scratch_fs
+}
+
+echo "Silence is golden"
+for t in "${_btrfs_profile_configs[@]}"; do
+	run_test "$t" nocompress
+	run_test "$t" compress
+done
+
+status=0
+exit
diff --git a/tests/btrfs/067.out b/tests/btrfs/067.out
new file mode 100644
index 0000000..daa1545
--- /dev/null
+++ b/tests/btrfs/067.out
@@ -0,0 +1,2 @@
+QA output created by 067
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 0770882..2420042 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -69,3 +69,4 @@
 064 auto balance replace
 065 auto subvol replace
 066 auto subvol scrub
+067 auto subvol defrag compress
-- 
1.8.3.1

