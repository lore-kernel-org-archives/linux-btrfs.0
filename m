Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:21800 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3GYHr3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 03:47:29 -0400
Message-ID: <51F0D80D.1040501@giantdisaster.de>
Date: Thu, 25 Jul 2013 09:47:25 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: =?UTF-8?B?SmFyb3PFgmF3IFNpZWJlcnQ=?= <jsiebert@poczta.wp.pl>
CC: linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.c:1145
References: <2281947.y0ajIxBEPp@dljproject> <51EF8A88.9030002@giantdisaster.de> <2857490.pEg4Y7bDN7@dljproject>
In-Reply-To: <2857490.pEg4Y7bDN7@dljproject>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 24 Jul 2013 19:34:05 +0200, Jarosław Siebert wrote:
>> This should have been fixed in 3.10 RC1 with the commit "Btrfs: fix tree mod
>> log regression on root split operations". If you still see it in 3.10,
>> apparently it isn't.
>>
>> Can you please post a log of the BUG when this happens with 3.10?
> from kernel 3.10.1:
> [ 2911.005736] ------------[ cut here ]------------
> [ 2911.008063] kernel BUG at fs/btrfs/relocation.c:4452!

Thanks for the 3.10 log.

That's a different issue that you see on 3.10. The tree mod log issue fix is apparently working well.

This relocation.c:4452 BUG has relink_extent_backref() in the call trace which is part of the snapshot-aware defrag code. But I cannot say whether this issue is fixed after 3.10.

You could try to run btrfs-next (see <https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories>) or 3.11RC2. If it's not fixed, a bugzilla helps to remind people to fix the issue (see <https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_do_I_report_bugs_and_issues.3F>).


> [ 2911.010344] invalid opcode: 0000 [#1] SMP 
> [ 2911.012610] Modules linked in: hwmon_vid ipv6 cpufreq_ondemand lp ppdev 
> parport_pc parport i2c_dev acpi_cpufreq mperf freq_table kvm crc32_pclmul 
> crc32c_intel ghash_clmulni_intel radeon ttm drm_kms_helper drm sp5100_tco 
> 8139too ohci_hcd ehci_pci agpgart microcode ehci_hcd xhci_hcd i2c_piix4 
> i2c_algo_bit evdev mii firewire_ohci i2c_core firewire_core shpchp fam15h_power 
> k10temp processor wmi asus_atk0110 thermal_sys button hwmon loop
> [ 2911.023059] CPU: 2 PID: 19328 Comm: btrfs-endio-wri Not tainted 3.10.1 #1
> [ 2911.025725] Hardware name: System manufacturer System Product Name/M5A88-V 
> EVO, BIOS 1202    03/16/2012
> [ 2911.028534] task: ffff8803a3698720 ti: ffff88039cd0a000 task.ti: ffff88039cd0a000
> [ 2911.031337] RIP: 0010:[<ffffffff814ff4c6>]  [<ffffffff814ff4c6>] 
> btrfs_reloc_cow_block+0x1c6/0x200
> [ 2911.034204] RSP: 0018:ffff88039cd0b928  EFLAGS: 00010246
> [ 2911.037085] RAX: ffff88040b55a000 RBX: ffff88035dbd0800 RCX: ffff8803392ebcc0
> [ 2911.040000] RDX: ffff880331a712c0 RSI: ffff88040b6ee800 RDI: ffff88040655d0a0
> [ 2911.042902] RBP: ffff88039cd0b978 R08: ffff88039cd0b9c0 R09: 0000000000001000
> [ 2911.045878] R10: 0000000000000001 R11: ffffea0010116ac0 R12: ffff88040b6ee800
> [ 2911.048832] R13: ffff88040655d0a0 R14: ffff88040655d0a0 R15: ffff8803392ebcc0
> [ 2911.051777] FS:  00007f4386d91700(0000) GS:ffff88041ec80000(0000) 
> knlGS:0000000000000000
> [ 2911.054854] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2911.057886] CR2: 00007f77439426e8 CR3: 00000003f4232000 CR4: 
> 00000000000407e0
> [ 2911.060946] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [ 2911.064049] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 2911.067114] Stack:
> [ 2911.070115]  0000000000001000 ffff88039cd0b978 ffffffff814d42bd 0000000000000001
> [ 2911.073269]  0000000000000000 ffff88040b6ee800 ffff880331a712c0 ffff88040655d0a0
> [ 2911.076450]  0000000000000000 ffff8803392ebcc0 ffff88039cd0ba00 ffffffff8148e489
> [ 2911.079577] Call Trace:
> [ 2911.082705]  [<ffffffff814d42bd>] ? copy_extent_buffer+0xad/0x110
> [ 2911.085900]  [<ffffffff8148e489>] __btrfs_cow_block+0x3a9/0x500
> [ 2911.089078]  [<ffffffff8148e772>] btrfs_cow_block+0x112/0x1a0
> [ 2911.092276]  [<ffffffff81492486>] btrfs_search_slot+0x426/0x970
> [ 2911.095484]  [<ffffffff814a7a97>] btrfs_lookup_file_extent+0x37/0x40
> [ 2911.098677]  [<ffffffff814c693e>] __btrfs_drop_extents+0x11e/0xae0
> [ 2911.101881]  [<ffffffff8148fa8d>] ? generic_bin_search.constprop.43+0x8d/0x1a0
> [ 2911.105146]  [<ffffffff8114b131>] ? kmem_cache_alloc+0xd1/0x120
> [ 2911.108352]  [<ffffffff8148d2ca>] ? btrfs_alloc_path+0x1a/0x20
> [ 2911.111590]  [<ffffffff814c7db0>] btrfs_drop_extents+0x60/0x90
> [ 2911.114845]  [<ffffffff814c013a>] relink_extent_backref+0x30a/0x7a0
> [ 2911.118073]  [<ffffffff814b7760>] ? can_nocow_odirect+0x2f0/0x2f0
> [ 2911.121330]  [<ffffffff8150bd07>] ? iterate_inodes_from_logical+0x87/0xa0
> [ 2911.124600]  [<ffffffff814b5617>] ? record_extent_backrefs+0x77/0xf0
> [ 2911.127872]  [<ffffffff814c07c9>] btrfs_finish_ordered_io+0x1f9/0x9a0
> [ 2911.131150]  [<ffffffff814c1155>] finish_ordered_fn+0x15/0x20
> [ 2911.134418]  [<ffffffff814dfd4e>] worker_loop+0x13e/0x4f0
> [ 2911.137678]  [<ffffffff814dfc10>] ? btrfs_queue_worker+0x330/0x330
> [ 2911.140962]  [<ffffffff8107ae60>] kthread+0xc0/0xd0
> [ 2911.144250]  [<ffffffff8107ada0>] ? kthread_create_on_node+0x120/0x120
> [ 2911.147557]  [<ffffffff81b72d1c>] ret_from_fork+0x7c/0xb0
> [ 2911.150825]  [<ffffffff8107ada0>] ? kthread_create_on_node+0x120/0x120
> [ 2911.154117] Code: 80 00 00 00 00 4c 89 e2 48 89 de 4c 89 f7 e8 d2 b7 ff ff 85 
> c0 0f 84 e3 fe ff ff 0f 0b 48 83 be d7 01 00 00 f7 0f 85 76 fe ff ff <0f> 0b 48 3b 
> 7e 20 0f 84 0b ff ff ff 0f 0b be 6d 11 00 00 48 c7 
> [ 2911.161243] RIP  [<ffffffff814ff4c6>] btrfs_reloc_cow_block+0x1c6/0x200
> [ 2911.164589]  RSP <ffff88039cd0b928>
> [ 2911.180851] ---[ end trace b716b32a1783bdba ]---
> 
> You are right - I use autodefrag option.
> To repoduce this bug faster I did filesystem balance.
> I can't start new ssh session so I can't give You more details.
> I hope, that the log above could help you find the bug.
> 
> Kind regards
> 	Jaroslaw Siebert

