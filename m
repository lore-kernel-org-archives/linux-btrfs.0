Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbaHTRfN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 13:35:13 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH 03/15] btrfs: new test to run btrfs balance and defrag operations simultaneously
Date: Thu, 21 Aug 2014 01:33:52 +0800
Message-Id: <1408556044-907-5-git-send-email-eguan@redhat.com>
In-Reply-To: <1408556044-907-1-git-send-email-eguan@redhat.com>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run btrfs balance and defrag operations simultaneously with fsstress
running in background.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/btrfs/059     | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/059.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 153 insertions(+)
 create mode 100755 tests/btrfs/059
 create mode 100644 tests/btrfs/059.out

diff --git a/tests/btrfs/059 b/tests/btrfs/059
new file mode 100755
index 0000000..897a300
--- /dev/null
+++ b/tests/btrfs/059
@@ -0,0 +1,150 @@
+#! /bin/bash
+# FSQA Test No. btrfs/059
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
+	local with_compress=$2
+	local saved_mkfs_opts=$MKFS_OPTIONS
+
+	echo "Test $mkfs_opts with $with_compress" >>$seqres.full
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
+	if [ $ret -ne 0 ]; then
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
+	(
+		while true; do
+			$BTRFS_UTIL_PROG balance start $SCRATCH_MNT
+		done
+	) >/dev/null 2>&1 &
+	balance_pid=$!
+	echo "$balance_pid" >>$seqres.full
+
+	echo -n "Start defrag worker: " >>$seqres.full
+	(
+		while true; do
+			if [ "$with_compress" == "nocompress" ]; then
+				find $SCRATCH_MNT \( -type f -o -type d \) -exec \
+					$BTRFS_UTIL_PROG filesystem defrag {} \; >>$seqres.full 2>&1
+			else
+				find $SCRATCH_MNT \( -type f -o -type d \) -exec \
+					$BTRFS_UTIL_PROG filesystem defrag -clzo {} \; >>$seqres.full 2>&1
+				find $SCRATCH_MNT \( -type f -o -type d \) -exec \
+					$BTRFS_UTIL_PROG filesystem defrag -czlib {} \; >>$seqres.full 2>&1
+			fi
+		done
+	) &
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
diff --git a/tests/btrfs/059.out b/tests/btrfs/059.out
new file mode 100644
index 0000000..36ebeea
--- /dev/null
+++ b/tests/btrfs/059.out
@@ -0,0 +1,2 @@
+QA output created by 059
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index c6b1baa..73bae0f 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -61,3 +61,4 @@
 056 auto quick
 057 auto stress balance subvol
 058 auto stress balance scrub
+059 auto stress balance defrag compress
-- 
1.8.3.1

