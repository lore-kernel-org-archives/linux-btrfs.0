Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:53225 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbbEGVax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 May 2015 17:30:53 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id E48F8160AD3
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2015 16:30:52 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id FTZDTjq2keLT for <linux-btrfs@vger.kernel.org>;
	Thu,  7 May 2015 16:30:52 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id 12B2D160FD3
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2015 16:30:52 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BBDEAD2-HssH for <linux-btrfs@vger.kernel.org>;
	Thu,  7 May 2015 16:30:51 -0500 (CDT)
Received: from [192.168.168.20] (unknown [206.126.223.13])
	by mail.lqfe.com (Postfix) with ESMTPSA id AEB97160AD3
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2015 16:30:51 -0500 (CDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: Kernel Dump scanning directory
From: Anthony Plack <anthony@plack.net>
In-Reply-To: <4B045A3B-60E2-4151-86E7-029E79585886@plack.net>
Date: Thu, 7 May 2015 16:30:50 -0500
Message-Id: <60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net> <4B045A3B-60E2-4151-86E7-029E79585886@plack.net>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 7, 2015, at 9:33 AM, Anthony Plack <anthony@plack.net> wrote:
> 
> Okay, trying my programming skills at this unfamiliar code.
> 
> Okay so this looks like an IO error, then an abort transaction.  Is it a fair assumption that a normal transaction abort marks the volume as read-only, undoes the transaction, and then marks the transaction as read-write?  Therefore, because of the dump, in the middle of the undo, the volume remains read-only?
> 
>> On May 6, 2015, at 4:56 PM, Anthony Plack <anthony@plack.net> wrote:
>> 
>> Hey guys, I have some dump data from BTRFS.  This occurred when running rsync -nav to my backup server.  Data is all there (as far as I can tell about 9TB of data).  If I unmount the drive, and remount it, it will be writable (echo ‘b’ > b) for days, but I start the rsync and very quickly it will dump and switch to read-only.  Scrub finished successful (mount was still RW after completion) yesterday.  Let me know what else I can get you.
>> 
>> May  6 11:17:47 fatdrive kernel: verify_parent_transid: 19 callbacks suppressed
>> May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
>> May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
>> May  6 11:17:47 fatdrive kernel: ------------[ cut here ]------------
>> May  6 11:17:47 fatdrive kernel: WARNING: CPU: 0 PID: 9426 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0x5a/0x130()
>> May  6 11:17:47 fatdrive kernel: BTRFS: Transaction aborted (error -5)
>> May  6 11:17:47 fatdrive kernel: Modules linked in: nfsd exportfs kvm_amd r8168(O) kvm k10temp ata_generic acpi_cpufreq
>> May  6 11:17:47 fatdrive kernel: CPU: 0 PID: 9426 Comm: kworker/u12:4 Tainted: G        W  O    4.0.0-gentoo #1
>> May  6 11:17:47 fatdrive kernel: Hardware name: BIOSTAR Group TA880G HD/TA880G HD, BIOS 080015  11/11/2011
>> May  6 11:17:47 fatdrive kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
>> May  6 11:17:47 fatdrive kernel:  ffffffff81a9729e ffff8801704abc38 ffffffff817e6414 0000000000000000
>> May  6 11:17:47 fatdrive kernel:  ffff8801704abc88 ffff8801704abc78 ffffffff81049e60 0000000000000000
>> May  6 11:17:47 fatdrive kernel:  ffff8802142b22c0 ffff88020ce81800 00000000fffffffb ffffffff81869b50
>> May  6 11:17:47 fatdrive kernel: Call Trace:
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff817e6414>] dump_stack+0x45/0x57
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81049e60>] warn_slowpath_common+0x90/0xd0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81049ee1>] warn_slowpath_fmt+0x41/0x50
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff812d9e7a>] __btrfs_abort_transaction+0x5a/0x130
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff812f6fa1>] btrfs_run_delayed_refs.part.65+0x121/0x270
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff812f7190>] delayed_ref_async_start+0x80/0xa0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81336e07>] normal_work_helper+0xb7/0x2b0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff8133711d>] btrfs_extent_refs_helper+0xd/0x10
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff810606c7>] process_one_work+0x147/0x3f0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81060a88>] worker_thread+0x118/0x440
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81060970>] ? process_one_work+0x3f0/0x3f0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81065624>] kthread+0xc4/0xe0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81065560>] ? kthread_create_on_node+0x190/0x190
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff817ee488>] ret_from_fork+0x58/0x90
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81065560>] ? kthread_create_on_node+0x190/0x190
>> May  6 11:17:47 fatdrive kernel: ---[ end trace f948e8ffd1f550c0 ]---
>> May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
>> May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
> 
> Not sure where to dig out btrfs_run_delayed_refs.part.65+0x121 as it is a structure (gdb is not a regular tool I use).  it seems that it is trying to run the delayed refs and something in the data for line 265 is wrong and generating a warning.
> 
> 260					errno);
> 261		}
> 262		trans->aborted = errno;
> 263		/* Nothing used. The other threads that have joined this
> 264		 * transaction may be able to continue. */
> 265		if (!trans->blocks_used && list_empty(&trans->new_bgs)) {
> 266			const char *errstr;
> 267	
> 268			errstr = btrfs_decode_error(errno);
> 269			btrfs_warn(root->fs_info,
> 
> 
> 
>> May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
>> May  6 11:17:47 fatdrive kernel: ------------[ cut here ]------------
>> May  6 11:17:47 fatdrive kernel: WARNING: CPU: 1 PID: 9414 at fs/btrfs/delayed-ref.c:438 btrfs_select_ref_head+0x124/0x140()
>> May  6 11:17:47 fatdrive kernel: Modules linked in: nfsd exportfs kvm_amd r8168(O) kvm k10temp ata_generic acpi_cpufreq
>> May  6 11:17:47 fatdrive kernel: CPU: 1 PID: 9414 Comm: kworker/u12:0 Tainted: G        W  O    4.0.0-gentoo #1
>> May  6 11:17:47 fatdrive kernel: Hardware name: BIOSTAR Group TA880G HD/TA880G HD, BIOS 080015  11/11/2011
>> May  6 11:17:47 fatdrive kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
>> May  6 11:17:47 fatdrive kernel:  ffffffff81a98a02 ffff88006476bb58 ffffffff817e6414 0000000000000000
>> May  6 11:17:47 fatdrive kernel:  0000000000000000 ffff88006476bb98 ffffffff81049e60 ffff88006476bbd8
>> May  6 11:17:47 fatdrive kernel:  ffff880214300320 ffff880178aec120 0000000000000000 ffff880178aec208
>> May  6 11:17:47 fatdrive kernel: Call Trace:
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff817e6414>] dump_stack+0x45/0x57
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81049e60>] warn_slowpath_common+0x90/0xd0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81049f45>] warn_slowpath_null+0x15/0x20
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81351f04>] btrfs_select_ref_head+0x124/0x140
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff812f1f15>] __btrfs_run_delayed_refs+0x1f5/0x11f0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff8106e6cd>] ? check_preempt_curr+0x8d/0xa0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff8106e6f8>] ? ttwu_do_wakeup+0x18/0xd0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff812f6eea>] btrfs_run_delayed_refs.part.65+0x6a/0x270
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff812f7190>] delayed_ref_async_start+0x80/0xa0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81336e07>] normal_work_helper+0xb7/0x2b0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff8133711d>] btrfs_extent_refs_helper+0xd/0x10
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff810606c7>] process_one_work+0x147/0x3f0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81060a88>] worker_thread+0x118/0x440
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81060970>] ? process_one_work+0x3f0/0x3f0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81065624>] kthread+0xc4/0xe0
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81065560>] ? kthread_create_on_node+0x190/0x190
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff817ee488>] ret_from_fork+0x58/0x90
>> May  6 11:17:47 fatdrive kernel:  [<ffffffff81065560>] ? kthread_create_on_node+0x190/0x190
>> May  6 11:17:47 fatdrive kernel: ---[ end trace f948e8ffd1f550c1 ]---
>> May  6 11:17:47 fatdrive kernel: BTRFS: error (device sdm) in btrfs_run_delayed_refs:2790: errno=-5 IO failure
>> May  6 11:17:47 fatdrive kernel: BTRFS info (device sdm): forced readonly
>> May  6 11:17:47 fatdrive kernel: BTRFS: error (device sdm) in btrfs_run_delayed_refs:2790: errno=-5 IO failure
>> May  6 11:17:47 fatdrive kernel: BTRFS: error (device sdm) in btrfs_run_delayed_refs:2790: errno=-5 IO failure
>> May  6 11:18:16 fatdrive kernel: verify_parent_transid: 28 callbacks suppressed
>> May  6 11:18:16 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 7645497978880 wanted 148829 found 147711
>> 
> 
> This next one seems a little more obvious.
> 
> 0x12d4 is in btrfs_select_ref_head (fs/btrfs/delayed-ref.c:438).
> 433			head = rb_entry(node, struct btrfs_delayed_ref_head,
> 434					href_node);
> 435		}
> 436	
> 437		head->processing = 1;
> 438		WARN_ON(delayed_refs->num_heads_ready == 0);
> 439		delayed_refs->num_heads_ready--;
> 440		delayed_refs->run_delayed_start = head->node.bytenr +
> 441			head->node.num_bytes;
> 442		return head;
> 
> Because there are not heads ready, we are getting a warning.
> 
> So the real question is how do I know what is generating the IO error?  The rsync -nav is not changing the the volume, it is reading from it.
> 
> The devices are not showing errors in the log or in the "device stat" view.
> 
> What seems to be interesting is that whatever is generating the IO errors (which seems to be in the extents), triggers the Warning, which by default flips the whole volume to read-only.

Okay, so I ran btrfs-debug-tree /dev/sdm.  Most of the leaves looked okay until it got to one where it gave me this and quit:

	item 35 key (2685703434240 EXTENT_ITEM 4096) itemoff 2159 itemsize 51
		extent refs 1 gen 150619 flags TREE_BLOCK
		tree block key (4231221 DIR_ITEM 1140804831) level 0
		tree block backref root 5
parent transid verify failed on 94238015488 wanted 150690 found 150691
parent transid verify failed on 94238015488 wanted 150690 found 150691
parent transid verify failed on 94238015488 wanted 150690 found 150691
parent transid verify failed on 94238015488 wanted 150690 found 150691
Ignoring transid failure
print-tree.c:1091: btrfs_print_tree: Assertion failed.
btrfs-debug-tree[0x418539]
btrfs-debug-tree[0x41a53a]
btrfs-debug-tree(btrfs_print_tree+0x1eb)[0x41a40b]
btrfs-debug-tree(main+0x704)[0x407d04]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f2936a42a85]
btrfs-debug-tree[0x40812d]

So it looks like the IO error is really just a bad extent, which makes sense from the warnings from the kernel.

I will need to figure out why the Assertion failed.