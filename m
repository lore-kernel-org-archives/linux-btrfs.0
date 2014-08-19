Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38305 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752420AbaHSCgD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 22:36:03 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [BUG] 3.17 rc1 kernel BUG at fs/btrfs/extent_io.c:2124! oops when reading corrupt file on btrfs raid5
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <D3417AF1-C87C-493C-9D58-6A81CDA13333@colorremedies.com>
Date: Mon, 18 Aug 2014 20:36:00 -0600
Cc: Chris Mason <clm@fb.com>
Message-Id: <AB064F92-D268-4D1A-9A39-FCE8913FB621@colorremedies.com>
References: <E7CC2628-F28A-4431-86D7-0572F6C9F296@colorremedies.com> <D3417AF1-C87C-493C-9D58-6A81CDA13333@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reproduces in a not tainted kernel 3.17.0-0.rc1.git0.1.fc22.x86_64. I still used btrfs-progs v3.14.2-167-ge514381 to create the new raid5 volume, so it seems whatever fixed it in for-linus is not in for-linus2.



[   45.935848] BTRFS info (device sdc): disk space caching is enabled
[   54.820386] BTRFS info (device sdc): csum failed ino 257 off 0 csum 2566472073 expected csum 2759032090
[   55.069845] BTRFS info (device sdc): csum failed ino 257 off 4096 csum 3231022384 expected csum 2759032090
[   55.320244] BTRFS info (device sdc): csum failed ino 257 off 8192 csum 3303363542 expected csum 2759032090
[   55.320281] BTRFS info (device sdc): csum failed ino 257 off 0 csum 2566472073 expected csum 2759032090
[   55.528435] BTRFS info (device sdc): csum failed ino 257 off 12288 csum 2295875483 expected csum 2759032090
[   55.528506] ------------[ cut here ]------------
[   55.528510] kernel BUG at fs/btrfs/extent_io.c:2124!
[   55.528516] invalid opcode: 0000 [#1] SMP 
[   55.528528] Modules linked in: cfg80211 rfkill btrfs snd_intel8x0 snd_ac97_codec ac97_bus xor snd_seq ppdev snd_seq_device raid6_pq snd_pcm drm microcode snd_timer serio_raw snd parport_pc parport i2c_piix4 soundcore xfs libcrc32c virtio_net virtio_pci virtio_ring ata_generic pata_acpi virtio
[   55.528532] CPU: 3 PID: 88 Comm: kworker/u8:7 Not tainted 3.17.0-0.rc1.git0.1.fc22.x86_64 #1
[   55.528535] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   55.528556] Workqueue: btrfs-endio normal_work_helper [btrfs]
[   55.528559] BTRFS info (device sdc): csum failed ino 257 off 0 csum 2566472073 expected csum 2759032090
[   55.528561] 
[   55.528564] task: ffff8800d7152700 ti: ffff8800d729c000 task.ti: ffff8800d729c000
[   55.528578] RIP: 0010:[<ffffffffa02d6055>]  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[   55.528581] RSP: 0018:ffff8800d729fca8  EFLAGS: 00010246
[   55.528584] RAX: 0000000000000000 RBX: ffffea00033bc380 RCX: ffff8800d7f130d0
[   55.528586] RDX: ffff8800d7f130e0 RSI: ffff8800d7f130c0 RDI: 0000000000000000
[   55.528589] RBP: ffff8800d729fd78 R08: 0000000000000001 R09: 0000000000000000
[   55.528592] R10: ffff8800d7f1c578 R11: ffff8800d99d9100 R12: ffff8800d7f1c578
[   55.528595] R13: 0000000000001000 R14: ffff8800da481770 R15: 0000000000001000
[   55.528598] FS:  0000000000000000(0000) GS:ffff8800dfb80000(0000) knlGS:0000000000000000
[   55.528601] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   55.528603] CR2: 00007f634dd101ae CR3: 00000000d964a000 CR4: 00000000000006e0
[   55.528608] Stack:
[   55.528614]  0000000180150010 ffffffff810c3ef8 ffff8800d729fd00 ffffffff810ca969
[   55.528619]  ffff8800d729fcd8 ffff8800d7f1c3e0 ffff8800d950b000 ffff8800d7f1c578
[   55.528625]  ffff8800da481680 ffff8800d7f1c578 ffff8800d7f1c420 0000000000000000
[   55.528627] Call Trace:
[   55.528636]  [<ffffffff810c3ef8>] ? __enqueue_entity+0x78/0x80
[   55.528643]  [<ffffffff810ca969>] ? enqueue_entity+0x2e9/0x990
[   55.528649]  [<ffffffff813464ab>] bio_endio+0x6b/0xa0
[   55.528655]  [<ffffffff813464f2>] bio_endio_nodec+0x12/0x20
[   55.528666]  [<ffffffffa02ab217>] end_workqueue_fn+0x37/0x40 [btrfs]
[   55.528678]  [<ffffffffa02e4b5d>] normal_work_helper+0xbd/0x280 [btrfs]
[   55.528685]  [<ffffffff810ac4fe>] process_one_work+0x17e/0x430
[   55.528690]  [<ffffffff810ace8b>] worker_thread+0x6b/0x4a0
[   55.528696]  [<ffffffff810ace20>] ? rescuer_thread+0x2a0/0x2a0
[   55.528702]  [<ffffffff810b1fca>] kthread+0xea/0x100
[   55.528708]  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0
[   55.528715]  [<ffffffff8173dd7c>] ret_from_fork+0x7c/0xb0
[   55.528721]  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0
[   55.528735] Code: ff ff ff 4c 8b 9d 78 ff ff ff e9 a8 f9 ff ff 0f 1f 80 00 00 00 00 c7 01 00 00 00 00 c7 44 11 fc 00 00 00 00 e9 e5 f8 ff ff 0f 0b <0f> 0b f6 05 e4 d1 06 00 04 74 29 41 8b 4a 28 45 89 d8 ba 01 00 
[   55.528747] RIP  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[   55.528750]  RSP <ffff8800d729fca8>
[   55.528754] ---[ end trace 7c59083c4a090f24 ]---
[   55.528796] BUG: unable to handle kernel paging request at ffffffffffffffd8
[   55.528818] IP: [<ffffffff810b2600>] kthread_data+0x10/0x20
[   55.528824] PGD 1c17067 PUD 1c19067 PMD 0 
[   55.528829] Oops: 0000 [#2] SMP 
[   55.528840] Modules linked in: cfg80211 rfkill btrfs snd_intel8x0 snd_ac97_codec ac97_bus xor snd_seq ppdev snd_seq_device raid6_pq snd_pcm drm microcode snd_timer serio_raw snd parport_pc parport i2c_piix4 soundcore xfs libcrc32c virtio_net virtio_pci virtio_ring ata_generic pata_acpi virtio
[   55.528844] CPU: 3 PID: 88 Comm: kworker/u8:7 Tainted: G      D        3.17.0-0.rc1.git0.1.fc22.x86_64 #1
[   55.528846] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   55.528855] task: ffff8800d7152700 ti: ffff8800d729c000 task.ti: ffff8800d729c000
[   55.528861] RIP: 0010:[<ffffffff810b2600>]  [<ffffffff810b2600>] kthread_data+0x10/0x20
[   55.528863] RSP: 0018:ffff8800d729f950  EFLAGS: 00010002
[   55.528866] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000001
[   55.528869] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff8800d7152700
[   55.528871] RBP: ffff8800d729f950 R08: ffff8800d7152790 R09: 0000000000000001
[   55.528874] R10: ffff8800dfb99250 R11: ffff8800d711ed68 R12: ffff8800dfb94b80
[   55.528876] R13: ffff8800d7152bc0 R14: 0000000000000003 R15: ffff8800d7152700
[   55.528879] FS:  0000000000000000(0000) GS:ffff8800dfb80000(0000) knlGS:0000000000000000
[   55.528882] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   55.528885] CR2: 0000000000000028 CR3: 00000000d964a000 CR4: 00000000000006e0
[   55.528889] Stack:
[   55.528895]  ffff8800d729f968 ffffffff810ad341 0000000000000000 ffff8800d729f9d0
[   55.528900]  ffffffff8173927c ffff8800d7152700 0000000000014b80 ffff8800d729ffd8
[   55.528905]  0000000000014b80 ffff8800d729f9c8 ffff8800d7152700 ffff8800d7152dd8
[   55.528907] Call Trace:
[   55.528913]  [<ffffffff810ad341>] wq_worker_sleeping+0x11/0xa0
[   55.528920]  [<ffffffff8173927c>] __schedule+0x69c/0x840
[   55.528927]  [<ffffffff81739449>] schedule+0x29/0x70
[   55.528933]  [<ffffffff81096a68>] do_exit+0x838/0xa90
[   55.528940]  [<ffffffff8101755c>] oops_end+0x9c/0xe0
[   55.528946]  [<ffffffff81017a2b>] die+0x4b/0x70
[   55.528952]  [<ffffffff8101402a>] do_trap+0xba/0x150
[   55.528957]  [<ffffffff810143e5>] do_error_trap+0x95/0x130
[   55.528969]  [<ffffffffa02d6055>] ? end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[   55.528975]  [<ffffffff8133f137>] ? chksum_update+0x17/0x20
[   55.528981]  [<ffffffff81330536>] ? crypto_shash_update+0x36/0x100
[   55.528987]  [<ffffffff81014ca0>] do_invalid_op+0x20/0x30
[   55.528993]  [<ffffffff8173f7de>] invalid_op+0x1e/0x30
[   55.529003]  [<ffffffffa02d6055>] ? end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[   55.529020]  [<ffffffffa02d599e>] ? end_bio_extent_readpage+0x48e/0xcd0 [btrfs]
[   55.529026]  [<ffffffff810c3ef8>] ? __enqueue_entity+0x78/0x80
[   55.529032]  [<ffffffff810ca969>] ? enqueue_entity+0x2e9/0x990
[   55.529038]  [<ffffffff813464ab>] bio_endio+0x6b/0xa0
[   55.529043]  [<ffffffff813464f2>] bio_endio_nodec+0x12/0x20
[   55.529173]  [<ffffffffa02ab217>] end_workqueue_fn+0x37/0x40 [btrfs]
[   55.529184]  [<ffffffffa02e4b5d>] normal_work_helper+0xbd/0x280 [btrfs]
[   55.529190]  [<ffffffff810ac4fe>] process_one_work+0x17e/0x430
[   55.529196]  [<ffffffff810ace8b>] worker_thread+0x6b/0x4a0
[   55.529201]  [<ffffffff810ace20>] ? rescuer_thread+0x2a0/0x2a0
[   55.529207]  [<ffffffff810b1fca>] kthread+0xea/0x100
[   55.529213]  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0
[   55.529225]  [<ffffffff8173dd7c>] ret_from_fork+0x7c/0xb0
[   55.529231]  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0
[   55.529245] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 68 04 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[   55.529251] RIP  [<ffffffff810b2600>] kthread_data+0x10/0x20
[   55.529253]  RSP <ffff8800d729f950>
[   55.529255] CR2: ffffffffffffffd8
[   55.529259] ---[ end trace 7c59083c4a090f25 ]---
[   55.529261] Fixing recursive fault but reboot is needed!
[   57.966296] BTRFS info (device sdc): csum failed ino 257 off 16384 csum 1837874343 expected csum 2759032090
[   58.057671] BTRFS info (device sdc): csum failed ino 257 off 20480 csum 4011747594 expected csum 2759032090
[   58.078409] BTRFS info (device sdc): csum failed ino 257 off 24576 csum 199417701 expected csum 2759032090
[   58.220004] BTRFS info (device sdc): csum failed ino 257 off 28672 csum 802473067 expected csum 2759032090
[   58.400004] ------------[ cut here ]------------
[   58.400874] kernel BUG at fs/btrfs/extent_io.c:2124!
[   58.400874] invalid opcode: 0000 [#3] SMP 
[   58.400874] Modules linked in: cfg80211 rfkill btrfs snd_intel8x0 snd_ac97_codec ac97_bus xor snd_seq ppdev snd_seq_device raid6_pq snd_pcm drm microcode snd_timer serio_raw snd parport_pc parport i2c_piix4 soundcore xfs libcrc32c virtio_net virtio_pci virtio_ring ata_generic pata_acpi virtio
[   58.400874] CPU: 0 PID: 87 Comm: kworker/u8:6 Tainted: G      D        3.17.0-0.rc1.git0.1.fc22.x86_64 #1
[   58.400874] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   58.400874] Workqueue: btrfs-endio normal_work_helper [btrfs]
[   58.400874] task: ffff8800da6b6b40 ti: ffff8800d7298000 task.ti: ffff8800d7298000
[   58.400874] RIP: 0010:[<ffffffffa02d6055>]  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[   58.400874] RSP: 0018:ffff8800d729bca8  EFLAGS: 00010246
[   58.400874] RAX: 0000000000000000 RBX: ffffea00033bc340 RCX: ffff8800d7f13190
[   58.400874] RDX: ffff8800d7f131a0 RSI: ffff8800d7f13180 RDI: 0000000000000000
[   58.400874] RBP: ffff8800d729bd78 R08: 0000000000000001 R09: 0000000000000000
[   58.400874] R10: ffff8800d7f1c578 R11: ffff8800d99d9dc0 R12: ffff8800d7f1c578
[   58.400874] R13: 0000000000002000 R14: ffff8800da4818b0 R15: 0000000000001000
[   58.400874] FS:  0000000000000000(0000) GS:ffff8800dfa00000(0000) knlGS:0000000000000000
[   58.400874] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   58.400874] CR2: 0000000001773ac8 CR3: 00000000d88fc000 CR4: 00000000000006f0
[   58.400874] Stack:
[   58.400874]  0000000000000000 0000000000000050 ffff8800dfa14b80 0000000000014b80
[   58.400874]  0000000000000000 ffff8800d7f1c3e0 ffff8800d950b000 ffff8800d7f1c578
[   58.400874]  ffff8800da4817c0 ffff8800d7f1c578 ffff8800d7f1c420 0000000000000000
[   58.400874] Call Trace:
[   58.400874]  [<ffffffff813464ab>] bio_endio+0x6b/0xa0
[   58.400874]  [<ffffffff813464f2>] bio_endio_nodec+0x12/0x20
[   58.400874]  [<ffffffffa02ab217>] end_workqueue_fn+0x37/0x40 [btrfs]
[   58.400874]  [<ffffffffa02e4b5d>] normal_work_helper+0xbd/0x280 [btrfs]
[   58.400874]  [<ffffffff810ac4fe>] process_one_work+0x17e/0x430
[   58.400874]  [<ffffffff810ace8b>] worker_thread+0x6b/0x4a0
[   58.400874]  [<ffffffff810ace20>] ? rescuer_thread+0x2a0/0x2a0
[   58.400874]  [<ffffffff810b1fca>] kthread+0xea/0x100
[   58.400874]  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0
[   58.400874]  [<ffffffff8173dd7c>] ret_from_fork+0x7c/0xb0
[   58.400874]  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0
[   58.400874] Code: ff ff ff 4c 8b 9d 78 ff ff ff e9 a8 f9 ff ff 0f 1f 80 00 00 00 00 c7 01 00 00 00 00 c7 44 11 fc 00 00 00 00 e9 e5 f8 ff ff 0f 0b <0f> 0b f6 05 e4 d1 06 00 04 74 29 41 8b 4a 28 45 89 d8 ba 01 00 
[   58.400874] RIP  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[   58.400874]  RSP <ffff8800d729bca8>
[   58.823707] ---[ end trace 7c59083c4a090f26 ]---
[   58.826683] BUG: unable to handle kernel paging request at ffffffffffffffd8
[   58.827611] IP: [<ffffffff810b2600>] kthread_data+0x10/0x20
[   58.827611] PGD 1c17067 PUD 1c19067 PMD 0 
[   58.827611] Oops: 0000 [#4] SMP 
[   58.827611] Modules linked in: cfg80211 rfkill btrfs snd_intel8x0 snd_ac97_codec ac97_bus xor snd_seq ppdev snd_seq_device raid6_pq snd_pcm drm microcode snd_timer serio_raw snd parport_pc parport i2c_piix4 soundcore xfs libcrc32c virtio_net virtio_pci virtio_ring ata_generic pata_acpi virtio
[   58.827611] CPU: 0 PID: 87 Comm: kworker/u8:6 Tainted: G      D        3.17.0-0.rc1.git0.1.fc22.x86_64 #1
[   58.827611] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   58.827611] task: ffff8800da6b6b40 ti: ffff8800d7298000 task.ti: ffff8800d7298000
[   58.827611] RIP: 0010:[<ffffffff810b2600>]  [<ffffffff810b2600>] kthread_data+0x10/0x20
[   58.827611] RSP: 0018:ffff8800d729b950  EFLAGS: 00010002
[   58.827611] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000004
[   58.827611] RDX: 000000000000000f RSI: 0000000000000000 RDI: ffff8800da6b6b40
[   58.827611] RBP: ffff8800d729b950 R08: ffff8800da6b6bd0 R09: 0000000000000001
[   58.827611] R10: ffff8800dfa19250 R11: ffff8800368fb000 R12: ffff8800dfa14b80
[   58.827611] R13: ffff8800da6b7000 R14: 0000000000000000 R15: ffff8800da6b6b40
[   58.827611] FS:  0000000000000000(0000) GS:ffff8800dfa00000(0000) knlGS:0000000000000000
[   58.827611] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   58.827611] CR2: 0000000000000028 CR3: 00000000d88fc000 CR4: 00000000000006f0
[   58.827611] Stack:
[   58.827611]  ffff8800d729b968 ffffffff810ad341 0000000000000000 ffff8800d729b9d0
[   58.827611]  ffffffff8173927c ffff8800da6b6b40 0000000000014b80 ffff8800d729bfd8
[   58.827611]  0000000000014b80 ffff8800d729b9c8 ffff8800da6b6b40 ffff8800da6b7218
[   58.827611] Call Trace:
[   58.827611]  [<ffffffff810ad341>] wq_worker_sleeping+0x11/0xa0
[   58.827611]  [<ffffffff8173927c>] __schedule+0x69c/0x840
[   58.827611]  [<ffffffff81739449>] schedule+0x29/0x70
[   58.827611]  [<ffffffff81096a68>] do_exit+0x838/0xa90
[   58.827611]  [<ffffffff8101755c>] oops_end+0x9c/0xe0
[   58.827611]  [<ffffffff81017a2b>] die+0x4b/0x70
[   58.827611]  [<ffffffff8101402a>] do_trap+0xba/0x150
[   58.827611]  [<ffffffff810143e5>] do_error_trap+0x95/0x130
[   58.827611]  [<ffffffffa02d6055>] ? end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[   58.827611]  [<ffffffff8133f137>] ? chksum_update+0x17/0x20
[   58.827611]  [<ffffffff81330536>] ? crypto_shash_update+0x36/0x100
[   58.827611]  [<ffffffff81014ca0>] do_invalid_op+0x20/0x30
[   58.827611]  [<ffffffff8173f7de>] invalid_op+0x1e/0x30
[   58.827611]  [<ffffffffa02d6055>] ? end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
[   58.827611]  [<ffffffffa02d599e>] ? end_bio_extent_readpage+0x48e/0xcd0 [btrfs]
[   58.827611]  [<ffffffff813464ab>] bio_endio+0x6b/0xa0
[   58.827611]  [<ffffffff813464f2>] bio_endio_nodec+0x12/0x20
[   58.827611]  [<ffffffffa02ab217>] end_workqueue_fn+0x37/0x40 [btrfs]
[   58.827611]  [<ffffffffa02e4b5d>] normal_work_helper+0xbd/0x280 [btrfs]
[   58.827611]  [<ffffffff810ac4fe>] process_one_work+0x17e/0x430
[   58.827611]  [<ffffffff810ace8b>] worker_thread+0x6b/0x4a0
[   58.827611]  [<ffffffff810ace20>] ? rescuer_thread+0x2a0/0x2a0
[   58.827611]  [<ffffffff810b1fca>] kthread+0xea/0x100
[   58.827611]  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0
[   58.827611]  [<ffffffff8173dd7c>] ret_from_fork+0x7c/0xb0
[   58.827611]  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0
[   58.827611] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 68 04 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[   58.827611] RIP  [<ffffffff810b2600>] kthread_data+0x10/0x20
[   58.827611]  RSP <ffff8800d729b950>
[   58.827611] CR2: ffffffffffffffd8
[   58.827611] ---[ end trace 7c59083c4a090f27 ]---
[   58.827611] Fixing recursive fault but reboot is needed!

