Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59430 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbcCQGPy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 02:15:54 -0400
Received: from localhost
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 17 Mar 2016 16:15:51 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH] btrfs/066: Fix race condition by making 'subvolume stress' task to exit gracefully
Date: Thu, 17 Mar 2016 11:44:29 +0530
Message-Id: <1458195269-965-1-git-send-email-chandan@linux.vnet.ibm.com>
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

Instead of killing the 'subvolume stress' task, This commit uses a named
pipe to inform the 'subvolume stress' task to break out of the infinite
loop and exit.

There are four more such instances (i.e. btrfs/060, btrfs/065, btrfs/067
and btrfs/068) where __btrfs_stress_subvolume() is used. I am planning
to fix them up once we arrive at a solution to which everybody agrees.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 common/rc       |  9 +++++++++
 tests/btrfs/066 | 27 +++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/common/rc b/common/rc
index 16f5a43..c74d25e 100644
--- a/common/rc
+++ b/common/rc
@@ -3280,9 +3280,18 @@ _btrfs_stress_subvolume()
 	local btrfs_mnt=$2
 	local subvol_name=$3
 	local subvol_mnt=$4
+	local subvol_pipe=$5
+	local pipe_fd
 
 	mkdir -p $subvol_mnt
+
+	exec {pipe_fd}<$subvol_pipe
+
 	while true; do
+		read -t 0 -u $pipe_fd dummy_var
+		if [[ $? == 0 ]]; then
+			break;
+		fi
 		$BTRFS_UTIL_PROG subvolume create $btrfs_mnt/$subvol_name
 		$MOUNT_PROG -o subvol=$subvol_name $btrfs_dev $subvol_mnt
 		$UMOUNT_PROG $subvol_mnt
diff --git a/tests/btrfs/066 b/tests/btrfs/066
index 2d9a1d2..acf58b3 100755
--- a/tests/btrfs/066
+++ b/tests/btrfs/066
@@ -55,6 +55,8 @@ rm -f $seqres.full
 run_test()
 {
 	local mkfs_opts=$1
+	local subvol_pipe=$2
+	local pipe_fd=$3
 	local subvol_mnt=$TEST_DIR/$seq.mnt
 
 	echo "Test $mkfs_opts" >>$seqres.full
@@ -73,7 +75,8 @@ run_test()
 	fsstress_pid=$!
 
 	echo -n "Start subvolume worker: " >>$seqres.full
-	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt >/dev/null 2>&1 &
+	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt \
+				$subvol_pipe >/dev/null 2>&1 &
 	subvol_pid=$!
 	echo "$subvol_pid" >>$seqres.full
 
@@ -85,8 +88,12 @@ run_test()
 	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
 	wait $fsstress_pid
 
-	kill $subvol_pid $scrub_pid
-	wait
+	echo "Quit" >&${pipe_fd}
+
+	kill $scrub_pid
+	wait $subvol_pid $scrub_pid
+	dd if=$subvol_pipe iflag=nonblock of=/dev/null >/dev/null 2>&1
+
 	# wait for the scrub operation to finish
 	while ps aux | grep "scrub start" | grep -qv grep; do
 		sleep 1
@@ -106,9 +113,21 @@ run_test()
 	_check_scratch_fs
 }
 
+subvol_pipe=$tmp.subvol_pipe
+
+rm -rf $subvol_pipe
+
+mkfifo $subvol_pipe
+if [[ $? != 0 ]]; then
+	echo "Failed to create named pipe: $subvol_pipe"
+	exit
+fi
+
+exec {pipe_fd}<>$subvol_pipe
+
 echo "Silence is golden"
 for t in "${_btrfs_profile_configs[@]}"; do
-	run_test "$t"
+	run_test "$t" $subvol_pipe $pipe_fd
 done
 
 status=0
-- 
2.1.0

