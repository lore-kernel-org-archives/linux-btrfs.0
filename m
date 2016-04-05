Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64949 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751264AbcDEB1J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 21:27:09 -0400
Subject: Re: Qgroups wrong after snapshot create
To: Mark Fasheh <mfasheh@suse.de>, <linux-btrfs@vger.kernel.org>
References: <20160404230657.GA2187@wotan.suse.de>
CC: <jbacik@fb.com>, <clm@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <57031465.8070006@cn.fujitsu.com>
Date: Tue, 5 Apr 2016 09:27:01 +0800
MIME-Version: 1.0
In-Reply-To: <20160404230657.GA2187@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks for the report.

Mark Fasheh wrote on 2016/04/04 16:06 -0700:
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

Also reproduced it.

My first idea is, old snapshot qgroup hack is involved.

Unlike btrfs_inc/dec_extent_ref(), snapshotting just use a dirty hack to 
handle it:
Copy rfer from source subvolume, and directly set excl to nodesize.

If such work is before adding snapshot inode into src subvolume, it may 
be the reason causing the bug.

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

So the base of qgroup code is not affected, or we may need another 
painful rework.

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

Now, for extent 29786112, its nr_new_roots is 1.

>             btrfs-10233 [001] .... 260298.823347: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
>             btrfs-10233 [001] .... 260298.823348: qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
>             btrfs-10233 [001] .... 260298.823421: btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0

Now the problem is here, nr_old_roots should be 1, not 0.
Just as previous trace shows, we increased extent ref on that extent, 
but now it dropped back to 0.

Since its old_root == new_root == 0, qgroup code doesn't do anything on it.
If its nr_old_roots is 1, qgroup will drop it's excl/rfer to 0, and then 
accounting may goes back to normal.

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

It seems that, for 29851648 we are doing right accounting.
As we are modifying source subvolume to create the new inode for snapshot.

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

I assume this is because we're modifying the source subvolume at 
snapshot creation process.

That's to say, if you use the following subvolume layout, snapshot hack 
code won't cause bug:

root(5)
|- subvol 257(src)
\- snapshot 258 (src 257).

Anyway, this is really a big bug, I'll investigate it to ensure the new 
qgroup code will work as expected.

BTW, since we are using the hack for snapshot creation, if using with 
"-i" option, it will still cause qgroup corruption as we didn't go 
through correct accounting, making higher level go crazy.

Thanks,
Qu


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
>


