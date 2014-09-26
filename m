Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbaIZEVU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 00:21:20 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH v4 02/15] btrfs: new test to run btrfs balance and scrub simultaneously
Date: Fri, 26 Sep 2014 12:14:48 +0800
Message-Id: <1411704901-12723-3-git-send-email-eguan@redhat.com>
In-Reply-To: <1411704901-12723-1-git-send-email-eguan@redhat.com>
References: <1411704901-12723-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs balance and scrub operations simultaneously with fsstress
running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/rc           |   9 +++++
 tests/btrfs/060     | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/060.out |   2 +
 tests/btrfs/group   |   1 +
 4 files changed, 126 insertions(+)
 create mode 100755 tests/btrfs/060
 create mode 100644 tests/btrfs/060.out

diff --git a/common/rc b/common/rc
index 2393c4b..d1dec8a 100644
--- a/common/rc
+++ b/common/rc
@@ -2591,6 +2591,15 @@ _btrfs_stress_subvolume()
 	done
 }
 
+# stress btrfs by running scrub in a loop
+_btrfs_stress_scrub()
+{
+	local btrfs_mnt=$1
+	while true; do
+		$BTRFS_UTIL_PROG scrub start -B $btrfs_mnt
+	done
+}
+
 init_rc()
 {
 	if [ "$iam" == new ]
diff --git a/tests/btrfs/060 b/tests/btrfs/060
new file mode 100755
index 0000000..b270c7b
--- /dev/null
+++ b/tests/btrfs/060
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FSQA Test No. btrfs/060
+#
+# Run btrfs balance and scrub operations simultaneously with fsstress
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
+	echo -n "Start scrub worker: " >>$seqres.full
+	_btrfs_stress_scrub $SCRATCH_MNT >/dev/null 2>&1 &
+	scrub_pid=$!
+	echo "$scrub_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+	kill $balance_pid $scrub_pid
+	wait
+	# wait for the balance and scrub operations to finish
+	while ps aux | grep "balance start" | grep -qv grep; do
+		sleep 1
+	done
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
diff --git a/tests/btrfs/060.out b/tests/btrfs/060.out
new file mode 100644
index 0000000..8ffce4d
--- /dev/null
+++ b/tests/btrfs/060.out
@@ -0,0 +1,2 @@
+QA output created by 060
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index c66c42c..1c60c8f 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -62,3 +62,4 @@
 057 auto quick
 058 auto quick
 059 auto balance subvol
+060 auto balance scrub
-- 
1.8.3.1

