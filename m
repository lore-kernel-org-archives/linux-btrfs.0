Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23259 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752314AbdHNHDZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 03:03:25 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
CC: <bo.li.liu@oracle.com>
Subject: [PATCH] fstests: btrfs: enhance regression test for nocsum dio read's repair
Date: Mon, 14 Aug 2017 15:03:13 +0800
Message-ID: <20170814070313.20092-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I catch this following error from dmesg when this testcase fails.

[17446.661127] Buffer I/O error on dev sdb1, logical block 64, async page read

We expect to inject disk IO errors on the device when xfs_io reads the
specific file, but other processes may trigger IO error earlier. So, we
can use task-filter to solve this problem.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 tests/btrfs/142 | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tests/btrfs/142 b/tests/btrfs/142
index 414af1b2..5bd8b728 100755
--- a/tests/btrfs/142
+++ b/tests/btrfs/142
@@ -75,6 +75,7 @@ start_fail()
 {
 	echo 100 > $DEBUGFS_MNT/fail_make_request/probability
 	echo 2 > $DEBUGFS_MNT/fail_make_request/times
+	echo 1 > $DEBUGFS_MNT/fail_make_request/task-filter
 	echo 0 > $DEBUGFS_MNT/fail_make_request/verbose
 	echo 1 > $SYSFS_BDEV/make-it-fail
 }
@@ -83,6 +84,7 @@ stop_fail()
 {
 	echo 0 > $DEBUGFS_MNT/fail_make_request/probability
 	echo 0 > $DEBUGFS_MNT/fail_make_request/times
+	echo 0 > $DEBUGFS_MNT/fail_make_request/task-filter
 	echo 0 > $SYSFS_BDEV/make-it-fail
 }
 
@@ -118,16 +120,17 @@ echo "step 3......repair the bad copy" >>$seqres.full
 # since raid1 consists of two copies, and the bad copy was put on stripe #1
 # while the good copy lies on stripe #0, the bad copy only gets access when the
 # reader's pid % 2 == 1 is true
-while true; do
-	# start_fail only fails the following dio read so the repair is
+start_fail
+while [[ -z ${result} ]]; do
+	# enable task-filter only fails the following dio read so the repair is
 	# supposed to work.
-	start_fail
-	$XFS_IO_PROG -d -c "pread -b 128K 0 128K" "$SCRATCH_MNT/foobar" > /dev/null &
-	pid=$!
-	wait
-	stop_fail
-	[ $((pid % 2)) == 1 ] && break
+	result=$(bash -c "
+	if [[ \$((\$\$ % 2)) -eq 1 ]]; then
+		echo 1 > /proc/\$\$/make-it-fail
+		exec $XFS_IO_PROG -d -c \"pread -b 128K 0 128K\" \"$SCRATCH_MNT/foobar\"
+	fi");
 done
+stop_fail
 
 _scratch_unmount
 
-- 
2.14.1



