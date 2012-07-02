Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59019 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab2GBEkN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 00:40:13 -0400
Message-ID: <4FF12190.9090005@cn.fujitsu.com>
Date: Mon, 02 Jul 2012 12:20:32 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Daniel J Blueman <daniel@quora.org>
CC: Chris Mason <chris.mason@fusionio.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Please hammer my for-linus branch
References: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
In-Reply-To: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2012 11:35 AM, Daniel J Blueman wrote:

>> Hi everyone,
>>
>> I've got a nice set of fixes from Josef, Jan, Ilya and others in my
>> for-linus branch:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>>
>> Some of the changes are fixes for the tree logging code, so I ran some
>> extra crash runs against them Friday night.
>>
>> I ended up with a new crash in the tree log directory deletion replay
>> code, so I didn't send out the pull request to Linus.
>>
>> It isn't clear yet if the new crash is because I was testing differently
>> or if it is a regression.  I'm nailing it down this weekend, but please
>> give my for-linus a shot.
> 
> With this branch (3.4.0), my test has consistently been hitting the
> BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID) in
> insert_inline_extent_backref [1]. This is followed by a string of
> other issues [2] and a hard lockup, so I used netconsole to collect
> this.
> 
> I'm preparing my btrfs test for xfstests integration, but can slip you
> it if interested. It hits this case in ~30s.
> 


IMO the BUG_ON is meant to avoid to mix 'log tree' in, it should be:

BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID && root_objectid == BTRFS_TREE_LOG_OBJECTID);

This should help you, can you give it a try?

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4b5a1e1..a006017 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1766,7 +1766,8 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 					   bytenr, num_bytes, parent,
 					   root_objectid, owner, offset, 1);
 	if (ret == 0) {
-		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
+		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
+		       root_objectid == BTRFS_TREE_LOG_OBJECTID);
 		update_inline_extent_backref(trans, root, path, iref,
 					     refs_to_add, extent_op);
 	} else if (ret == -ENOENT) {


thanks,
liubo

> Thanks,
>   Daniel
> 
> --- [1]
> 
> kernel BUG at fs/btrfs/extent-tree.c:1769!
> invalid opcode: 0000 [#1] SMP
> CPU 0
> Modules linked in: brd netconsole dm_crypt dm_mod kvm_intel kvm
> coretemp microcode uvcvideo videobuf2_core iwlwifi videodev
> videobuf2_vmalloc videobuf2_memops btrfs i915 cfbcopyarea video
> cfbimgblt cfbfillrect
> 
> Pid: 3219, comm: btrfs Not tainted 3.4.0-debug+ #1 Dell Inc. Latitude
> E5420/0H5TG2
> RIP: 0010:[<ffffffffa009b867>]  [<ffffffffa009b867>]
> insert_inline_extent_backref+0xe7/0xf0 [btrfs]
> RSP: 0018:ffff8801924df8c8  EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff8801ea7ae3f0 RCX: ffff8801924df910
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffff8801924df948 R08: 0000000000000f4c R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801101e0000
> R13: ffff8801e6ed30f0 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f1b3bf80740(0000) GS:ffff88022ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000000042c430 CR3: 0000000195a05000 CR4: 00000000000407f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process btrfs (pid: 3219, threadinfo ffff8801924de000, task ffff880223e23dc0)
> Stack:
>  0000000000000000 0000000000000005 0000000000000000 0000000000000000
>  ffff880200000001 0000000000000005 ffff8801924df938 ffffffff81110457
>  ffff8801101e1800 0000000000000f43 ffff8801101e1800 ffff8801ea7ae3f0
> Call Trace:
>  [<ffffffff81110457>] ? kmem_cache_alloc+0xe7/0x180
>  [<ffffffffa009b90a>] __btrfs_inc_extent_ref+0x9a/0x1f0 [btrfs]
>  [<ffffffffa009d0a7>] run_delayed_tree_ref+0x167/0x190 [btrfs]
>  [<ffffffffa00a0f2e>] run_one_delayed_ref+0xde/0xf0 [btrfs]
>  [<ffffffffa00a101d>] run_clustered_refs+0xdd/0x370 [btrfs]
>  [<ffffffffa00a13f9>] btrfs_run_delayed_refs+0x149/0x340 [btrfs]
>  [<ffffffffa00b29c7>] __btrfs_end_transaction+0xa7/0x360 [btrfs]
>  [<ffffffffa00b2cc3>] btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
>  [<ffffffffa00fecc9>] relocate_block_group+0x439/0x560 [btrfs]
>  [<ffffffffa00fefb4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
>  [<ffffffffa00dc84a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
>  [<ffffffffa00d7592>] ? free_extent_buffer+0x32/0x90 [btrfs]
>  [<ffffffffa00dfb14>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
>  [<ffffffffa00dff03>] btrfs_balance+0x2f3/0x4d0 [btrfs]
>  [<ffffffffa00e5c30>] btrfs_ioctl_balance+0x140/0x290 [btrfs]
>  [<ffffffffa00e96c7>] btrfs_ioctl+0x5c7/0x7f0 [btrfs]
>  [<ffffffff810f2526>] ? do_brk+0x246/0x360
>  [<ffffffff81130987>] do_vfs_ioctl+0x87/0x340
>  [<ffffffff8122b894>] ? lockdep_sys_exit_thunk+0x35/0x67
>  [<ffffffff81130c8a>] sys_ioctl+0x4a/0x80
>  [<ffffffff815bc622>] system_call_fastpath+0x16/0x1b
> Code: 89 e6 4c 89 ef 48 8b 4d c8 4c 89 3c 24 48 89 44 24 18 8b 45 28
> 89 44 24 10 48 8b 45 20 48 89 44 24 08 e8 1d fa ff ff 31 c0 eb a4 <0f>
> 0b 0f 1f 80 00 00 00 00 55 48 89 e5 48 83 c4 80 48 89 5d d8
> RIP  [<ffffffffa009b867>] insert_inline_extent_backref+0xe7/0xf0 [btrfs]
>  RSP <ffff8801924df8c8>
> 
> --- [2]
> 
> BUG: sleeping function called from invalid context at kernel/rwsem.c:20
> in_atomic(): 1, irqs_disabled(): 0, pid: 3219, name: btrfs
> INFO: lockdep is turned off.
> Pid: 3219, comm: btrfs Tainted: G      D      3.4.0-debug+ #1
> Call Trace:
>  [<ffffffff81069ae2>] __might_sleep+0x142/0x240
>  [<ffffffff815b940f>] down_read+0x1f/0x5c
>  [<ffffffff8105143f>] exit_signals+0x1f/0x130
>  [<ffffffff81042956>] do_exit+0xb6/0x480
>  [<ffffffff81005677>] oops_end+0x77/0xb0
>  [<ffffffff810057f3>] die+0x53/0x80
>  [<ffffffff81002354>] do_trap+0xc4/0x170
>  [<ffffffff81002630>] do_invalid_op+0x90/0xb0
>  [<ffffffffa009b867>] ? insert_inline_extent_backref+0xe7/0xf0 [btrfs]
>  [<ffffffffa009466b>] ? btrfs_search_slot+0x67b/0x760 [btrfs]
>  [<ffffffffa00923ff>] ? btrfs_leaf_free_space+0x5f/0xb0 [btrfs]
>  [<ffffffff8122b85d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff815bbf09>] ? restore_args+0x30/0x30
>  [<ffffffff815bd695>] invalid_op+0x15/0x20
>  [<ffffffffa009b867>] ? insert_inline_extent_backref+0xe7/0xf0 [btrfs]
>  [<ffffffffa009b7de>] ? insert_inline_extent_backref+0x5e/0xf0 [btrfs]
>  [<ffffffff81110457>] ? kmem_cache_alloc+0xe7/0x180
>  [<ffffffffa009b90a>] __btrfs_inc_extent_ref+0x9a/0x1f0 [btrfs]
>  [<ffffffffa009d0a7>] run_delayed_tree_ref+0x167/0x190 [btrfs]
>  [<ffffffffa00a0f2e>] run_one_delayed_ref+0xde/0xf0 [btrfs]
>  [<ffffffffa00a101d>] run_clustered_refs+0xdd/0x370 [btrfs]
>  [<ffffffffa00a13f9>] btrfs_run_delayed_refs+0x149/0x340 [btrfs]
>  [<ffffffffa00b29c7>] __btrfs_end_transaction+0xa7/0x360 [btrfs]
>  [<ffffffffa00b2cc3>] btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
>  [<ffffffffa00fecc9>] relocate_block_group+0x439/0x560 [btrfs]
>  [<ffffffffa00fefb4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
>  [<ffffffffa00dc84a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
>  [<ffffffffa00d7592>] ? free_extent_buffer+0x32/0x90 [btrfs]
>  [<ffffffffa00dfb14>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
>  [<ffffffffa00dff03>] btrfs_balance+0x2f3/0x4d0 [btrfs]
>  [<ffffffffa00e5c30>] btrfs_ioctl_balance+0x140/0x290 [btrfs]
>  [<ffffffffa00e96c7>] btrfs_ioctl+0x5c7/0x7f0 [btrfs]
>  [<ffffffff810f2526>] ? do_brk+0x246/0x360
>  [<ffffffff81130987>] do_vfs_ioctl+0x87/0x340
>  [<ffffffff8122b894>] ? lockdep_sys_exit_thunk+0x35/0x67
>  [<ffffffff81130c8a>] sys_ioctl+0x4a/0x80
>  [<ffffffff815bc622>] system_call_fastpath+0x16/0x1b
> 
> BUG: scheduling while atomic: btrfs/3219/0x10000002
> INFO: lockdep is turned off.
> Modules linked in: brd netconsole dm_crypt dm_mod kvm_intel kvm
> coretemp microcode uvcvideo videobuf2_core iwlwifi videodev
> videobuf2_vmalloc videobuf2_memops btrfs i915 cfbcopyarea video
> cfbimgblt cfbfillrect
> Pid: 3219, comm: btrfs Tainted: G      D      3.4.0-debug+ #1
> Call Trace:
>  [<ffffffff815a674a>] __schedule_bug+0x5d/0x61
>  [<ffffffff815ba0fb>] __schedule+0x8fb/0x9a0
>  [<ffffffff810055a7>] ? show_trace_log_lvl+0x57/0x70
>  [<ffffffff810055d0>] ? show_trace+0x10/0x20
>  [<ffffffff815a469f>] ? dump_stack+0x72/0x7b
>  [<ffffffff8106c4e5>] __cond_resched+0x25/0x40
>  [<ffffffff815ba21d>] _cond_resched+0x2d/0x40
>  [<ffffffff815b9414>] down_read+0x24/0x5c
>  [<ffffffff8105143f>] exit_signals+0x1f/0x130
>  [<ffffffff81042956>] do_exit+0xb6/0x480
>  [<ffffffff81005677>] oops_end+0x77/0xb0
>  [<ffffffff810057f3>] die+0x53/0x80
>  [<ffffffff81002354>] do_trap+0xc4/0x170
>  [<ffffffff81002630>] do_invalid_op+0x90/0xb0
>  [<ffffffffa009b867>] ? insert_inline_extent_backref+0xe7/0xf0 [btrfs]
>  [<ffffffffa009466b>] ? btrfs_search_slot+0x67b/0x760 [btrfs]
>  [<ffffffffa00923ff>] ? btrfs_leaf_free_space+0x5f/0xb0 [btrfs]
>  [<ffffffff8122b85d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff815bbf09>] ? restore_args+0x30/0x30
>  [<ffffffff815bd695>] invalid_op+0x15/0x20
>  [<ffffffffa009b867>] ? insert_inline_extent_backref+0xe7/0xf0 [btrfs]
>  [<ffffffffa009b7de>] ? insert_inline_extent_backref+0x5e/0xf0 [btrfs]
>  [<ffffffff81110457>] ? kmem_cache_alloc+0xe7/0x180
>  [<ffffffffa009b90a>] __btrfs_inc_extent_ref+0x9a/0x1f0 [btrfs]
>  [<ffffffffa009d0a7>] run_delayed_tree_ref+0x167/0x190 [btrfs]
>  [<ffffffffa00a0f2e>] run_one_delayed_ref+0xde/0xf0 [btrfs]
>  [<ffffffffa00a101d>] run_clustered_refs+0xdd/0x370 [btrfs]
>  [<ffffffffa00a13f9>] btrfs_run_delayed_refs+0x149/0x340 [btrfs]
>  [<ffffffffa00b29c7>] __btrfs_end_transaction+0xa7/0x360 [btrfs]
>  [<ffffffffa00b2cc3>] btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
>  [<ffffffffa00fecc9>] relocate_block_group+0x439/0x560 [btrfs]
>  [<ffffffffa00fefb4>] btrfs_relocate_block_group+0x1c4/0x300 [btrfs]
>  [<ffffffffa00dc84a>] btrfs_relocate_chunk.isra.52+0x4a/0x240 [btrfs]
>  [<ffffffffa00d7592>] ? free_extent_buffer+0x32/0x90 [btrfs]
>  [<ffffffffa00dfb14>] __btrfs_balance+0x2f4/0x3f0 [btrfs]
>  [<ffffffffa00dff03>] btrfs_balance+0x2f3/0x4d0 [btrfs]
>  [<ffffffffa00e5c30>] btrfs_ioctl_balance+0x140/0x290 [btrfs]
>  [<ffffffffa00e96c7>] btrfs_ioctl+0x5c7/0x7f0 [btrfs]
>  [<ffffffff810f2526>] ? do_brk+0x246/0x360
>  [<ffffffff81130987>] do_vfs_ioctl+0x87/0x340
>  [<ffffffff8122b894>] ? lockdep_sys_exit_thunk+0x35/0x67
>  [<ffffffff81130c8a>] sys_ioctl+0x4a/0x80
>  [<ffffffff815bc622>] system_call_fastpath+0x16/0x1b
> note: btrfs[3219] exited with preempt_count 1


