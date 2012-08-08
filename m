Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:47059 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002Ab2HHRgv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 13:36:51 -0400
Date: Wed, 8 Aug 2012 19:36:45 +0200
From: David Sterba <dave@jikos.cz>
To: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BUG on 3.5.0
Message-ID: <20120808173645.GA17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120808161819.GO25996@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20120808161819.GO25996@vicerveza.homeunix.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Aug 08, 2012 at 06:18:19PM +0200, Lluís Batlle i Rossell wrote:
> I attach dmesg.txt, and the disasm of insert_inline_extent_backref. That disasm
> was a bit tricky; my objdump does not seem to understand the btrfs.ko.

thanks, added a few bits to the picture

> [ 6095.255745] ------------[ cut here ]------------
> [ 6095.255757] kernel BUG at fs/btrfs/extent-tree.c:1769!
> [ 6095.255762] invalid opcode: 0000 [#1] SMP 
> [ 6095.255769] CPU 1 
> [ 6095.255772] Modules linked in:<4>[ 6095.255897]  jbd ext2 mbcache
> [ 6095.255904] 
> [ 6095.255910] Pid: 30286, comm: btrfs Tainted: P           O 3.5.0 #1 System manufacturer System Product Name/M4A79 Deluxe
> [ 6095.255920] RIP: 0010:[<ffffffffa0191c9f>]  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
> [ 6095.255965] RSP: 0018:ffff880028723788  EFLAGS: 00010293
> [ 6095.255970] RAX: 0000000000000000 RBX: ffff8801275b3510 RCX: ffff8800287237d0
> [ 6095.255974] RDX: ffff8801275b3510 RSI: 0000000000000001 RDI: 0000000000000000
> [ 6095.255978] RBP: ffff880028723808 R08: 0000000000000bf2 R09: ffff880028723698
> [ 6095.255981] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880126918800
> [ 6095.255985] R13: ffff88012afdd280 R14: 0000000000000000 R15: 0000000000000001

1753 static noinline_for_stack
1754 int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
1755                                  struct btrfs_root *root,
1756                                  struct btrfs_path *path,
1757                                  u64 bytenr, u64 num_bytes, u64 parent,
1758                                  u64 root_objectid, u64 owner,
1759                                  u64 offset, int refs_to_add,
1760                                  struct btrfs_delayed_extent_op *extent_op)
1761 {
1762         struct btrfs_extent_inline_ref *iref;
1763         int ret;
1764
1765         ret = lookup_inline_extent_backref(trans, root, path, &iref,
1766                                            bytenr, num_bytes, parent,
1767                                            root_objectid, owner, offset, 1);
1768         if (ret == 0) {
1769                 BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);

>    15c17:    49 81 ff ff 00 00 00     cmp     $0xff,%r15
>    15c1e:    76 7f                    jbe     0x15c9f

according to assembly, owner is in R15, BTRFS_FIRST_FREE_OBJECTID is
256, so owner == 1

> [ 6095.255990] FS:  00007fbdb0dbc740(0000) GS:ffff88012fc40000(0000) knlGS:0000000000000000
> [ 6095.255994] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 6095.255998] CR2: 00000000006b3c60 CR3: 000000005e5df000 CR4: 00000000000007e0
> [ 6095.256002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 6095.256006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 6095.256011] Process btrfs (pid: 30286, threadinfo ffff880028722000, task ffff880080194440)
> [ 6095.256013] Stack:
> [ 6095.256016]  0000000000000000 0000000000000005 0000000000000001 0000000000000000
> [ 6095.256025]  0000000000000001 ffff880122fb37e0 ffff880028723858 0000000000000090
> [ 6095.256032]  ffff880126918400 0000000000000be9 ffff880126918400 ffff8801275b3510
> [ 6095.256040] Call Trace:
> [ 6095.256079]  [<ffffffffa0191d4f>] __btrfs_inc_extent_ref+0x9f/0x1f0 [btrfs]
> [ 6095.256117]  [<ffffffffa0194cdd>] ? btrfs_reduce_alloc_profile+0x5d/0x120 [btrfs]
> [ 6095.256154]  [<ffffffffa019874f>] run_clustered_refs+0x93f/0xa00 [btrfs]
> [ 6095.256190]  [<ffffffffa01989b2>] btrfs_run_delayed_refs+0x1a2/0x460 [btrfs]
> [ 6095.256234]  [<ffffffffa01f0875>] ? drop_backref_node+0xa5/0xb0 [btrfs]
> [ 6095.256243]  [<ffffffff8114a5cf>] ? kmem_cache_free+0x2f/0x110
> [ 6095.256286]  [<ffffffffa01f559d>] ? relocate_tree_blocks+0x5ad/0x650 [btrfs]
> [ 6095.256327]  [<ffffffffa01aa561>] __btrfs_end_transaction+0xd1/0x360 [btrfs]
> [ 6095.256368]  [<ffffffffa01aa848>] btrfs_end_transaction_throttle+0x18/0x20 [btrfs]
> [ 6095.256410]  [<ffffffffa01f66ec>] relocate_block_group+0x51c/0x650 [btrfs]
> [ 6095.256452]  [<ffffffffa01f69df>] btrfs_relocate_block_group+0x1bf/0x2f0 [btrfs]
> [ 6095.256495]  [<ffffffffa01d31b5>] btrfs_relocate_chunk.isra.53+0x75/0x730 [btrfs]
> [ 6095.256505]  [<ffffffff8107a673>] ? __wake_up+0x53/0x70
> [ 6095.256548]  [<ffffffffa01cfb17>] ? free_extent_buffer+0x37/0x90 [btrfs]
> [ 6095.256590]  [<ffffffffa01d7527>] btrfs_balance+0x857/0xd10 [btrfs]
> [ 6095.256633]  [<ffffffffa01de8e4>] btrfs_ioctl_balance+0x134/0x440 [btrfs]
> [ 6095.256676]  [<ffffffffa01e0d9f>] btrfs_ioctl+0xb8f/0x1380 [btrfs]
> [ 6095.256686]  [<ffffffff810419d8>] ? do_page_fault+0x1c8/0x460
> [ 6095.256694]  [<ffffffff811694e8>] do_vfs_ioctl+0x98/0x550
> [ 6095.256701]  [<ffffffff8114a5cf>] ? kmem_cache_free+0x2f/0x110
> [ 6095.256708]  [<ffffffff81169a31>] sys_ioctl+0x91/0xa0
> [ 6095.256717]  [<ffffffff813e0d69>] system_call_fastpath+0x16/0x1b
> [ 6095.256720] Code: 48 89 da 4c 89 e6 4c 89 ef 4c 89 3c 24 48 89 44 24 18 8b 45 28 89 44 24 10 48 8b 45 20 48 89 44 24 08 e8 b5 eb ff ff 31 c0 eb a1 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 
> [ 6095.256792] RIP  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
> [ 6095.256824]  RSP <ffff880028723788>
> [ 6095.256859] ---[ end trace 4f7bea0b41eaec44 ]---
> [ 6095.256873] ------------[ cut here ]------------
> [ 6095.256894] kernel BUG at fs/btrfs/extent-tree.c:1769!
> [ 6095.256901] invalid opcode: 0000 [#2] SMP 
> [ 6095.256907] CPU 3 
> [ 6095.256911] Modules linked in:<4>[ 6095.257038]  jbd ext2 mbcache
> [ 6095.257046] 
> [ 6095.257053] Pid: 30307, comm: btrfs-endio-wri Tainted: P      D    O 3.5.0 #1 System manufacturer System Product Name/M4A79 Deluxe
> [ 6095.257093] RIP: 0010:[<ffffffffa0191c9f>]  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
> [ 6095.257155] RSP: 0018:ffff88002599da40  EFLAGS: 00010293
> [ 6095.257160] RAX: 0000000000000000 RBX: ffff8801275db630 RCX: ffff88002599da88
> [ 6095.257164] RDX: ffff8801275db630 RSI: 0000000000000001 RDI: 0000000000000000
> [ 6095.257169] RBP: ffff88002599dac0 R08: 0000000000000eef R09: ffff88002599d950
> [ 6095.257173] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880126918800
> [ 6095.257177] R13: ffff880127618b40 R14: 0000000000000000 R15: 0000000000000000

different stacktrace, owner is 0

> [ 6095.257183] FS:  00007f9350d7c700(0000) GS:ffff88012fcc0000(0000) knlGS:0000000000000000
> [ 6095.257188] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 6095.257192] CR2: 0000000000f38008 CR3: 000000011f67b000 CR4: 00000000000007e0
> [ 6095.257197] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 6095.257201] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 6095.257207] Process btrfs-endio-wri (pid: 30307, threadinfo ffff88002599c000, task ffff88009ee12d80)
> [ 6095.257210] Stack:
> [ 6095.257214]  0000000000000000 0000000000000005 0000000000000000 0000000000000000
> [ 6095.257231]  ffff880000000001 ffff88012b002200 ffff88002599db10 0000000000000090
> [ 6095.257248]  ffff880126ccb400 0000000000000ee6 ffff880126ccb400 ffff8801275db630
> [ 6095.257265] Call Trace:
> [ 6095.257275]  [<ffffffffa0191d4f>] __btrfs_inc_extent_ref+0x9f/0x1f0 [btrfs]
> [ 6095.257314]  [<ffffffffa0194cdd>] ? btrfs_reduce_alloc_profile+0x5d/0x120 [btrfs]
> [ 6095.257351]  [<ffffffffa019874f>] run_clustered_refs+0x93f/0xa00 [btrfs]
> [ 6095.257419]  [<ffffffffa01989b2>] btrfs_run_delayed_refs+0x1a2/0x460 [btrfs]
> [ 6095.257466]  [<ffffffffa01cadd8>] ? free_extent_state+0x58/0xd0 [btrfs]
> [ 6095.257502]  [<ffffffffa01925e8>] ? block_rsv_release_bytes+0x78/0x190 [btrfs]
> [ 6095.257542]  [<ffffffffa01aa537>] __btrfs_end_transaction+0xa7/0x360 [btrfs]
> [ 6095.257583]  [<ffffffffa01aa865>] btrfs_end_transaction+0x15/0x20 [btrfs]
> [ 6095.257626]  [<ffffffffa01b0645>] btrfs_finish_ordered_io+0x195/0x3c0 [btrfs]
> [ 6095.257668]  [<ffffffffa01b0885>] finish_ordered_fn+0x15/0x20 [btrfs]
> [ 6095.257722]  [<ffffffffa01db49f>] worker_loop+0x14f/0x570 [btrfs]
> [ 6095.257764]  [<ffffffffa01db350>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
> [ 6095.257772]  [<ffffffff810701c3>] kthread+0x93/0xa0
> [ 6095.257780]  [<ffffffff813e2064>] kernel_thread_helper+0x4/0x10
> [ 6095.257787]  [<ffffffff81070130>] ? kthread_freezable_should_stop+0x70/0x70
> [ 6095.257791]  [<ffffffff813e2060>] ? gs_change+0x13/0x13
> [ 6095.257793] Code: 48 89 da 4c 89 e6 4c 89 ef 4c 89 3c 24 48 89 44 24 18 8b 45 28 89 44 24 10 48 8b 45 20 48 89 44 24 08 e8 b5 eb ff ff 31 c0 eb a1 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 
> [ 6095.257891] RIP  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
> [ 6095.257930]  RSP <ffff88002599da40>
> [ 6095.257950] ---[ end trace 4f7bea0b41eaec45 ]---
> [ 6127.304475] ------------[ cut here ]------------
> [ 6127.304485] kernel BUG at fs/btrfs/extent-tree.c:1769!
> [ 6127.304490] invalid opcode: 0000 [#3] SMP 
> [ 6127.304496] CPU 0 
> [ 6127.304499] Modules linked in:<4>[ 6127.304623]  jbd ext2 mbcache
> [ 6127.304630] 
> [ 6127.304635] Pid: 1126, comm: btrfs-transacti Tainted: P      D    O 3.5.0 #1 System manufacturer System Product Name/M4A79 Deluxe
> [ 6127.304644] RIP: 0010:[<ffffffffa0191c9f>]  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
> [ 6127.304685] RSP: 0018:ffff880126bfbac0  EFLAGS: 00010293
> [ 6127.304689] RAX: 0000000000000000 RBX: ffff880127486630 RCX: ffff880126bfbb08
> [ 6127.304694] RDX: ffff880127486630 RSI: 0000000000000001 RDI: 0000000000000000
> [ 6127.304698] RBP: ffff880126bfbb40 R08: 0000000000000e56 R09: ffff880126bfb9d0
> [ 6127.304701] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880126918800
> [ 6127.304705] R13: ffff88012afdd370 R14: 0000000000000000 R15: 0000000000000001

yet another different callchain, and owner == 1 again

> [ 6127.304710] FS:  00007f9350d7c700(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
> [ 6127.304714] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 6127.304718] CR2: 00007fcd544f7b40 CR3: 000000011f67b000 CR4: 00000000000007f0
> [ 6127.304722] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 6127.304726] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 6127.304731] Process btrfs-transacti (pid: 1126, threadinfo ffff880126bfa000, task ffff8801268d2d80)
> [ 6127.304733] Stack:
> [ 6127.304736]  0000000000000000 0000000000000005 0000000000000001 0000000000000000
> [ 6127.304745]  ffff880100000001 ffff88012b002200 ffff880126bfbb90 0000000000000090
> [ 6127.304753]  ffff880126918400 0000000000000e4d ffff880126918400 ffff880127486630
> [ 6127.304760] Call Trace:
> [ 6127.304800]  [<ffffffffa0191d4f>] __btrfs_inc_extent_ref+0x9f/0x1f0 [btrfs]
> [ 6127.304837]  [<ffffffffa0194cdd>] ? btrfs_reduce_alloc_profile+0x5d/0x120 [btrfs]
> [ 6127.304874]  [<ffffffffa019874f>] run_clustered_refs+0x93f/0xa00 [btrfs]
> [ 6127.304910]  [<ffffffffa01989b2>] btrfs_run_delayed_refs+0x1a2/0x460 [btrfs]
> [ 6127.304920]  [<ffffffff813ddb8d>] ? mutex_lock+0x1d/0x50
> [ 6127.304966]  [<ffffffffa01c98a7>] ? btrfs_run_ordered_operations+0x1c7/0x1e0 [btrfs]
> [ 6127.305007]  [<ffffffffa01a9a6b>] btrfs_commit_transaction+0xab/0xaa0 [btrfs]
> [ 6127.305016]  [<ffffffff81070c40>] ? add_wait_queue+0x60/0x60
> [ 6127.305055]  [<ffffffffa01a3b3d>] transaction_kthread+0x23d/0x2b0 [btrfs]
> [ 6127.305095]  [<ffffffffa01a3900>] ? btrfs_destroy_marked_extents.isra.99.constprop.113+0x1a0/0x1a0 [btrfs]
> [ 6127.305103]  [<ffffffff810701c3>] kthread+0x93/0xa0
> [ 6127.305111]  [<ffffffff813e2064>] kernel_thread_helper+0x4/0x10
> [ 6127.305119]  [<ffffffff81070130>] ? kthread_freezable_should_stop+0x70/0x70
> [ 6127.305126]  [<ffffffff813e2060>] ? gs_change+0x13/0x13
> [ 6127.305128] Code: 48 89 da 4c 89 e6 4c 89 ef 4c 89 3c 24 48 89 44 24 18 8b 45 28 89 44 24 10 48 8b 45 20 48 89 44 24 08 e8 b5 eb ff ff 31 c0 eb a1 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 
> [ 6127.305200] RIP  [<ffffffffa0191c9f>] insert_inline_extent_backref+0xef/0x100 [btrfs]
> [ 6127.305231]  RSP <ffff880126bfbac0>
> [ 6127.305287] ---[ end trace 4f7bea0b41eaec46 ]---
