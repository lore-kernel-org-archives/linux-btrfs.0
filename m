Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbaIRFu1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 01:50:27 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH v3 03/15] btrfs: new test to run btrfs balance and defrag operations simultaneously
Date: Thu, 18 Sep 2014 13:49:27 +0800
Message-Id: <1411019379-8104-4-git-send-email-eguan@redhat.com>
In-Reply-To: <1411019379-8104-1-git-send-email-eguan@redhat.com>
References: <1411019379-8104-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs balance and defrag operations simultaneously with fsstress
running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/rc           |  20 +++++++++
 tests/btrfs/061     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/061.out |   2 +
 tests/btrfs/group   |   1 +
 4 files changed, 139 insertions(+)
 create mode 100755 tests/btrfs/061
 create mode 100644 tests/btrfs/061.out

diff --git a/common/rc b/common/rc
index cc5901f..a333af8 100644
--- a/common/rc
+++ b/common/rc
@@ -2594,6 +2594,26 @@ _btrfs_stress_scrub()
 	done
 }
 
+# stress btrfs by defragmenting every file/dir in a loop and compress file
+# contents while defragmenting if second argument is not "nocompress"
+_btrfs_stress_defrag()
+{
+	local btrfs_mnt=$1
+	local compress=$2
+
+	while true; do
+		if [ "$compress" == "nocompress" ]; then
+			find $btrfs_mnt \( -type f -o -type d \) -exec \
+			$BTRFS_UTIL_PROG filesystem defrag {} \;
+		else
+			find $btrfs_mnt \( -type f -o -type d \) -exec \
+			$BTRFS_UTIL_PROG filesystem defrag -clzo {} \;
+			find $btrfs_mnt \( -type f -o -type d \) -exec \
+			$BTRFS_UTIL_PROG filesystem defrag -czlib {} \;
+		fi
+	done
+}
+
 init_rc()
 {
 	if [ "$iam" == new ]
diff --git a/tests/btrfs/061 b/tests/btrfs/061
new file mode 100755
index 0000000..4aeb366
--- /dev/null
+++ b/tests/btrfs/061
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FSQA Test No. btrfs/061
+#
+# Run btrfs balance and defrag operations simultaneously with fsstress
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
+_require_scratch_dev_pool 4
+_btrfs_get_profile_configs
+
+rm -f $seqres.full
+
+run_test()
+{
+	local mkfs_opts=$1
+	local with_compress=$2
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
+	echo -n "Start balance worker: " >>$seqres.full
+	_btrfs_stress_balance $SCRATCH_MNT >/dev/null 2>&1 &
+	balance_pid=$!
+	echo "$balance_pid" >>$seqres.full
+
+	echo -n "Start defrag worker: " >>$seqres.full
+	_btrfs_stress_defrag $SCRATCH_MNT $with_compress >/dev/null 2>&1 &
+	defrag_pid=$!
+	echo "$defrag_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+	kill $balance_pid $defrag_pid
+	wait
+	# wait for the balance and defrag operations to finish
+	while ps aux | grep "balance start" | grep -qv grep; do
+		sleep 1
+	done
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
diff --git a/tests/btrfs/061.out b/tests/btrfs/061.out
new file mode 100644
index 0000000..273be9e
--- /dev/null
+++ b/tests/btrfs/061.out
@@ -0,0 +1,2 @@
+QA output created by 061
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 1c60c8f..85d30b3 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -63,3 +63,4 @@
 058 auto quick
 059 auto balance subvol
 060 auto balance scrub
+061 auto balance defrag compress
-- 
1.8.3.1

