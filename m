Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbcDZVit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 17:38:49 -0400
Date: Tue, 26 Apr 2016 14:38:47 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs: fix qgroup accounting when snapshotting
Message-ID: <20160426213847.GC2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1461680685-2432-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461680685-2432-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On Tue, Apr 26, 2016 at 10:24:45AM -0400, Josef Bacik wrote:
> The new qgroup stuff needs the quota accounting to be run before doing the
> inherit, unfortunately they need the commit root switch to happen at a specific
> time for this to work properly.  Fix this by delaying the inherit until after we
> do the qgroup accounting, and remove the inherit and accounting dance in
> create_pending_snapshot.  Thanks,

Thanks for the patch. Unfortunately, this doesn't pass the xfstest case I
wrote for this bug:

http://www.spinics.net/lists/linux-btrfs/msg54403.html


I will also attach the patch to the bottom of this e-mail to make life
easier for you :)

But basically I get a difference of 16k in the qgroups. My trivial test
checks out (just make a couple of snapshots) so my guess is that we're
missing some metadata accounting.


Counts for qgroup id: 5 are different
our:		referenced 672481280 referenced compressed 672481280
disk:		referenced 672481280 referenced compressed 672481280
our:		exclusive 49152 exclusive compressed 49152
disk:		exclusive 16384 exclusive compressed 16384
diff:		exclusive 32768 exclusive compressed 32768
Counts for qgroup id: 260 are different
our:		referenced 672481280 referenced compressed 672481280
disk:		referenced 672481280 referenced compressed 672481280
our:		exclusive 32768 exclusive compressed 32768
disk:		exclusive 16384 exclusive compressed 16384
diff:		exclusive 16384 exclusive compressed 16384
Counts for qgroup id: 261 are different
our:		referenced 672481280 referenced compressed 672481280
disk:		referenced 672481280 referenced compressed 672481280
our:		exclusive 32768 exclusive compressed 32768
disk:		exclusive 16384 exclusive compressed 16384
diff:		exclusive 16384 exclusive compressed 16384
	--Mark

--
Mark Fasheh


From: Mark Fasheh <mfasheh@suse.de>

[PATCH] btrfs: Test that qgroup counts are valid after snapshot creation

This has been broken since Linux v4.1. We may have worked out a solution on
the btrfs list but in the meantime sending a test to expose the issue seems
like a good idea.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 tests/btrfs/122     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/122.out |  1 +
 tests/btrfs/group   |  1 +
 3 files changed, 90 insertions(+)
 create mode 100755 tests/btrfs/122
 create mode 100644 tests/btrfs/122.out

diff --git a/tests/btrfs/122 b/tests/btrfs/122
new file mode 100755
index 0000000..82252ab
--- /dev/null
+++ b/tests/btrfs/122
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. btrfs/122
+#
+# Test that qgroup counts are valid after snapshot creation. This has
+# been broken in btrfs since Linux v4.1
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
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
+
+rm -f $seqres.full
+
+# Force a small leaf size to make it easier to blow out our root
+# subvolume tree
+_scratch_mkfs "--nodesize 16384"
+_scratch_mount
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+
+mkdir "$SCRATCH_MNT/snaps"
+
+# First make some simple snapshots - the bug was initially reproduced like this
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT "$SCRATCH_MNT/snaps/empty1"
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT "$SCRATCH_MNT/snaps/empty2"
+
+# This forces the fs tree out past level 0, adding at least one tree
+# block which must be properly accounted for when we make our next
+# snapshots.
+mkdir "$SCRATCH_MNT/data"
+for i in `seq 0 640`; do
+	$XFS_IO_PROG -f -c "pwrite 0 1M" "$SCRATCH_MNT/data/file$i" > /dev/null 2>&1
+done
+
+# Snapshot twice.
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT "$SCRATCH_MNT/snaps/snap1"
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT "$SCRATCH_MNT/snaps/snap2"
+
+_scratch_unmount
+
+# generate a qgroup report and look for inconsistent groups
+$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | \
+			grep -q -E "Counts for qgroup.*are different"
+if [ $? -ne 0 ]; then
+	status=0
+fi
+
+exit
diff --git a/tests/btrfs/122.out b/tests/btrfs/122.out
new file mode 100644
index 0000000..2b1890e
--- /dev/null
+++ b/tests/btrfs/122.out
@@ -0,0 +1 @@
+QA output created by 122
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 9403daa..f7e8cff 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -122,3 +122,4 @@
 119 auto quick snapshot metadata qgroup
 120 auto quick snapshot metadata
 121 auto quick snapshot qgroup
+122 auto quick snapshot qgroup
-- 
2.1.4

