Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbbIWVFS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 17:05:18 -0400
Date: Wed, 23 Sep 2015 14:05:16 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: add test for quota groups and drop
 snapshot
Message-ID: <20150923210516.GC17854@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20150922221649.GB17854@wotan.suse.de>
 <20150923024708.GK3902@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150923024708.GK3902@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Dave, thanks for the review. A refreshed patch for you to look at is
attached.

On Wed, Sep 23, 2015 at 12:47:08PM +1000, Dave Chinner wrote:
> On Tue, Sep 22, 2015 at 03:16:49PM -0700, Mark Fasheh wrote:
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	rm -fr $tmp
> > +}
> 
> Missing a "cd /" (see the "new" template).

Ok, added that and I updated from a fresh template as well.


> > +# Create an fs tree of a given height at a target location. This is
> > +# done by agressively creating inline extents to expand the number of
> > +# nodes required. We also add an traditional extent so that
> > +# drop_snapshot is forced to walk at least one extent that is not
> > +# stored in metadata.
> > +#
> > +# NOTE: The ability to vary tree height for this test is very useful
> > +# for debugging problems with drop_snapshot(). As a result we retain
> > +# that parameter even though the test below always does level 2 trees.
> > +_explode_fs_tree () {
> > +    local level=$1;
> > +    local loc="$2";
> > +    local bs=4095;
> > +    local cnt=1;
> > +    local n;
> 
> 8 space tabs, please.

Ok hopefully I got that right this time around.


> Please use xfs_io, not dd. It's also only ever writing a single
> block of 4095 bytes, so you can drop the bs/cnt variables and just
> use:
> 
> 	$XFS_IO_PROG -f -c "pwrite 0 4095" $loc/file$i > /dev/null 2>&1
> 
> > +    done
> > +
> > +    bs=131072
> > +    cnt=1
> > +    dd status=none if=/dev/zero of=$loc/extentfile bs=$bs count=$cnt
> 
> Variables for a single use? :P

Heh, I got a bit sloppy there sorry - it's from when I was experimenting
with different numbers to create various tree levels. I turned all the 'dd'
calls into $XFS_IO_PROG.


> 	$XFS_IO_PROG -f -c "pwrite 0 128k $loc/extentfile > /dev/null 2>&1
> 
> > +# Force the default leaf size as the calculations for making our btree
> > +# heights are based on that.
> > +run_check _scratch_mkfs "--nodesize 16384"
> 
> Please, no new users of run_check.

Ok I took that out, I'm confused though whyen you say 'no new users of
run_check', does that include the usage of _run_btrfs_util_prog() in this
test?


> > +# Finally, delete snap1 to trigger btrfs_drop_snapshot(). This
> > +# snapshot is most interesting to delete because it will cause some
> > +# nodes to go exclusively owned for snap2, while some will stay shared
> > +# with the default subvolume. That exercises a maximum of the drop
> > +# snapshot/qgroup interactions.
> > +#
> > +# snap2s imlied ref from to the 128K extent in files/ can be lost by
> > +# the root finding code in qgroup accounting due to snap1 no longer
> > +# providing a path to it. This was fixed by the first two patches
> > +# referenced above.
> > +_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap1
> > +
> > +# There is no way from userspace to force btrfs_drop_snapshot to run
> > +# at a given time (even via mount/unmount). We must wait for it to
> > +# start and complete. This is the shortest time on my tests systems I
> > +# have found which always allows drop_snapshot to run to completion.
> > +sleep 45
> 
> Which means it will not be long enough for someone else. We've had
> this discussion before - btrfs needs a way to query if a background
> operation is in progress or not....

At least the situation improved since last time - I don't need a 'sleep'
around the qgroup calls any more ;)

On a more serious note I agree that this is a problem, but we're going to
have to add an ioctl for this as the usual one does not provide any room for
additional behavior. Also, drop_snapshot can happen across mounts which
might make things a bit difficult (or maybe not, if the process waiting
holds an open fd to the fs).

Since the last time I sent this test, drop snapshot was broken again with
respect to qgroups. What practical step could I take to get a test for that
in here which I can beat the btrfs developers over the head with the next
time someone handwaves this problem away ;)
	--Mark

--
Mark Fasheh


From: Mark Fasheh <mfasheh@suse.de>

[PATCH] btrfs: add test for quota groups and drop snapshot

Test btrfs quota group consistency operations during snapshot
delete. Btrfs has had long standing issues with drop snapshot
failing to properly account for quota groups. This test crafts
several snapshot trees with shared and exclusive elements. One of
the trees is removed and then quota group consistency is checked.

This issue is fixed by the following linux kernel patches:
   Btrfs: use btrfs_get_fs_root in resolve_indirect_ref
   Btrfs: keep dropped roots in cache until transaciton commit
   btrfs: qgroup: account shared subtree during snapshot delete

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 tests/btrfs/104     | 165 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/104.out |   1 +
 tests/btrfs/group   |   1 +
 3 files changed, 167 insertions(+)
 create mode 100644 tests/btrfs/104
 create mode 100644 tests/btrfs/104.out

diff --git a/tests/btrfs/104 b/tests/btrfs/104
new file mode 100644
index 0000000..59367d9
--- /dev/null
+++ b/tests/btrfs/104
@@ -0,0 +1,165 @@
+#! /bin/bash
+# FS QA Test No. btrfs/104
+#
+# Test btrfs quota group consistency operations during snapshot
+# delete. Btrfs has had long standing issues with drop snapshot
+# failing to properly account for quota groups. This test crafts
+# several snapshot trees with shared and exclusive elements. One of
+# the trees is removed and then quota group consistency is checked.
+#
+# This issue is fixed by the following linux kernel patches:
+#
+#    Btrfs: use btrfs_get_fs_root in resolve_indirect_ref
+#    Btrfs: keep dropped roots in cache until transaciton commit
+#    btrfs: qgroup: account shared subtree during snapshot delete
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
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
+status=1	# failure is the default!
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+rm -f $seqres.full
+
+# Create an fs tree of a given height at a target location. This is
+# done by agressively creating inline extents to expand the number of
+# nodes required. We also add an traditional extent so that
+# drop_snapshot is forced to walk at least one extent that is not
+# stored in metadata.
+#
+# NOTE: The ability to vary tree height for this test is very useful
+# for debugging problems with drop_snapshot(). As a result we retain
+# that parameter even though the test below always does level 2 trees.
+_explode_fs_tree () {
+	local level=$1;
+	local loc="$2";
+	local n;
+
+	if [ -z $loc ]; then
+	    echo "specify location for fileset"
+	    exit 1;
+	fi
+
+	case $level in
+	    1)# this always reproduces level 1 trees
+		n=10;
+		;;
+	    2)# this always reproduces level 2 trees
+		n=1500
+		;;
+	    3)# this always reproduces level 3 trees
+		n=1000000;
+		;;
+	    *)
+		echo "Can't make level $level trees";
+		exit 1;
+		;;
+	esac
+
+	mkdir -p $loc
+	for i in `seq -w 1 $n`; do
+	    $XFS_IO_PROG -f -c "pwrite 0 4095" $loc/file$i > /dev/null 2>&1
+	done
+
+	$XFS_IO_PROG -f -c "pwrite 0 128k" $loc/extentfile > /dev/null 2>&1
+}
+
+# Force the default leaf size as the calculations for making our btree
+# heights are based on that.
+_scratch_mkfs "--nodesize 16384"
+_scratch_mount
+
+# populate the default subvolume and create a snapshot ('snap1')
+_explode_fs_tree 1 $SCRATCH_MNT/files
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap1
+
+# create new btree nodes in this snapshot. They will become shared
+# with the next snapshot we create.
+_explode_fs_tree 1 $SCRATCH_MNT/snap1/files-snap1
+
+# create our final snapshot ('snap2'), populate it with
+# exclusively owned nodes.
+#
+# As a result of this action, snap2 will get an implied ref to the
+# 128K extent created in the default subvolume.
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2
+_explode_fs_tree 1 $SCRATCH_MNT/snap2/files-snap2
+
+# Enable qgroups now that we have our filesystem prepared. This
+# will kick off a scan which we will have to wait for.
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+
+# Remount to clear cache, force everything to disk
+_scratch_remount
+
+# Finally, delete snap1 to trigger btrfs_drop_snapshot(). This
+# snapshot is most interesting to delete because it will cause some
+# nodes to go exclusively owned for snap2, while some will stay shared
+# with the default subvolume. That exercises a maximum of the drop
+# snapshot/qgroup interactions.
+#
+# snap2s imlied ref from to the 128K extent in files/ can be lost by
+# the root finding code in qgroup accounting due to snap1 no longer
+# providing a path to it. This was fixed by the first two patches
+# referenced above.
+_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap1
+
+# There is no way from userspace to force btrfs_drop_snapshot to run
+# at a given time (even via mount/unmount). We must wait for it to
+# start and complete. This is the shortest time on my tests systems I
+# have found which always allows drop_snapshot to run to completion.
+sleep 45
+
+_scratch_unmount
+
+# generate a qgroup report and look for inconsistent groups
+#  - don't use _run_btrfs_util_prog here as it captures the output and
+#    we need to grep it.
+$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | grep -E -q "Counts for qgroup.*are different"
+if [ $? -ne 0 ]; then
+    status=0
+fi
+
+exit
diff --git a/tests/btrfs/104.out b/tests/btrfs/104.out
new file mode 100644
index 0000000..1ed84bc
--- /dev/null
+++ b/tests/btrfs/104.out
@@ -0,0 +1 @@
+QA output created by 104
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e92a65a..6218adf 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -106,3 +106,4 @@
 101 auto quick replace
 102 auto quick metadata enospc
 103 auto quick clone compress
+104 auto qgroup
-- 
2.1.2

