Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbaIZEne (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 00:43:34 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH v4 14/15] btrfs: new case to run btrfs scrub and remount with different compress algorithms simultaneously
Date: Fri, 26 Sep 2014 12:15:00 +0800
Message-Id: <1411704901-12723-15-git-send-email-eguan@redhat.com>
In-Reply-To: <1411704901-12723-1-git-send-email-eguan@redhat.com>
References: <1411704901-12723-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs scrub and remount with different compress algorithms
simultaneously with fsstress running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/btrfs/072     | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/072.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 117 insertions(+)
 create mode 100755 tests/btrfs/072
 create mode 100644 tests/btrfs/072.out

diff --git a/tests/btrfs/072 b/tests/btrfs/072
new file mode 100755
index 0000000..b185f85
--- /dev/null
+++ b/tests/btrfs/072
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FSQA Test No. btrfs/072
+#
+# Run btrfs scrub and remount with different compress algorithms
+# simultaneously with fsstress running in background.
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
+	echo -n "Start scrub worker: " >>$seqres.full
+	_btrfs_stress_scrub $SCRATCH_MNT >/dev/null 2>&1 &
+	scrub_pid=$!
+	echo "$scrub_pid" >>$seqres.full
+
+	echo -n "Start remount worker: " >>$seqres.full
+	_btrfs_stress_remount_compress $SCRATCH_MNT >/dev/null 2>&1 &
+	remount_pid=$!
+	echo "$remount_pid" >>$seqres.full
+
+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
+	wait $fsstress_pid
+	kill $scrub_pid $remount_pid
+	wait
+	# wait for the scrub and remount operations to finish
+	while ps aux | grep "scrub start" | grep -qv grep; do
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
diff --git a/tests/btrfs/072.out b/tests/btrfs/072.out
new file mode 100644
index 0000000..590bbc6
--- /dev/null
+++ b/tests/btrfs/072.out
@@ -0,0 +1,2 @@
+QA output created by 072
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 5377acf..e631d5b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -74,3 +74,4 @@
 069 auto replace defrag compress
 070 auto replace remount compress
 071 auto scrub defrag compress
+072 auto scrub remount compress
-- 
1.8.3.1

