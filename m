From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: 2.6.39-rc1: kernel BUG at fs/btrfs/extent-tree.c:5479!
Date: Sat, 02 Apr 2011 17:37:58 +0800
Message-ID: <4D96EE76.5040208@cn.fujitsu.com>
References: <20110402121946.6bf27f80@sf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110402121946.6bf27f80@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/02/2011 05:19 PM, Sergei Trofimovich wrote:
> The partition is a physical ~5GB --mixed lzo compressed partition.
> 
> The kernel 2.6.39-rc1 + reverted commit c59021f846881a957ac5afe456d0f59d6a517b61.
> (see http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09083.html)
> 

Hi, Sergei,

I'm digging this...

Can u show me steps to reproduce this?

thanks,
liubo

> This time I've really filled whole partition and kernel OOpsed.
> Note, the blow came right after INFO about hung write task (see full dmesg),
> so it could be bad guy.
> 
> Apr  1 11:59:54 st kernel: [168399.199337] ------------[ cut here ]------------
> Apr  1 11:59:54 st kernel: [168399.199368] kernel BUG at fs/btrfs/extent-tree.c:5479!
> Apr  1 11:59:54 st kernel: [168399.199380] invalid opcode: 0000 [#1] PREEMPT SMP 
> Apr  1 11:59:54 st kernel: [168399.199397] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
> Apr  1 11:59:54 st kernel: [168399.199409] CPU 0 
> Apr  1 11:59:54 st kernel: [168399.199416] Modules linked in: btrfs bridge stp llc zlib_deflate lzo_decompress lzo_compress crc3c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_kms_helper drm i2c_algo_bit forcedeth i2c_core 8139cp 8139too cfbcopyarea cfbimblt cfbfillrect [last unloaded: btrfs]
> Apr  1 11:59:54 st kernel: [168399.199508] 
> Apr  1 11:59:54 st kernel: [168399.199516] Pid: 18178, comm: btrfs-endio-wri Not tainted 2.6.39-rc1+ #2 To Be Filled By O.E.M. T Be Filled By O.E.M./ALiveNF6G-VSTA
> Apr  1 11:59:54 st kernel: [168399.199540] RIP: 0010:[<ffffffffa04c1123>]  [<ffffffffa04c1123>] alloc_reserved_file_extent.clone66+0x213/0x220 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.199589] RSP: 0018:ffff88000de7ba80  EFLAGS: 00010286
> Apr  1 11:59:54 st kernel: [168399.199600] RAX: 00000000ffffffe4 RBX: ffff880077f17bd0 RCX: 0000000000000000
> Apr  1 11:59:54 st kernel: [168399.199612] RDX: 0000000000000000 RSI: ffff880077f17bd0 RDI: 0000000000000000
> Apr  1 11:59:54 st kernel: [168399.199623] RBP: ffff88000de7bb00 R08: 0000000000000000 R09: 0000000000000000
> Apr  1 11:59:54 st kernel: [168399.199635] R10: ffffffffffffffe4 R11: 0000000000000002 R12: 00000000000000b2
> Apr  1 11:59:54 st kernel: [168399.199647] R13: 0000000000000000 R14: ffff88000de7bbb0 R15: ffff88001e16ee00
> Apr  1 11:59:54 st kernel: [168399.199659] FS:  00007fcc3e5f2700(0000) GS:ffff88007bc00000(0000) knlGS:00000000f68deb20
> Apr  1 11:59:54 st kernel: [168399.199673] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Apr  1 11:59:54 st kernel: [168399.199683] CR2: 00007f87634fab00 CR3: 0000000033310000 CR4: 00000000000006f0
> Apr  1 11:59:54 st kernel: [168399.199694] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Apr  1 11:59:54 st kernel: [168399.199705] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Apr  1 11:59:54 st kernel: [168399.199718] Process btrfs-endio-wri (pid: 18178, threadinfo ffff88000de7a000, task ffff88007083d80)
> Apr  1 11:59:54 st kernel: [168399.199731] Stack:
> Apr  1 11:59:54 st kernel: [168399.199736]  ffff880000000035 00000000002c9a4e 0000000000000005 0000000000000000
> Apr  1 11:59:54 st kernel: [168399.199755]  ffff880036370928 ffffffffa04f984e ffff88000de7bad0 ffff8800166dc000
> Apr  1 11:59:54 st kernel: [168399.199773]  ffff88000de7bb10 0000003500000001 ffff88000de7baf0 ffff88000616aa20
> Apr  1 11:59:54 st kernel: [168399.199790] Call Trace:
> Apr  1 11:59:54 st kernel: [168399.199814]  [<ffffffffa04f984e>] ? unmap_extent_buffer+0xe/0x40 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.199831]  [<ffffffffa04c414c>] run_clustered_refs+0x2ec/0x860 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.199850]  [<ffffffffa04f9755>] ? map_private_extent_buffer+0xd5/0x1c0 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.199871]  [<ffffffffa0514b01>] ? btrfs_find_ref_cluster+0xe1/0x180 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.199889]  [<ffffffffa04c4780>] btrfs_run_delayed_refs+0xc0/0x210 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.199909]  [<ffffffffa04d5ca8>] __btrfs_end_transaction+0x68/0x220 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.199928]  [<ffffffffa04d5ea0>] btrfs_end_transaction+0x10/0x20 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.199946]  [<ffffffffa04dba0c>] btrfs_finish_ordered_io+0x28c/0x330 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.199965]  [<ffffffff810a2e32>] ? test_clear_page_writeback+0xf2/0x130
> Apr  1 11:59:54 st kernel: [168399.199984]  [<ffffffffa04dbac5>] btrfs_writepage_end_io_hook+0x15/0x20 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.200004]  [<ffffffffa04f4adb>] end_bio_extent_writepage+0x13b/0x180 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff8110f528>] bio_endio+0x18/0x30
> Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffffa04cf1ac>] end_workqueue_fn+0xec/0x120 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffffa0501dfc>] worker_loop+0xac/0x510 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffffa0501d50>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff8105c0e6>] kthread+0x96/0xa0
> Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff815758d4>] kernel_thread_helper+0x4/0x10
> Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff8105c050>] ? kthread_worker_fn+0x190/0x190
> Apr  1 11:59:54 st kernel: [168399.200010]  [<ffffffff815758d0>] ? gs_change+0xb/0xb
> Apr  1 11:59:54 st kernel: [168399.200010] Code: 48 83 c4 58 b8 f4 ff ff ff 5b 41 5c 41 5d 41 5e 41 5f c9 c3 49 8b 56 09 49 8b 3 48 c7 c7 50 19 52 a0 31 c0 e8 de fb 0a e1 0f 0b <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 
> Apr  1 11:59:54 st kernel: [168399.200010] RIP  [<ffffffffa04c1123>] alloc_reserved_file_extent.clone.66+0x213/0x220 [btrfs]
> Apr  1 11:59:54 st kernel: [168399.200010]  RSP <ffff88000de7ba80>
> Apr  1 11:59:54 st kernel: [168399.203852] ---[ end trace c4a85bad852f7be8 ]---
> 

