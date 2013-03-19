Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:64167 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab3CSQYl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 12:24:41 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com
Subject: [PATCH] xfstests: add background noise to test 276 (btrfs backref resolving)
Date: Tue, 19 Mar 2013 17:24:20 +0100
Message-Id: <1363710260-10225-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backref resolver test for btrfs was run on a static file system so far.
Resolving backrefs on a busy file system is what happens in reality and that
is what should be checked by this test.

I added a parameter such that the script can easily be changed to the former
behavior for development purposes.

Furthermore, this increases two constants which make the test simply cycle a
few seconds longer, increasing the chance to hit on something suspicious in
case we broke something.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 276 |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/276 b/276
index 65da464..40b30cf 100755
--- a/276
+++ b/276
@@ -33,9 +33,16 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1
+noise_pid=0
 
 _cleanup()
 {
+	if [ $noise_pid -ne 0 ]; then
+		echo "background noise kill $noise_pid" >>$seq.full
+		kill $noise_pid
+		noise_pid=0
+		wait
+	fi
 	echo "*** unmount"
 	umount $SCRATCH_MNT 2>/dev/null
 	rm -f $tmp.*
@@ -171,6 +178,7 @@ workout()
 	nfiles=$2
 	procs=$3
 	snap_name=$4
+	do_bg_noise=$5
 
 	umount $SCRATCH_DEV >/dev/null 2>&1
 	echo "*** mkfs -dsize=$fsz"    >>$seq.full
@@ -179,7 +187,7 @@ workout()
 		|| _fail "size=$fsz mkfs failed"
 	run_check _scratch_mount
 	# -w ensures that the only ops are ones which cause write I/O
-	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 1000 \
+	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 2000 \
 		$FSSTRESS_AVOID
 
 	run_check $BTRFS_UTIL_PROG subvol snap $SCRATCH_MNT \
@@ -190,9 +198,10 @@ workout()
 
 	# make some noise but ensure we're not touching existing data
 	# extents.
-	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n 2000 \
+	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n 4000 \
 		-z -f chown=3 -f link=1 -f mkdir=2 -f mknod=2 \
 		-f rename=2 -f setxattr=1 -f symlink=2
+
 	clean_dir="$SCRATCH_MNT/next"
 	mkdir $clean_dir
 	# now make more files to get a higher tree
@@ -201,6 +210,18 @@ workout()
 	run_check umount $SCRATCH_DEV >/dev/null 2>&1
 	run_check _scratch_mount "-o atime"
 
+	if [ $do_bg_noise -ne 0 ]; then
+		# make background noise while backrefs are being walked
+		while /bin/true; do
+			echo background fsstress >>$seq.full
+			run_check $FSSTRESS_PROG -d $SCRATCH_MNT/bgnoise -n 999
+			echo background rm >>$seq.full
+			rm -rf $SCRATCH_MNT/bgnoise/
+		done &
+		noise_pid=`jobs -p %1`
+		echo "background noise by $noise_pid" >>$seq.full
+	fi
+
 	cnt=0
 	errcnt=0
 	dir="$SCRATCH_MNT/$snap_name/"
@@ -230,6 +251,7 @@ workout()
 			break
 		fi
 	done
+
 	if [ $errcnt -gt 0 ]; then
 		_fail "test failed: $errcnt error(s)"
 	fi
@@ -241,8 +263,9 @@ snap_name="snap1"
 filesize=`expr 2000 \* 1024 \* 1024`
 nfiles=4
 numprocs=1
+do_bg_noise=1
 
-workout $filesize $nfiles $numprocs $snap_name
+workout $filesize $nfiles $numprocs $snap_name $do_bg_noise
 
 echo "*** done"
 status=0
-- 
1.7.2.2

