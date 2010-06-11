From: Brad Figg <brad.figg@canonical.com>
Subject: Regression in 2.6.35 RC1 (Ubuntu 2.6.35-1-generic)
Date: Thu, 10 Jun 2010 21:54:03 -0700
Message-ID: <4C11C16B.7030302@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm seeing the following in /var/log/messages. The system is not under
any particular load. The system has my /home as a btrfs partition. The
system has GDM up and I've logged in via ssh.


Jun 10 21:22:43 bradf-x301 kernel: [  175.563934] CPU 1
Jun 10 21:22:43 bradf-x301 kernel: [  175.563937] Modules linked in: cryptd aes_x86_64 aes_generic rfcomm binfmt_misc sco ppdev bridge stp bnep l2cap dm_crypt snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi snd_seq_midi 
snd_rawmidi snd_seq_midi_event arc4 snd_seq snd_timer snd_seq_device uvcvideo lp iwlagn videodev parport iwlcore btusb mac80211 v4l1_compat snd cfg80211 bluetooth joydev soundcore v4l2_compat_ioctl32 psmouse tpm_tis tpm serio_raw tpm_bios led_class nvram 
snd_page_alloc btrfs zlib_deflate crc32c libcrc32c vga16fb vgastate usbhid hid i915 drm_kms_helper drm ahci i2c_algo_bit video e1000e output libahci intel_agp
Jun 10 21:22:43 bradf-x301 kernel: [  175.564051]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564059] Pid: 936, comm: btrfs-endio-wri Tainted: G        W   2.6.35-1-generic #1-Ubuntu 2777MSU/2777MSU
Jun 10 21:22:43 bradf-x301 kernel: [  175.564066] RIP: 0010:[<ffffffffa015916b>]  [<ffffffffa015916b>] btrfs_free_tree_block+0x3bb/0x3e0 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564102] RSP: 0018:ffff8801282638f0  EFLAGS: 00010287
Jun 10 21:22:43 bradf-x301 kernel: [  175.564108] RAX: ffff8801326c5b00 RBX: ffff88013279e800 RCX: ffff8801326c5300
Jun 10 21:22:43 bradf-x301 kernel: [  175.564114] RDX: 0000000181ffffff RSI: 0000000140000000 RDI: ffff8801304dc070
Jun 10 21:22:43 bradf-x301 kernel: [  175.564121] RBP: ffff880128263940 R08: 0000000000000000 R09: 0000000000000007
Jun 10 21:22:43 bradf-x301 kernel: [  175.564126] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880123dba7e0
Jun 10 21:22:43 bradf-x301 kernel: [  175.564132] R13: ffff8801304dc128 R14: ffff880123dbd000 R15: ffff8801326c5300
Jun 10 21:22:43 bradf-x301 kernel: [  175.564139] FS:  0000000000000000(0000) GS:ffff880001e80000(0000) knlGS:0000000000000000
Jun 10 21:22:43 bradf-x301 kernel: [  175.564146] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 10 21:22:43 bradf-x301 kernel: [  175.564152] CR2: 00007f1a263e4e40 CR3: 0000000001a2a000 CR4: 00000000000006e0
Jun 10 21:22:43 bradf-x301 kernel: [  175.564158] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 10 21:22:43 bradf-x301 kernel: [  175.564164] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 10 21:22:43 bradf-x301 kernel: [  175.564171] Process btrfs-endio-wri (pid: 936, threadinfo ffff880128262000, task ffff880128635b40)
Jun 10 21:22:43 bradf-x301 kernel: [  175.564179]  ffff880100000002 0000000000000000 ffff880130b301b8 000000000000b242
Jun 10 21:22:43 bradf-x301 kernel: [  175.564189] <0> ffff880128263940 ffff88013081c630 ffff880123dba900 ffff88013279e800
Jun 10 21:22:43 bradf-x301 kernel: [  175.564199] <0> ffff880123dba7e0 ffff880123dbd000 ffff8801282639f0 ffffffffa014992b
Jun 10 21:22:43 bradf-x301 kernel: [  175.564234]  [<ffffffffa014992b>] __btrfs_cow_block+0x3bb/0x620 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564257]  [<ffffffffa0149c97>] btrfs_cow_block+0x107/0x1f0 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564280]  [<ffffffffa015086e>] btrfs_search_slot+0x37e/0x6b0 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564308]  [<ffffffffa016104d>] btrfs_lookup_csum+0x6d/0x160 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564321]  [<ffffffff81140915>] ? kmem_cache_alloc+0xe5/0x140
Jun 10 21:22:43 bradf-x301 kernel: [  175.564347]  [<ffffffffa0161d29>] btrfs_csum_file_blocks+0xd9/0x850 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564380]  [<ffffffffa0186b9e>] ? merge_state+0x7e/0x150 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564411]  [<ffffffffa0186317>] ? free_extent_state+0x37/0x60 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564442]  [<ffffffffa016b4b9>] add_pending_csums+0x49/0x70 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564471]  [<ffffffffa016d7f3>] btrfs_finish_ordered_io+0x1a3/0x2a0 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564482]  [<ffffffff81108aed>] ? test_clear_page_writeback+0x8d/0x150
Jun 10 21:22:43 bradf-x301 kernel: [  175.564512]  [<ffffffffa016d90a>] btrfs_writepage_end_io_hook+0x1a/0x20 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564542]  [<ffffffffa018822b>] end_bio_extent_writepage+0x13b/0x180 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564553]  [<ffffffff8158235d>] ? schedule_timeout+0x19d/0x310
Jun 10 21:22:43 bradf-x301 kernel: [  175.564564]  [<ffffffff8106e1d0>] ? process_timeout+0x0/0x10
Jun 10 21:22:43 bradf-x301 kernel: [  175.564573]  [<ffffffff8117da1d>] bio_endio+0x1d/0x40
Jun 10 21:22:43 bradf-x301 kernel: [  175.564601]  [<ffffffffa01641ec>] end_workqueue_fn+0xfc/0x130 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564629]  [<ffffffffa01942cc>] worker_loop+0x15c/0x4c0 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564657]  [<ffffffffa0194170>] ? worker_loop+0x0/0x4c0 [btrfs]
Jun 10 21:22:43 bradf-x301 kernel: [  175.564668]  [<ffffffff8107d0b6>] kthread+0x96/0xa0
Jun 10 21:22:43 bradf-x301 kernel: [  175.564677]  [<ffffffff8100aee4>] kernel_thread_helper+0x4/0x10
Jun 10 21:22:43 bradf-x301 kernel: [  175.564686]  [<ffffffff8107d020>] ? kthread+0x0/0xa0
Jun 10 21:22:43 bradf-x301 kernel: [  175.564693]  [<ffffffff8100aee0>] ? kernel_thread_helper+0x0/0x10
Jun 10 21:22:43 bradf-x301 kernel: [  175.564809]  RSP <ffff8801282638f0>
Jun 10 21:22:43 bradf-x301 kernel: [  175.564816] ---[ end trace 32d3e1002acaefc4 ]---

Jun 10 21:23:17 bradf-x301 kernel: [  209.857602] CPU 1
Jun 10 21:23:17 bradf-x301 kernel: [  209.857605] Modules linked in: cryptd aes_x86_64 aes_generic rfcomm binfmt_misc sco ppdev bridge stp bnep l2cap dm_crypt snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi snd_seq_midi 
snd_rawmidi snd_seq_midi_event arc4 snd_seq snd_timer snd_seq_device uvcvideo lp iwlagn videodev parport iwlcore btusb mac80211 v4l1_compat snd cfg80211 bluetooth joydev soundcore v4l2_compat_ioctl32 psmouse tpm_tis tpm serio_raw tpm_bios led_class nvram 
snd_page_alloc btrfs zlib_deflate crc32c libcrc32c vga16fb vgastate usbhid hid i915 drm_kms_helper drm ahci i2c_algo_bit video e1000e output libahci intel_agp
Jun 10 21:23:17 bradf-x301 kernel: [  209.857719]
Jun 10 21:23:17 bradf-x301 kernel: [  209.857726] Pid: 946, comm: btrfs-transacti Tainted: G      D W   2.6.35-1-generic #1-Ubuntu 2777MSU/2777MSU
Jun 10 21:23:17 bradf-x301 kernel: [  209.857733] RIP: 0010:[<ffffffffa015916b>]  [<ffffffffa015916b>] btrfs_free_tree_block+0x3bb/0x3e0 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.857767] RSP: 0018:ffff88012821b820  EFLAGS: 00010287
Jun 10 21:23:17 bradf-x301 kernel: [  209.857772] RAX: ffff8801326c5b00 RBX: ffff88013279a000 RCX: ffff8801326c5300
Jun 10 21:23:17 bradf-x301 kernel: [  209.857778] RDX: 0000000181ffffff RSI: 0000000140000000 RDI: ffff8801304dc070
Jun 10 21:23:17 bradf-x301 kernel: [  209.857784] RBP: ffff88012821b870 R08: 0000000000000000 R09: 0000000000000002
Jun 10 21:23:17 bradf-x301 kernel: [  209.857790] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880130ab0510
Jun 10 21:23:17 bradf-x301 kernel: [  209.857796] R13: ffff8801304dc128 R14: ffff880123dbd040 R15: ffff8801326c5300
Jun 10 21:23:17 bradf-x301 kernel: [  209.857803] FS:  0000000000000000(0000) GS:ffff880001e80000(0000) knlGS:0000000000000000
Jun 10 21:23:17 bradf-x301 kernel: [  209.857810] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 10 21:23:17 bradf-x301 kernel: [  209.857815] CR2: 0000000001be6028 CR3: 0000000001a2a000 CR4: 00000000000006e0
Jun 10 21:23:17 bradf-x301 kernel: [  209.857821] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 10 21:23:17 bradf-x301 kernel: [  209.857827] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 10 21:23:17 bradf-x301 kernel: [  209.857834] Process btrfs-transacti (pid: 946, threadinfo ffff88012821a000, task ffff880128660000)
Jun 10 21:23:17 bradf-x301 kernel: [  209.857843]  ffff880100000002 0000000000000000 ffff880130b301b8 000000000000b242
Jun 10 21:23:17 bradf-x301 kernel: [  209.857852] <0> ffff88012821b870 ffff880130ab0cf0 ffff880130b6a000 ffff88013279a000
Jun 10 21:23:17 bradf-x301 kernel: [  209.857862] <0> ffff880130ab0510 ffff880123dbd040 ffff88012821b920 ffffffffa014992b
Jun 10 21:23:17 bradf-x301 kernel: [  209.857898]  [<ffffffffa014992b>] __btrfs_cow_block+0x3bb/0x620 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.857920]  [<ffffffffa0149c97>] btrfs_cow_block+0x107/0x1f0 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.857943]  [<ffffffffa015086e>] btrfs_search_slot+0x37e/0x6b0 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.857969]  [<ffffffffa0157cfc>] lookup_inline_extent_backref+0xbc/0x400 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.857982]  [<ffffffff81140915>] ? kmem_cache_alloc+0xe5/0x140
Jun 10 21:23:17 bradf-x301 kernel: [  209.858006]  [<ffffffffa01583f6>] __btrfs_free_extent+0xd6/0x710 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858031]  [<ffffffffa0158b8a>] run_delayed_tree_ref+0x15a/0x160 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858055]  [<ffffffffa0158d8a>] run_one_delayed_ref+0x9a/0xc0 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858080]  [<ffffffffa015b3a0>] run_clustered_refs+0xc0/0x220 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858090]  [<ffffffff8104ff7a>] ? finish_task_switch+0x4a/0xd0
Jun 10 21:23:17 bradf-x301 kernel: [  209.858115]  [<ffffffffa015b5ca>] btrfs_run_delayed_refs+0xca/0x220 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858127]  [<ffffffff81582a9e>] ? mutex_lock+0x1e/0x50
Jun 10 21:23:17 bradf-x301 kernel: [  209.858159]  [<ffffffffa0185a0e>] ? btrfs_run_ordered_operations+0x1ee/0x210 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858189]  [<ffffffffa01694e0>] btrfs_commit_transaction+0x80/0x710 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858198]  [<ffffffff81582a9e>] ? mutex_lock+0x1e/0x50
Jun 10 21:23:17 bradf-x301 kernel: [  209.858227]  [<ffffffffa0169f8b>] ? start_transaction+0x1ab/0x230 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858238]  [<ffffffff8107d610>] ? autoremove_wake_function+0x0/0x40
Jun 10 21:23:17 bradf-x301 kernel: [  209.858265]  [<ffffffffa0163d53>] transaction_kthread+0x283/0x290 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858293]  [<ffffffffa0163ad0>] ? transaction_kthread+0x0/0x290 [btrfs]
Jun 10 21:23:17 bradf-x301 kernel: [  209.858302]  [<ffffffff8107d0b6>] kthread+0x96/0xa0
Jun 10 21:23:17 bradf-x301 kernel: [  209.858311]  [<ffffffff8100aee4>] kernel_thread_helper+0x4/0x10
Jun 10 21:23:17 bradf-x301 kernel: [  209.858320]  [<ffffffff8107d020>] ? kthread+0x0/0xa0
Jun 10 21:23:17 bradf-x301 kernel: [  209.858327]  [<ffffffff8100aee0>] ? kernel_thread_helper+0x0/0x10
Jun 10 21:23:17 bradf-x301 kernel: [  209.858441]  RSP <ffff88012821b820>
Jun 10 21:23:17 bradf-x301 kernel: [  209.858448] ---[ end trace 32d3e1002acaefc5 ]---

Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com
