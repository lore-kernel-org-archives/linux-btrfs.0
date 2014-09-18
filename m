Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbaIRFub (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 01:50:31 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH v3 04/15] btrfs: new case to run btrfs balance and remount with different compress algorithms
Date: Thu, 18 Sep 2014 13:49:28 +0800
Message-Id: <1411019379-8104-5-git-send-email-eguan@redhat.com>
In-Reply-To: <1411019379-8104-1-git-send-email-eguan@redhat.com>
References: <1411019379-8104-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs balance and remount with different compress algorithms
simultaneously, with fsstress running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/rc           |  14 +++++++
 tests/btrfs/062     | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/062.out |   2 +
 tests/btrfs/group   |   1 +
 4 files changed, 131 insertions(+)
 create mode 100755 tests/btrfs/062
 create mode 100644 tests/btrfs/062.out

diff --git a/common/rc b/common/rc
index a333af8..571dfad 100644
--- a/common/rc
+++ b/common/rc
@@ -2614,6 +2614,20 @@ _btrfs_stress_defrag()
 	done
 }
 
+# stress btrfs by remounting it with different compression algorithms in a loop
+# run this with fsstress running at background could exercise the compression
+# code path and ensure no race when switching compression algorithm with constant
+# I/O activity.
+_btrfs_stress_remount_compress()
+{
+	local btrfs_mnt=$1
+	while true; do
+		for algo in no zlib lzo; do
+			$MOUNT_PROG -o remount,compress=$algo $btrfs_mnt
+		done
+	done
+}
+
 init_rc()
 {
 	if [ "$iam" == new ]
diff --git a/tests/btrfs/062 b/tests/btrfs/062
new file mode 100755
index 0000000..274da5c
--- /dev/null
+++ b/tests/btrfs/062
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FSQA Test No. btrfs/062
+#
+# Run btrfs balance and remount with different compress algorithms
+# simultaneously, with fsstress running in background.
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
+
+	echo "Test $mkfs_opts" >>$seqres.full
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
+	echo -n "Start balance worker: " >>$seqres.full
+	_btrfs_stress_balance $SCRATCH_MNT >/dev/null 2>&1 &
+	balance_pid=$!
+	echo "$balance_pid" >>$seqres.full
+
+	echo -n "Start remount worker: " >>$seqres.full
+	_btrfs_stress_remount_compress $SCRATCH_MNT >/dev/null 2>&1 &
+	remount_pid=$!
+	echo "$remount_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+	kill $balance_pid $remount_pid
+	wait
+	# wait for the balance and remount loop to finish
+	while ps aux | grep "balance start" | grep -qv grep; do
+		sleep 1
+	done
+	while ps aux | grep "mount.*$SCRATCH_MNT" | grep -qv grep; do
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
diff --git a/tests/btrfs/062.out b/tests/btrfs/062.out
new file mode 100644
index 0000000..a1578f4
--- /dev/null
+++ b/tests/btrfs/062.out
@@ -0,0 +1,2 @@
+QA output created by 062
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 85d30b3..7aa9bf3 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -64,3 +64,4 @@
 059 auto balance subvol
 060 auto balance scrub
 061 auto balance defrag compress
+062 auto balance remount compress
-- 
1.8.3.1

