Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:44836 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab3HSWtJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 18:49:09 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout0.freenet.de with esmtpa (ID lutz.euler@freenet.de) (port 25) (Exim 4.80.1 #4)
	id 1VBXHR-0004jg-3z
	for linux-btrfs@vger.kernel.org; Mon, 19 Aug 2013 23:46:29 +0200
Received: from localhost ([::1]:35439 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID lutz.euler@freenet.de) (Exim 4.80.1 #4)
	id 1VBXHQ-0007hT-To
	for linux-btrfs@vger.kernel.org; Mon, 19 Aug 2013 23:46:29 +0200
Received: from mx5.freenet.de ([195.4.92.15]:39269)
	by mjail2.freenet.de with esmtpa (ID lutz.euler@freenet.de) (Exim 4.80.1 #4)
	id 1VBXFM-0005Xr-IP
	for linux-btrfs@vger.kernel.org; Mon, 19 Aug 2013 23:44:20 +0200
Received: from p548fb91a.dip0.t-ipconnect.de ([84.143.185.26]:44054 helo=lutz)
	by mx5.freenet.de with esmtpsa (ID lutz.euler@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.80.1 #4)
	id 1VBXFM-0008H4-3V
	for linux-btrfs@vger.kernel.org; Mon, 19 Aug 2013 23:44:20 +0200
Received: from lutz by lutz with local (Exim 4.74)
	(envelope-from <lutz.euler@freenet.de>)
	id 1VBXFL-0001XC-85
	for linux-btrfs@vger.kernel.org; Mon, 19 Aug 2013 23:44:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21010.37299.189607.141474@localhost.localdomain>
Date: Mon, 19 Aug 2013 23:44:19 +0200
From: lutz.euler@freenet.de (Lutz Euler)
To: linux-btrfs@vger.kernel.org
Subject: BUG at fs/btrfs/relocation.c:1055 during balance.
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

during a balance I got the BUG from the subject line, followed by
BUG: unable to handle kernel paging request at 000000000008a940.
The machine needed to be rebooted afterwards; the filesystem was
successfully mounted and the balance resumed and finished successfully.
I then ran scrub which found no errors.

I have run the same balance command several times already in the past,
without problems. This was the first time I tried it under kernel
3.11.0-rc6.

Please find below:

- the balance command I issued
- software versions
- filesystem information (taken after the reboot and after the balance
  finished)
- the syslog entries from the start of the balance until the machine
  was rebooted
- an excerpt from syslog at reboot

Thanks for looking into this,

Lutz

$ sudo time btrfs filesystem balance start -dusage=20 /home

# uname -r
3.11.0-rc6

# uname -m
x86_64

# btrfs --version
Btrfs v0.20-rc1-358-g194aa4a

# grep btrfs /proc/mounts
/dev/sda3 /home btrfs rw,relatime,compress=lzo,ssd,space_cache 0 0

# btrfs fi show
failed to open /dev/sr0: No medium found
Label: none  uuid: 88af7576-3027-4a3b-a5ae-34bfd167982f
	Total devices 2 FS bytes used 35.24GB
	devid    4 size 74.53GB used 44.06GB path /dev/sdb1
	devid    3 size 75.24GB used 44.06GB path /dev/sda3

# btrfs fi df /home
Data, RAID1: total=40.00GB, used=33.73GB
System, RAID1: total=64.00MB, used=12.00KB
Metadata, RAID1: total=4.00GB, used=1.51GB

Syslog with the two BUGs:

Aug 19 22:30:51 lutz kernel: [31953.286566] btrfs: relocating block group 360872673280 flags 17
Aug 19 22:30:52 lutz kernel: [31953.780476] btrfs: found 1076 extents
Aug 19 22:30:53 lutz kernel: [31955.303963] btrfs: found 1076 extents
Aug 19 22:30:53 lutz kernel: [31955.393341] btrfs: relocating block group 357651447808 flags 17
Aug 19 22:30:55 lutz kernel: [31957.666563] btrfs: found 6449 extents
Aug 19 22:30:58 lutz kernel: [31959.706092] ------------[ cut here ]------------
Aug 19 22:30:58 lutz kernel: [31959.706190] kernel BUG at fs/btrfs/relocation.c:1055!
Aug 19 22:30:58 lutz kernel: [31959.706276] invalid opcode: 0000 [#1] PREEMPT SMP 
Aug 19 22:30:58 lutz kernel: [31959.706370] Modules linked in: pppoe pppox binfmt_misc parport_pc ppdev snd_hda_codec_hdmi snd_hda_intel snd_es1938 snd_hda_codec gameport snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_opl3_lib snd_hwdep snd_mpu401_uart snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq asus_atk0110 snd_rawmidi radeon snd_timer snd_seq_device psmouse fbcon edac_core tileblit serio_raw font bitblit softcursor ttm i2c_piix4 snd drm_kms_helper drm soundcore snd_page_alloc i2c_algo_bit hwmon_vid lp parport usbhid btrfs raid6_pq r8169 mii xor zlib_deflate xhci_hcd libcrc32c
Aug 19 22:30:58 lutz kernel: [31959.707393] CPU: 5 PID: 11880 Comm: btrfs Not tainted 3.11.0-rc6 #1
Aug 19 22:30:58 lutz kernel: [31959.707496] Hardware name: System manufacturer System Product Name/M4A87TD/USB3, BIOS 1202    02/17/2011
Aug 19 22:30:58 lutz kernel: [31959.707649] task: ffff88022d9816b0 ti: ffff88009e640000 task.ti: ffff88009e640000
Aug 19 22:30:58 lutz kernel: [31959.707770] RIP: 0010:[<ffffffffa00e963d>]  [<ffffffffa00e963d>] build_backref_tree+0x119d/0x1220 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.707975] RSP: 0018:ffff88009e641868  EFLAGS: 00010246
Aug 19 22:30:58 lutz kernel: [31959.708063] RAX: 0000000000000000 RBX: ffff88022d59a240 RCX: ffff88009bf37e10
Aug 19 22:30:58 lutz kernel: [31959.708178] RDX: ffff88009e641928 RSI: ffff88009e641928 RDI: ffff88021727e400
Aug 19 22:30:58 lutz kernel: [31959.708292] RBP: ffff88009e641978 R08: ffff88021727e580 R09: 0000000000000001
Aug 19 22:30:58 lutz kernel: [31959.708407] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88021727ed80
Aug 19 22:30:58 lutz kernel: [31959.708522] R13: ffff88009bf37e10 R14: ffff88009bf37e00 R15: ffff88022db58800
Aug 19 22:30:58 lutz kernel: [31959.708638] FS:  00007f68c9ae8760(0000) GS:ffff880237d40000(0000) knlGS:0000000009e8d840
Aug 19 22:30:58 lutz kernel: [31959.708768] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 19 22:30:58 lutz kernel: [31959.708861] CR2: ffffffffff600000 CR3: 000000008a63c000 CR4: 00000000000007e0
Aug 19 22:30:58 lutz kernel: [31959.708976] Stack:
Aug 19 22:30:58 lutz kernel: [31959.714551]  ffff88009e641898 ffff88021727e580 ffff88009bf37f80 ffff88009bf37fe0
Aug 19 22:30:58 lutz kernel: [31959.720296]  ffff88022db58920 ffff88022aa32000 ffff88021727e680 ffff88021727e6c0
Aug 19 22:30:58 lutz kernel: [31959.726092]  ffff88022db58924 ffff88022d59a480 ffff88022db58820 0000000000000000
Aug 19 22:30:58 lutz kernel: [31959.731850] Call Trace:
Aug 19 22:30:58 lutz kernel: [31959.737584]  [<ffffffffa00e9998>] relocate_tree_blocks+0x2d8/0x690 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.743411]  [<ffffffffa00e82f0>] ? add_data_references+0x2b0/0x2e0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.749244]  [<ffffffffa00eab89>] relocate_block_group+0x249/0x640 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.755056]  [<ffffffffa00eb11f>] btrfs_relocate_block_group+0x19f/0x2c0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.760943]  [<ffffffffa00c20cb>] btrfs_relocate_chunk.clone.58+0x7b/0x7e0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.766797]  [<ffffffffa00d2c48>] ? btrfs_set_lock_blocking_rw+0xd8/0x120 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.772605]  [<ffffffff81613a61>] ? _raw_spin_unlock+0x11/0x40
Aug 19 22:30:58 lutz kernel: [31959.778399]  [<ffffffffa00b7a91>] ? release_extent_buffer+0xb1/0xe0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.784244]  [<ffffffffa00bd4a8>] ? free_extent_buffer+0x58/0xb0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.790115]  [<ffffffffa00c5daf>] btrfs_balance+0x89f/0xe50 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.795956]  [<ffffffff812fa531>] ? __percpu_counter_add+0x71/0xb0
Aug 19 22:30:58 lutz kernel: [31959.801813]  [<ffffffff81144207>] ? kmem_cache_alloc_trace+0xe7/0x180
Aug 19 22:30:58 lutz kernel: [31959.807724]  [<ffffffffa00cf200>] ? btrfs_ioctl_balance+0x1b0/0x340 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.813685]  [<ffffffffa00cf272>] btrfs_ioctl_balance+0x222/0x340 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.819658]  [<ffffffffa00d0dea>] btrfs_ioctl+0x58a/0x1af0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.825589]  [<ffffffff81122bdb>] ? handle_mm_fault+0x13b/0x210
Aug 19 22:30:58 lutz kernel: [31959.831544]  [<ffffffff81617124>] ? __do_page_fault+0x1c4/0x530
Aug 19 22:30:58 lutz kernel: [31959.837480]  [<ffffffff8115cab6>] do_vfs_ioctl+0x86/0x4d0
Aug 19 22:30:58 lutz kernel: [31959.843401]  [<ffffffff81127967>] ? do_brk+0x1a7/0x2f0
Aug 19 22:30:58 lutz kernel: [31959.849316]  [<ffffffff811561f1>] ? final_putname+0x21/0x50
Aug 19 22:30:58 lutz kernel: [31959.855241]  [<ffffffff8115cf91>] SyS_ioctl+0x91/0xa0
Aug 19 22:30:58 lutz kernel: [31959.861178]  [<ffffffff8161b012>] system_call_fastpath+0x16/0x1b
Aug 19 22:30:58 lutz kernel: [31959.867154] Code: ff ff 48 89 df e8 44 bd f8 ff 48 8b bd 38 ff ff ff e8 38 bd f8 ff 48 83 bd 20 ff ff ff 00 0f 84 e5 ef ff ff e9 66 ff ff ff 0f 0b <0f> 0b 48 8b 8d 20 ff ff ff 49 8d 7f 20 48 8b 71 18 48 89 ca e8 
Aug 19 22:30:58 lutz kernel: [31959.873715] RIP  [<ffffffffa00e963d>] build_backref_tree+0x119d/0x1220 [btrfs]
Aug 19 22:30:58 lutz kernel: [31959.879915]  RSP <ffff88009e641868>
Aug 19 22:30:58 lutz kernel: [31959.931299] ---[ end trace 1c4397b1b9d76036 ]---
Aug 19 22:30:58 lutz kernel: [31959.931474] BUG: unable to handle kernel paging request at 000000000008a940
Aug 19 22:30:58 lutz kernel: [31959.933012] IP: [<ffffffff8123ff88>] jbd2__journal_start+0x48/0x200
Aug 19 22:30:58 lutz kernel: [31959.934555] PGD 0 
Aug 19 22:30:58 lutz kernel: [31959.936078] Oops: 0000 [#2] PREEMPT SMP 
Aug 19 22:30:58 lutz kernel: [31959.937607] Modules linked in: pppoe pppox binfmt_misc parport_pc ppdev snd_hda_codec_hdmi snd_hda_intel snd_es1938 snd_hda_codec gameport snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_opl3_lib snd_hwdep snd_mpu401_uart snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq asus_atk0110 snd_rawmidi radeon snd_timer snd_seq_device psmouse fbcon edac_core tileblit serio_raw font bitblit softcursor ttm i2c_piix4 snd drm_kms_helper drm soundcore snd_page_alloc i2c_algo_bit hwmon_vid lp parport usbhid btrfs raid6_pq r8169 mii xor zlib_deflate xhci_hcd libcrc32c
Aug 19 22:30:58 lutz kernel: [31959.942733] CPU: 5 PID: 11880 Comm: btrfs Tainted: G      D      3.11.0-rc6 #1
Aug 19 22:30:58 lutz kernel: [31959.944447] Hardware name: System manufacturer System Product Name/M4A87TD/USB3, BIOS 1202    02/17/2011
Aug 19 22:30:58 lutz kernel: [31959.946188] task: ffff88022d9816b0 ti: ffff88009e640000 task.ti: ffff88009e640000
Aug 19 22:30:58 lutz kernel: [31959.947946] RIP: 0010:[<ffffffff8123ff88>]  [<ffffffff8123ff88>] jbd2__journal_start+0x48/0x200
Aug 19 22:30:58 lutz kernel: [31959.949743] RSP: 0018:ffff88009e6410d8  EFLAGS: 00010286
Aug 19 22:30:58 lutz kernel: [31959.951547] RAX: 000000000008a940 RBX: ffff88022c448e60 RCX: 0000000000000050
Aug 19 22:30:58 lutz kernel: [31959.953359] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88022b418000
Aug 19 22:30:58 lutz kernel: [31959.955175] RBP: ffff88009e641128 R08: 0000000000000001 R09: 000000000000134b
Aug 19 22:30:58 lutz kernel: [31959.956995] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88022b418000
Aug 19 22:30:58 lutz kernel: [31959.958815] R13: 000000000000134b R14: 0000000000000001 R15: 0000000000000002
Aug 19 22:30:58 lutz kernel: [31959.960620] FS:  00007f68c9ae8760(0000) GS:ffff880237d40000(0000) knlGS:0000000009e8d840
Aug 19 22:30:58 lutz kernel: [31959.962421] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 19 22:30:58 lutz kernel: [31959.964206] CR2: 000000000008a940 CR3: 0000000001c0b000 CR4: 00000000000007e0
Aug 19 22:30:58 lutz kernel: [31959.966061] Stack:
Aug 19 22:30:58 lutz kernel: [31959.967894]  ffff88009e641108 ffff880237ffa600 ffff880237ffac00 ffff88009e641118
Aug 19 22:30:58 lutz kernel: [31959.969800]  ffffffff81118cf9 ffff88022b049800 0000000000000001 ffffffff811f5a1f
Aug 19 22:30:58 lutz kernel: [31959.971665]  0000000000000000 0000000000000002 ffff88009e641178 ffffffff8121d0a0
Aug 19 22:30:58 lutz kernel: [31959.973495] Call Trace:
Aug 19 22:30:58 lutz kernel: [31959.975321]  [<ffffffff81118cf9>] ? zone_statistics+0x99/0xc0
Aug 19 22:30:58 lutz kernel: [31959.977163]  [<ffffffff811f5a1f>] ? ext4_dirty_inode+0x2f/0x70
Aug 19 22:30:58 lutz kernel: [31959.978997]  [<ffffffff8121d0a0>] __ext4_journal_start_sb+0x70/0x100
Aug 19 22:30:58 lutz kernel: [31959.980827]  [<ffffffff811f5a1f>] ext4_dirty_inode+0x2f/0x70
Aug 19 22:30:58 lutz kernel: [31959.982602]  [<ffffffff81173e1f>] __mark_inode_dirty+0x4f/0x310
Aug 19 22:30:58 lutz kernel: [31959.984319]  [<ffffffff81163bb1>] update_time+0x81/0xc0
Aug 19 22:30:58 lutz kernel: [31959.985974]  [<ffffffff81163c84>] file_update_time+0x94/0xf0
Aug 19 22:30:58 lutz kernel: [31959.987885]  [<ffffffff810fdb4c>] __generic_file_aio_write+0x17c/0x3c0
Aug 19 22:30:58 lutz kernel: [31959.989752]  [<ffffffff812e6afa>] ? put_dec+0x6a/0x80
Aug 19 22:30:58 lutz kernel: [31959.991374]  [<ffffffff810fddf2>] generic_file_aio_write+0x62/0xc0
Aug 19 22:30:58 lutz kernel: [31959.992976]  [<ffffffff811e9cab>] ext4_file_write+0x5b/0x430
Aug 19 22:30:58 lutz kernel: [31959.994564]  [<ffffffff8114263a>] ? __slab_free+0x27a/0x480
Aug 19 22:30:58 lutz kernel: [31959.996143]  [<ffffffff8114a6a5>] do_sync_write+0x75/0xb0
Aug 19 22:30:58 lutz kernel: [31959.997718]  [<ffffffff810a91bc>] do_acct_process+0x32c/0x3d0
Aug 19 22:30:58 lutz kernel: [31959.999289]  [<ffffffff810a98c1>] acct_process+0x71/0xa0
Aug 19 22:30:58 lutz kernel: [31960.000855]  [<ffffffff810491b1>] do_exit+0x7c1/0xaa0
Aug 19 22:30:58 lutz kernel: [31960.002417]  [<ffffffff8160f26b>] ? printk+0x48/0x4a
Aug 19 22:30:58 lutz kernel: [31960.003963]  [<ffffffff81091069>] ? kmsg_dump+0xb9/0xd0
Aug 19 22:30:58 lutz kernel: [31960.005499]  [<ffffffff81614e61>] oops_end+0xa1/0xf0
Aug 19 22:30:58 lutz kernel: [31960.007024]  [<ffffffff81006e16>] die+0x56/0x90
Aug 19 22:30:58 lutz kernel: [31960.008534]  [<ffffffff8161482b>] do_trap+0xbb/0x160
Aug 19 22:30:58 lutz kernel: [31960.010213]  [<ffffffff81004130>] do_invalid_op+0x90/0xb0
Aug 19 22:30:58 lutz kernel: [31960.011959]  [<ffffffffa00e963d>] ? build_backref_tree+0x119d/0x1220 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.013481]  [<ffffffff8161c508>] invalid_op+0x18/0x20
Aug 19 22:30:58 lutz kernel: [31960.014988]  [<ffffffffa00e963d>] ? build_backref_tree+0x119d/0x1220 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.016495]  [<ffffffffa00e94e2>] ? build_backref_tree+0x1042/0x1220 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.017995]  [<ffffffffa00e9998>] relocate_tree_blocks+0x2d8/0x690 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.019492]  [<ffffffffa00e82f0>] ? add_data_references+0x2b0/0x2e0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.020986]  [<ffffffffa00eab89>] relocate_block_group+0x249/0x640 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.022482]  [<ffffffffa00eb11f>] btrfs_relocate_block_group+0x19f/0x2c0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.024016]  [<ffffffffa00c20cb>] btrfs_relocate_chunk.clone.58+0x7b/0x7e0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.025504]  [<ffffffffa00d2c48>] ? btrfs_set_lock_blocking_rw+0xd8/0x120 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.026987]  [<ffffffff81613a61>] ? _raw_spin_unlock+0x11/0x40
Aug 19 22:30:58 lutz kernel: [31960.028474]  [<ffffffffa00b7a91>] ? release_extent_buffer+0xb1/0xe0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.029967]  [<ffffffffa00bd4a8>] ? free_extent_buffer+0x58/0xb0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.031459]  [<ffffffffa00c5daf>] btrfs_balance+0x89f/0xe50 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.032942]  [<ffffffff812fa531>] ? __percpu_counter_add+0x71/0xb0
Aug 19 22:30:58 lutz kernel: [31960.034422]  [<ffffffff81144207>] ? kmem_cache_alloc_trace+0xe7/0x180
Aug 19 22:30:58 lutz kernel: [31960.035910]  [<ffffffffa00cf200>] ? btrfs_ioctl_balance+0x1b0/0x340 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.037404]  [<ffffffffa00cf272>] btrfs_ioctl_balance+0x222/0x340 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.038898]  [<ffffffffa00d0dea>] btrfs_ioctl+0x58a/0x1af0 [btrfs]
Aug 19 22:30:58 lutz kernel: [31960.040385]  [<ffffffff81122bdb>] ? handle_mm_fault+0x13b/0x210
Aug 19 22:30:58 lutz kernel: [31960.041872]  [<ffffffff81617124>] ? __do_page_fault+0x1c4/0x530
Aug 19 22:30:58 lutz kernel: [31960.043357]  [<ffffffff8115cab6>] do_vfs_ioctl+0x86/0x4d0
Aug 19 22:30:58 lutz kernel: [31960.044841]  [<ffffffff81127967>] ? do_brk+0x1a7/0x2f0
Aug 19 22:30:58 lutz kernel: [31960.046324]  [<ffffffff811561f1>] ? final_putname+0x21/0x50
Aug 19 22:30:58 lutz kernel: [31960.047806]  [<ffffffff8115cf91>] SyS_ioctl+0x91/0xa0
Aug 19 22:30:58 lutz kernel: [31960.049240]  [<ffffffff8161b012>] system_call_fastpath+0x16/0x1b
Aug 19 22:30:58 lutz kernel: [31960.050633] Code: 89 fc 4c 89 75 f0 4c 89 7d f8 45 89 c6 48 89 5d d8 41 89 f7 45 89 cd 48 8b 80 08 06 00 00 74 33 48 85 c0 48 89 c3 74 3b 48 8b 00 <48> 3b 38 0f 85 a6 01 00 00 ff 43 14 48 89 d8 4c 8b 65 e0 48 8b 
Aug 19 22:30:58 lutz kernel: [31960.052183] RIP  [<ffffffff8123ff88>] jbd2__journal_start+0x48/0x200
Aug 19 22:30:58 lutz kernel: [31960.053652]  RSP <ffff88009e6410d8>
Aug 19 22:30:58 lutz kernel: [31960.055107] CR2: 000000000008a940
Aug 19 22:30:58 lutz kernel: [31960.056574] ---[ end trace 1c4397b1b9d76037 ]---
Aug 19 22:30:58 lutz kernel: [31960.056575] Fixing recursive fault but reboot is needed!

Syslog entries relating to btrfs at reboot:

Aug 19 22:33:56 lutz kernel: [    2.400885] Btrfs loaded
Aug 19 22:33:56 lutz kernel: [    2.409365] device fsid 88af7576-3027-4a3b-a5ae-34bfd167982f devid 3 transid 567615 /dev/sda3
Aug 19 22:33:56 lutz kernel: [    2.410420] device fsid 88af7576-3027-4a3b-a5ae-34bfd167982f devid 4 transid 567615 /dev/sdb1
Aug 19 22:33:56 lutz kernel: [    3.976490] device fsid 88af7576-3027-4a3b-a5ae-34bfd167982f devid 3 transid 567615 /dev/sda3
Aug 19 22:33:56 lutz kernel: [    4.263380] btrfs: use lzo compression
Aug 19 22:33:56 lutz kernel: [    4.263383] btrfs: disk space caching is enabled
Aug 19 22:33:56 lutz kernel: [    4.290596] Btrfs detected SSD devices, enabling SSD mode
Aug 19 22:33:56 lutz kernel: [    4.359586] BTRFS debug (device sdb1): unlinked 5 orphans
Aug 19 22:33:56 lutz kernel: [    4.359586] BTRFS debug (device sdb1): truncated 2 orphans
Aug 19 22:33:56 lutz kernel: [    4.382089] BTRFS debug (device sdb1): unlinked 1 orphans
Aug 19 22:33:56 lutz kernel: [    4.382148] btrfs: continuing balance
Aug 19 22:33:56 lutz kernel: [    4.575843] btrfs: relocating block group 357651447808 flags 17
Aug 19 22:33:56 lutz kernel: [    5.947512] btrfs: found 6446 extents
Aug 19 22:34:03 lutz kernel: [   12.432288] btrfs: found 6443 extents
