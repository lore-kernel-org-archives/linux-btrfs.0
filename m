Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:26229 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbbEINZO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 May 2015 09:25:14 -0400
Received: from cloud.myjm.de (ipbcc1d2c6.dynamic.kabel-deutschland.de [188.193.210.198])
	by smtp.strato.de (RZmta 37.5 DYNA|AUTH)
	with ESMTPSA id t06455r49DPC21z
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve sect571r1 with 571 ECDH bits, eq. 15360 bits RSA))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Sat, 9 May 2015 15:25:12 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 09 May 2015 15:25:11 +0200
From: =?UTF-8?Q?Michael_G=C3=B6hler?= <visit@myjm.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-transacti exited with =?UTF-8?Q?preempt=5Fcount=20=31=20-?=
 =?UTF-8?Q?=20kernel=20=34=2E=30=2E=30?=
Message-ID: <baf50c44eb4e3fe97d5f5a5d87119e7b@myjm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

my kernel is freezing randomly on my server, after upgrade to 4.0.0.
Downgrade to 3.19.6 fixed it for now.

[  458.586767] kernel BUG at block/blk-core.c:2333!
[  458.586864] invalid opcode: 0000 [#1] PREEMPT SMP
[  458.586989] Modules linked in: xt_conntrack iptable_filter xt_nat 
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat 
nf_conntrack ip_tables x_tables ext4 crc16 mbcache jbd2 
snd_hda_codec_realtek snd_hda_codec_generic evdev mac_hid snd_hda_intel 
snd_hda_controller kvm_amd snd_hda_codec kvm snd_hwdep r8169 psmouse 
serio_raw snd_pcm mii pcspkr snd_timer snd shpchp soundcore i2c_piix4 
button acpi_cpufreq processor sch_fq_codel nfs lockd grace sunrpc 
fscache it87 hwmon_vid k10temp crc32c_generic btrfs xor raid6_pq sd_mod 
uas usb_storage atkbd libps2 ahci libahci ohci_pci libata ohci_hcd 
ehci_pci ehci_hcd scsi_mod usbcore usb_common i8042 serio radeon hwmon 
i2c_algo_bit drm_kms_helper ttm drm i2c_core
[  458.588814] CPU: 1 PID: 127 Comm: btrfs-transacti Not tainted 
4.0.0-1-ck #1
[  458.588952] Hardware name: Hewlett-Packard CQ1102DE/2ACA, BIOS 7.00 
06/28/2011
[  458.589098] task: ffff880233d39000 ti: ffff880233e54000 task.ti: 
ffff880233e54000
[  458.589245] RIP: 0010:[<ffffffff81265198>]  [<ffffffff81265198>] 
blk_dequeue_request+0x88/0xa0
[  458.589433] RSP: 0018:ffff880233e573d0  EFLAGS: 00010046
[  458.589542] RAX: ffff8802338ddb50 RBX: ffff8802338ddb50 RCX: 
ffff880233c68000
[  458.589682] RDX: 000000000000001c RSI: 000000000000001b RDI: 
ffff8802338ddb50
[  458.589822] RBP: ffff880233e573e8 R08: 000000000000001b R09: 
ffff880233c8d800
[  458.589962] R10: ffff880233c68000 R11: 0000000000000000 R12: 
ffff8802338ddb50
[  458.590101] R13: 000000000000001f R14: ffff880233c68000 R15: 
000000000000001f
[  458.590243] FS:  00007f0754c1e700(0000) GS:ffff88023ed00000(0000) 
knlGS:00000000e65ffb40
[  458.590401] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  458.590517] CR2: 00007f98f89dc000 CR3: 000000022ad6e000 CR4: 
00000000000007e0
[  458.590657] Stack:
[  458.590703]  ffffffff812651c6 ffff880233e573f8 ffff880037bb2440 
ffff880233e57438
[  458.590878]  ffffffff812662af 000000000000001f 0000001b33c68000 
ffff880233e57438
[  458.591053]  ffff880234073800 ffff880233c8d800 ffff8802338ddb50 
ffff880233c68000
[  458.591228] Call Trace:
[  458.591290]  [<ffffffff812651c6>] ? blk_start_request+0x16/0x70
[  458.591416]  [<ffffffff812662af>] blk_queue_start_tag+0xcf/0x1d0
[  458.591565]  [<ffffffffa02642fb>] scsi_request_fn+0x2bb/0x5b0 
[scsi_mod]
[  458.591705]  [<ffffffff812616b7>] __blk_run_queue+0x37/0x50
[  458.591823]  [<ffffffff81265d33>] blk_queue_bio+0x373/0x380
[  458.591941]  [<ffffffff812639c0>] generic_make_request+0xe0/0x130
[  458.592067]  [<ffffffff81263a88>] submit_bio+0x78/0x180
[  458.592178]  [<ffffffff8125bc7f>] ? bio_clone_bioset+0xef/0x330
[  458.592348]  [<ffffffffa03ccf73>] submit_stripe_bio+0x63/0x90 [btrfs]
[  458.592513]  [<ffffffffa03d2f52>] btrfs_map_bio+0x312/0x570 [btrfs]
[  458.592674]  [<ffffffffa03d1c9d>] ? __btrfs_map_block+0x64d/0x1220 
[btrfs]
[  458.592818]  [<ffffffff81141d11>] ? mempool_alloc+0x61/0x170
[  458.592967]  [<ffffffffa03a73ad>] btrfs_submit_bio_hook+0xed/0x1d0 
[btrfs]
[  458.593140]  [<ffffffffa03c1a27>] submit_one_bio+0x67/0xa0 [btrfs]
[  458.593301]  [<ffffffffa03c5627>] 
submit_extent_page.isra.36+0xd7/0x210 [btrfs]
[  458.593481]  [<ffffffffa03c5db7>] __extent_writepage_io+0x457/0x4a0 
[btrfs]
[  458.593656]  [<ffffffffa03c53b0>] ? end_extent_writepage+0x90/0x90 
[btrfs]
[  458.593830]  [<ffffffffa03c6040>] __extent_writepage+0x240/0x340 
[btrfs]
[  458.598627]  [<ffffffffa03c6482>] 
extent_write_cache_pages.isra.30.constprop.46+0x342/0x410 [btrfs]
[  458.603520]  [<ffffffffa03c834c>] extent_writepages+0x5c/0x90 [btrfs]
[  458.608422]  [<ffffffffa03a9470>] ? btrfs_direct_IO+0x3d0/0x3d0 
[btrfs]
[  458.613302]  [<ffffffffa03a79a8>] btrfs_writepages+0x28/0x30 [btrfs]
[  458.618117]  [<ffffffff8114b1de>] do_writepages+0x1e/0x30
[  458.622935]  [<ffffffff81140635>] 
__filemap_fdatawrite_range+0x65/0x90
[  458.627666]  [<ffffffff81140723>] filemap_fdatawrite_range+0x13/0x20
[  458.632311]  [<ffffffffa03bb5b4>] btrfs_fdatawrite_range+0x24/0x60 
[btrfs]
[  458.636863]  [<ffffffffa03c11af>] btrfs_wait_ordered_range+0x4f/0x120 
[btrfs]
[  458.641301]  [<ffffffffa03ebea7>] __btrfs_write_out_cache+0x387/0x470 
[btrfs]
[  458.645627]  [<ffffffffa03ed2aa>] btrfs_write_out_cache+0x9a/0x100 
[btrfs]
[  458.649832]  [<ffffffffa0393ad2>] 
btrfs_write_dirty_block_groups+0x152/0x210 [btrfs]
[  458.654008]  [<ffffffffa04210c2>] commit_cowonly_roots+0x1fd/0x2ab 
[btrfs]
[  458.658209]  [<ffffffffa03a4c15>] 
btrfs_commit_transaction+0x595/0xc20 [btrfs]
[  458.662394]  [<ffffffffa03a5333>] ? start_transaction+0x93/0x5c0 
[btrfs]
[  458.666527]  [<ffffffffa03a02c5>] transaction_kthread+0x1d5/0x240 
[btrfs]
[  458.670611]  [<ffffffffa03a00f0>] ? 
btrfs_cleanup_transaction+0x5a0/0x5a0 [btrfs]
[  458.674666]  [<ffffffff81091088>] kthread+0xd8/0xf0
[  458.678697]  [<ffffffff81090fb0>] ? 
kthread_create_on_node+0x1c0/0x1c0
[  458.682780]  [<ffffffff8154d458>] ret_from_fork+0x58/0x90
[  458.686889]  [<ffffffff81090fb0>] ? 
kthread_create_on_node+0x1c0/0x1c0
[  458.690997] Code: 00 00 01 65 ff 05 a9 67 da 7e e8 44 a8 db ff 48 89 
83 e8 00 00 00 65 ff 0d 96 67 da 7e 74 1c 48 83 c4 08 5b 5d c3 0f 1f 44 
00 00 <0f> 0b 66 0f 1f 44 00 00 0f 0b 66 0f 1f 44 00 00 e8 24 2d 04 00
[  458.699986] RIP  [<ffffffff81265198>] blk_dequeue_request+0x88/0xa0
[  458.704226]  RSP <ffff880233e573d0>
[  458.708390] ---[ end trace d6c55e4e70588a8b ]---
[  458.712533] note: btrfs-transacti[127] exited with preempt_count 1

--
Michael Goehler
