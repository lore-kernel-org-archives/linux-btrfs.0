From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: kernel BUG at fs/btrfs/extent-tree.c
Date: Thu, 02 Feb 2012 23:28:58 +0200
Message-ID: <4F2B001A.5040006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,  i get this kernel message on my btrfs filesystem.
kernel is 3.2.2-1-aufs_friendly from arch linux (3.2.2 with aufs patches)

[  401.013567] ------------[ cut here ]------------
[  401.013594] kernel BUG at fs/btrfs/extent-tree.c:5736!
[  401.013616] invalid opcode: 0000 [#1] PREEMPT SMP
[  401.013641] CPU 2
[  401.013650] Modules linked in: fuse ipv6 btrfs zlib_deflate crc32c 
libcrc32c loop xfs exportfs ext2 raid456 async_raid6_recov async_pq 
raid6_pq async_xor snd_hda_codec_hdmi xor async_memcpy async_tx md_mod 
snd_hda_intel snd_hda_codec radeon snd_hwdep snd_pcm snd_timer snd ttm 
soundcore drm_kms_helper drm i2c_piix4 snd_page_alloc i2c_algo_bit 
i2c_core shpchp pci_hotplug processor edac_core sp5100_tco evdev r8169 
pcspkr button mii wmi edac_mce_amd k10temp ext4 mbcache jbd2 crc16 
sd_mod pata_acpi ohci_hcd pata_jmicron ehci_hcd ahci libahci libata 
xhci_hcd usbcore scsi_mod usb_common
[  401.013957]
[  401.013966] Pid: 548, comm: btrfs-cleaner Not tainted 
3.2.2-1-aufs_friendly #1 Gigabyte Technology Co., Ltd. 
GA-890GPA-UD3H/GA-890GPA-UD3H
[  401.014020] RIP: 0010:[<ffffffffa04b4db7>]  [<ffffffffa04b4db7>] 
alloc_reserved_file_extent+0x1e7/0x200 [btrfs]
[  401.014073] RSP: 0018:ffff8801e5d05b70  EFLAGS: 00010282
[  401.014095] RAX: 00000000ffffffef RBX: ffff8801e75d4630 RCX: 
0000000000000001
[  401.014124] RDX: 0000000000000008 RSI: 0000000000000001 RDI: 
ffff8801eb2a6be0
[  401.014153] RBP: ffff8801e5d05bf0 R08: 00000000000004ad R09: 
ffff8801e5d059b0
[  401.014181] R10: ffff8801fa4c2800 R11: ffff8801e1924090 R12: 
00000000000000b2
[  401.014210] R13: 0000000000000000 R14: ffff8801e5d05c9b R15: 
ffff8801e1924090
[  401.014239] FS:  00007f2012b1a740(0000) GS:ffff88020fc80000(0000) 
knlGS:0000000000000000
[  401.014271] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  401.014295] CR2: 00007fb3c00b0088 CR3: 00000001e4a80000 CR4: 
00000000000006e0
[  401.014324] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  401.014352] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  401.014382] Process btrfs-cleaner (pid: 548, threadinfo 
ffff8801e5d04000, task ffff880201b063c0)
[  401.014416] Stack:
[  401.014425]  ffff880100000035 000000000000023f 0000000000000d6b 
0000000000000000
[  401.014462]  ffff8801fa4c2000 0000000000000246 ffffffffa04b8e4d 
ffff8801f9ef0000
[  401.014497]  ffff88018febe038 00000035d245c0f0 ffff8801e5d05bf0 
ffff88018d9fa9c0
[  401.014533] Call Trace:
[  401.014550]  [<ffffffffa04b8e4d>] ? run_clustered_refs+0x11d/0x810 
[btrfs]
[  401.014583]  [<ffffffffa04b9029>] run_clustered_refs+0x2f9/0x810 [btrfs]
[  401.014618]  [<ffffffffa0506101>] ? btrfs_find_ref_cluster+0xe1/0x190 
[btrfs]
[  401.014651]  [<ffffffffa04b9608>] btrfs_run_delayed_refs+0xc8/0x220 
[btrfs]
[  401.014684]  [<ffffffffa04c9c98>] 
btrfs_should_end_transaction+0x98/0xa0 [btrfs]
[  401.014719]  [<ffffffffa04bb2a4>] btrfs_drop_snapshot+0x2c4/0x590 [btrfs]
[  401.014752]  [<ffffffffa04d993e>] ? 
btrfs_run_defrag_inodes+0x1fe/0x210 [btrfs]
[  401.014786]  [<ffffffffa04cb37f>] 
btrfs_clean_old_snapshots+0xff/0x140 [btrfs]
[  401.014820]  [<ffffffffa04c2ffc>] cleaner_kthread+0x16c/0x1a0 [btrfs]
[  401.014851]  [<ffffffffa04c2e90>] ? transaction_kthread+0x290/0x290 
[btrfs]
[  401.014881]  [<ffffffff8108839c>] kthread+0x8c/0xa0
[  401.014903]  [<ffffffff8142b2f4>] kernel_thread_helper+0x4/0x10
[  401.014929]  [<ffffffff81088310>] ? kthread_worker_fn+0x190/0x190
[  401.014956]  [<ffffffff8142b2f0>] ? gs_change+0x13/0x13
[  401.014978] Code: 4c 89 ea 48 89 c6 e8 59 b4 02 00 48 8b 75 a8 8b 55 
20 48 8b 7d b8 48 81 c6 86 00 00 00 e8 12 b2 02 00 eb 92 b8 f4 ff ff ff 
eb bf <0f> 0b 49 8b 56 09 49 8b 36 48 c7 c7 20 f0 51 a0 31 c0 e8 6a 9b
[  401.016869] RIP  [<ffffffffa04b4db7>] 
alloc_reserved_file_extent+0x1e7/0x200 [btrfs]
[  401.016869]  RSP <ffff8801e5d05b70>
[  401.019349] ---[ end trace c960a7b93b93472b ]---
[  401.020617] note: btrfs-cleaner[548] exited with preempt_count 1
