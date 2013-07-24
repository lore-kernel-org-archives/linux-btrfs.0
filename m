Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:39613 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3GXIE0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jul 2013 04:04:26 -0400
Message-ID: <51EF8A88.9030002@giantdisaster.de>
Date: Wed, 24 Jul 2013 10:04:24 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: =?UTF-8?B?SmFyb3PFgmF3IFNpZWJlcnQ=?= <jsiebert@poczta.wp.pl>
CC: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/ctree.c:1145
References: <2281947.y0ajIxBEPp@dljproject>
In-Reply-To: <2281947.y0ajIxBEPp@dljproject>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 24 Jul 2013 04:39:39 +0200, Jarosław Siebert wrote:
> Hello,
> Since 3.7.X kernel series I noticed kernel BUG in btrfs.
> I use:
> Linux demo 3.9.11-dlj #1 SMP Tue Jul 23 04:45:02 CEST 2013 x86_64 AMD 
> FX(tm)-8150 Eight-Core Processor AuthenticAMD GNU/Linux.
> I notice below BUG once per day.
> After the BUG, the system stop running some processes,  and can't be 
> restarted.
> I can run new ssh session and watch the dmesg.
> I tested 3.10.2 with te same result.
> I hope you can fix it. I will switch to longterm kernel.
> BTRFS mount options:
> defaults,compress=no,autodefrag,discard,ssd
> 
> log from this BUG below:
> 
> 
> [65534.453769] ------------[ cut here ]------------
> [65534.455361] kernel BUG at fs/btrfs/ctree.c:1145!
> [65534.456919] invalid opcode: 0000 [#1] SMP 
> [65534.458491] Modules linked in: hwmon_vid ipv6 cpufreq_ondemand lp ppdev 
> parport_pc parport i2c_dev acpi_cpufreq mperf freq_table sp5100_tco kvm 
> crc32_pclmul crc32c_intel ghash_clmulni_intel microcode evdev radeon ttm 
> drm_kms_helper drm fam15h_power agpgart 8139too i2c_algo_bit i2c_piix4 
> ohci_hcd mii ehci_pci k10temp i2c_core ehci_hcd firewire_ohci asus_atk0110 
> processor shpchp firewire_core thermal_sys wmi hwmon button loop
> [65534.466324] CPU 6 
> [65534.466358] Pid: 1181768, comm: btrfs-endio-wri Not tainted 3.9.11-dlj #1 
> System manufacturer System Product Name/M5A88-V EVO
> [65534.470602] RIP: 0010:[<ffffffff814a07db>]  [<ffffffff814a07db>] 
> __tree_mod_log_rewind+0x20b/0x210
> [65534.472912] RSP: 0018:ffff8802a903d8e0  EFLAGS: 00010293
> [65534.475221] RAX: 0000000000000001 RBX: ffff880407a47e80 RCX: ffff8802a903d888
> [65534.477596] RDX: ffff880407a47e81 RSI: ffff8802a474b0a7 RDI: ffff880407a47700
> [65534.480032] RBP: ffff8802a903d908 R08: 0000000000001000 R09: ffff8802a903d898
> [65534.482479] R10: 000000000008b72c R11: 0000000000000000 R12: ffff8803282522a0
> [65534.484914] R13: 0000000000000003 R14: ffff880407a47900 R15: 00000000000000f3
> [65534.487368] FS:  00007f47c00f0700(0000) GS:ffff88041ed80000(0000) 
> knlGS:0000000000000000
> [65534.489894] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [65534.492437] CR2: 00007f08be7eca08 CR3: 00000003f46b6000 CR4: 
> 00000000000407e0
> [65534.495056] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [65534.497673] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [65534.500290] Process btrfs-endio-wri (pid: 1181768, threadinfo 
> ffff8802a903c000, task ffff88040bbd5400)
> [65534.503012] Stack:
> [65534.505696]  ffff880328111e10 ffff880328111e18 0000160000000000 
> 0000000000000001
> [65534.508536]  ffff8803281f3ce0 ffff8802a903d988 ffffffff814a83a2 ffff880407a47900
> [65534.511396]  ffff88040b680000 00000000a903d948 00000000000000f3 
> ffff8803282522a0
> [65534.514293] Call Trace:
> [65534.517195]  [<ffffffff814a83a2>] btrfs_search_old_slot+0x542/0x8c0
> [65534.520178]  [<ffffffff814ab39f>] btrfs_next_old_leaf+0xff/0x4a0
> [65534.523187]  [<ffffffff8152068f>] __resolve_indirect_refs+0x2df/0x5d0
> [65534.526211]  [<ffffffff815212c4>] find_parent_nodes+0x944/0xfd0
> [65534.529277]  [<ffffffff814c8115>] ? join_transaction.isra.12+0x25/0x380
> [65534.532373]  [<ffffffff814cd060>] ? can_nocow_odirect+0x310/0x310
> [65534.535448]  [<ffffffff8152237d>] iterate_extent_inodes+0xfd/0x2a0
> [65534.538555]  [<ffffffff814cd060>] ? can_nocow_odirect+0x310/0x310
> [65534.541683]  [<ffffffff815225b2>] iterate_inodes_from_logical+0x92/0xb0
> [65534.544846]  [<ffffffff814cae77>] record_extent_backrefs+0x77/0xf0
> [65534.548038]  [<ffffffff814d5df6>] btrfs_finish_ordered_io+0x156/0x9c0
> [65534.551239]  [<ffffffff814d6825>] finish_ordered_fn+0x15/0x20
> [65534.554446]  [<ffffffff814f5a0e>] worker_loop+0x13e/0x500
> [65534.557656]  [<ffffffff814f58d0>] ? btrfs_queue_worker+0x300/0x300
> [65534.560896]  [<ffffffff81079850>] kthread+0xc0/0xd0
> [65534.564137]  [<ffffffff81050000>] ? syscall32_setup_pages+0x150/0x160
> [65534.567429]  [<ffffffff81079790>] ? kthread_create_on_node+0x120/0x120
> [65534.570784]  [<ffffffff81b68edc>] ret_from_fork+0x7c/0xb0
> [65534.574131]  [<ffffffff81079790>] ? kthread_create_on_node+0x120/0x120
> [65534.577557] Code: c1 48 63 43 58 48 89 c2 48 c1 e2 05 48 8d 54 10 65 48 63 
> 43 2c 48 89 c6 48 c1 e6 05 48 8d 74 30 65 e8 ba 99 04 00 e9 da fe ff ff <0f> 0b 
> 0f 0b 90 66 66 66 66 90 55 48 b9 00 00 00 00 00 16 00 00 
> [65534.585040] RIP  [<ffffffff814a07db>] __tree_mod_log_rewind+0x20b/0x210
> [65534.588670]  RSP <ffff8802a903d8e0>
> [65534.605795] ---[ end trace c7a43fbc947f83d6 ]---

This should have been fixed in 3.10 RC1 with the commit "Btrfs: fix tree mod log regression on root split operations". If you still see it in 3.10, apparently it isn't.

Can you please post a log of the BUG when this happens with 3.10?

The recommendation at that time was to avoid balancing the filesystem:
http://marc.info/?l=linux-btrfs&m=136558416914156&w=2

