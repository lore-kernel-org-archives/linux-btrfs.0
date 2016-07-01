Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbcGAKBd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jul 2016 06:01:33 -0400
Date: Fri, 1 Jul 2016 12:00:50 +0200
From: Jan Kara <jack@suse.cz>
To: Nikolay Borisov <kernel@kyup.com>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        dvyukov@google.com, linux-btrfs@vger.kernel.org,
        SiteGround Operations <operations@siteground.com>
Subject: Re: GPF in __mark_inode_dirty due to
 locked_inode_to_wb_and_lock_list returning NULL
Message-ID: <20160701100050.GC22922@quack2.suse.cz>
References: <5774FFF6.3030408@kyup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5774FFF6.3030408@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On Thu 30-06-16 14:18:14, Nikolay Borisov wrote:
> In light of the discussion in https://patchwork.kernel.org/patch/9187411/ and 
> the discussion at https://groups.google.com/forum/#!topic/syzkaller/XvxH3cBQ134

Well, it looks it is also some bdi_writeback lifetime issue but I don't see
how it would be related to I_DIRTY_TIME issues. There were couple of fixes
related to bdi_writeback issues from Tejun since 4.4. Maybe Tejun can tell
you whether he's seen this or not...

									Honza

> I think the following might be related:
> 
> [1416412.898946] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> [1416412.899217] IP: [<ffffffff811cab1d>] __mark_inode_dirty+0x21d/0x410
> [1416412.899438] PGD 0 
> [1416412.899647] Oops: 0000 [#1] SMP 
> [1416412.903807] CPU: 2 PID: 11154 Comm: umount Tainted: P        W  O    4.4.9-clouder1 #20
> [1416412.903980] Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013
> [1416412.904270] task: ffff880466f18000 ti: ffff8802651d0000 task.ti: ffff8802651d0000
> [1416412.907150] RIP: 0010:[<ffffffff811cab1d>]  [<ffffffff811cab1d>] __mark_inode_dirty+0x21d/0x410
> [1416412.907487] RSP: 0018:ffff8802651d3828  EFLAGS: 00010282
> [1416412.907656] RAX: 0000000000000000 RBX: ffff8801f71c3c48 RCX: 000000000000001a
> [1416412.907829] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88034a44c398
> [1416412.908001] RBP: ffff8802651d38d8 R08: 0000000000000000 R09: 0000000000000000
> [1416412.908173] R10: 0000000000000000 R11: ffff88020e17d468 R12: 0000000000000000
> [1416412.908343] R13: ffff88034a44c340 R14: 0000000000000000 R15: 0000000000000000
> [1416412.908516] FS:  00007fd09f80f740(0000) GS:ffff88047fc40000(0000) knlGS:0000000000000000
> [1416412.908690] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1416412.908859] CR2: 0000000000000018 CR3: 00000004671da000 CR4: 00000000000406e0
> [1416412.909030] Stack:
> [1416412.909192]  ffff8802651d38d8 ffffffffa0912043 ffff8802651d38e8 ffffffffa0911de3
> [1416412.909551]  ffff8802651d38a4 ffff8802a41fcfa0 0000000000000000 0000000000000003
> [1416412.909908]  ffff8801f71c3c48 ffff88046f029000 ffff8802651d38d8 ffffffff8113d2ed
> [1416412.910263] Call Trace:
> [1416412.910455]  [<ffffffffa0912043>] ? __set_extent_bit+0x393/0x5e0 [btrfs]
> [1416412.910642]  [<ffffffffa0911de3>] ? __set_extent_bit+0x133/0x5e0 [btrfs]
> [1416412.910816]  [<ffffffff8113d2ed>] ? account_page_dirtied+0xed/0x1b0
> [1416412.910987]  [<ffffffff8113d486>] __set_page_dirty_nobuffers+0xd6/0x150
> [1416412.911173]  [<ffffffffa08f2a0e>] btrfs_set_page_dirty+0xe/0x10 [btrfs]
> [1416412.911346]  [<ffffffff81139c61>] set_page_dirty+0x41/0x70
> [1416412.911530]  [<ffffffffa090376a>] btrfs_dirty_pages+0x7a/0xb0 [btrfs]
> [1416412.911718]  [<ffffffffa093a263>] __btrfs_write_out_cache+0x383/0x430 [btrfs]
> [1416412.911903]  [<ffffffffa08d360e>] ? btrfs_free_reserved_data_space_noquota+0x5e/0x130 [btrfs]
> [1416412.912208]  [<ffffffffa093be8f>] btrfs_write_out_cache+0xaf/0x120 [btrfs]
> [1416412.912391]  [<ffffffffa08dbb7f>] btrfs_start_dirty_block_groups+0x24f/0x490 [btrfs]
> [1416412.912566]  [<ffffffff8107adb2>] ? __might_sleep+0x52/0x90
> [1416412.912750]  [<ffffffffa08efe63>] btrfs_commit_transaction+0x163/0xb70 [btrfs]
> [1416412.912933]  [<ffffffffa08f0ccd>] ? start_transaction+0x9d/0x4e0 [btrfs]
> [1416412.913119]  [<ffffffffa090bf4b>] ? btrfs_wait_ordered_roots+0x1bb/0x1f0 [btrfs]
> [1416412.913302]  [<ffffffffa08bb0d0>] btrfs_sync_fs+0x70/0x150 [btrfs]
> [1416412.913475]  [<ffffffff811d3e10>] __sync_filesystem+0x30/0x50
> [1416412.913645]  [<ffffffff811d3e72>] sync_filesystem+0x42/0x60
> [1416412.913816]  [<ffffffff811a2dab>] generic_shutdown_super+0x2b/0x100
> [1416412.913987]  [<ffffffff811a2f76>] kill_anon_super+0x16/0x30
> [1416412.914165]  [<ffffffffa08beeae>] btrfs_kill_super+0x1e/0x130 [btrfs]
> [1416412.914338]  [<ffffffff811a31b3>] deactivate_locked_super+0x53/0x90
> [1416412.914507]  [<ffffffff811a3651>] deactivate_super+0x51/0x70
> [1416412.914679]  [<ffffffff811bf4ef>] cleanup_mnt+0x3f/0x80
> [1416412.914852]  [<ffffffff811bf582>] __cleanup_mnt+0x12/0x20
> [1416412.915028]  [<ffffffff81072968>] task_work_run+0x68/0xb0
> [1416412.915203]  [<ffffffff81002306>] exit_to_usermode_loop+0xe6/0xf0
> [1416412.915376]  [<ffffffff811b75ad>] ? dput+0x11d/0x240
> [1416412.915547]  [<ffffffff81002600>] syscall_return_slowpath+0xa0/0x110
> [1416412.915719]  [<ffffffff81002017>] ? trace_hardirqs_on_thunk+0x17/0x19
> [1416412.915893]  [<ffffffff8164302c>] int_ret_from_sys_call+0x25/0x9f
> 
> The faulting instructions are: 
> 
> 0xffffffff811cab12 <__mark_inode_dirty+530>:    callq  0xffffffff811c9d80 <locked_inode_to_wb_and_lock_list>
> 0xffffffff811cab17 <__mark_inode_dirty+535>:    mov    %rax,%r13      ; move bdi_writeback to r13
> 0xffffffff811cab1a <__mark_inode_dirty+538>:    mov    (%rax),%rax    ; rax = bdi_write-back->bdi
> 0xffffffff811cab1d <__mark_inode_dirty+541>:    testb  $0x2,0x18(%rax) ; bdi_cap_writeback_dirty(wb->bdi) 
> 
> So we call locked_inode_to_wb_and_lock_list, and then get the bdi_writeback->bdi, 
> which actually is null. As a matter of fact the whole struct bdi_writeback is null
> (not the pointer to it). Is this possible to stem from the same issue discussed
> in the referenced email threads or is it a different, btrfs-specific problem. 
> 
> Regards, 
> Nikolay 
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
