Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:31929 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbbHVR36 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Aug 2015 13:29:58 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: btrfs regression since 4.X kernel NULL pointer dereference
Cc: Christoph Hellwig <hch@lst.de>
Message-ID: <55D8B193.8010906@profihost.ag>
Date: Sat, 22 Aug 2015 19:29:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

today i experienced the following btrfs bug:

Aug 20 11:59:18 debian-build kernel: [  325.170036] BUG: unable to 
handle kernel NULL pointer dereference at 0000000000000330
Aug 20 11:59:18 debian-build kernel: [  325.170144] IP: 
[<ffffffff813204c0>] blk_get_backing_dev_info+0x10/0x20
Aug 20 11:59:18 debian-build kernel: [  325.170216] PGD 74f57067 PUD 
74f51067 PMD 0
Aug 20 11:59:18 debian-build kernel: [  325.170282] Oops: 0000 [#1] SMP
Aug 20 11:59:18 debian-build kernel: [  325.170330] Modules linked in: 
dm_mod netconsole xt_multiport iptable_filter ip_tables x_tab
les cpufreq_userspace cpufreq_stats cpufreq_powersave 
cpufreq_conservative ext2 loop shpchp i2c_piix4 i2c_core virtio_balloon 
acpi_c
pufreq button btrfs xor lzo_compress usbhid raid6_pq ata_generic sg 
sd_mod virtio_net virtio_scsi floppy uhci_hcd ehci_hcd ata_piix
usbcore usb_common virtio_pci
Aug 20 11:59:18 debian-build kernel: [  325.170783] CPU: 4 PID: 13323 
Comm: btrfs Not tainted 4.1.6+17-ph #1
Aug 20 11:59:18 debian-build kernel: [  325.170842] Hardware name: QEMU 
Standard PC (i440FX + PIIX, 1996), BIOS 
rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
Aug 20 11:59:18 debian-build kernel: [  325.170952] task: 
ffff88022d6bbae0 ti: ffff8800748e0000 task.ti: ffff8800748e0000
Aug 20 11:59:18 debian-build kernel: [  325.171017] RIP: 
0010:[<ffffffff813204c0>]  [<ffffffff813204c0>] 
blk_get_backing_dev_info+0x10/0x20
Aug 20 11:59:18 debian-build kernel: [  325.171096] RSP: 
0018:ffff8800748e39a8  EFLAGS: 00010202
Aug 20 11:59:18 debian-build kernel: [  325.171148] RAX: 
0000000000000000 RBX: ffff880234680770 RCX: 0000000000000001
Aug 20 11:59:18 debian-build kernel: [  325.171210] RDX: 
7fffffffffffffff RSI: 0000000000000000 RDI: ffff880234680680
Aug 20 11:59:18 debian-build kernel: [  325.171271] RBP: 
ffff8800748e39a8 R08: 7fffffffffffffff R09: 0000000000000246
Aug 20 11:59:18 debian-build kernel: [  325.171333] R10: 
ffffffffa0158bdc R11: 0000000000000000 R12: ffff880237019000
Aug 20 11:59:18 debian-build kernel: [  325.171393] R13: 
7fffffffffffffff R14: ffff880092df07fc R15: 7fffffffffffffff
Aug 20 11:59:18 debian-build kernel: [  325.171455] FS: 
00007fb05f0ba880(0000) GS:ffff88023fd00000(0000) knlGS:0000000000000000
Aug 20 11:59:18 debian-build kernel: [  325.171522] CS:  0010 DS: 0000 
ES: 0000 CR0: 0000000080050033
Aug 20 11:59:18 debian-build kernel: [  325.171577] CR2: 
0000000000000330 CR3: 0000000074ce4000 CR4: 00000000000006e0
Aug 20 11:59:18 debian-build kernel: [  325.171669] Stack:
Aug 20 11:59:18 debian-build kernel: [  325.171706]  ffff8800748e39c8 
ffffffff811e6d60 ffff8802346808c0 0000000000000000
Aug 20 11:59:18 debian-build kernel: [  325.171811]  ffff8800748e3a18 
ffffffff8114e232 ffff880212f93910 7fffffffffffffff
Aug 20 11:59:18 debian-build kernel: [  325.171923]  0000000000000000 
0000000000000000 7fffffffffffffff 0000000000000001
Aug 20 11:59:18 debian-build kernel: [  325.172078] Call Trace:
Aug 20 11:59:18 debian-build kernel: [  325.172132] 
[<ffffffff811e6d60>] inode_to_bdi+0x60/0x70
Aug 20 11:59:18 debian-build kernel: [  325.172221] 
[<ffffffff8114e232>] __filemap_fdatawrite_range+0x42/0x70
Aug 20 11:59:18 debian-build kernel: [  325.172319] 
[<ffffffff8114eea3>] filemap_fdatawrite_range+0x13/0x20
Aug 20 11:59:18 debian-build kernel: [  325.172418] 
[<ffffffffa0157c2b>] btrfs_fdatawrite_range+0x2b/0x70 [btrfs]
Aug 20 11:59:18 debian-build kernel: [  325.172493] 
[<ffffffffa015d57c>] btrfs_wait_ordered_range+0x4c/0x130 [btrfs]
Aug 20 11:59:18 debian-build kernel: [  325.174258] 
[<ffffffffa0155075>] ? btrfs_drop_extent_cache+0x355/0x420 [btrfs]
Aug 20 11:59:18 debian-build kernel: [  325.175688] 
[<ffffffffa014dde6>] btrfs_evict_inode+0x226/0x550 [btrfs]
Aug 20 11:59:18 debian-build kernel: [  325.177252] 
[<ffffffff811e726d>] ? __inode_wait_for_writeback+0x6d/0xc0
Aug 20 11:59:18 debian-build kernel: [  325.179214] 
[<ffffffff811d9058>] evict+0xb8/0x190
Aug 20 11:59:18 debian-build kernel: [  325.180619] 
[<ffffffff811d986b>] iput+0x18b/0x1f0
Aug 20 11:59:18 debian-build kernel: [  325.182034] 
[<ffffffff811d4f28>] __dentry_kill+0x198/0x200
Aug 20 11:59:18 debian-build kernel: [  325.183559] 
[<ffffffff811d50ad>] shrink_dentry_list+0x11d/0x2b0
Aug 20 11:59:18 debian-build kernel: [  325.184981] 
[<ffffffff811d56c8>] d_invalidate+0xd8/0x100
Aug 20 11:59:18 debian-build kernel: [  325.186394] 
[<ffffffffa017757b>] btrfs_ioctl_snap_destroy+0x50b/0x6e0 [btrfs]
Aug 20 11:59:18 debian-build kernel: [  325.187832] 
[<ffffffffa017abca>] btrfs_ioctl+0x131a/0x2a30 [btrfs]
Aug 20 11:59:18 debian-build kernel: [  325.189239] 
[<ffffffff8115ab2b>] ? lru_cache_add_active_or_unevictable+0x2b/0xa0
Aug 20 11:59:18 debian-build kernel: [  325.190668] 
[<ffffffff8117970a>] ? handle_mm_fault+0x2ba/0x1860
Aug 20 11:59:18 debian-build kernel: [  325.192062] 
[<ffffffff81181566>] ? mmap_region+0x316/0x630
Aug 20 11:59:18 debian-build kernel: [  325.193453] 
[<ffffffff81116ecc>] ? acct_account_cputime+0x1c/0x20
Aug 20 11:59:18 debian-build kernel: [  325.194851] 
[<ffffffff810ae3f9>] ? account_user_time+0x99/0xb0
Aug 20 11:59:18 debian-build kernel: [  325.196241] 
[<ffffffff811d0bd3>] do_vfs_ioctl+0x83/0x550
Aug 20 11:59:18 debian-build kernel: [  325.197584] 
[<ffffffff8114be23>] ? context_tracking_user_exit+0x13/0x20
Aug 20 11:59:18 debian-build kernel: [  325.198913] 
[<ffffffff81012558>] ? syscall_trace_enter_phase1+0xf8/0x160
Aug 20 11:59:18 debian-build kernel: [  325.200229] 
[<ffffffff811d10ec>] SyS_ioctl+0x4c/0x90
Aug 20 11:59:18 debian-build kernel: [  325.201548] 
[<ffffffff8163442e>] system_call_fastpath+0x12/0x71
Aug 20 11:59:18 debian-build kernel: [  325.202836] Code: e9 23 ff ff ff 
b8 01 00 00 00 45 31 e4 eb d5 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 
44 00 00 48 8b 87 98 00 00 00 55 48 89 e5 <48> 8b 80 30 03 00 00 5d 48 
05 98 01 00 00 c3 90 0f 1f 44 00 00
Aug 20 11:59:18 debian-build kernel: [  325.205694] RIP 
[<ffffffff813204c0>] blk_get_backing_dev_info+0x10/0x20
Aug 20 11:59:18 debian-build kernel: [  325.206983]  RSP <ffff8800748e39a8>
Aug 20 11:59:18 debian-build kernel: [  325.208233] CR2: 0000000000000330
Aug 20 11:59:18 debian-build kernel: [  325.209467] ---[ end trace 
9dd28134a31aacc4 ]---

It was introduced by:
| commit de1414a654e66b81b5348dbc5259ecf2fb61655e
| Author: Christoph Hellwig <hch@lst.de>
| Date:   Wed Jan 14 10:42:36 2015 +0100
|
|     fs: export inode_to_bdi and use it in favor of 
mapping->backing_dev_info

More details and a reproducer from a 3rd person can be found here:
https://bugzilla.kernel.org/show_bug.cgi?id=100911

Greets,
Stefan
