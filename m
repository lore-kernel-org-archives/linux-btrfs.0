From: "Sergey V." <sftp.mtuci@gmail.com>
Subject: btrfs oops when defrag directories
Date: Sun, 4 Dec 2011 23:21:20 +0400
Message-ID: <201112042321.23160.sftp.mtuci@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When i do `find -type d -xdev -print0 | xargs -0 btrfs fi defrag` to
try to "defragments just the metadata held by the directory object" 
(as noted at wiki [1]), i get several oopses.

kernel version is 3.2.0-rc3; mount options is "compress=lzo,autodefrag".

Thanks.

[1] http://btrfs.ipv5.de/index.php?title=Problem_FAQ#Defragmenting_a_directory_doesn.27t_work

[ 2445.721245] ------------[ cut here ]------------
[ 2445.721308] WARNING: at fs/btrfs/extent-tree.c:4740 __btrfs_free_extent+0x64f/0x700 [btrfs]()
[ 2445.721315] Hardware name: PR210
[ 2445.721319] Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 btrfs cpufreq_ondemand powernow_k8 freq_table mperf lp ppdev parport_pc parport fuse radeon ttm drm_kms_helper snd_hda_codec_hdmi drm snd_hda_codec_realtek snd_hda_intel snd_hda_codec agpgart sdhci_pci r8169 joydev snd_hwdep snd_pcm sdhci snd_timer i2c_algo_bit mmc_core i2c_piix4 video snd processor i2c_core battery mii evdev thermal ac button psmouse thermal_sys sg shpchp k8temp hwmon soundcore snd_page_alloc serio_raw
[ 2445.721417] Pid: 2624, comm: btrfs-endio-wri Tainted: G        W    3.2.0-rc3+ #5
[ 2445.721423] Call Trace:
[ 2445.721441]  [<ffffffff8104fc7f>] warn_slowpath_common+0x7f/0xc0
[ 2445.721450]  [<ffffffff8104fcda>] warn_slowpath_null+0x1a/0x20
[ 2445.721475]  [<ffffffffa0426a3f>] __btrfs_free_extent+0x64f/0x700 [btrfs]
[ 2445.721511]  [<ffffffffa04519fc>] ? btrfs_item_offset+0x3c/0x90 [btrfs]
[ 2445.721537]  [<ffffffffa042a3a3>] run_clustered_refs+0x213/0x840 [btrfs]
[ 2445.721548]  [<ffffffff8103e6cb>] ? __wake_up+0x4b/0x60
[ 2445.721576]  [<ffffffffa0478700>] ? btrfs_find_ref_cluster+0xe0/0x190 [btrfs]
[ 2445.721602]  [<ffffffffa042aa90>] btrfs_run_delayed_refs+0xc0/0x200 [btrfs]
[ 2445.721631]  [<ffffffffa043bd68>] __btrfs_end_transaction+0xb8/0x230 [btrfs]
[ 2445.721659]  [<ffffffffa043bf55>] btrfs_end_transaction+0x15/0x20 [btrfs]
[ 2445.721688]  [<ffffffffa0441bbb>] btrfs_finish_ordered_io+0x16b/0x320 [btrfs]
[ 2445.721700]  [<ffffffff8105e8aa>] ? try_to_del_timer_sync+0x8a/0xe0
[ 2445.721729]  [<ffffffffa0441dc1>] btrfs_writepage_end_io_hook+0x51/0xa0 [btrfs]
[ 2445.721756]  [<ffffffffa0476ca2>] end_compressed_bio_write+0x82/0xf0 [btrfs]
[ 2445.721766]  [<ffffffff811598bd>] bio_endio+0x1d/0x40
[ 2445.721792]  [<ffffffffa0434914>] end_workqueue_fn+0xf4/0x130 [btrfs]
[ 2445.721819]  [<ffffffffa04645e4>] worker_loop+0xb4/0x500 [btrfs]
[ 2445.721847]  [<ffffffffa0464530>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 2445.721875]  [<ffffffffa0464530>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 2445.721884]  [<ffffffff810709c6>] kthread+0x96/0xa0
[ 2445.721893]  [<ffffffff817fd034>] kernel_thread_helper+0x4/0x10
[ 2445.721902]  [<ffffffff81070930>] ? kthread_worker_fn+0x190/0x190
[ 2445.721909]  [<ffffffff817fd030>] ? gs_change+0xb/0xb
[ 2445.721915] ---[ end trace d59ffe0d1e39faba ]---
[ 2445.721922] btrfs unable to find ref byte nr 5125677056 parent 0 root 5  owner 46703 offset 0
[ 2445.721947] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 2445.722011] IP: [<ffffffffa045c11e>] map_private_extent_buffer+0xe/0x150 [btrfs]
[ 2445.722011] PGD 5ba83067 PUD 5ba7b067 PMD 0
[ 2445.722011] Oops: 0000 [#1] SMP
[ 2445.722011] CPU 0
[ 2445.722011] Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 btrfs cpufreq_ondemand powernow_k8 freq_table mperf lp ppdev parport_pc parport fuse radeon ttm drm_kms_helper snd_hda_codec_hdmi drm snd_hda_codec_realtek snd_hda_intel snd_hda_codec agpgart sdhci_pci r8169 joydev snd_hwdep snd_pcm sdhci snd_timer i2c_algo_bit mmc_core i2c_piix4 video snd processor i2c_core battery mii evdev thermal ac button psmouse thermal_sys sg shpchp k8temp hwmon soundcore snd_page_alloc serio_raw
[ 2445.722011]
[ 2445.722011] Pid: 2624, comm: btrfs-endio-wri Tainted: G        W    3.2.0-rc3+ #5 Micro-Star International PR210/MS-1222
[ 2445.722011] RIP: 0010:[<ffffffffa045c11e>]  [<ffffffffa045c11e>] map_private_extent_buffer+0xe/0x150 [btrfs]
[ 2445.722011] RSP: 0018:ffff8800316ab9c0  EFLAGS: 00010286
[ 2445.722011] RAX: 0000000000000000 RBX: 0000000000000065 RCX: ffff8800316aba00
[ 2445.722011] RDX: 0000000000000004 RSI: 000000000000007a RDI: 0000000000000000
[ 2445.722011] RBP: ffff8800316ab9e0 R08: ffff8800316ab9f8 R09: ffff8800316ab9f0
[ 2445.722011] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000007a
[ 2445.722011] R13: 0000000000000000 R14: 0000000000000065 R15: 0000000000000000
[ 2445.722011] FS:  00007f3b4665a780(0000) GS:ffff88007bc00000(0000) knlGS:00000000f6ff56d0
[ 2445.722011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2445.722011] CR2: 0000000000000000 CR3: 000000005ba84000 CR4: 00000000000006f0
[ 2445.722011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2445.722011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2445.722011] Process btrfs-endio-wri (pid: 2624, threadinfo ffff8800316aa000, task ffff8800449171a0)
[ 2445.722011] Stack:
[ 2445.722011]  0000000000000000 0000000000000000 ffff8800316aba30 0000000000000065
[ 2445.722011]  ffff8800316aba30 ffffffffa0451b1c ffff8800316aba00 ffff880074a94000
[ 2445.722011]  0000000000000005 000000013183a000 0000000000000000 ffff880074a94000
[ 2445.722011] Call Trace:
[ 2445.722011]  [<ffffffffa0451b1c>] btrfs_item_size+0x3c/0x90 [btrfs]
[ 2445.722011]  [<ffffffffa0426651>] __btrfs_free_extent+0x261/0x700 [btrfs]
[ 2445.722011]  [<ffffffffa04519fc>] ? btrfs_item_offset+0x3c/0x90 [btrfs]
[ 2445.722011]  [<ffffffffa042a3a3>] run_clustered_refs+0x213/0x840 [btrfs]
[ 2445.722011]  [<ffffffff8103e6cb>] ? __wake_up+0x4b/0x60
[ 2445.722011]  [<ffffffffa0478700>] ? btrfs_find_ref_cluster+0xe0/0x190 [btrfs]
[ 2445.722011]  [<ffffffffa042aa90>] btrfs_run_delayed_refs+0xc0/0x200 [btrfs]
[ 2445.722011]  [<ffffffffa043bd68>] __btrfs_end_transaction+0xb8/0x230 [btrfs]
[ 2445.722011]  [<ffffffffa043bf55>] btrfs_end_transaction+0x15/0x20 [btrfs]
[ 2445.722011]  [<ffffffffa0441bbb>] btrfs_finish_ordered_io+0x16b/0x320 [btrfs]
[ 2445.722011]  [<ffffffff8105e8aa>] ? try_to_del_timer_sync+0x8a/0xe0
[ 2445.722011]  [<ffffffffa0441dc1>] btrfs_writepage_end_io_hook+0x51/0xa0 [btrfs]
[ 2445.722011]  [<ffffffffa0476ca2>] end_compressed_bio_write+0x82/0xf0 [btrfs]
[ 2445.722011]  [<ffffffff811598bd>] bio_endio+0x1d/0x40
[ 2445.722011]  [<ffffffffa0434914>] end_workqueue_fn+0xf4/0x130 [btrfs]
[ 2445.722011]  [<ffffffffa04645e4>] worker_loop+0xb4/0x500 [btrfs]
[ 2445.722011]  [<ffffffffa0464530>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 2445.722011]  [<ffffffffa0464530>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 2445.722011]  [<ffffffff810709c6>] kthread+0x96/0xa0
[ 2445.722011]  [<ffffffff817fd034>] kernel_thread_helper+0x4/0x10
[ 2445.722011]  [<ffffffff81070930>] ? kthread_worker_fn+0x190/0x190
[ 2445.722011]  [<ffffffff817fd030>] ? gs_change+0xb/0xb
[ 2445.722011] Code: ff 41 89 dd e9 17 ff ff ff 48 8d 4e 01 48 89 b5 60 ff ff ff 48 89 4d 80 e9 d0 fc ff ff 55 48 89 e5 53 48 83 ec 18 66 66 66 66 90
[ 2445.722011]  8b 1f 81 e3 ff 0f 00 00 48 8d 04 1e 4c 8d 54 10 ff 49 89 c3
[ 2445.722011] RIP  [<ffffffffa045c11e>] map_private_extent_buffer+0xe/0x150 [btrfs]
[ 2445.722011]  RSP <ffff8800316ab9c0>
[ 2445.722011] CR2: 0000000000000000
[ 2445.792409] ---[ end trace d59ffe0d1e39fabb ]---
[ 2445.801004] ------------[ cut here ]------------
[ 2445.801011] kernel BUG at fs/btrfs/inode.c:1667!
[ 2445.801011] invalid opcode: 0000 [#2] SMP
[ 2445.801011] CPU 0
[ 2445.801011] Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 btrfs cpufreq_ondemand powernow_k8 freq_table mperf lp ppdev parport_pc parport fuse radeon ttm drm_kms_helper snd_hda_codec_hdmi drm snd_hda_codec_realtek snd_hda_intel snd_hda_codec agpgart sdhci_pci r8169 joydev snd_hwdep snd_pcm sdhci snd_timer i2c_algo_bit mmc_core i2c_piix4 video snd processor i2c_core battery mii evdev thermal ac button psmouse thermal_sys sg shpchp k8temp hwmon soundcore snd_page_alloc serio_raw
[ 2445.801011]
[ 2445.801011] Pid: 1596, comm: btrfs-endio-wri Tainted: G      D W    3.2.0-rc3+ #5 Micro-Star International PR210/MS-1222
[ 2445.801011] RIP: 0010:[<ffffffffa0440ef6>]  [<ffffffffa0440ef6>] insert_reserved_file_extent.clone.41+0x276/0x280 [btrfs]
[ 2445.801011] RSP: 0018:ffff880076c09c70  EFLAGS: 00010286
[ 2445.801011] RAX: 00000000ffffffe4 RBX: ffff880074a942d0 RCX: 00000000002ef186
[ 2445.801011] RDX: 00000000002ef185 RSI: 000060ff84000ba0 RDI: ffffea0001d2a500
[ 2445.801011] RBP: ffff880076c09d00 R08: ffffffffa041a7ca R09: ffff880077057000
[ 2445.801011] R10: ffffffffffffffe4 R11: 0000000000000000 R12: ffff880074a2d450
[ 2445.801011] R13: 0000000000000000 R14: ffff880076cf2000 R15: ffff880037ea5048
[ 2445.801011] FS:  00007f7cdb89e720(0000) GS:ffff88007bc00000(0000) knlGS:00000000f6ff56d0
[ 2445.801011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2445.801011] CR2: 00007f7cdb368cdb CR3: 0000000077097000 CR4: 00000000000006f0
[ 2445.801011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2445.801011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2445.801011] Process btrfs-endio-wri (pid: 1596, threadinfo ffff880076c08000, task ffff880076ff6500)
[ 2445.801011] Stack:
[ 2445.801011]  02ff880076c09ca0 0000000000001000 00000001368d5000 0000000000002000
[ 2445.801011]  ffff880076cf2000 0000000000000001 ffff880076c09cf0 ffffffffa043bff3
[ 2445.801011]  ffffea00005c0f40 0000000000000010 ffff880076c09ce0 ffff880076cf2000
[ 2445.801011] Call Trace:
[ 2445.801011]  [<ffffffffa043bff3>] ? start_transaction+0x93/0x2a0 [btrfs]
[ 2445.801011]  [<ffffffffa0441d22>] btrfs_finish_ordered_io+0x2d2/0x320 [btrfs]
[ 2445.801011]  [<ffffffff8105e8aa>] ? try_to_del_timer_sync+0x8a/0xe0
[ 2445.801011]  [<ffffffffa0441dc1>] btrfs_writepage_end_io_hook+0x51/0xa0 [btrfs]
[ 2445.801011]  [<ffffffffa0476ca2>] end_compressed_bio_write+0x82/0xf0 [btrfs]
[ 2445.801011]  [<ffffffff811598bd>] bio_endio+0x1d/0x40
[ 2445.801011]  [<ffffffffa0434914>] end_workqueue_fn+0xf4/0x130 [btrfs]
[ 2445.801011]  [<ffffffffa04645e4>] worker_loop+0xb4/0x500 [btrfs]
[ 2445.801011]  [<ffffffffa0464530>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 2445.801011]  [<ffffffffa0464530>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 2445.801011]  [<ffffffff810709c6>] kthread+0x96/0xa0
[ 2445.801011]  [<ffffffff817fd034>] kernel_thread_helper+0x4/0x10
[ 2445.801011]  [<ffffffff81070930>] ? kthread_worker_fn+0x190/0x190
[ 2445.801011]  [<ffffffff817fd030>] ? gs_change+0xb/0xb
[ 2445.801011] Code: ff 0f 1f 40 00 41 80 bc 24 80 fe ff ff 84 75 a3 eb 9c 0f 1f 00 48 83 c4 68 b8 f4 ff ff ff 5b 41 5c 41 5d 41 5e 41 5f c9 c3 0f 0b <0f> 0b 0f 0b 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec 20 48 89 5d
[ 2445.801011] RIP  [<ffffffffa0440ef6>] insert_reserved_file_extent.clone.41+0x276/0x280 [btrfs]
[ 2445.801011]  RSP <ffff880076c09c70>
[ 2446.050997] ---[ end trace d59ffe0d1e39fabc ]---
[ 2453.290312] ------------[ cut here ]------------
[ 2453.291011] kernel BUG at fs/btrfs/extent-tree.c:5770!
[ 2453.291011] invalid opcode: 0000 [#3] SMP
[ 2453.291011] CPU 0
[ 2453.291011] Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 btrfs cpufreq_ondemand powernow_k8 freq_table mperf lp ppdev parport_pc parport fuse radeon ttm drm_kms_helper snd_hda_codec_hdmi drm snd_hda_codec_realtek snd_hda_intel snd_hda_codec agpgart sdhci_pci r8169 joydev snd_hwdep snd_pcm sdhci snd_timer i2c_algo_bit mmc_core i2c_piix4 video snd processor i2c_core battery mii evdev thermal ac button psmouse thermal_sys sg shpchp k8temp hwmon soundcore snd_page_alloc serio_raw
[ 2453.291011]
[ 2453.291011] Pid: 1601, comm: btrfs-cleaner Tainted: G      D W    3.2.0-rc3+ #5 Micro-Star International PR210/MS-1222
[ 2453.291011] RIP: 0010:[<ffffffffa042a9c3>]  [<ffffffffa042a9c3>] run_clustered_refs+0x833/0x840 [btrfs]
[ 2453.291011] RSP: 0018:ffff880076c7d840  EFLAGS: 00010286
[ 2453.291011] RAX: 00000000ffffffe4 RBX: ffff880040058d20 RCX: 0000000000000000
[ 2453.291011] RDX: ffff88003418f118 RSI: 0000000000000286 RDI: 0000000000000000
[ 2453.291011] RBP: ffff880076c7d930 R08: 0000000000000000 R09: 0000000001c3c000
[ 2453.291011] R10: ffffffffffffffe4 R11: 0000000000000000 R12: ffff88003bb54b00
[ 2453.291011] R13: ffff880056844cc0 R14: ffff880037ea60c0 R15: ffff880037ea6000
[ 2453.291011] FS:  00007f5b49717740(0000) GS:ffff88007bc00000(0000) knlGS:00000000f6ff56d0
[ 2453.291011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2453.291011] CR2: 00007fa59204c008 CR3: 000000005a532000 CR4: 00000000000006f0
[ 2453.291011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2453.291011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2453.291011] Process btrfs-cleaner (pid: 1601, threadinfo ffff880076c7c000, task ffff8800790cdeb0)
[ 2453.291011] Stack:
[ 2453.291011]  ffff8800128d86c0 ffff880021cfa5a0 0000000000000000 ffffffff8111bb0f
[ 2453.291011]  ffff8800790cdeb0 0000000000000634 ffff880076cf2120 0000000000000020
[ 2453.291011]  0000000000000000 00000000000005a5 000000000000060a 0000000000000005
[ 2453.291011] Call Trace:
[ 2453.291011]  [<ffffffff8111bb0f>] ? kmem_cache_alloc+0xcf/0x120
[ 2453.291011]  [<ffffffffa042aa90>] btrfs_run_delayed_refs+0xc0/0x200 [btrfs]
[ 2453.291011]  [<ffffffff817fa32e>] ? mutex_lock+0x1e/0x50
[ 2453.291011]  [<ffffffffa043b4b7>] btrfs_commit_transaction+0x97/0x860 [btrfs]
[ 2453.291011]  [<ffffffffa043ac27>] ? join_transaction.clone.24+0x27/0x230 [btrfs]
[ 2453.291011]  [<ffffffff81070f10>] ? wake_up_bit+0x40/0x40
[ 2453.291011]  [<ffffffffa0422acf>] may_commit_transaction+0x8f/0x100 [btrfs]
[ 2453.291011]  [<ffffffffa0427a38>] ? get_alloc_profile+0x38/0x80 [btrfs]
[ 2453.291011]  [<ffffffffa0428f7a>] reserve_metadata_bytes.clone.60+0x65a/0x6c0 [btrfs]
[ 2453.291011]  [<ffffffffa041a7ca>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[ 2453.291011]  [<ffffffffa0429835>] btrfs_delalloc_reserve_metadata+0x115/0x1d0 [btrfs]
[ 2453.291011]  [<ffffffffa04299fb>] btrfs_delalloc_reserve_space+0x3b/0x60 [btrfs]
[ 2453.291011]  [<ffffffffa04681e5>] btrfs_defrag_file+0x465/0xc60 [btrfs]
[ 2453.291011]  [<ffffffff8103e9da>] ? update_shares+0xca/0x100
[ 2453.291011]  [<ffffffff812836ab>] ? radix_tree_lookup+0xb/0x10
[ 2453.291011]  [<ffffffffa044a994>] btrfs_run_defrag_inodes+0x184/0x230 [btrfs]
[ 2453.291011]  [<ffffffffa0434747>] cleaner_kthread+0x177/0x190 [btrfs]
[ 2453.291011]  [<ffffffffa04345d0>] ? transaction_kthread+0x280/0x280 [btrfs]
[ 2453.291011]  [<ffffffffa04345d0>] ? transaction_kthread+0x280/0x280 [btrfs]
[ 2453.291011]  [<ffffffff810709c6>] kthread+0x96/0xa0
[ 2453.291011]  [<ffffffff817fd034>] kernel_thread_helper+0x4/0x10
[ 2453.291011]  [<ffffffff81070930>] ? kthread_worker_fn+0x190/0x190
[ 2453.291011]  [<ffffffff817fd030>] ? gs_change+0xb/0xb
[ 2453.291011] Code: ff e9 f4 f8 ff ff 0f 0b 80 fa b2 0f 84 94 f9 ff ff 0f 0b be 95 00 00 00 48 c7 c7 49 ec 48 a0 e8 04 53 c2 e0 e9 e5 f8 ff ff 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 90 55 48 89 e5 41 57 41 56
[ 2453.291011] RIP  [<ffffffffa042a9c3>] run_clustered_refs+0x833/0x840 [btrfs]
[ 2453.291011]  RSP <ffff880076c7d840>
[ 2453.606327] ---[ end trace d59ffe0d1e39fabd ]---
[ 2458.290106] ------------[ cut here ]------------
[ 2458.290167] WARNING: at fs/btrfs/extent-tree.c:4740 __btrfs_free_extent+0x64f/0x700 [btrfs]()
[ 2458.290173] Hardware name: PR210
[ 2458.290178] Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 btrfs cpufreq_ondemand powernow_k8 freq_table mperf lp ppdev parport_pc parport fuse radeon ttm drm_kms_helper snd_hda_codec_hdmi drm snd_hda_codec_realtek snd_hda_intel snd_hda_codec agpgart sdhci_pci r8169 joydev snd_hwdep snd_pcm sdhci snd_timer i2c_algo_bit mmc_core i2c_piix4 video snd processor i2c_core battery mii evdev thermal ac button psmouse thermal_sys sg shpchp k8temp hwmon soundcore snd_page_alloc serio_raw
[ 2458.290282] Pid: 1602, comm: btrfs-transacti Tainted: G      D W    3.2.0-rc3+ #5
[ 2458.290289] Call Trace:
[ 2458.290305]  [<ffffffff8104fc7f>] warn_slowpath_common+0x7f/0xc0
[ 2458.290315]  [<ffffffff8104fcda>] warn_slowpath_null+0x1a/0x20
[ 2458.290340]  [<ffffffffa0426a3f>] __btrfs_free_extent+0x64f/0x700 [btrfs]
[ 2458.290352]  [<ffffffff81040138>] ? hrtick_update+0x38/0x40
[ 2458.290361]  [<ffffffff810402f4>] ? dequeue_task_fair+0x1b4/0x220
[ 2458.290388]  [<ffffffffa042a3a3>] run_clustered_refs+0x213/0x840 [btrfs]
[ 2458.290398]  [<ffffffff817f8c51>] ? __schedule+0x321/0x920
[ 2458.290428]  [<ffffffffa0470df9>] ? tree_insert_offset+0x79/0xd0 [btrfs]
[ 2458.290456]  [<ffffffffa0478700>] ? btrfs_find_ref_cluster+0xe0/0x190 [btrfs]
[ 2458.290481]  [<ffffffffa042aa90>] btrfs_run_delayed_refs+0xc0/0x200 [btrfs]
[ 2458.290491]  [<ffffffff817fa32e>] ? mutex_lock+0x1e/0x50
[ 2458.290519]  [<ffffffffa043b4b7>] btrfs_commit_transaction+0x97/0x860 [btrfs]
[ 2458.290548]  [<ffffffffa043ac27>] ? join_transaction.clone.24+0x27/0x230 [btrfs]
[ 2458.290558]  [<ffffffff81070f10>] ? wake_up_bit+0x40/0x40
[ 2458.290585]  [<ffffffffa04345b3>] transaction_kthread+0x263/0x280 [btrfs]
[ 2458.290625]  [<ffffffffa0434350>] ? btrfs_congested_fn+0xb0/0xb0 [btrfs]
[ 2458.290652]  [<ffffffffa0434350>] ? btrfs_congested_fn+0xb0/0xb0 [btrfs]
[ 2458.290660]  [<ffffffff810709c6>] kthread+0x96/0xa0
[ 2458.290670]  [<ffffffff817fd034>] kernel_thread_helper+0x4/0x10
[ 2458.290678]  [<ffffffff81070930>] ? kthread_worker_fn+0x190/0x190
[ 2458.290686]  [<ffffffff817fd030>] ? gs_change+0xb/0xb
[ 2458.290692] ---[ end trace d59ffe0d1e39fabe ]---
[ 2458.290699] btrfs unable to find ref byte nr 5125689344 parent 0 root 5  owner 64563 offset 0
[ 2458.290722] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 2458.291012] IP: [<ffffffffa045c11e>] map_private_extent_buffer+0xe/0x150 [btrfs]
[ 2458.291012] PGD 568d5067 PUD 568d6067 PMD 0
[ 2458.291012] Oops: 0000 [#4] SMP
[ 2458.291012] CPU 0
[ 2458.291012] Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 btrfs cpufreq_ondemand powernow_k8 freq_table mperf lp ppdev parport_pc parport fuse radeon ttm drm_kms_helper snd_hda_codec_hdmi drm snd_hda_codec_realtek snd_hda_intel snd_hda_codec agpgart sdhci_pci r8169 joydev snd_hwdep snd_pcm sdhci snd_timer i2c_algo_bit mmc_core i2c_piix4 video snd processor i2c_core battery mii evdev thermal ac button psmouse thermal_sys sg shpchp k8temp hwmon soundcore snd_page_alloc serio_raw
[ 2458.291012]
[ 2458.291012] Pid: 1602, comm: btrfs-transacti Tainted: G      D W    3.2.0-rc3+ #5 Micro-Star International PR210/MS-1222
[ 2458.291012] RIP: 0010:[<ffffffffa045c11e>]  [<ffffffffa045c11e>] map_private_extent_buffer+0xe/0x150 [btrfs]
[ 2458.291012] RSP: 0018:ffff8800772c5ab0  EFLAGS: 00010282
[ 2458.291012] RAX: 0000000000000000 RBX: 0000000000000065 RCX: ffff8800772c5af0
[ 2458.291012] RDX: 0000000000000004 RSI: 000000000000007a RDI: 0000000000000000
[ 2458.291012] RBP: ffff8800772c5ad0 R08: ffff8800772c5ae8 R09: ffff8800772c5ae0
[ 2458.291012] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000007a
[ 2458.291012] R13: 0000000000000000 R14: 0000000000000065 R15: 0000000000000000
[ 2458.291012] FS:  00007f5b49717740(0000) GS:ffff88007bc00000(0000) knlGS:00000000f6ff56d0
[ 2458.291012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2458.291012] CR2: 0000000000000000 CR3: 000000005a532000 CR4: 00000000000006f0
[ 2458.291012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2458.291012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2458.291012] Process btrfs-transacti (pid: 1602, threadinfo ffff8800772c4000, task ffff8800790ce500)
[ 2458.291012] Stack:
[ 2458.291012]  0000000000000000 0000000000000000 ffff8800772c5b20 0000000000000065
[ 2458.291012]  ffff8800772c5b20 ffffffffa0451b1c ffff8800772c5af0 ffff880074a941b0
[ 2458.291012]  0000000000000005 000000013183d000 0000000000000000 ffff880074a941b0
[ 2458.291012] Call Trace:
[ 2458.291012]  [<ffffffffa0451b1c>] btrfs_item_size+0x3c/0x90 [btrfs]
[ 2458.291012]  [<ffffffffa0426651>] __btrfs_free_extent+0x261/0x700 [btrfs]
[ 2458.291012]  [<ffffffff81040138>] ? hrtick_update+0x38/0x40
[ 2458.291012]  [<ffffffff810402f4>] ? dequeue_task_fair+0x1b4/0x220
[ 2458.291012]  [<ffffffffa042a3a3>] run_clustered_refs+0x213/0x840 [btrfs]
[ 2458.291012]  [<ffffffff817f8c51>] ? __schedule+0x321/0x920
[ 2458.291012]  [<ffffffffa0470df9>] ? tree_insert_offset+0x79/0xd0 [btrfs]
[ 2458.291012]  [<ffffffffa0478700>] ? btrfs_find_ref_cluster+0xe0/0x190 [btrfs]
[ 2458.291012]  [<ffffffffa042aa90>] btrfs_run_delayed_refs+0xc0/0x200 [btrfs]
[ 2458.291012]  [<ffffffff817fa32e>] ? mutex_lock+0x1e/0x50
[ 2458.291012]  [<ffffffffa043b4b7>] btrfs_commit_transaction+0x97/0x860 [btrfs]
[ 2458.291012]  [<ffffffffa043ac27>] ? join_transaction.clone.24+0x27/0x230 [btrfs]
[ 2458.291012]  [<ffffffff81070f10>] ? wake_up_bit+0x40/0x40
[ 2458.291012]  [<ffffffffa04345b3>] transaction_kthread+0x263/0x280 [btrfs]
[ 2458.291012]  [<ffffffffa0434350>] ? btrfs_congested_fn+0xb0/0xb0 [btrfs]
[ 2458.291012]  [<ffffffffa0434350>] ? btrfs_congested_fn+0xb0/0xb0 [btrfs]
[ 2458.291012]  [<ffffffff810709c6>] kthread+0x96/0xa0
[ 2458.291012]  [<ffffffff817fd034>] kernel_thread_helper+0x4/0x10
[ 2458.291012]  [<ffffffff81070930>] ? kthread_worker_fn+0x190/0x190
[ 2458.291012]  [<ffffffff817fd030>] ? gs_change+0xb/0xb
[ 2458.291012] Code: ff 41 89 dd e9 17 ff ff ff 48 8d 4e 01 48 89 b5 60 ff ff ff 48 89 4d 80 e9 d0 fc ff ff 55 48 89 e5 53 48 83 ec 18 66 66 66 66 90
[ 2458.291012]  8b 1f 81 e3 ff 0f 00 00 48 8d 04 1e 4c 8d 54 10 ff 49 89 c3
[ 2458.291012] RIP  [<ffffffffa045c11e>] map_private_extent_buffer+0xe/0x150 [btrfs]
[ 2458.291012]  RSP <ffff8800772c5ab0>
[ 2458.291012] CR2: 0000000000000000
[ 2458.588150] ---[ end trace d59ffe0d1e39fabf ]---
