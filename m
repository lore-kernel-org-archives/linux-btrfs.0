Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50967 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbcC3RZq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 13:25:46 -0400
Date: Wed, 30 Mar 2016 10:25:09 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: Infinite loop in in btrfs_find_space_cluster() with
 btrfs_free_cluster::lock held
Message-ID: <20160330172509.GC20816@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAOi1vP9HWN98jo23sG_iOjVy1OSXNjeoJWukOhLCmA42rzZHrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOi1vP9HWN98jo23sG_iOjVy1OSXNjeoJWukOhLCmA42rzZHrA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 05:24:04PM +0200, Ilya Dryomov wrote:
> Hi,
> 
> We are hitting the attached lockup on a somewhat regular basis during
> nightly tests.  Looks like a bunch of CPUs spin in find_free_extent()
> on btrfs_free_cluster::lock, which is held by writer, who seems to be
> stuck in an endless loop in btrfs_find_space_cluster(), trying to
> cleanup bitmaps list.  Smells like a list corruption to me?

My objdump shows that find_free_extent() may wait on down_read(&space_info->groups_sem);

One possible thing is that there're too many entries in bitmap, and
list_for_each_entry just is just stuck there.

Are these stacks from "Blocked more than 120s"?

Thanks,

-liubo

> 
> The kernel is ancient in btrfs terms - ubuntu's 3.13.0-83-generic, but
> the surroundings look sufficiently similar to upstream and given recent
> patches like 1b9b922a3a60 ("Btrfs: check for empty bitmap list in
> setup_cluster_bitmaps") I thought this might be relevant for upstream.
> 
> Thanks,
> 
>                 Ilya

> [74750.641965] CPU: 6 PID: 12768 Comm: btrfs-transacti Not tainted 3.13.0-83-generic #127-Ubuntu
> [74750.650976] Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 1.0c 09/07/2015
> [74750.658951] task: ffff88074b0e8000 ti: ffff88083c564000 task.ti: ffff88083c564000
> [74750.666936] RIP: 0010:[<ffffffff8172d9a7>]  [<ffffffff8172d9a7>] _raw_spin_lock+0x37/0x50
> [74750.675645] RSP: 0018:ffff88083c565b50  EFLAGS: 00000206
> [74750.681469] RAX: 00000000000018ca RBX: ffff88083c565b48 RCX: 00000000000009a0
> [74750.689126] RDX: 00000000000009a6 RSI: 00000000000009a6 RDI: ffff88084f6671b0
> [74750.696784] RBP: ffff88083c565b50 R08: ffff88083c565cef R09: 0000000000000001
> [74750.704466] R10: ffffffffa019c9e6 R11: ffffea001ff7f6c0 R12: ffff8807e829d4e0
> [74750.712140] R13: ffffffffa02073ab R14: ffff88083c565ae0 R15: ffff8807e829d4e0
> [74750.719811] FS:  0000000000000000(0000) GS:ffff88087fd80000(0000) knlGS:0000000000000000
> [74750.728450] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [74750.734744] CR2: 00007f4d2b6a9060 CR3: 0000000001c0e000 CR4: 00000000001407e0
> [74750.742437] Stack:
> [74750.745001]  ffff88083c565c28 ffffffffa01b07a3 ffff88074873a000 ffff880530131d20
> [74750.753033]  ffff880791982000 ffff88083c565cef 0000000000001000 0000000400000002
> [74750.761065]  ffffffffa01a3a97 0000000000200000 ffff880523f4a800 0000000000000001
> [74750.769105] Call Trace:
> [74750.772137]  [<ffffffffa01b07a3>] find_free_extent+0x213/0xc30 [btrfs]
> [74750.779259]  [<ffffffffa01a3a97>] ? btrfs_del_items+0x367/0x470 [btrfs]
> [74750.786476]  [<ffffffffa01b12e8>] btrfs_reserve_extent+0xa8/0x1a0 [btrfs]
> [74750.793869]  [<ffffffffa01cbeb5>] __btrfs_prealloc_file_range+0xe5/0x380 [btrfs]
> [74750.801876]  [<ffffffffa01d31e0>] btrfs_prealloc_file_range_trans+0x30/0x40 [btrfs]
> [74750.810136]  [<ffffffffa01b4053>] btrfs_write_dirty_block_groups+0x4d3/0x620 [btrfs]
> [74750.818469]  [<ffffffffa022d5f6>] commit_cowonly_roots+0x151/0x213 [btrfs]
> [74750.825940]  [<ffffffffa01c3aa3>] btrfs_commit_transaction+0x483/0x970 [btrfs]
> [74750.833765]  [<ffffffffa01bf8d5>] transaction_kthread+0x1b5/0x240 [btrfs]
> [74750.841156]  [<ffffffffa01bf720>] ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
> [74750.849244]  [<ffffffff8108b8f2>] kthread+0xd2/0xf0
> [74750.854729]  [<ffffffff8108b820>] ? kthread_create_on_node+0x1c0/0x1c0
> [74750.861861]  [<ffffffff817364e8>] ret_from_fork+0x58/0x90
> [74750.867868]  [<ffffffff8108b820>] ? kthread_create_on_node+0x1c0/0x1c0
> 
> [74758.651947] CPU: 5 PID: 13299 Comm: kworker/u16:1 Not tainted 3.13.0-83-generic #127-Ubuntu
> [74758.662554] Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 1.0c 09/07/2015
> [74758.672309] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-15)
> [74758.681114] task: ffff880734153000 ti: ffff88078ad98000 task.ti: ffff88078ad98000
> [74758.690802] RIP: 0010:[<ffffffff8172d9a2>]  [<ffffffff8172d9a2>] _raw_spin_lock+0x32/0x50
> [74758.701202] RSP: 0018:ffff88078ad99728  EFLAGS: 00000202
> [74758.708662] RAX: 0000000000004bf5 RBX: ffffffff811f0610 RCX: 00000000000009a0
> [74758.717910] RDX: 00000000000009a4 RSI: 00000000000009a4 RDI: ffff88084f6671b0
> [74758.727114] RBP: ffff88078ad99728 R08: ffff88078ad998b7 R09: 0000000000000001
> [74758.736311] R10: 0000000000000000 R11: ffffea001b38bc00 R12: ffff88084e918770
> [74758.745503] R13: ffff88084e9188c0 R14: ffffffff8114f8ee R15: ffff88078ad99698
> [74758.754665] FS:  0000000000000000(0000) GS:ffff88087fd40000(0000) knlGS:0000000000000000
> [74758.764805] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [74758.772582] CR2: 00007f4d2b695000 CR3: 0000000001c0e000 CR4: 00000000001407e0
> [74758.781766] Stack:
> [74758.785786]  ffff88078ad99800 ffffffffa01b07a3 ffff8807e6bc5000 ffff880853034e70
> [74758.795307]  ffff88078ad997b8 ffff88078ad998b7 ffff880853034e40 0000000400000002
> [74758.804838]  ffff88078ad99778 ffffffff00200000 ffff880523f4a800 0000000000000001
> [74758.814337] Call Trace:
> [74758.818811]  [<ffffffffa01b07a3>] find_free_extent+0x213/0xc30 [btrfs]
> [74758.827389]  [<ffffffffa01dc281>] ? alloc_extent_state+0x21/0xc0 [btrfs]
> [74758.836147]  [<ffffffffa01d7f30>] ? __lookup_extent_mapping+0xa0/0x150 [btrfs]
> [74758.845413]  [<ffffffffa01b12e8>] btrfs_reserve_extent+0xa8/0x1a0 [btrfs]
> [74758.854224]  [<ffffffffa01ca1a5>] cow_file_range+0x135/0x430 [btrfs]
> [74758.862593]  [<ffffffffa01cb252>] run_delalloc_range+0x312/0x350 [btrfs]
> [74758.871310]  [<ffffffffa01df479>] ? find_lock_delalloc_range.constprop.43+0x1b9/0x1f0 [btrfs]
> [74758.881857]  [<ffffffff8150c6f3>] ? ata_scsi_queuecmd+0x133/0x400
> [74758.889974]  [<ffffffffa01e06f4>] __extent_writepage+0x2f4/0x760 [btrfs]
> [74758.898703]  [<ffffffffa01c8fb1>] ? btrfs_add_delayed_iput+0x61/0xc0 [btrfs]
> [74758.907763]  [<ffffffff8133a333>] ? __blk_run_queue+0x33/0x40
> [74758.915511]  [<ffffffff811501b1>] ? find_get_pages_tag+0xd1/0x180
> [74758.923600]  [<ffffffff811a386c>] ? kmem_cache_alloc_trace+0x3c/0x1f0
> [74758.932051]  [<ffffffffa01e0dd2>] extent_write_cache_pages.isra.30.constprop.50+0x272/0x3d0 [btrfs]
> [74758.943109]  [<ffffffff81365eb0>] ? cpumask_next_and+0x30/0x50
> [74758.950946]  [<ffffffff810a6e63>] ? find_busiest_group+0x133/0x890
> [74758.959141]  [<ffffffffa01e20ad>] extent_writepages+0x4d/0x70 [btrfs]
> [74758.967592]  [<ffffffffa01c8060>] ? btrfs_submit_direct+0x6a0/0x6a0 [btrfs]
> [74758.976585]  [<ffffffffa01c5b58>] btrfs_writepages+0x28/0x30 [btrfs]
> [74758.984951]  [<ffffffff8115bc2e>] do_writepages+0x1e/0x40
> [74758.992359]  [<ffffffff811e7f10>] __writeback_single_inode+0x40/0x220
> [74759.000782]  [<ffffffff811e8cd7>] writeback_sb_inodes+0x247/0x3e0
> [74759.008817]  [<ffffffff811e8f0f>] __writeback_inodes_wb+0x9f/0xd0
> [74759.016829]  [<ffffffff811e9183>] wb_writeback+0x243/0x2c0
> [74759.024187]  [<ffffffff811eab42>] bdi_writeback_workfn+0x2a2/0x430
> [74759.032198]  [<ffffffff81083d22>] process_one_work+0x182/0x450
> [74759.039804]  [<ffffffff81084b11>] worker_thread+0x121/0x410
> [74759.047089]  [<ffffffff810849f0>] ? rescuer_thread+0x430/0x430
> [74759.054584]  [<ffffffff8108b8f2>] kthread+0xd2/0xf0
> [74759.061085]  [<ffffffff8108b820>] ? kthread_create_on_node+0x1c0/0x1c0
> [74759.069223]  [<ffffffff817364e8>] ret_from_fork+0x58/0x90
> [74759.076193]  [<ffffffff8108b820>] ? kthread_create_on_node+0x1c0/0x1c0
> 
> [74762.991544] CPU: 0 PID: 13053 Comm: filestore_sync Not tainted 3.13.0-83-generic #127-Ubuntu
> [74763.000561] Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 1.0c 09/07/2015
> [74763.008623] task: ffff88084f0cc800 ti: ffff880747972000 task.ti: ffff880747972000
> [74763.016679] RIP: 0010:[<ffffffff8172d9a7>]  [<ffffffff8172d9a7>] _raw_spin_lock+0x37/0x50
> [74763.025465] RSP: 0018:ffff880747973a38  EFLAGS: 00000206
> [74763.031367] RAX: 0000000000002188 RBX: 0000000000013180 RCX: 00000000000009a0
> [74763.039099] RDX: 00000000000009a2 RSI: 00000000000009a2 RDI: ffff88084f6671b0
> [74763.046832] RBP: ffff880747973a38 R08: ffff880747973bc7 R09: 0000000000000001
> [74763.054562] R10: 0000000000000001 R11: ffffea001b7bdac0 R12: ffff8808539bea00
> [74763.062284] R13: ffff8808539bea08 R14: 0000000200000002 R15: ffff88087fc8d3a0
> [74763.070006] FS:  00007f8852891700(0000) GS:ffff88087fc00000(0000) knlGS:0000000000000000
> [74763.078691] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [74763.085021] CR2: 00007f1eafe44000 CR3: 000000077caa6000 CR4: 00000000001407f0
> [74763.092752] Stack:
> [74763.095347]  ffff880747973b10 ffffffffa01b07a3 ffff8807e6bc5000 ffffffffa019f521
> [74763.103399]  00000001801a0019 ffff880747973bc7 ffff88075fbbe000 0000000400000002
> [74763.111451]  0000000000000000 0000000000200000 ffff880523f4a800 0000000000000001
> [74763.119505] Call Trace:
> [74763.122552]  [<ffffffffa01b07a3>] find_free_extent+0x213/0xc30 [btrfs]
> [74763.129688]  [<ffffffffa019f521>] ? read_block_for_search.isra.33+0xa1/0x380 [btrfs]
> [74763.138044]  [<ffffffffa01b12e8>] btrfs_reserve_extent+0xa8/0x1a0 [btrfs]
> [74763.145449]  [<ffffffffa01ca1a5>] cow_file_range+0x135/0x430 [btrfs]
> [74763.152416]  [<ffffffffa01cb252>] run_delalloc_range+0x312/0x350 [btrfs]
> [74763.159736]  [<ffffffffa01df479>] ? find_lock_delalloc_range.constprop.43+0x1b9/0x1f0 [btrfs]
> [74763.168884]  [<ffffffffa01e06f4>] __extent_writepage+0x2f4/0x760 [btrfs]
> [74763.176203]  [<ffffffff810a62d2>] ? enqueue_task_fair+0x422/0x6c0
> [74763.182911]  [<ffffffff8109d945>] ? sched_clock_cpu+0xb5/0x100
> [74763.189361]  [<ffffffff810985e5>] ? check_preempt_curr+0x75/0xa0
> [74763.195979]  [<ffffffff811501b1>] ? find_get_pages_tag+0xd1/0x180
> [74763.202677]  [<ffffffff8109877d>] ? ttwu_do_activate.constprop.74+0x5d/0x70
> [74763.210253]  [<ffffffffa01e0dd2>] extent_write_cache_pages.isra.30.constprop.50+0x272/0x3d0 [btrfs]
> [74763.219928]  [<ffffffffa01e20ad>] extent_writepages+0x4d/0x70 [btrfs]
> [74763.226997]  [<ffffffffa01c8060>] ? btrfs_submit_direct+0x6a0/0x6a0 [btrfs]
> [74763.234579]  [<ffffffff811d19d0>] ? do_vfs_ioctl+0x2e0/0x4c0
> [74763.240869]  [<ffffffffa01c5b58>] btrfs_writepages+0x28/0x30 [btrfs]
> [74763.247855]  [<ffffffff8115bc2e>] do_writepages+0x1e/0x40
> [74763.253879]  [<ffffffff81150da9>] __filemap_fdatawrite_range+0x59/0x60
> [74763.261042]  [<ffffffff81153e6c>] SyS_fadvise64+0x23c/0x250
> [74763.267243]  [<ffffffff8173659d>] system_call_fastpath+0x1a/0x1f
> 
> [74762.553346] CPU: 3 PID: 13092 Comm: journal_write Not tainted 3.13.0-83-generic #127-Ubuntu
> [74762.553347] Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 1.0c 09/07/2015
> [74762.553348] task: ffff88070619b000 ti: ffff88077584c000 task.ti: ffff88077584c000
> [74762.553349] RIP: 0010:[<ffffffffa0203b21>]  [<ffffffffa0203b21>] btrfs_find_space_cluster+0x161/0x290 [btrfs]
> [74762.553367] RSP: 0018:ffff88077584d780  EFLAGS: 00000212
> [74762.553368] RAX: ffff88081908cff0 RBX: ffffffffa0200a75 RCX: ffff88081908cfc0
> [74762.553369] RDX: ffff88081908cfc0 RSI: ffff88081908cff0 RDI: ffff88081908cff0
> [74762.553370] RBP: ffff88077584d7f0 R08: ffff88084f6671b8 R09: 0000000000000000
> [74762.553371] R10: 0000000000118000 R11: ffff88084f7e9400 R12: ffffffffa0200611
> [74762.553372] R13: ffff88077584d6f8 R14: 0000000000318000 R15: ffff88084f6671b0
> [74762.553373] FS:  00007f8852090700(0000) GS:ffff88087fcc0000(0000) knlGS:0000000000000000
> [74762.553374] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [74762.553375] CR2: 00007f8833d2fff8 CR3: 000000077caa6000 CR4: 00000000001407e0
> [74762.553376] Stack:
> [74762.553377]  0000000000001000 ffff88077584d7f0 0000000000118000 0000000111b8d000
> [74762.553380]  0000000000001000 0000000000200000 ffff880852237bc0 ffff88081908cc70
> [74762.553383]  ffff88081908c6f0 ffff88084f7e9400 ffff88084f6671b0 0000000000000001
> [74762.553385] Call Trace:
> [74762.553388]  [<ffffffffa01b0a62>] find_free_extent+0x4d2/0xc30 [btrfs]
> [74762.553401]  [<ffffffffa01b12e8>] btrfs_reserve_extent+0xa8/0x1a0 [btrfs]
> [74762.553413]  [<ffffffffa01d1e97>] btrfs_get_blocks_direct+0x4c7/0x640 [btrfs]
> [74762.553427]  [<ffffffff811fb96c>] do_blockdev_direct_IO+0x103c/0x2910
> [74762.553433]  [<ffffffffa01d19d0>] ? can_nocow_extent+0x390/0x390 [btrfs]
> [74762.553446]  [<ffffffffa01c79c0>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
> [74762.553459]  [<ffffffff811fd295>] __blockdev_direct_IO+0x55/0x60
> [74762.553463]  [<ffffffffa01d19d0>] ? can_nocow_extent+0x390/0x390 [btrfs]
> [74762.553476]  [<ffffffffa01c79c0>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
> [74762.553489]  [<ffffffffa01c5f1e>] btrfs_direct_IO+0x1de/0x3b0 [btrfs]
> [74762.553500]  [<ffffffffa01d19d0>] ? can_nocow_extent+0x390/0x390 [btrfs]
> [74762.553512]  [<ffffffffa01c79c0>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
> [74762.553523]  [<ffffffff81150fb1>] generic_file_direct_write+0xc1/0x180
> [74762.553527]  [<ffffffffa01d5166>] btrfs_file_aio_write+0x3d6/0x510 [btrfs]
> [74762.553540]  [<ffffffff811bdfdc>] do_sync_readv_writev+0x4c/0x80
> [74762.553544]  [<ffffffff811bf4a0>] do_readv_writev+0xb0/0x220
> [74762.553548]  [<ffffffffa01d4d90>] ? __btrfs_buffered_write+0x490/0x490 [btrfs]
> [74762.553559]  [<ffffffff811bdf00>] ? do_sync_read+0x90/0x90
> [74762.553563]  [<ffffffff810a06a5>] ? set_next_entity+0x95/0xb0
> [74762.553566]  [<ffffffff8101260b>] ? __switch_to+0x16b/0x4d0
> [74762.553569]  [<ffffffff8172c1e2>] ? mutex_lock+0x12/0x2f
> [74762.553573]  [<ffffffffa01d3a58>] ? btrfs_file_llseek+0x1a8/0x250 [btrfs]
> [74762.553584]  [<ffffffff811bf690>] vfs_writev+0x30/0x60
> [74762.553587]  [<ffffffff811bf7c9>] SyS_writev+0x49/0xc0
> [74762.553591]  [<ffffffff8173659d>] system_call_fastpath+0x1a/0x1f
> 
> [74830.727656] CPU: 3 PID: 13092 Comm: journal_write Not tainted 3.13.0-83-generic #127-Ubuntu
> [74830.737713] Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 1.0c 09/07/2015
> [74830.746900] task: ffff88070619b000 ti: ffff88077584c000 task.ti: ffff88077584c000
> [74830.756084] RIP: 0010:[<ffffffffa0203b1e>]  [<ffffffffa0203b1e>] btrfs_find_space_cluster+0x15e/0x290 [btrfs]
> [74830.767758] RSP: 0018:ffff88077584d780  EFLAGS: 00000212
> [74830.774774] RAX: ffff88081908cff0 RBX: ffffffffa0200a75 RCX: ffff88081908cfc0
> [74830.783631] RDX: ffff88081908cfc0 RSI: ffff88081908cff0 RDI: ffff88081908cff0
> [74830.792480] RBP: ffff88077584d7f0 R08: ffff88084f6671b8 R09: 0000000000000000
> [74830.801320] R10: 0000000000118000 R11: ffff88084f7e9400 R12: ffffffffa0200611
> [74830.810156] R13: ffff88077584d6f8 R14: 0000000000318000 R15: ffff88084f6671b0
> [74830.818993] FS:  00007f8852090700(0000) GS:ffff88087fcc0000(0000) knlGS:0000000000000000
> [74830.828789] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [74830.836230] CR2: 00007f8833d2fff8 CR3: 000000077caa6000 CR4: 00000000001407e0
> [74830.845063] Stack:
> [74830.848750]  0000000000001000 ffff88077584d7f0 0000000000118000 0000000111b8d000
> [74830.857923]  0000000000001000 0000000000200000 ffff880852237bc0 ffff88081908cc70
> [74830.867096]  ffff88081908c6f0 ffff88084f7e9400 ffff88084f6671b0 0000000000000001
> [74830.876269] Call Trace:
> [74830.880415]  [<ffffffffa01b0a62>] find_free_extent+0x4d2/0xc30 [btrfs]
> [74830.888665]  [<ffffffffa01b12e8>] btrfs_reserve_extent+0xa8/0x1a0 [btrfs]
> [74830.897168]  [<ffffffffa01d1e97>] btrfs_get_blocks_direct+0x4c7/0x640 [btrfs]
> [74830.906005]  [<ffffffff811fb96c>] do_blockdev_direct_IO+0x103c/0x2910
> [74830.914159]  [<ffffffffa01d19d0>] ? can_nocow_extent+0x390/0x390 [btrfs]
> [74830.922978]  [<ffffffffa01c79c0>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
> [74830.931942]  [<ffffffff811fd295>] __blockdev_direct_IO+0x55/0x60
> [74830.940038]  [<ffffffffa01d19d0>] ? can_nocow_extent+0x390/0x390 [btrfs]
> [74830.948829]  [<ffffffffa01c79c0>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
> [74830.957795]  [<ffffffffa01c5f1e>] btrfs_direct_IO+0x1de/0x3b0 [btrfs]
> [74830.966336]  [<ffffffffa01d19d0>] ? can_nocow_extent+0x390/0x390 [btrfs]
> [74830.975143]  [<ffffffffa01c79c0>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
> [74830.984105]  [<ffffffff81150fb1>] generic_file_direct_write+0xc1/0x180
> [74830.992714]  [<ffffffffa01d5166>] btrfs_file_aio_write+0x3d6/0x510 [btrfs]
> [74831.001667]  [<ffffffff811bdfdc>] do_sync_readv_writev+0x4c/0x80
> [74831.009744]  [<ffffffff811bf4a0>] do_readv_writev+0xb0/0x220
> [74831.017483]  [<ffffffffa01d4d90>] ? __btrfs_buffered_write+0x490/0x490 [btrfs]
> [74831.026767]  [<ffffffff811bdf00>] ? do_sync_read+0x90/0x90
> [74831.034314]  [<ffffffff810a06a5>] ? set_next_entity+0x95/0xb0
> [74831.042121]  [<ffffffff8101260b>] ? __switch_to+0x16b/0x4d0
> [74831.049750]  [<ffffffff8172c1e2>] ? mutex_lock+0x12/0x2f
> [74831.057126]  [<ffffffffa01d3a58>] ? btrfs_file_llseek+0x1a8/0x250 [btrfs]
> [74831.065558]  [<ffffffff811bf690>] vfs_writev+0x30/0x60
> [74831.072304]  [<ffffffff811bf7c9>] SyS_writev+0x49/0xc0
> [74831.079012]  [<ffffffff8173659d>] system_call_fastpath+0x1a/0x1f

