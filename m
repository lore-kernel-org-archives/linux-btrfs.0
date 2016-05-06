Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691AbcEFV5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 May 2016 17:57:37 -0400
Date: Fri, 6 May 2016 14:57:35 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix qgroup accounting when snapshotting
Message-ID: <20160506215735.GB7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1461680685-2432-1-git-send-email-jbacik@fb.com>
 <1d9f9fed-8f31-04fc-66d3-41ce77ff6a94@cn.fujitsu.com>
 <8d0fb4f5-9701-b2e1-172e-e60bd178b2f3@fb.com>
 <9e10e641-d85d-0b54-3bd1-f7694a924490@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9e10e641-d85d-0b54-3bd1-f7694a924490@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 28, 2016 at 08:34:13AM +0800, Qu Wenruo wrote:
> 
> 
> Josef Bacik wrote on 2016/04/27 11:18 -0400:
> >On 04/26/2016 09:19 PM, Qu Wenruo wrote:
> >>
> >>
> >>Josef Bacik wrote on 2016/04/26 10:24 -0400:
> >>>The new qgroup stuff needs the quota accounting to be run before doing
> >>>the
> >>>inherit, unfortunately they need the commit root switch to happen at a
> >>>specific
> >>>time for this to work properly.  Fix this by delaying the inherit
> >>>until after we
> >>>do the qgroup accounting, and remove the inherit and accounting dance in
> >>>create_pending_snapshot.  Thanks,
> >>>
> >>>Signed-off-by: Josef Bacik <jbacik@fb.com>
> >>>---
> >>> fs/btrfs/transaction.c | 51
> >>>++++++++++++++++++++++++++++++--------------------
> >>> fs/btrfs/transaction.h |  1 +
> >>> 2 files changed, 32 insertions(+), 20 deletions(-)
> >>>
> >>>diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> >>>index 7c7671d..aa3025a 100644
> >>>--- a/fs/btrfs/transaction.c
> >>>+++ b/fs/btrfs/transaction.c
> >>>@@ -1353,6 +1353,7 @@ static noinline int
> >>>create_pending_snapshot(struct btrfs_trans_handle *trans,
> >>>     pending->error = btrfs_find_free_objectid(tree_root, &objectid);
> >>>     if (pending->error)
> >>>         goto no_free_objectid;
> >>>+    pending->objectid = objectid;
> >>>
> >>>     /*
> >>>      * Make qgroup to skip current new snapshot's qgroupid, as it is
> >>>@@ -1559,24 +1560,6 @@ static noinline int
> >>>create_pending_snapshot(struct btrfs_trans_handle *trans,
> >>>         btrfs_abort_transaction(trans, root, ret);
> >>>         goto fail;
> >>>     }
> >>>-
> >>>-    /*
> >>>-     * account qgroup counters before qgroup_inherit()
> >>>-     */
> >>>-    ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
> >>>-    if (ret)
> >>>-        goto fail;
> >>>-    ret = btrfs_qgroup_account_extents(trans, fs_info);
> >>>-    if (ret)
> >>>-        goto fail;
> >>>-    ret = btrfs_qgroup_inherit(trans, fs_info,
> >>>-                   root->root_key.objectid,
> >>>-                   objectid, pending->inherit);
> >>>-    if (ret) {
> >>>-        btrfs_abort_transaction(trans, root, ret);
> >>>-        goto fail;
> >>>-    }
> >>>-
> >>> fail:
> >>>     pending->error = ret;
> >>> dir_item_existed:
> >>>@@ -1599,15 +1582,35 @@ no_free_objectid:
> >>> static noinline int create_pending_snapshots(struct
> >>>btrfs_trans_handle *trans,
> >>>                          struct btrfs_fs_info *fs_info)
> >>> {
> >>>+    struct btrfs_pending_snapshot *pending;
> >>>+    struct list_head *head = &trans->transaction->pending_snapshots;
> >>>+    int ret = 0;
> >>>+
> >>>+    list_for_each_entry(pending, head, list) {
> >>>+        ret = create_pending_snapshot(trans, fs_info, pending);
> >>>+        if (ret)
> >>>+            break;
> >>>+    }
> >>>+    return ret;
> >>>+}
> >>>+
> >>>+static noinline int inherit_pending_snapshots(struct
> >>>btrfs_trans_handle *trans,
> >>>+                          struct btrfs_fs_info *fs_info)
> >>>+{
> >>>     struct btrfs_pending_snapshot *pending, *next;
> >>>     struct list_head *head = &trans->transaction->pending_snapshots;
> >>>     int ret = 0;
> >>>
> >>>     list_for_each_entry_safe(pending, next, head, list) {
> >>>+        struct btrfs_root *root = pending->root;
> >>>         list_del(&pending->list);
> >>>-        ret = create_pending_snapshot(trans, fs_info, pending);
> >>>-        if (ret)
> >>>+        ret = btrfs_qgroup_inherit(trans, fs_info,
> >>>+                       root->root_key.objectid,
> >>>+                       pending->objectid, pending->inherit);
> >>
> >>It's too late to call qgroup_inherit() here.
> >>As we already inserted DIR_ITEM into parent_root.
> >>
> >>This will cause qgroup difference, if parent_root is also the src_root.
> >>
> >>
> >>But your fix provides a very potential fix method.
> >>If we didn't do the DIR_ITEM insert in create_pending_snapshot, but do
> >>the insert after all qgroup_inherit() is done,
> >>the problem may have a better fix.
> >>
> >>Although I am still concerning about the DIR_ITEM insert.
> >>As we still need to account them, and since we must run qgroup
> >>accounting before qgroup_inherit(), I'm afraid we still need to do the
> >>commit hack though.
> >>
> >
> >Ugh I forgot about that.  It would be nice to use the tree mod log here,
> >but the rework makes that tricky.  Basically we'd need to delay any
> >modifications to the extent tree until after we do the inherit, so do
> >btrfs_get_tree_mod_seq() and store it in the pending, and then do the
> >inherit, and then put the seq and re-run the delayed refs and the qgroup
> >accounting.
> >
> >This is hard because this will keep us from running delayed refs, and we
> >do btrfs_run_delayed_refs(-1) a few times in between so we'd deadlock
> >because we would find delayed refs on the tree still.
> >
> >I'm not sure how to fix this without undoing what we have and going
> >back.  I'll think about it some more.  Thanks,
> >
> >Josef
> >
> >
> >
> I think your idea on moving qgroup_inherit() out is already good enough.
> 
> If we use the __commit_trans() method, we can already make things
> much cleaner.
> 
> We only need to do one qgroup accounting (including switching roots
> though) before create_pending_snapshots() (don't do DIR ITEM
> insert).
> 
> Finally, doing all DIR_ITEM insert, and remaining qgroup will be
> accounted by normal commit routine.
> 
> Already a great improvement compared to old commit_trans() every
> time we create one snapshot.
> 
> For tree_mod_seq() method, maybe we can reverted it, but I'm not
> sure if there will cause qgroup problem, as the old qgroup bugs are
> all related to backref walk on delayed_refs (while backref walk on
> extent tree is always OK).

Josef, can I please get some more attention on this topic? What Qu proposes
above seems like it will still keep the partial commit which you were very
much against. However, your patch falls over quite quickly in testing. On
my end I've tried a few things, excluding the partial commit for obvious
reasons. As soon as I think I have something that works though, it falls
over once I poke it with a larger test.

In particular, I've been trying to move around the points at which we are
taking our values for qgroup_inherit(). I can get rfer values _almost_
always correct by recording them off the source qgroup at the top of
create_snapshot() (including running qgroup accounting before that).  excl
though is always blown up.  I also tried manually counting changed blocks
during our directory insert in create_snapshot() but that fell apart pretty
quickly.

One problem is that the assumption in btrfs_qgroup_inherit() that excl for
the target group should always be 1 tree node in size is laughably incorrect
and winds up overwriting the sometimes-correct values.  My guess is that for
the old code this was just an initial value (and the rest was added later). 
This is obviously not the case after Qu's rewrite.  So we'll have to correct
that somehow in our fix.

I can't quite tell (yet) what happens on my larger tests to make the values
go bad, but my guess based on the conversation so far is that we can't
reliably count roots at this stage in the commit process. If we can't do
that, 100% correctly every time then the qgroup accounting has no hope of
working correctly.

Do you agree with this? What can we do to fix the root counting code? Your
description above seems pretty good but there's a deadlock there I have no
clue how to fix (perhaps you could help with that?).  Finally, do we have to
look more seriously at doing the partial commit you wanted to avoid in the
first place?
    --Mark

PS: In order to make this all go faster I have included my xfstests patch
for this bug so nobody has to gate behind my testing.


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

