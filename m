Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:39608 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754747AbcLPJSi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 04:18:38 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.84_2)
        (envelope-from <kilobyte@angband.pl>)
        id 1cHoes-0004Du-4V
        for linux-btrfs@vger.kernel.org; Fri, 16 Dec 2016 10:18:30 +0100
Date: Fri, 16 Dec 2016 10:18:30 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: corrupt leaf on just-created filesystem
Message-ID: <20161216091830.GA13211@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got a 100% reproducible splat on 4.9.

So I plopped in a fresh 4TB disk:

dd if=/dev/zero of=meow bs=1 seek=4000785104895 count=1
mkfs -t btrfs meow
mount -onoatime meow /mnt/vol1
cd /mnt/vol1
btrfs subv create foo

[  104.867344] BTRFS: device label diediedie devid 1 transid 5 /dev/sdc1
[  127.438513] BTRFS info (device sdc1): setting 8 feature flag
[  127.444540] BTRFS info (device sdc1): use lzo compression
[  127.450290] BTRFS info (device sdc1): disk space caching is enabled
[  127.456910] BTRFS info (device sdc1): has skinny extents
[  127.462551] BTRFS info (device sdc1): flagging fs with big metadata feature
[  127.472953] BTRFS info (device sdc1): creating UUID tree
[  138.792678] BTRFS critical (device sdc1): corrupt leaf, non-root leaf's nritems is 0: block=29573120, 
root=1, slot=0
[  138.804002] BTRFS info (device sdc1): leaf 29573120 total ptrs 0 free space 16283
[  138.812220] assertion failed: 0, file: fs/btrfs/disk-io.c, line: 4074
[  138.819384] ------------[ cut here ]------------
[  138.824673] kernel BUG at fs/btrfs/ctree.h:3418!
[  138.829965] invalid opcode: 0000 [#1] SMP
[  138.829984] Modules linked in: cp210x pl2303 usbserial nouveau video mxm_wmi ttm
[  138.829989] CPU: 3 PID: 2158 Comm: btrfs Not tainted 4.9.0-debug+ #1
[  138.829991] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[  138.829995] task: ffff88022d8def80 task.stack: ffffc900047a0000
[  138.830008] RIP: 0010:[<ffffffff814dfaa0>]  [<ffffffff814dfaa0>] assfail.constprop.21+0x1c/0x2a
[  138.830011] RSP: 0018:ffffc900047a38d8  EFLAGS: 00010296
[  138.830014] RAX: 0000000000000039 RBX: ffff880227b05730 RCX: ffffffff82090d18
[  138.830017] RDX: 0000000000000039 RSI: 0000000000000246 RDI: ffffffff825f534c
[  138.830020] RBP: ffffc900047a38d8 R08: ffff88021d959800 R09: 00000000ffffffff
[  138.830023] R10: ffff88022ef54000 R11: 0000000000000000 R12: 000000022d9f1000
[  138.830025] R13: ffff88021d960000 R14: ffff88022ee0faa0 R15: 0000000000000000
[  138.830029] FS:  00007fa8de68e8c0(0000) GS:ffff880237cc0000(0000) knlGS:0000000000000000
[  138.830032] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  138.830034] CR2: 00000000013a4098 CR3: 000000021f137000 CR4: 00000000000006e0
[  138.830035] Stack:
[  138.830043]  ffffc900047a3900 ffffffff8143b049 ffff880227b05730 ffff88021d941000
[  138.830048]  ffff8802297a8a68 ffffc900047a3998 ffffffff8140ee9c 0000000000000000
[  138.830053]  0000000000000000 0000000000000000 ffffc900047a3a58 ffff8802297a8a68
[  138.830054] Call Trace:
[  138.830062]  [<ffffffff8143b049>] btrfs_mark_buffer_dirty+0x109/0x150
[  138.830069]  [<ffffffff8140ee9c>] __btrfs_cow_block+0x37c/0x700
[  138.830075]  [<ffffffff8140f3f7>] btrfs_cow_block+0x137/0x1a0
[  138.830081]  [<ffffffff8141462b>] btrfs_search_slot+0x25b/0xfb0
[  138.830087]  [<ffffffff8140d9c3>] ? btrfs_set_path_blocking+0x73/0x170
[  138.830092]  [<ffffffff81417486>] btrfs_insert_empty_items+0x66/0xc0
[  138.830098]  [<ffffffff814caa9a>] btrfs_uuid_tree_add+0x17a/0x340
[  138.830103]  [<ffffffff8147d2fb>] create_subvol+0x5cb/0x910
[  138.830109]  [<ffffffff8147d9d2>] btrfs_mksubvol+0x392/0x600
[  138.830115]  [<ffffffff815e3ce3>] ? get_color+0x33/0x160
[  138.830120]  [<ffffffff8147dd0c>] btrfs_ioctl_snap_create_transid+0xcc/0x1b0
[  138.830125]  [<ffffffff8147de64>] btrfs_ioctl_snap_create+0x74/0xa0
[  138.830130]  [<ffffffff814825fe>] btrfs_ioctl+0xd8e/0x2660
[  138.830136]  [<ffffffff81111696>] ? __wake_up+0x46/0x60
[  138.830141]  [<ffffffff816881f1>] ? tty_ldisc_deref+0x11/0x20
[  138.830148]  [<ffffffff8167e635>] ? tty_write+0x1e5/0x310
[  138.830152]  [<ffffffff816833d0>] ? n_tty_receive_signal_char+0x70/0x70
[  138.830157]  [<ffffffff81248dd3>] ? __vfs_write+0x23/0x130
[  138.830162]  [<ffffffff8125eeea>] do_vfs_ioctl+0x9a/0x5e0
[  138.830167]  [<ffffffff8124a232>] ? vfs_write+0x172/0x1a0
[  138.830172]  [<ffffffff8125f4b6>] SyS_ioctl+0x86/0xa0
[  138.830178]  [<ffffffff81a3ce24>] entry_SYSCALL_64_fastpath+0x17/0x98
[  138.830229] Code: 88 00 00 00 89 d8 5b 41 5c 41 5d 41 5e 5d c3 55 89 f1 48 c7 c2 5f e1 da 81 48 89 fe 48 c7 c7 88 cd d9 81 48 89 e5 e8 8a 24 cd ff <0f> 0b 48 c7 c7 40 27 14 82 e8 12 1e 0c 00 55 48 89 e5 41 54 53 
[  138.830235] RIP  [<ffffffff814dfaa0>] assfail.constprop.21+0x1c/0x2a
[  138.830236]  RSP <ffffc900047a38d8>
[  138.830253] ---[ end trace 957cf23018b1bbce ]---
[  169.116682] BTRFS critical (device sdc1): corrupt leaf, non-root leaf's nritems is 0: block=29605888, root=1, slot=0
[  169.128243] BTRFS info (device sdc1): leaf 29605888 total ptrs 0 free space 16283
[  169.136644] assertion failed: 0, file: fs/btrfs/disk-io.c, line: 4074
[  169.144009] ------------[ cut here ]------------
[  169.149524] kernel BUG at fs/btrfs/ctree.h:3418!
[  169.155016] invalid opcode: 0000 [#2] SMP
[  169.159887] Modules linked in: cp210x pl2303 usbserial nouveau video mxm_wmi ttm
[  169.168434] CPU: 4 PID: 2149 Comm: btrfs-transacti Tainted: G      D         4.9.0-debug+ #1
[  169.177786] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[  169.187681] task: ffff88021a7f0e00 task.stack: ffffc90004768000
[  169.194519] RIP: 0010:[<ffffffff814dfaa0>]  [<ffffffff814dfaa0>] assfail.constprop.21+0x1c/0x2a
[  169.204196] RSP: 0018:ffffc9000476b8c8  EFLAGS: 00010292
[  169.210420] RAX: 0000000000000039 RBX: ffff88022cbd3bd0 RCX: ffffffff82090d18
[  169.218481] RDX: 0000000000000039 RSI: 0000000000000246 RDI: ffffffff825f534c
[  169.226547] RBP: ffffc9000476b8c8 R08: ffff88021d959800 R09: 00000000ffffffff
[  169.234603] R10: ffff88022ef54000 R11: 0000000000000000 R12: 0000000220c62000
[  169.242646] R13: ffff88021d960000 R14: ffff88022ee0f820 R15: 0000000000000000
[  169.250701] FS:  0000000000000000(0000) GS:ffff880237d00000(0000) knlGS:0000000000000000
[  169.259732] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  169.266383] CR2: 00007f236e493b00 CR3: 0000000002007000 CR4: 00000000000006e0
[  169.274447] Stack:
[  169.277330]  ffffc9000476b8f0 ffffffff8143b049 ffff88022cbd3bd0 ffff880220f77800
[  169.285754]  ffff8802297a86f0 ffffc9000476b988 ffffffff8140ee9c 0000000000000000
[  169.294156]  0000000000000000 ffff88022af3b000 ffffc9000476ba48 ffff8802297a86f0
[  169.302582] Call Trace:
[  169.305906]  [<ffffffff8143b049>] btrfs_mark_buffer_dirty+0x109/0x150
[  169.313290]  [<ffffffff8140ee9c>] __btrfs_cow_block+0x37c/0x700
[  169.320147]  [<ffffffff8140f3f7>] btrfs_cow_block+0x137/0x1a0
[  169.326846]  [<ffffffff8141462b>] btrfs_search_slot+0x25b/0xfb0
[  169.333674]  [<ffffffff81223be0>] ? kmem_cache_alloc+0xa0/0x190
[  169.340495]  [<ffffffff814336fb>] btrfs_del_csums+0x1cb/0x3b0
[  169.347100]  [<ffffffff81417937>] ? btrfs_del_items+0x377/0x5e0
[  169.353899]  [<ffffffff8141f9ae>] __btrfs_free_extent+0x6be/0xdc0
[  169.360890]  [<ffffffff81424b12>] __btrfs_run_delayed_refs+0x4a2/0x1180
[  169.368393]  [<ffffffff8145d4b6>] ? btrfs_get_token_32+0xf6/0x110
[  169.375381]  [<ffffffff814295e9>] btrfs_run_delayed_refs+0xb9/0x300
[  169.382522]  [<ffffffff8142d9b8>] btrfs_start_dirty_block_groups+0x2a8/0x420
[  169.390475]  [<ffffffff81429740>] ? btrfs_run_delayed_refs+0x210/0x300
[  169.397880]  [<ffffffff81440586>] btrfs_commit_transaction+0x146/0xa30
[  169.405308]  [<ffffffff8143c63f>] transaction_kthread+0x19f/0x1f0
[  169.412317]  [<ffffffff8143c4a0>] ? btrfs_cleanup_transaction+0x4d0/0x4d0
[  169.419997]  [<ffffffff810e8695>] kthread+0xc5/0xe0
[  169.425758]  [<ffffffff810e85d0>] ? kthread_create_on_node+0x40/0x40
[  169.433007]  [<ffffffff81a3d072>] ret_from_fork+0x22/0x30
[  169.439292] Code: 88 00 00 00 89 d8 5b 41 5c 41 5d 41 5e 5d c3 55 89 f1 48 c7 c2 5f e1 da 81 48 89 fe 48 c7 c7 88 cd d9 81 48 89 e5 e8 8a 24 cd ff <0f> 0b 48 c7 c7 40 27 14 82 e8 12 1e 0c 00 55 48 89 e5 41 54 53 
[  169.461686] RIP  [<ffffffff814dfaa0>] assfail.constprop.21+0x1c/0x2a
[  169.469015]  RSP <ffffc9000476b8c8>
[  169.473439] ---[ end trace 957cf23018b1bbcf ]---
[  169.479025] BUG: unable to handle kernel NULL pointer dereference at 000000000000000b
[  169.487252] IP: [<ffffffff811115d8>] __wake_up_common+0x28/0xa0
[  169.493541] PGD 0 [  169.495380] 
[  169.497218] Oops: 0000 [#3] SMP
[  169.500700] Modules linked in: cp210x pl2303 usbserial nouveau video mxm_wmi ttm
[  169.508570] CPU: 4 PID: 2149 Comm: btrfs-transacti Tainted: G      D         4.9.0-debug+ #1
[  169.517349] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[  169.526636] task: ffff88021a7f0e00 task.stack: ffffc90004768000
[  169.532899] RIP: 0010:[<ffffffff811115d8>]  [<ffffffff811115d8>] __wake_up_common+0x28/0xa0
[  169.541605] RSP: 0018:ffffc9000476be48  EFLAGS: 00010092
[  169.547236] RAX: 0000000000000286 RBX: 0000000000000001 RCX: 0000000000000000
[  169.554695] RDX: 000000000000000b RSI: 0000000000000003 RDI: ffffc9000476bf18
[  169.562152] RBP: ffffc9000476be80 R08: 0000000000000000 R09: 0000000000000000
[  169.569611] R10: 0000000000000000 R11: 0000000000000028 R12: ffffc9000476bf10
[  169.577080] R13: ffffc9000476bf20 R14: 0000000000000001 R15: 0000000000000003
[  169.584532] FS:  0000000000000000(0000) GS:ffff880237d00000(0000) knlGS:0000000000000000
[  169.592949] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  169.599011] CR2: 000000000000000b CR3: 0000000002007000 CR4: 00000000000006e0
[  169.606465] Stack:
[  169.608803]  0000000000000000 0000000000000282 ffffc9000476bf18 ffffc9000476bf10
[  169.616615]  0000000000000286 0000000000000001 0000000000000000 ffffc9000476be90
[  169.624413]  ffffffff811116be ffffc9000476beb8 ffffffff8111207c 0000000000000000
[  169.632221] Call Trace:
[  169.634992]  [<ffffffff811116be>] __wake_up_locked+0xe/0x10
[  169.640890]  [<ffffffff8111207c>] complete+0x3c/0x60
[  169.646173]  [<ffffffff810c2c6d>] mm_release+0xad/0x130
[  169.651711]  [<ffffffff810ca0fa>] do_exit+0x13a/0xab0
[  169.657076]  [<ffffffff81a3e727>] rewind_stack_do_exit+0x17/0x20
[  169.663391] Code: 00 00 00 55 48 89 e5 41 57 41 89 f7 41 56 41 55 4c 8d 6f 08 41 54 53 89 d3 48 83 ec 10 48 8b 57 08 89 4d d4 4c 89 45 c8 49 39 d5 <48> 8b 32 74 4a 48 8d 42 e8 4c 8d 76 e8 44 8b 20 48 8b 4d c8 44 
[  169.684082] RIP  [<ffffffff811115d8>] __wake_up_common+0x28/0xa0
[  169.690445]  RSP <ffffc9000476be48>
[  169.694256] CR2: 000000000000000b
[  169.697902] ---[ end trace 957cf23018b1bbd0 ]---
[  169.702832] Fixing recursive fault but reboot is needed!


4.9 final, with patches that can't possibly affect anything (one for
balance, one for extent_same, one for defrag).

Works fine on 4.8.15.

-progs 4.7.3, current Debian package.

-- 
u-boot problems can be solved with the help of your old SCSI manuals, the
parts that deal with goat termination.  You need a black-handled knife, and
an appropriate set of candles (number and color matters).  Or was it a
silver-handled knife?  Crap, need to look that up.
