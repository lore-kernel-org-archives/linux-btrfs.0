Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39485 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbbERT7w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 15:59:52 -0400
From: Josef Bacik <jbacik@fb.com>
To: <fstests@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] fstests: btrfs balance with dm log writes test
Date: Mon, 18 May 2015 15:50:42 -0400
Message-ID: <1431978642-13124-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1431978642-13124-1-git-send-email-jbacik@fb.com>
References: <1431978642-13124-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test runs fsstress+balance+defrag and then replays every FUA in the log and
mounts, scrubs and then fscks the fs to make sure it does the balance recovery
properly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 tests/btrfs/093     | 135 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/093.out |   1 +
 tests/btrfs/group   |   1 +
 3 files changed, 137 insertions(+)
 create mode 100644 tests/btrfs/093
 create mode 100644 tests/btrfs/093.out

diff --git a/tests/btrfs/093 b/tests/btrfs/093
new file mode 100644
index 0000000..26f1c69
--- /dev/null
+++ b/tests/btrfs/093
@@ -0,0 +1,135 @@
+#! /bin/bash
+# FSQA Test No. btrfs/093
+#
+# Run btrfs balance and defrag operations simultaneously with fsstress
+# running in background on top of dm-log-writes.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2015 Facebook. All rights reserved.
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
+. ./common/dmlogwrites
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+# we check scratch dev after each loop
+_need_to_be_root
+_require_scratch_nocheck
+_require_dm_log_writes
+
+rm -f $seqres.full
+
+_wait_balance()
+{
+	while [ 1 ]
+	do
+		$BTRFS_UTIL_PROG filesystem balance status $SCRATCH_MNT \
+			| grep "No balance" >> $seqres.full
+		[ $? -eq 0 ] && break
+		sleep 1
+	done
+}
+
+run_test()
+{
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
+}
+
+_init_log_writes
+
+_log_writes_mkfs >> $seqres.full 2>&1
+
+_mount_log_writes
+
+run_test "$t" nocompress
+
+_unmount_log_writes
+_log_writes_remove
+
+# Get the number of entries in the log
+NUM_ENTRIES=$($REPLAYLOG_PROG --log $LOGWRITES_DEV --num-entries)
+
+# Start at the first FUA after the mkfs
+ENTRY=$($REPLAYLOG_PROG --log $LOGWRITES_DEV --start-mark mkfs \
+	--find --next-fua)
+
+while [ $ENTRY -lt $NUM_ENTRIES ];
+do
+	echo "Replaying to $ENTRY" >> $seqres.full
+	$REPLAYLOG_PROG --log $LOGWRITES_DEV --replay $SCRATCH_DEV --limit \
+		$ENTRY > /dev/null 2>&1
+	[ $? -ne 0 ] && _fatal "replay failed"
+	btrfsck $SCRATCH_DEV >> $seqres.full 2>&1 || _fatal "btrfsck failed"
+	_scratch_mount || _fatal "mount failed"
+	_wait_balance
+	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT >> $seqres.full 2>&1
+	[ $? -ne 0 ] && _fatal "scrub failed"
+	_scratch_unmount
+	btrfsck $SCRATCH_DEV >> $seqres.full 2>&1 || _fatal "btrfsck failed"
+	let ENTRY+=1
+	ENTRY=$($REPLAYLOG_PROG --find --start-entry $ENTRY --log \
+		$LOGWRITES_DEV --next-fua)
+done
+
+status=0
+exit
+
diff --git a/tests/btrfs/093.out b/tests/btrfs/093.out
new file mode 100644
index 0000000..211b92c
--- /dev/null
+++ b/tests/btrfs/093.out
@@ -0,0 +1 @@
+QA output created by 093
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 8e32b20..a9955f7 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -94,3 +94,4 @@
 090 auto quick metadata
 091 auto quick qgroup
 092 auto quick send
+093 auto log
-- 
1.8.3.1

