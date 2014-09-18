Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbaIRFux (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 01:50:53 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH v3 10/15] btrfs: new case to run device replace and scrub operations simultaneously
Date: Thu, 18 Sep 2014 13:49:34 +0800
Message-Id: <1411019379-8104-11-git-send-email-eguan@redhat.com>
In-Reply-To: <1411019379-8104-1-git-send-email-eguan@redhat.com>
References: <1411019379-8104-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs replace operations and scrub simultaneously with fsstress
running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/btrfs/068     | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/068.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 126 insertions(+)
 create mode 100755 tests/btrfs/068
 create mode 100644 tests/btrfs/068.out

diff --git a/tests/btrfs/068 b/tests/btrfs/068
new file mode 100755
index 0000000..220e608
--- /dev/null
+++ b/tests/btrfs/068
@@ -0,0 +1,123 @@
+#! /bin/bash
+# FSQA Test No. btrfs/068
+#
+# Run btrfs replace operations and scrub simultaneously with fsstress
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
+	echo -n "Start replace worker: " >>$seqres.full
+	_btrfs_stress_replace $SCRATCH_MNT >>$seqres.full 2>&1 &
+	replace_pid=$!
+	echo "$replace_pid" >>$seqres.full
+
+	echo -n "Start scrub worker: " >>$seqres.full
+	_btrfs_stress_scrub $SCRATCH_MNT >/dev/null 2>&1 &
+	scrub_pid=$!
+	echo "$scrub_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+	kill $replace_pid $scrub_pid
+	wait
+
+	# wait for the scrub and replace operations to finish
+	while ps aux | grep "scrub start" | grep -qv grep; do
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
diff --git a/tests/btrfs/068.out b/tests/btrfs/068.out
new file mode 100644
index 0000000..d10c9bd
--- /dev/null
+++ b/tests/btrfs/068.out
@@ -0,0 +1,2 @@
+QA output created by 068
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index d515ff5..1e83505 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -70,3 +70,4 @@
 065 auto subvol scrub
 066 auto subvol defrag compress
 067 auto subvol remount compress
+068 auto replace scrub
-- 
1.8.3.1

