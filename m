Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:45171 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab3HBIgn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 04:36:43 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id ADB0634CA9B
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Aug 2013 10:36:39 +0200 (CEST)
Received: from localhost (ppp-58-8-234-213.revip2.asianet.co.th [58.8.234.213])
	by mail.virtall.com (Postfix) with ESMTPSA id D57C834CA78
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Aug 2013 10:36:38 +0200 (CEST)
Date: Fri, 2 Aug 2013 15:36:33 +0700
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: "kernel BUG at fs/btrfs/extent_io.c:2054!"after disk died
Message-ID: <20130802153633.21dbc3c6@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A disk just died on this RAID-1 btrfs filesystem running 3.10 - I can
see a "kernel BUG at fs/btrfs/extent_io.c:2054!", is it expected to BUG on a failing drive?


Aug  2 10:21:12 mach-5 kernel: [1589617.888162] Read(16): 88 00 00 00 00 00 35 ee 2f d0 00 00 00 30 00 00
Aug  2 10:21:12 mach-5 kernel: [1589617.888249] end_request: I/O error, dev sdb, sector 904802256
Aug  2 10:21:12 mach-5 kernel: [1589617.888316] btrfs: bdev /dev/sdb4 errs: wr 36055, rd 37753, flush 0, corrupt 0, gen 0
Aug  2 10:21:12 mach-5 kernel: [1589617.888458] btrfs csum failed ino 45664581 extent 463258779648 csum 2566472073 wanted 4044412290 mirror 1
Aug  2 10:21:12 mach-5 kernel: [1589617.907505] ------------[ cut here ]------------
Aug  2 10:21:12 mach-5 kernel: [1589617.907557] kernel BUG at fs/btrfs/extent_io.c:2054!
Aug  2 10:21:12 mach-5 kernel: [1589617.907608] invalid opcode: 0000 [#1] SMP 
Aug  2 10:21:12 mach-5 kernel: [1589617.907659] Modules linked in: tun cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats ipv6 btrfs zlib_deflate ext3 jbd loop acpi_cpufreq mperf intel_powerclamp kvm_intel kvm crc32_pclmul lpc_ich microcode i2c_i801 mfd_core ehci_pci ehci_hcd pcspkr i2c_core button video ext4 crc16 jbd2 mbcache freq_table aacraid 3w_9xxx 3w_xxxx raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 sata_nv sata_sil sata_via sg sd_mod ahci libahci libata scsi_mod r8169 mii
Aug  2 10:21:12 mach-5 kernel: [1589617.908062] CPU: 0 PID: 19788 Comm: btrfs-endio-3 Not tainted 3.10.0 #3
Aug  2 10:21:12 mach-5 kernel: [1589617.908116] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1106 10/17/2011
Aug  2 10:21:12 mach-5 kernel: [1589617.908215] task: ffff880011bb16e0 ti: ffff880730b5e000 task.ti: ffff880730b5e000
Aug  2 10:21:12 mach-5 kernel: [1589617.908312] RIP: 0010:[<ffffffffa078cc51>]  [<ffffffffa078cc51>] repair_io_failure+0xdd/0x1dc [btrfs]
Aug  2 10:21:12 mach-5 kernel: [1589617.908424] RSP: 0018:ffff880730b5fca8  EFLAGS: 00010206
Aug  2 10:21:12 mach-5 kernel: [1589617.908475] RAX: ffff8802e401fe40 RBX: ffff88002e7f9910 RCX: ffff880730b5fcd0
Aug  2 10:21:12 mach-5 kernel: [1589617.908572] RDX: ffff8802e401fe88 RSI: 0000000000000000 RDI: ffff8807d7d55688
Aug  2 10:21:12 mach-5 kernel: [1589617.908668] RBP: ffff880730b5fd28 R08: ffff88083fa14540 R09: 0000000000000001
Aug  2 10:21:12 mach-5 kernel: [1589617.908766] R10: 0000000000000000 R11: 0000000000000000 R12: 000000003f2bcd00
Aug  2 10:21:12 mach-5 kernel: [1589617.908863] R13: ffffea00087dc380 R14: ffff880730b5fcd8 R15: ffff88081349e000
Aug  2 10:21:12 mach-5 kernel: [1589617.908960] FS:  0000000000000000(0000) GS:ffff88083fa00000(0000) knlGS:0000000000000000
Aug  2 10:21:12 mach-5 kernel: [1589617.909058] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug  2 10:21:12 mach-5 kernel: [1589617.909110] CR2: 00007f3324fee000 CR3: 000000000160b000 CR4: 00000000000407f0
Aug  2 10:21:12 mach-5 kernel: [1589617.909207] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  2 10:21:12 mach-5 kernel: [1589617.909303] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  2 10:21:12 mach-5 kernel: [1589617.909400] Stack:
Aug  2 10:21:12 mach-5 kernel: [1589617.909446]  ffff880730b5fd28 00000170ba9fa000 0000000000000000 0000000000001000
Aug  2 10:21:12 mach-5 kernel: [1589617.909546]  0000000000006000 ffff8802e401fe40 ffff880700000000 ffffffffa07c0000
Aug  2 10:21:12 mach-5 kernel: [1589617.909644]  ffff880730b5fce8 ffff880730b5fce8 ffff880730b5fd28 ffffea00087dc380
Aug  2 10:21:12 mach-5 kernel: [1589617.909744] Call Trace:
Aug  2 10:21:12 mach-5 kernel: [1589617.909799]  [<ffffffffa07c0000>] ? btrfs_remove_qgroup+0x8f/0x2c9 [btrfs]
Aug  2 10:21:12 mach-5 kernel: [1589617.909858]  [<ffffffffa078d049>] end_bio_extent_readpage+0x274/0x6e6 [btrfs]
Aug  2 10:21:12 mach-5 kernel: [1589617.909957]  [<ffffffff8110a293>] bio_endio+0x28/0x2a
Aug  2 10:21:12 mach-5 kernel: [1589617.910013]  [<ffffffffa076ec6b>] end_workqueue_fn+0x33/0x38 [btrfs]
Aug  2 10:21:12 mach-5 kernel: [1589617.910071]  [<ffffffffa0799b5c>] worker_loop+0x15e/0x48e [btrfs]
Aug  2 10:21:12 mach-5 kernel: [1589617.910128]  [<ffffffffa07999fe>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
Aug  2 10:21:12 mach-5 kernel: [1589617.910183]  [<ffffffff81048ab2>] kthread+0xb5/0xbd
Aug  2 10:21:12 mach-5 kernel: [1589617.910235]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
Aug  2 10:21:12 mach-5 kernel: [1589617.910291]  [<ffffffff8137576c>] ret_from_fork+0x7c/0xb0
Aug  2 10:21:12 mach-5 kernel: [1589617.910344]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
Aug  2 10:21:12 mach-5 kernel: [1589617.910397] Code: 8d 4d a0 48 8b 45 98 45 89 e1 be 01 00 00 00 4c 89 ff 48 89 45 a0 e8 7a 9a 00 00 85 c0 74 02 eb 47 48 8b 45 a8 44 3b 60 2c 74 02 <0f> 0b 41 ff cc 4d 63 e4 4d 6b e4 18 4e 8b 7c 20 38 49 c1 ef 09 
Aug  2 10:21:12 mach-5 kernel: [1589617.911823] RIP  [<ffffffffa078cc51>] repair_io_failure+0xdd/0x1dc [btrfs]
Aug  2 10:21:12 mach-5 kernel: [1589617.911881]  RSP <ffff880730b5fca8>
Aug  2 10:21:12 mach-5 kernel: [1589617.912255] ---[ end trace fe8a4880aa46a7ef ]---
Aug  2 10:23:11 mach-5 kernel: [1589736.946747] sd 1:0:0:0: [sdb] Unhandled error code
Aug  2 10:23:11 mach-5 kernel: [1589736.946846] sd 1:0:0:0: [sdb]  
Aug  2 10:23:11 mach-5 kernel: [1589736.946938] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Aug  2 10:23:11 mach-5 kernel: [1589736.947039] sd 1:0:0:0: [sdb] CDB: 



-- 
Tomasz Chmielewski
http://wpkg.org
