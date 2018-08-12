Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:41709 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbeHLDfi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 23:35:38 -0400
Received: by mail-oi0-f66.google.com with SMTP id k12-v6so21806913oiw.8
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Aug 2018 17:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com> <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com> <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
 <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com> <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
 <6c29c33b-68f4-91d1-493e-5751000dec24@gmx.com> <CAPL5yKe4if48zANCpSXi+G_q6cHevTEu+LJ2whqc1dQYapq1bA@mail.gmail.com>
 <CAPL5yKcWZ9qOt7ymw2tCM4gqZ3wiwgRLer+r1x=+kYgDJnqjcQ@mail.gmail.com> <0ad384b6-58ef-f2e9-76e3-f706cd38bd42@gmx.com>
In-Reply-To: <0ad384b6-58ef-f2e9-76e3-f706cd38bd42@gmx.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Sat, 11 Aug 2018 20:59:24 -0400
Message-ID: <CAPL5yKcW2T4-pq3v-XMM0LU999pVhVkXbh4H0d-Gx85pjgakiQ@mail.gmail.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 11, 2018 at 8:30 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> It looks pretty like qgroup, but too many noise.
> The pin point trace event would btrfs_find_all_roots().

I had this half-written when you replied.

Agreed: looks like bulk of time spent resides in qgroups.  Spent some
time with sysrq-l and ftrace:

? __rcu_read_unlock+0x5/0x50
? return_to_handler+0x15/0x36
__rcu_read_unlock+0x5/0x50
find_extent_buffer+0x47/0x90                    extent_io.c:4888
read_block_for_search.isra.12+0xc8/0x350        ctree.c:2399
btrfs_search_slot+0x3e7/0x9c0                   ctree.c:2837
btrfs_next_old_leaf+0x1dc/0x410                 ctree.c:5702
btrfs_next_old_item                             ctree.h:2952
add_all_parents                                 backref.c:487
resolve_indirect_refs+0x3f7/0x7e0               backref.c:575
find_parent_nodes+0x42d/0x1290                  backref.c:1236
? find_parent_nodes+0x5/0x1290                  backref.c:1114
btrfs_find_all_roots_safe+0x98/0x100            backref.c:1414
btrfs_find_all_roots+0x52/0x70                  backref.c:1442
btrfs_qgroup_trace_extent_post+0x27/0x60        qgroup.c:1503
btrfs_qgroup_trace_leaf_items+0x104/0x130       qgroup.c:1589
btrfs_qgroup_trace_subtree+0x26a/0x3a0          qgroup.c:1750
do_walk_down+0x33c/0x5a0                        extent-tree.c:8883
walk_down_tree+0xa8/0xd0                        extent-tree.c:9041
btrfs_drop_snapshot+0x370/0x8b0                 extent-tree.c:9203
merge_reloc_roots+0xcf/0x220
btrfs_recover_relocation+0x26d/0x400
? btrfs_cleanup_fs_roots+0x16a/0x180
btrfs_remount+0x32e/0x510
do_remount_sb+0x67/0x1e0
do_mount+0x712/0xc90

The mount is looping in btrfs_qgroup_trace_subtree, as evidenced by
the following ftrace filter:
fileserver:/sys/kernel/tracing# cat set_ftrace_filter
btrfs_qgroup_trace_extent
btrfs_qgroup_trace_subtree

# cat trace
...
           mount-6803  [003] .... 80407.649752:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_subtree
           mount-6803  [003] .... 80407.649772:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [003] .... 80407.649797:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [003] .... 80407.649821:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [003] .... 80407.649846:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [003] .... 80407.701652:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [003] .... 80407.754547:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [003] .... 80407.754574:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [003] .... 80407.754598:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [003] .... 80407.754622:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [003] .... 80407.754646:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items

... repeats 240 times

           mount-6803  [002] .... 80412.568804:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [002] .... 80412.568825:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items
           mount-6803  [002] .... 80412.568850:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_subtree
           mount-6803  [002] .... 80412.568872:
btrfs_qgroup_trace_extent <-btrfs_qgroup_trace_leaf_items

Looks like invocations of btrfs_qgroup_trace_subtree are taking forever:

           mount-6803  [006] .... 80641.627709:
btrfs_qgroup_trace_subtree <-do_walk_down
           mount-6803  [003] .... 81433.760945:
btrfs_qgroup_trace_subtree <-do_walk_down
(add do_walk_down to the trace here)
           mount-6803  [001] .... 82124.623557: do_walk_down <-walk_down_tree
           mount-6803  [001] .... 82124.623567:
btrfs_qgroup_trace_subtree <-do_walk_down
           mount-6803  [006] .... 82695.241306: do_walk_down <-walk_down_tree
           mount-6803  [006] .... 82695.241316:
btrfs_qgroup_trace_subtree <-do_walk_down

So 10-13 minutes per cycle.

> 11T, with highly deduped usage is really the worst scenario case for qgroup.
> Qgroup is not really good at handle hight reflinked files, nor balance.
> When they combines, it goes worse.

I'm not really understanding the use-case of qgroup if it melts down
on large systems with a shared base + individual changes.

> I'll add a new rescue subcommand, 'btrfs rescue disable-quota' for you
> to disable quota offline.

Ok.  I was looking at just doing this to speed things up:

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 51b5e2da708c..c5bf937b79f0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8877,7 +8877,7 @@ static noinline int do_walk_down(struct
btrfs_trans_handle *trans,
                        parent = 0;
                }

-               if (need_account) {
+               if (0) {
                        ret = btrfs_qgroup_trace_subtree(trans, root, next,
                                                         generation, level - 1);
                        if (ret) {


                        btrfs_err_rl(fs_info,
                          "Error %d accounting shared subtree. Quota
is out of sync, rescan required.",
                          ret);
             }


If I follow, this will leave me with inconsistent qgroups and a full
rescan is required.  That seems an acceptable tradeoff, since it seems
like the best plan going forward is to nuke the qgroups anyway.

There's still the btrfs-transaction spin, but I'm hoping that's
related to qgroups as well.

>
> Thanks,
> Qu

Appreciate it.  I was going to go with my hackjob patch to avoid any
untested rewriting - there's already an error path for "something went
wrong updating qgroups during walk_tree" so it seemed safest to take
advantage of it.  I'll patch either the kernel or the btrfs programs,
whichever you think is best.
