Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61349 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbcDEN2T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 09:28:19 -0400
Subject: Re: Qgroups wrong after snapshot create
To: Mark Fasheh <mfasheh@suse.de>, linux-btrfs@vger.kernel.org
References: <20160404230657.GA2187@wotan.suse.de>
Cc: quwenruo@cn.fujitsu.com, jbacik@fb.com, clm@fb.com
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5703BD5C.1040108@gmx.com>
Date: Tue, 5 Apr 2016 21:27:56 +0800
MIME-Version: 1.0
In-Reply-To: <20160404230657.GA2187@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/05/2016 07:06 AM, Mark Fasheh wrote:
> Hi,
>
> Making a snapshot gets us the wrong qgroup numbers. This is very easy to
> reproduce. From a fresh btrfs filesystem, simply enable qgroups and create a
> snapshot. In this example we have mounted a newly created fresh filesystem
> and mounted it at /btrfs:
>
> # btrfs quota enable /btrfs
> # btrfs sub sna /btrfs/ /btrfs/snap1
> # btrfs qg show /btrfs
>
> qgroupid         rfer         excl
> --------         ----         ----
> 0/5          32.00KiB     32.00KiB
> 0/257        16.00KiB     16.00KiB
>
>
> In the example above, the default subvolume (0/5) should read 16KiB
> referenced and 16KiB exclusive.
>
> A rescan fixes things, so we know the rescan process is doing the math
> right:
>
> # btrfs quota rescan /btrfs
> # btrfs qgroup show /btrfs
> qgroupid         rfer         excl
> --------         ----         ----
> 0/5          16.00KiB     16.00KiB
> 0/257        16.00KiB     16.00KiB
>
>
>
> The last kernel to get this right was v4.1:
>
> # uname -r
> 4.1.20
> # btrfs quota enable /btrfs
> # btrfs sub sna /btrfs/ /btrfs/snap1
> Create a snapshot of '/btrfs/' in '/btrfs/snap1'
> # btrfs qg show /btrfs
> qgroupid         rfer         excl
> --------         ----         ----
> 0/5          16.00KiB     16.00KiB
> 0/257        16.00KiB     16.00KiB
>
>
> Which leads me to believe that this was a regression introduced by Qu's
> rewrite as that is the biggest change to qgroups during that development
> period.
>
>
> Going back to upstream, I applied my tracing patch from this list
> ( http://thread.gmane.org/gmane.comp.file-systems.btrfs/54685 ), with a
> couple changes - I'm printing the rfer/excl bytecounts in
> qgroup_update_counters AND I print them twice - once before we make any
> changes and once after the changes. If I enable tracing in
> btrfs_qgroup_account_extent and qgroup_update_counters just before the
> snapshot creation, we get the following trace:
>
>
> # btrfs quota enable /btrfs
> # <wait a sec for the rescan to finish>
> # echo 1 > /sys/kernel/debug/tracing/events/btrfs/btrfs_qgroup_account_extent/enable
> # echo 1 > //sys/kernel/debug/tracing/events/btrfs/qgroup_update_counters/enable
> # btrfs sub sna /btrfs/ /btrfs/snap2
> Create a snapshot of '/btrfs/' in '/btrfs/snap2'
> # btrfs qg show /btrfs
> qgroupid         rfer         excl
> --------         ----         ----
> 0/5          32.00KiB     32.00KiB
> 0/257        16.00KiB     16.00KiB
> # fstest1:~ # cat /sys/kernel/debug/tracing/trace
>
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 13/13   #P:2
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>             btrfs-10233 [001] .... 260298.823339: btrfs_qgroup_account_extent: bytenr = 29360128, num_bytes = 16384, nr_old_roots = 1, nr_new_roots = 0
>             btrfs-10233 [001] .... 260298.823342: qgroup_update_counters: qgid = 5, cur_old_count = 1, cur_new_count = 0, rfer = 16384, excl = 16384
>             btrfs-10233 [001] .... 260298.823342: qgroup_update_counters: qgid = 5, cur_old_count = 1, cur_new_count = 0, rfer = 0, excl = 0
>             btrfs-10233 [001] .... 260298.823343: btrfs_qgroup_account_extent: bytenr = 29720576, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
>             btrfs-10233 [001] .... 260298.823345: btrfs_qgroup_account_extent: bytenr = 29736960, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
>             btrfs-10233 [001] .... 260298.823347: btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
>             btrfs-10233 [001] .... 260298.823347: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
>             btrfs-10233 [001] .... 260298.823348: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
>             btrfs-10233 [001] .... 260298.823421: btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0

I think I caught the direct cause.

Here for bytenr 29786112, it got quota dirtied twice, one for cow to a 
new block(although I don't got why it got cowed, as it is cowed again 
later), one for de-ref.

But the problem is, qgroup accounting is run twice inside the same 
transaction.

Current qgroup design heavily depends on transaction to get correct old 
and new roots.
It always get old roots from *COMMIT ROOT*, and get new roots from 
current root just before *SWITCHING COMMIT ROOT*.

However in this case, we got new roots in the middle of a transaction, 
and did update qgroup accounting.
This means we get wrong new_roots for extent which will not be committed 
to disk.

In this case, it is bytenr 29786112. It doesn't reach disk, so it's not 
on disk in either transaction before/after snapshot.
Normally, its old and new roots should both be 0, and qgroup will skip 
it, nothing will be corrupted
However current qgroup doesn't do it like that, it just run delayed refs 
and then update qgroup accounting, then adding snapshot inode into fs 
tree, then finally commit transaction(which did qgroup accounting again).

That's why for extent 29786112, it get nr_new_roots = 1, but at second 
time, it get nr_new_roots = 0.
(nr_old_roots are always 0 as we didn't switch commit root, for 1st 
time, it get allocated so its nr_new_roots = 1, but for 2nd time, it got 
removed, so its nr_new_roots = 0)


To fix it we have at least 2 method.
1) Ensure no temporary cowed tree block will happen in create_snapshot()
    That's to eliminate extent 29786112, only old fs root and the final
    fs root(29851648).

    This fix has some meaning, as in fact we really don't need the
    temporary tree block, but that's not the real fix.
    (And I didn't got the reason yet)

2) Don't run qgroup accounting in the middle of a transaction
    That's the root fix, I'll use this method to fix tomorrow.

Thanks for your report again.
Qu
>             btrfs-10233 [001] .... 260298.823422: btrfs_qgroup_account_extent: bytenr = 29835264, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
>             btrfs-10233 [001] .... 260298.823425: btrfs_qgroup_account_extent: bytenr = 29851648, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
>             btrfs-10233 [001] .... 260298.823426: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
>             btrfs-10233 [001] .... 260298.823426: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 32768, excl = 32768
>
> If you read through the whole log we do some ... interesting.. things - at
> the start, we *subtract* from qgroup 5, making it's count go to zero. I want
> to say that this is kind of unexpected for a snapshot create but perhaps
> there's something I'm missing.
>
> Remember that I'm printing each qgroup twice in qgroup_adjust_counters (once
> before, once after). Sothen we can see then that extent 29851648 (len 16k)
> is the extent being counted against qgroup 5 which makes the count invalid.
>
>  From a btrfs-debug-tree I get the following records referencing that extent:
>
>  From the root tree:
>          item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
>                  root data bytenr 29851648 level 0 dirid 256 refs 1 gen 10 lastsnap 10
>                  uuid 00000000-0000-0000-0000-000000000000
>                  ctransid 10 otransid 0 stransid 0 rtransid 0
>
>  From the extent tree:
>          item 9 key (29851648 METADATA_ITEM 0) itemoff 15960 itemsize 33
>                  extent refs 1 gen 10 flags TREE_BLOCK
>                  tree block skinny level 0
>                  tree block backref root 5
>
> And here is the block itself:
>
> fs tree key (FS_TREE ROOT_ITEM 0)
> leaf 29851648 items 4 free space 15941 generation 10 owner 5
> fs uuid f7e55c97-b0b3-44e5-bab1-1fd55d54409b
> chunk uuid b78fe016-e35f-4f57-8211-796cbc9be3a4
>          item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
>                  inode generation 3 transid 10 size 10 nbytes 16384
>                  block group 0 mode 40755 links 1 uid 0 gid 0
>                  rdev 0 flags 0x0
>          item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
>                  inode ref index 0 namelen 2 name: ..
>          item 2 key (256 DIR_ITEM 3390559794) itemoff 16076 itemsize 35
>                  location key (257 ROOT_ITEM -1) type DIR
>                  namelen 5 datalen 0 name: snap2
>          item 3 key (256 DIR_INDEX 2) itemoff 16041 itemsize 35
>                  location key (257 ROOT_ITEM -1) type DIR
>                  namelen 5 datalen 0 name: snap2
>
>
> So unless I'm mistaken, it seems like we're counting the original snapshot
> root against itself when creating a snapshot.
>
> I found this looking for what I believe to be a _different_ corruption in
> qgroups. In the meantime while I track that one down though I was hoping
> that someone might be able to shed some light on this particular issue.
>
> Qu, do you have any ideas how we might fix this?
>
> Thanks,
> 	--Mark
>
> PS: I have attached the output of btrfs-debug-tree for the FS used in this
> example.
>
> --
> Mark Fasheh
>
