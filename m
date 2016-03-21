Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([125.16.236.4]:51154 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcCUHkY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:40:24 -0400
Received: from localhost
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 21 Mar 2016 13:10:20 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com, eguan@redhat.com
Subject: [PATCH V2] _btrfs_stress_subvolume: Fix race condition by making 'subvolume stress' task to exit gracefully
Date: Mon, 21 Mar 2016 13:09:52 +0530
Message-Id: <1458545992-32114-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following scenario can occur when running btrfs/066,

  Task A                                Task B                     Task C

  run_test()
  - Execute _btrfs_stress_subvolume()
    in a background shell.
                                        _btrfs_stress_subvolme()
                                          ...
                                        - fork & exec "mount"
                                               	      		   Mount subvolume on directory in $TEST_DIR
  - Wait for fsstress to finish                                    do_mount()
  - kill shell process executing                                   - btrfs_mount()
    _btrfs_stress_subvolume()
    i.e. Task B.
  - Init process becomes the parent
    of "subvolume mount" task
    i.e. Task C.
  - In case subvolume is mounted
    (which is not the case),
    unmount it.
                                                                   - Complete mounting subvolume

Hence on the completion of one iteration of run_test(), the subvolume
created inside the filesystem on $SCRATCH_DEV continues to be mounted on
$TEST_DIR/$seq.mnt. Subsequent invocations of run_test() (called for
remaining Btrfs profile configs) fail during _scratch_pool_mkfs.

Instead of killing the 'subvolume stress' task this commit makes
_btrfs_stress_subvolume() to break out of the loop when a file exists
on the filesystem. The commit also makes relevant changes to other
users of _btrfs_stress_subvolume() i.e. btrfs/060, btrfs/065,
btrfs/067 & btrfs/068.

Suggested-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
Changelog:

V1->V2: Instead of named pipes, Use a file to let 'subvolume stress' task know
that it should break from the while loop.

 common/rc       | 3 ++-
 tests/btrfs/060 | 8 ++++++--
 tests/btrfs/065 | 8 ++++++--
 tests/btrfs/066 | 8 ++++++--
 tests/btrfs/067 | 8 ++++++--
 tests/btrfs/068 | 8 ++++++--
 6 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/common/rc b/common/rc
index 16f5a43..7d971ea 100644
--- a/common/rc
+++ b/common/rc
@@ -3280,9 +3280,10 @@ _btrfs_stress_subvolume()
 	local btrfs_mnt=$2
 	local subvol_name=$3
 	local subvol_mnt=$4
+	local stop_file=$stop_file
 
 	mkdir -p $subvol_mnt
-	while true; do
+	while [ ! -e $stop_file ]; do
 		$BTRFS_UTIL_PROG subvolume create $btrfs_mnt/$subvol_name
 		$MOUNT_PROG -o subvol=$subvol_name $btrfs_dev $subvol_mnt
 		$UMOUNT_PROG $subvol_mnt
diff --git a/tests/btrfs/060 b/tests/btrfs/060
index 8ef0e7f..6b6a480 100755
--- a/tests/btrfs/060
+++ b/tests/btrfs/060
@@ -56,6 +56,7 @@ run_test()
 {
 	local mkfs_opts=$1
 	local subvol_mnt=$TEST_DIR/$seq.mnt
+	local stop_file=$TEST_DIR/$seq.stop.$$
 
 	echo "Test $mkfs_opts" >>$seqres.full
 
@@ -77,15 +78,18 @@ run_test()
 	balance_pid=$!
 	echo "$balance_pid" >>$seqres.full
 
+	# make sure the stop sign is not there
+	rm -f $stop_file
 	echo -n "Start subvolume worker: " >>$seqres.full
-	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt >/dev/null 2>&1 &
+	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt $stop_file >/dev/null 2>&1 &
 	subvol_pid=$!
 	echo "$subvol_pid" >>$seqres.full
 
 	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
 	wait $fsstress_pid
 
-	kill $balance_pid $subvol_pid
+	touch $stop_file
+	kill $balance_pid
 	wait
 	# wait for the balance operation to finish
 	while ps aux | grep "balance start" | grep -qv grep; do
diff --git a/tests/btrfs/065 b/tests/btrfs/065
index 7d8249b..a4afe73 100755
--- a/tests/btrfs/065
+++ b/tests/btrfs/065
@@ -58,6 +58,7 @@ run_test()
 	local mkfs_opts=$1
 	local saved_scratch_dev_pool=$SCRATCH_DEV_POOL
 	local subvol_mnt=$TEST_DIR/$seq.mnt
+	local stop_file=$TEST_DIR/$seq.stop.$$
 
 	echo "Test $mkfs_opts" >>$seqres.full
 
@@ -80,8 +81,10 @@ run_test()
 	$FSSTRESS_PROG $args >/dev/null 2>&1 &
 	fsstress_pid=$!
 
+	# make sure the stop sign is not there
+	rm -f $stop_file
 	echo -n "Start subvolume worker: " >>$seqres.full
-	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt >/dev/null 2>&1 &
+	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt $stop_file >/dev/null 2>&1 &
 	subvol_pid=$!
 	echo "$subvol_pid" >>$seqres.full
 
@@ -93,7 +96,8 @@ run_test()
 	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
 	wait $fsstress_pid
 
-	kill $subvol_pid $replace_pid
+	touch $stop_file
+	kill $replace_pid
 	wait
 	# wait for the replace operation to finish
 	while ps aux | grep "replace start" | grep -qv grep; do
diff --git a/tests/btrfs/066 b/tests/btrfs/066
index 2d9a1d2..cf4dd0d 100755
--- a/tests/btrfs/066
+++ b/tests/btrfs/066
@@ -56,6 +56,7 @@ run_test()
 {
 	local mkfs_opts=$1
 	local subvol_mnt=$TEST_DIR/$seq.mnt
+	local stop_file=$TEST_DIR/$seq.stop.$$
 
 	echo "Test $mkfs_opts" >>$seqres.full
 
@@ -72,8 +73,10 @@ run_test()
 	$FSSTRESS_PROG $args >/dev/null 2>&1 &
 	fsstress_pid=$!
 
+	# make sure the stop sign is not there
+	rm -f $stop_file
 	echo -n "Start subvolume worker: " >>$seqres.full
-	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt >/dev/null 2>&1 &
+	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt $stop_file >/dev/null 2>&1 &
 	subvol_pid=$!
 	echo "$subvol_pid" >>$seqres.full
 
@@ -85,7 +88,8 @@ run_test()
 	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
 	wait $fsstress_pid
 
-	kill $subvol_pid $scrub_pid
+	touch $stop_file
+	kill $scrub_pid
 	wait
 	# wait for the scrub operation to finish
 	while ps aux | grep "scrub start" | grep -qv grep; do
diff --git a/tests/btrfs/067 b/tests/btrfs/067
index 2c1e284..b76f5ec 100755
--- a/tests/btrfs/067
+++ b/tests/btrfs/067
@@ -57,6 +57,7 @@ run_test()
 	local mkfs_opts=$1
 	local with_compress=$2
 	local subvol_mnt=$TEST_DIR/$seq.mnt
+	local stop_file=$TEST_DIR/$seq.stop.$$
 
 	echo "Test $mkfs_opts with $with_compress" >>$seqres.full
 
@@ -73,8 +74,10 @@ run_test()
 	$FSSTRESS_PROG $args >/dev/null 2>&1 &
 	fsstress_pid=$!
 
+	# make sure the stop sign is not there
+	rm -f $stop_file
 	echo -n "Start subvolume worker: " >>$seqres.full
-	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt >/dev/null 2>&1 &
+	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt $stop_file >/dev/null 2>&1 &
 	subvol_pid=$!
 	echo "$subvol_pid" >>$seqres.full
 
@@ -86,7 +89,8 @@ run_test()
 	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
 	wait $fsstress_pid
 
-	kill $subvol_pid $defrag_pid
+	touch $stop_file
+	kill $defrag_pid
 	wait
 	# wait for btrfs defrag process to exit, otherwise it will block umount
 	while ps aux | grep "btrfs filesystem defrag" | grep -qv grep; do
diff --git a/tests/btrfs/068 b/tests/btrfs/068
index 3126ec2..534aee6 100755
--- a/tests/btrfs/068
+++ b/tests/btrfs/068
@@ -57,6 +57,7 @@ run_test()
 {
 	local mkfs_opts=$1
 	local subvol_mnt=$TEST_DIR/$seq.mnt
+	local stop_file=$TEST_DIR/$seq.stop.$$
 
 	echo "Test $mkfs_opts with $with_compress" >>$seqres.full
 
@@ -73,8 +74,10 @@ run_test()
 	$FSSTRESS_PROG $args >/dev/null 2>&1 &
 	fsstress_pid=$!
 
+	# make sure the stop sign is not there
+	rm -f $stop_file
 	echo -n "Start subvolume worker: " >>$seqres.full
-	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt >/dev/null 2>&1 &
+	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt $stop_file >/dev/null 2>&1 &
 	subvol_pid=$!
 	echo "$subvol_pid" >>$seqres.full
 
@@ -86,7 +89,8 @@ run_test()
 	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
 	wait $fsstress_pid
 
-	kill $subvol_pid $remount_pid
+	touch $stop_file
+	kill $remount_pid
 	wait
 	# wait for the remount loop process to finish
 	while ps aux | grep "mount.*$SCRATCH_MNT" | grep -qv grep; do
-- 
2.1.0

