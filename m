From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: Re: [PATCH] btrfs: fix race between allocate and release extent buffer.
Date: Thu, 04 Feb 2010 16:56:06 +0800
Message-ID: <4B6A8BA6.3070703@oracle.com>
References: <4B6A8980.206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B6A8980.206@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/04/2010 04:46 PM, Yan, Zheng wrote:
> Increase extent buffer's reference count while holding the lock.
> Otherwise it can race with try_release_extent_buffer.
> 
> Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
> 
> ---
> diff -urp 1/fs/btrfs/extent_io.c 2/fs/btrfs/extent_io.c
> --- 1/fs/btrfs/extent_io.c	2010-01-17 15:48:16.770302026 +0800
> +++ 2/fs/btrfs/extent_io.c	2010-02-04 16:37:45.704800682 +0800
> @@ -3165,10 +3165,9 @@ struct extent_buffer *alloc_extent_buffe
>  		spin_unlock(&tree->buffer_lock);
>  		goto free_eb;
>  	}
> -	spin_unlock(&tree->buffer_lock);
> -
>  	/* add one reference for the tree */
>  	atomic_inc(&eb->refs);
> +	spin_unlock(&tree->buffer_lock);
>  	return eb;
>  
>  free_eb:

Oops caused by this bug are attached below.

Modules linked in: btrfs ipt_MASQUERADE iptable_nat nf_nat bridge stp zlib_deflate libcrc32c llc sunrpc xt_physdev ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 p4_clockmod freq_table speedstep_lib dm_multipath kvm uinput snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm ppdev parport_pc parport dcdbas serio_raw i2c_i801 pcspkr snd_timer snd soundcore iTCO_wdt iTCO_vendor_support snd_page_alloc e1000e ata_generic pata_acpi i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: freq_table]
Pid: 3302, comm: flush-btrfs-1 Tainted: G        W  2.6.32 #1 OptiPlex 755                 
RIP: 0010:[<ffffffffa0396718>]  [<ffffffffa0396718>] btrfs_set_buffer_uptodate+0x14/0x25 [btrfs]
RSP: 0018:ffff880077e47480  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88003d8a4000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff88003d8a4000 RDI: ffff88003d8a4000
RBP: ffff880077e47480 R08: ffff880001c555c0 R09: 0000000000000000
R10: ffff880001c55630 R11: ffff880001c555c0 R12: ffff88007910eb80
R13: ffff88007a39c800 R14: 0000000000000022 R15: ffff88007910eb80
FS:  0000000000000000(0000) GS:ffff880001c40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000000a991000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-btrfs-1 (pid: 3302, threadinfo ffff880077e46000, task ffff8800796a2e60)
Stack:
ffff880077e474b0 ffffffffa038c334 ffff88007a39c800 ffff88007a39c9e0
<0> 0000000000001000 0000000000000000 ffff880077e47550 ffffffffa039237b
<0> ffffffff00000003 ffff8800288935c0 0000000000000000 ffffffff814627da
Call Trace:
[<ffffffffa038c334>] btrfs_init_new_buffer+0x78/0xe9 [btrfs]
[<ffffffffa039237b>] btrfs_alloc_free_block+0x1ef/0x1f4 [btrfs]
[<ffffffff814627da>] ? sub_preempt_count+0x9/0x83
[<ffffffffa038708e>] split_leaf+0x243/0x449 [btrfs]
[<ffffffff814600d2>] ? _spin_unlock+0x2a/0x35
[<ffffffffa038826a>] btrfs_search_slot+0x45c/0x518 [btrfs]
[<ffffffffa0388e0b>] btrfs_insert_empty_items+0x6a/0xbc [btrfs]
[<ffffffff8146285d>] ? add_preempt_count+0x9/0x83
[<ffffffffa039effe>] insert_inline_extent+0xc0/0x251 [btrfs]
[<ffffffffa03b4eeb>] ? extent_clear_unlock_delalloc+0x1c7/0x1e4 [btrfs]
[<ffffffffa039f2a5>] cow_file_range_inline+0x116/0x159 [btrfs]
[<ffffffffa039bb6e>] ? start_transaction+0x1b8/0x1ea [btrfs]
[<ffffffffa039f384>] cow_file_range+0x9c/0x354 [btrfs]
[<ffffffffa03b3dae>] ? set_extent_bit+0x390/0x3e8 [btrfs]
[<ffffffffa039fc67>] run_delalloc_range+0xb4/0x364 [btrfs]
[<ffffffffa03b6198>] ? find_lock_delalloc_range+0x186/0x1a6 [btrfs]
[<ffffffffa03b6343>] __extent_writepage+0x18b/0x584 [btrfs]
[<ffffffff811156e5>] ? mem_cgroup_add_lru_list+0x81/0x8a
[<ffffffffa03b6b73>] extent_write_cache_pages.clone.0+0x155/0x2b1 [btrfs]
[<ffffffff8145e6ab>] ? thread_return+0xa8/0xd0
[<ffffffff8104ad22>] ? finish_task_switch+0x85/0xa8
[<ffffffff8103fe77>] ? need_resched+0x23/0x2d
[<ffffffffa03b6dda>] extent_writepages+0x44/0x5a [btrfs]
[<ffffffffa039e608>] ? btrfs_get_extent+0x0/0x753 [btrfs]
[<ffffffff81076de8>] ? bit_waitqueue+0x17/0xa9
[<ffffffffa039e4da>] btrfs_writepages+0x27/0x29 [btrfs]
[<ffffffff810dd8d5>] do_writepages+0x21/0x2a
[<ffffffff8113a5e2>] writeback_single_inode+0xd1/0x1f6
[<ffffffff8113ade1>] writeback_inodes_wb+0x388/0x423
[<ffffffff8113afa4>] wb_writeback+0x128/0x1ac
[<ffffffff810b0ded>] ? call_rcu_sched+0x15/0x17
[<ffffffff810b0dfd>] ? call_rcu+0xe/0x10
[<ffffffff8113b147>] wb_do_writeback+0x6e/0x166
[<ffffffff8113b27e>] bdi_writeback_task+0x3f/0xaf
[<ffffffff810ecf94>] ? bdi_start_fn+0x0/0xd4
[<ffffffff810ed00a>] bdi_start_fn+0x76/0xd4
[<ffffffff810ecf94>] ? bdi_start_fn+0x0/0xd4
[<ffffffff81076b9c>] kthread+0x7f/0x87
[<ffffffff81012dda>] child_rip+0xa/0x20
[<ffffffff81076b1d>] ? kthread+0x0/0x87
[<ffffffff81012dd0>] ? child_rip+0x0/0x20
Code: 00 00 48 81 c7 d0 20 00 00 e8 ad 99 0c e1 5b 41 5c 41 5d 41 5e c9 c3 55 48 89 e5 0f 1f 44 00 00 48 8b 47 30 48 89 fe 48 8b 40 18 <48> 8b 38 48 81 ef 78 01 00 00 e8 0a d7 01 00 c9 c3 55 48 89 e5 
RIP  [<ffffffffa0396718>] btrfs_set_buffer_uptodate+0x14/0x25 [btrfs]
RSP <ffff880077e47480>
CR2: 0000000000000000

Modules linked in: btrfs ipt_MASQUERADE iptable_nat nf_nat bridge stp zlib_deflate llc libcrc32c sunrpc xt_physdev ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 p4_clockmod freq_table speedstep_lib dm_multipath kvm uinput snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device i915 snd_pcm drm_kms_helper snd_timer snd drm soundcore i2c_i801 ppdev e1000e parport_pc i2c_algo_bit parport video iTCO_wdt i2c_core ata_generic iTCO_vendor_support output snd_page_alloc pata_acpi dcdbas serio_raw pcspkr [last unloaded: btrfs]
Pid: 11099, comm: flush-btrfs-1 Tainted: G        W  2.6.32 #2 OptiPlex 755                 
RIP: 0010:[<ffffffffa0350961>]  [<ffffffffa0350961>] clear_extent_buffer_dirty+0x45/0xd9 [btrfs]
RSP: 0018:ffff8800326b1430  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88005e631240
RBP: ffff8800326b1450 R08: 0000000000000000 R09: 0000000000000001
R10: ffff880001c55630 R11: ffff880001c55630 R12: 0000000000000001
R13: 0000000000000002 R14: ffff88005e631240 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880001c40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000038723000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-btrfs-1 (pid: 11099, threadinfo ffff8800326b0000, task ffff880059434590)
Stack:
ffff88003d6ea000 ffff88005e631240 ffff880011ea81a0 0000000000000011
<0> ffff8800326b1480 ffffffffa03353e2 ffff8800326b1458 ffff88005e631240
<0> ffff88003b25ba00 ffff88003d6ea000 ffff8800326b14b0 ffffffffa0329d66
Call Trace:
[<ffffffffa03353e2>] clean_tree_block+0xcd/0xd7 [btrfs]
[<ffffffffa0329d66>] btrfs_init_new_buffer+0x68/0xe9 [btrfs]
[<ffffffffa032ffc4>] btrfs_alloc_free_block+0x19d/0x1a1 [btrfs]
[<ffffffff814626ea>] ? sub_preempt_count+0x9/0x83
[<ffffffffa032509c>] split_leaf+0x243/0x449 [btrfs]
[<ffffffff8145ffe2>] ? _spin_unlock+0x2a/0x35
[<ffffffffa0326288>] btrfs_search_slot+0x46c/0x528 [btrfs]
[<ffffffffa0326e29>] btrfs_insert_empty_items+0x6a/0xbc [btrfs]
[<ffffffff8146276d>] ? add_preempt_count+0x9/0x83
[<ffffffffa033c8df>] insert_inline_extent+0xc0/0x251 [btrfs]
[<ffffffffa0352c0a>] ? extent_clear_unlock_delalloc+0x1d2/0x1ef [btrfs]
[<ffffffffa033cb81>] cow_file_range_inline+0x111/0x145 [btrfs]
[<ffffffff8145eec1>] ? mutex_lock+0x24/0x4b
[<ffffffffa0338ce0>] ? start_transaction+0x122/0x12e [btrfs]
[<ffffffffa033cc51>] cow_file_range+0x9c/0x353 [btrfs]
[<ffffffffa0351a73>] ? set_extent_bit+0x386/0x3de [btrfs]
[<ffffffffa033d512>] run_delalloc_range+0xb4/0x364 [btrfs]
[<ffffffffa0353eb7>] ? find_lock_delalloc_range+0x186/0x1a6 [btrfs]
[<ffffffffa0354062>] __extent_writepage+0x18b/0x584 [btrfs]
[<ffffffff811156e5>] ? mem_cgroup_add_lru_list+0x81/0x8a
[<ffffffffa0354892>] extent_write_cache_pages.clone.0+0x155/0x2b1 [btrfs]
[<ffffffff810106c6>] ? __switch_to+0xd9/0x22b
[<ffffffff814626ea>] ? sub_preempt_count+0x9/0x83
[<ffffffff814600d0>] ? _spin_unlock_irq+0x31/0x3c
[<ffffffff8104aced>] ? finish_task_switch+0x50/0xa8
[<ffffffffa0354af9>] extent_writepages+0x44/0x5b [btrfs]
[<ffffffffa033bee9>] ? btrfs_get_extent+0x0/0x753 [btrfs]
[<ffffffff81076de8>] ? bit_waitqueue+0x17/0xa9
[<ffffffffa033bdbb>] btrfs_writepages+0x27/0x29 [btrfs]
[<ffffffff810dd8d5>] do_writepages+0x21/0x2a
[<ffffffff8113a5e2>] writeback_single_inode+0xd1/0x1f6
[<ffffffff8113ade1>] writeback_inodes_wb+0x388/0x423
[<ffffffff8113afa4>] wb_writeback+0x128/0x1ac
[<ffffffff810b0dfd>] ? call_rcu+0xe/0x10
[<ffffffff8113b147>] wb_do_writeback+0x6e/0x166
[<ffffffff8113b27e>] bdi_writeback_task+0x3f/0xaf
[<ffffffff810ecf94>] ? bdi_start_fn+0x0/0xd4
[<ffffffff810ed00a>] bdi_start_fn+0x76/0xd4
[<ffffffff810ecf94>] ? bdi_start_fn+0x0/0xd4
[<ffffffff81076b9c>] kthread+0x7f/0x87
[<ffffffff81012dda>] child_rip+0xa/0x20
[<ffffffff81076b1d>] ? kthread+0x0/0x87
[<ffffffff81012dd0>] ? child_rip+0x0/0x20
Code: 89 c5 48 c1 e8 0c 4c 03 6e 08 49 81 c5 ff 0f 00 00 49 c1 ed 0c 49 29 c5 e9 8e 00 00 00 4c 89 e6 4c 89 f7 e8 d3 f0 ff ff 48 89 c3 <f6> 00 10 74 78 48 89 c7 e8 1d fc ff ff 4d 85 e4 75 12 49 8b 46 
RIP  [<ffffffffa0350961>] clear_extent_buffer_dirty+0x45/0xd9 [btrfs]
RSP <ffff8800326b1430>
CR2: 0000000000000000
---[ end trace a969005a7d0c3bd0 ]---
