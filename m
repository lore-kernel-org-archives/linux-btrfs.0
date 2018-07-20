Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43662 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731746AbeGTQx5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 12:53:57 -0400
Date: Fri, 20 Jul 2018 18:04:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 01/22] btrfs: add btrfs_delete_ref_head helper
Message-ID: <20180720160450.GE26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180719145006.17532-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fstests run in the sequence from btrfs/001, in qemu, 2G memory, warning
and crash at btrfs/124

btrfs/124		[22:58:39]
[10100.765898] run fstests btrfs/124 at 2018-07-19 22:58:39
...
[10110.113787] BTRFS: device fsid 8b6b700e-3346-4260-bb2e-c561ba4b9960 devid 1 transid 7 /dev/vdb
[10110.118673] BTRFS info (device vdb): allowing degraded mounts
[10110.120386] BTRFS info (device vdb): disk space caching is enabled
[10110.122070] BTRFS info (device vdb): has skinny extents
[10110.138082] BTRFS warning (device vdb): devid 2 uuid 1e933775-ded8-40fa-9b6a-6127afd4cc01 is missing
[10110.141411] BTRFS warning (device vdb): devid 2 uuid 1e933775-ded8-40fa-9b6a-6127afd4cc01 is missing
[10110.719342] WARNING: CPU: 3 PID: 28973 at fs/btrfs/extent-tree.c:6122 btrfs_trans_release_chunk_metadata+0x3f/0x50 [btrfs]
[10110.723171] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq dm_mod dax loop [last unloaded: libcrc32c]
[10110.727313] CPU: 3 PID: 28973 Comm: dd Not tainted 4.18.0-rc5-default+ #198
[10110.728504] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[10110.730236] RIP: 0010:btrfs_trans_release_chunk_metadata+0x3f/0x50 [btrfs]
[10110.734444] RSP: 0018:ffffb3edc08bfba0 EFLAGS: 00010202
[10110.735361] RAX: ffff9b68e5232dd8 RBX: ffff9b69315f98f0 RCX: 00000000000c0000
[10110.736539] RDX: ffff9b69315f9948 RSI: ffff9b68e52369d8 RDI: ffff9b69315f98f0
[10110.737721] RBP: ffff9b68e5236000 R08: 0000000000000001 R09: 0000000000000000
[10110.738849] R10: ffff9b691e93e4e0 R11: 0000000000000000 R12: ffff9b69359b0000
[10110.739966] R13: 0000000000000000 R14: 0000000000000201 R15: ffff9b6917e08528
[10110.741460] FS:  00007f15f5b14540(0000) GS:ffff9b693cc00000(0000) knlGS:0000000000000000
[10110.742795] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10110.743679] CR2: 00007f15f5571690 CR3: 000000002d8a0000 CR4: 00000000000006e0
[10110.744692] Call Trace:
[10110.745096]  __btrfs_end_transaction+0x55/0x230 [btrfs]
[10110.745762]  btrfs_create+0xf2/0x1f0 [btrfs]
[10110.746564]  lookup_open+0x562/0x700
[10110.747216]  ? __wake_up_common_lock+0x63/0xc0
[10110.748021]  ? find_held_lock+0x34/0xa0
[10110.748737]  path_openat+0x653/0xf90
[10110.749411]  do_filp_open+0x93/0x100
[10110.750076]  ? _raw_spin_unlock+0x24/0x40
[10110.750793]  ? __alloc_fd+0xee/0x1d0
[10110.751438]  do_sys_open+0x186/0x210
[10110.752152]  do_syscall_64+0x5a/0x170
[10110.752774]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[10110.753582] RIP: 0033:0x7f15f562090e
[10110.757116] RSP: 002b:00007ffea876ae20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
[10110.758424] RAX: ffffffffffffffda RBX: 000055d6f74323e0 RCX: 00007f15f562090e
[10110.759523] RDX: 0000000000000241 RSI: 00007ffea876c286 RDI: 00000000ffffff9c
[10110.760501] RBP: 0000000000000001 R08: 00007ffea876c2a7 R09: 0000000000000000
[10110.761323] R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000241
[10110.762400] R13: 00007ffea876c286 R14: 0000000000000001 R15: 00007ffea876b118
[10110.763533] irq event stamp: 2212
[10110.764139] hardirqs last  enabled at (2211): [<ffffffff9221b007>] slab_free_freelist_hook+0x97/0xe0
[10110.765566] hardirqs last disabled at (2212): [<ffffffff92800f9c>] error_entry+0x6c/0xc0
[10110.766932] softirqs last  enabled at (2006): [<ffffffff921c485e>] __set_page_dirty_nobuffers+0xfe/0x140
[10110.768464] softirqs last disabled at (2002): [<ffffffff921ddebe>] wb_wakeup_delayed+0x2e/0x70
[10110.769891] ---[ end trace 6fb571b51e7cab5c ]---
[10131.610680] assertion failed: list_empty(&block_group->bg_list), file: fs/btrfs/extent-tree.c, line: 10070
[10131.614113] ------------[ cut here ]------------
[10131.615675] kernel BUG at fs/btrfs/ctree.h:3472!
[10131.617376] invalid opcode: 0000 [#1] PREEMPT SMP
[10131.618968] CPU: 1 PID: 28975 Comm: umount Tainted: G        W         4.18.0-rc5-default+ #198
[10131.621170] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[10131.622672] RIP: 0010:assfail.constprop.84+0x18/0x1a [btrfs]
[10131.626514] RSP: 0018:ffffb3edc6bfbde0 EFLAGS: 00010246
[10131.627380] RAX: 000000000000005e RBX: ffff9b68e5232c00 RCX: 0000000000000006
[10131.628521] RDX: 0000000000000000 RSI: ffff9b68f9bcd9c8 RDI: 0000000000000246
[10131.629596] RBP: ffff9b69359b0000 R08: 00001016d930fc78 R09: 0000000000000000
[10131.630678] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9b69359b0118
[10131.631754] R13: ffff9b69359b0168 R14: ffff9b68e5232d98 R15: dead000000000100
[10131.632823] FS:  00007fbc00b0dfc0(0000) GS:ffff9b693c800000(0000) knlGS:0000000000000000
[10131.634119] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10131.635030] CR2: 00007fbc006e167e CR3: 0000000053e5c000 CR4: 00000000000006e0
[10131.636136] Call Trace:
[10131.636641]  btrfs_free_block_groups.cold.112+0x22/0x55 [btrfs]
[10131.637583]  close_ctree+0x159/0x330 [btrfs]
[10131.638292]  generic_shutdown_super+0x64/0x100
[10131.639031]  kill_anon_super+0xe/0x20
[10131.639663]  btrfs_kill_super+0x12/0xa0 [btrfs]
[10131.640408]  deactivate_locked_super+0x29/0x60
[10131.641159]  cleanup_mnt+0x3b/0x70
[10131.641764]  task_work_run+0x9b/0xd0
[10131.642406]  exit_to_usermode_loop+0xbd/0xc0
[10131.643124]  do_syscall_64+0x16c/0x170
[10131.643775]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[10131.644590] RIP: 0033:0x7fbc003d4d07
[10131.648070] RSP: 002b:00007fff6a865598 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[10131.649331] RAX: 0000000000000000 RBX: 0000557a82414970 RCX: 00007fbc003d4d07
[10131.650417] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000557a82414b50
[10131.651486] RBP: 0000000000000000 R08: 0000557a82414b70 R09: 00007fff6a863e00
[10131.652439] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbc008f11c4
[10131.653253] R13: 0000557a82414b50 R14: 0000000000000000 R15: 00007fff6a865808
[10131.654063] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq dm_mod dax loop [last unloaded: libcrc32c]
[10131.655964] ---[ end trace 6fb571b51e7cab5d ]---
[10131.656787] RIP: 0010:assfail.constprop.84+0x18/0x1a [btrfs]
[10131.660454] RSP: 0018:ffffb3edc6bfbde0 EFLAGS: 00010246
[10131.661302] RAX: 000000000000005e RBX: ffff9b68e5232c00 RCX: 0000000000000006
[10131.662353] RDX: 0000000000000000 RSI: ffff9b68f9bcd9c8 RDI: 0000000000000246
[10131.663413] RBP: ffff9b69359b0000 R08: 00001016d930fc78 R09: 0000000000000000
[10131.664508] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9b69359b0118
[10131.665627] R13: ffff9b69359b0168 R14: ffff9b68e5232d98 R15: dead000000000100
[10131.666723] FS:  00007fbc00b0dfc0(0000) GS:ffff9b693c800000(0000) knlGS:0000000000000000
[10131.668029] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10131.668943] CR2: 00007fbc006e167e CR3: 0000000053e5c000 CR4: 00000000000006e0
[10132.375092] BTRFS: device fsid fec9b6db-bc92-4981-85fa-f965b2e44059 devid 1 transid 234 /dev/vda
