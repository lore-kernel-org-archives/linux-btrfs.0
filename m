Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50651 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3BDHBh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 02:01:37 -0500
Received: by mail-qc0-f169.google.com with SMTP id t2so2567472qcq.0
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Feb 2013 23:01:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMQ-g0dj3X_hjnwDEqivwyrW2ZanCeEeA2r3x8kYFJ1YFaFaqA@mail.gmail.com>
References: <CAGvr90BH3DWzqXt-5cJz9e0myU-rU-+Om=RmAG8eY_=N9hKUZw@mail.gmail.com>
	<CAGvr90DA3KQrBTRG2pmAnihjhJ2wJ4srfP=BYqcJuCqRLob8Ug@mail.gmail.com>
	<CAMQ-g0dj3X_hjnwDEqivwyrW2ZanCeEeA2r3x8kYFJ1YFaFaqA@mail.gmail.com>
Date: Mon, 4 Feb 2013 02:01:36 -0500
Message-ID: <CALJXSJrt1P3NPV2kiQXMMb4X7WUVObu+1tX2Hap8J41UL1kKdA@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:6185!
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Radek Machulka <radek.machulka@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Jan Steffens <jan.steffens@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I was however able to save my data with btrfs-restore command (it boots into
> some systemd emergency shell or I can use recovery cd). I tried to mount it
> manually and after no success (the mount command does not end) mount it with
> -o recovery option, but it does not do anything nether (well the command is
> 'running' for hours without any output until I turn the pc off, so I do not know
> wheather it is recovering something or not). So before doing any btrfsck
> --repair or btrfs-zero-log (which are pretty much all commands for
> 'repairing' btrfs I founded over the net) I would like to ask for some help
> or advices.

I recently encountered the same problem on kernel 3.8 with Archlinux,
I'm running BTRFS in RAID1 and had pretty much the same problem.
Mounting the volume resulted in this trace and no mount, trying to
mount again would freeze and I would need to reboot to try again, I
tried using clear_cache, recovery, ro without any success, tried
btrsck --repair, it said it fixed something but fails to mount
afterward and furthermore complains about space_cache being outdated.

I had to use btrfs-zero-log before it could mount again.

Here is the trace I had:

[   15.289140] device label p4-btrfs devid 1 transid 545533 /dev/dm-1
[   15.336323] device label p4-openwrt devid 1 transid 56491 /dev/dm-2
[   15.622376] device label p4-btrfsRoot devid 3 transid 128743 /dev/sdc4
[   15.683499] btrfs: force clearing of disk cache
[   15.697295] btrfs: disk space caching is enabled
[   16.864388] ------------[ cut here ]------------
[   16.877759] kernel BUG at fs/btrfs/free-space-cache.c:1542!
[   16.891417] invalid opcode: 0000 [#1] PREEMPT SMP
[   16.905434] Modules linked in: dm_crypt sr_mod cdrom sd_mod
ata_generic pata_acpi hid_generic crc32c_intel ghash_clmulni_intel
aesni_intel aes_x86_64 ablk_helper cryptd xts lrw gf128mul ahci
sata_mv libahci pata_jmicron ehci_pci xhci_hcd uhci_hcd ata_piix
libata btrfs crc32c libcrc32c zlib_deflate ext4 crc16 jbd2 mbcache
fuse usbhid hid usb_storage scsi_mod ehci_hcd usbcore usb_common
raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor
async_tx raid1 md_mod dm_snapshot dm_mod loop
[   17.024301] CPU 0
[   17.024553] Pid: 216, comm: mount Not tainted
3.8.0-rc5-TiARCH-00004-g99beec4-dirty #3 Gigabyte Technology Co., Ltd.
P55-USB3/P55-USB3
[   17.080278] RIP: 0010:[<ffffffffa02bbfbf>]  [<ffffffffa02bbfbf>]
remove_from_bitmap+0x16f/0x180 [btrfs]
[   17.118802] RSP: 0018:ffff88011567f6e8  EFLAGS: 00010287
[   17.138121] RAX: 0000000000000000 RBX: ffff88011769cf80 RCX: ffff880118e053a4
[   17.157722] RDX: 00000001b0b22000 RSI: 0000000000008000 RDI: 0000000000006200
[   17.177096] RBP: ffff88011567f738 R08: ffff880114c7d3c8 R09: 0000000000001e00
[   17.196438] R10: ffffea0004500d80 R11: ffffffffa0267948 R12: ffff88011567f760
[   17.216040] R13: ffff88011567f758 R14: ffff880118e05380 R15: 00000001b6e50000
[   17.235653] FS:  00007f7f55594780(0000) GS:ffff88011fc00000(0000)
knlGS:0000000000000000
[   17.274869] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.294723] CR2: 0000000001dc9008 CR3: 0000000118fa2000 CR4: 00000000000007f0
[   17.314910] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   17.334664] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   17.353846] Process mount (pid: 216, threadinfo ffff88011567e000,
task ffff8801154beb40)
[   17.392013] Stack:
[   17.410836]  ffff880114036600 ffff880118e053a4 00000001b0bce000
00000000000a4000
[   17.449642]  ffff88011567f738 ffff880118e05380 ffff880118e053a4
0000000000000000
[   17.488869]  ffff880118cf0200 ffff880115a95000 ffff88011567f788
ffffffffa02be2d3
[   17.527977] Call Trace:
[   17.546721]  [<ffffffffa02be2d3>] btrfs_remove_free_space+0x53/0x290 [btrfs]
[   17.565962]  [<ffffffffa026f80f>]
btrfs_alloc_logged_file_extent+0x1bf/0x1e0 [btrfs]
[   17.603515]  [<ffffffffa025b32a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[   17.622918]  [<ffffffffa02b6e90>] replay_one_extent+0x620/0x690 [btrfs]
[   17.641943]  [<ffffffffa0290604>] ? btrfs_destroy_inode+0x1c4/0x2e0 [btrfs]
[   17.660666]  [<ffffffffa02a04f3>] ? read_extent_buffer+0xc3/0x120 [btrfs]
[   17.679065]  [<ffffffffa02b7f1b>] replay_one_buffer+0x2db/0x3a0 [btrfs]
[   17.697334]  [<ffffffffa029eded>] ? alloc_extent_buffer+0x9d/0x490 [btrfs]
[   17.715505]  [<ffffffffa02b48e2>] walk_down_log_tree+0x212/0x400 [btrfs]
[   17.733741]  [<ffffffffa02b4b6d>] walk_log_tree+0x9d/0x1f0 [btrfs]
[   17.751879]  [<ffffffffa02bb41b>] btrfs_recover_log_trees+0x21b/0x3a0 [btrfs]
[   17.770168]  [<ffffffffa02b7c40>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
[   17.788456]  [<ffffffffa027f45f>] open_ctree+0x166f/0x1d00 [btrfs]
[   17.806537]  [<ffffffff81256ff1>] ? disk_name+0x61/0xc0
[   17.824153]  [<ffffffffa0257b83>] btrfs_mount+0x633/0x770 [btrfs]
[   17.841672]  [<ffffffff81168f38>] ? alloc_pages_current+0xb8/0x180
[   17.859027]  [<ffffffff8118dfb3>] mount_fs+0x43/0x1b0
[   17.876427]  [<ffffffff811a8c54>] vfs_kern_mount+0x74/0x110
[   17.894093]  [<ffffffff811aac26>] do_mount+0x216/0xa80
[   17.911362]  [<ffffffff81126d4e>] ? __get_free_pages+0xe/0x50
[   17.928315]  [<ffffffff811aa87a>] ? copy_mount_options+0x3a/0x180
[   17.945484]  [<ffffffff811ab51e>] sys_mount+0x8e/0xe0
[   17.962222]  [<ffffffff814bb05d>] system_call_fastpath+0x1a/0x1f
[   17.978677] Code: 8e 0f 1f 00 31 c0 48 83 7b 20 00 75 d5 48 89 de
4c 89 f7 89 45 b0 e8 01 f8 ff ff 8b 45 b0 eb c2 0f 1f 40 00 b8 ea ff
ff ff eb b7 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66
66 66
[   18.029032] RIP  [<ffffffffa02bbfbf>] remove_from_bitmap+0x16f/0x180 [btrfs]
[   18.045301]  RSP <ffff88011567f6e8>
[   18.061636] ---[ end trace a76d6978e0d86d8a ]---
[   18.077872] note: mount[216] exited with preempt_count 1
[   18.094215] BUG: scheduling while atomic: mount/216/0x10000002
[   18.110279] Modules linked in: dm_crypt sr_mod cdrom sd_mod
ata_generic pata_acpi hid_generic crc32c_intel ghash_clmulni_intel
aesni_intel aes_x86_64 ablk_helper cryptd xts lrw gf128mul ahci
sata_mv libahci pata_jmicron ehci_pci xhci_hcd uhci_hcd ata_piix
libata btrfs crc32c libcrc32c zlib_deflate ext4 crc16 jbd2 mbcache
fuse usbhid hid usb_storage scsi_mod ehci_hcd usbcore usb_common
raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor
async_tx raid1 md_mod dm_snapshot dm_mod loop
[   18.231469] Pid: 216, comm: mount Tainted: G      D
3.8.0-rc5-TiARCH-00004-g99beec4-dirty #3
[   18.267744] Call Trace:
[   18.285502]  [<ffffffff814ab69d>] __schedule_bug+0x4d/0x59
[   18.303649]  [<ffffffff814b240a>] __schedule+0x8da/0x920
[   18.321578]  [<ffffffff81168f38>] ? alloc_pages_current+0xb8/0x180
[   18.339693]  [<ffffffff8108aa7a>] __cond_resched+0x2a/0x40
[   18.357708]  [<ffffffff814b24cf>] _cond_resched+0x2f/0x40
[   18.375638]  [<ffffffff8114b38c>] unmap_single_vma+0x44c/0x870
[   18.393653]  [<ffffffff8112fbe0>] ? release_pages+0x1f0/0x230
[   18.411723]  [<ffffffff8114c011>] unmap_vmas+0x51/0xa0
[   18.429705]  [<ffffffff81154878>] exit_mmap+0x98/0x170
[   18.447613]  [<ffffffff81054431>] mmput+0x61/0x120
[   18.465337]  [<ffffffff8105cc4e>] do_exit+0x24e/0xa50
[   18.482995]  [<ffffffff814ab130>] ? printk+0x4d/0x4f
[   18.500233]  [<ffffffff8105aa51>] ? kmsg_dump+0xc1/0xd0
[   18.517015]  [<ffffffff814b49cd>] oops_end+0x9d/0xe0
[   18.533538]  [<ffffffff81018df8>] die+0x58/0x90
[   18.549486]  [<ffffffff814b42ab>] do_trap+0x6b/0x170
[   18.565109]  [<ffffffff81016385>] do_invalid_op+0x95/0xb0
[   18.580717]  [<ffffffffa02bbfbf>] ? remove_from_bitmap+0x16f/0x180 [btrfs]
[   18.596539]  [<ffffffffa025af19>] ? btrfs_set_path_blocking+0x39/0x80 [btrfs]
[   18.612331]  [<ffffffffa02967f4>] ? btrfs_get_token_32+0x64/0xf0 [btrfs]
[   18.627750]  [<ffffffff811303ab>] ? mark_page_accessed+0x4b/0x60
[   18.642682]  [<ffffffff814bc2de>] invalid_op+0x1e/0x30
[   18.657109]  [<ffffffffa0267948>] ?
cache_block_group.isra.44+0x2f8/0x3e0 [btrfs]
[   18.685083]  [<ffffffffa02bbfbf>] ? remove_from_bitmap+0x16f/0x180 [btrfs]
[   18.699534]  [<ffffffffa02bbebd>] ? remove_from_bitmap+0x6d/0x180 [btrfs]
[   18.713427]  [<ffffffffa02be2d3>] btrfs_remove_free_space+0x53/0x290 [btrfs]
[   18.727197]  [<ffffffffa026f80f>]
btrfs_alloc_logged_file_extent+0x1bf/0x1e0 [btrfs]
[   18.753938]  [<ffffffffa025b32a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[   18.768121]  [<ffffffffa02b6e90>] replay_one_extent+0x620/0x690 [btrfs]
[   18.782519]  [<ffffffffa0290604>] ? btrfs_destroy_inode+0x1c4/0x2e0 [btrfs]
[   18.797052]  [<ffffffffa02a04f3>] ? read_extent_buffer+0xc3/0x120 [btrfs]
[   18.811591]  [<ffffffffa02b7f1b>] replay_one_buffer+0x2db/0x3a0 [btrfs]
[   18.826220]  [<ffffffffa029eded>] ? alloc_extent_buffer+0x9d/0x490 [btrfs]
[   18.840962]  [<ffffffffa02b48e2>] walk_down_log_tree+0x212/0x400 [btrfs]
[   18.855839]  [<ffffffffa02b4b6d>] walk_log_tree+0x9d/0x1f0 [btrfs]
[   18.870647]  [<ffffffffa02bb41b>] btrfs_recover_log_trees+0x21b/0x3a0 [btrfs]
[   18.885771]  [<ffffffffa02b7c40>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
[   18.901055]  [<ffffffffa027f45f>] open_ctree+0x166f/0x1d00 [btrfs]
[   18.916476]  [<ffffffff81256ff1>] ? disk_name+0x61/0xc0
[   18.931962]  [<ffffffffa0257b83>] btrfs_mount+0x633/0x770 [btrfs]
[   18.947622]  [<ffffffff81168f38>] ? alloc_pages_current+0xb8/0x180
[   18.963421]  [<ffffffff8118dfb3>] mount_fs+0x43/0x1b0
[   18.979230]  [<ffffffff811a8c54>] vfs_kern_mount+0x74/0x110
[   18.995180]  [<ffffffff811aac26>] do_mount+0x216/0xa80
[   19.011066]  [<ffffffff81126d4e>] ? __get_free_pages+0xe/0x50
[   19.026876]  [<ffffffff811aa87a>] ? copy_mount_options+0x3a/0x180
[   19.042588]  [<ffffffff811ab51e>] sys_mount+0x8e/0xe0
[   19.058170]  [<ffffffff814bb05d>] system_call_fastpath+0x1a/0x1f
