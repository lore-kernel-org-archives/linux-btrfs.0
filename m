From: Christian Brunner <chb@muc.de>
Subject: BUG at fs/btrfs/inode.c:1587
Date: Tue, 15 Nov 2011 09:19:53 +0100
Message-ID: <CAO47_--H0+6bu4qQ2QA9gZcHvGVWO4QUGCAb3+9a5Kg3+23UiQ@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this time I've hit a new bug. This happened while ceph was rebuilding
his filestore (heavy io).

The btrfs version is from 3.2-rc1, applied to a 3.0 kernel.

Regards,
Christian

[28981.550478] ------------[ cut here ]------------
[28981.555625] kernel BUG at fs/btrfs/inode.c:1587!
[28981.560773] invalid opcode: 0000 [#1] SMP
[28981.565361] CPU 2
[28981.567407] Modules linked in: btrfs zlib_deflate libcrc32c sunrpc
bonding ipv6 sg serio_raw pcspkr ghes hed iTCO_wdt iTCO_vendor_support
ixgbe dca mdio i7core_edac edac_core iomemory_vsl(P) hpsa squashfs
[last unloaded: scsi_wait_scan]
[28981.591184]
[28981.592842] Pid: 1814, comm: btrfs-fixup-0 Tainted: P
3.0.8-1.fits.4.el6.x86_64 #1 HP ProLiant DL180 G6
[28981.604589] RIP: 0010:[<ffffffffa0292f3c>]  [<ffffffffa0292f3c>]
btrfs_writepage_fixup_worker+0x14c/0x160 [btrfs]
[28981.616049] RSP: 0018:ffff8805ee735dd0  EFLAGS: 00010246
[28981.621967] RAX: 0000000000000000 RBX: ffffea00132c2520 RCX: ffff8805ef32ec58
[28981.629918] RDX: 0000000000000000 RSI: 00000000003b5000 RDI: ffff8805ef32ea38
[28981.637870] RBP: ffff8805ee735e20 R08: ffff88063f25add0 R09: ffff8805ee735d88
[28981.645822] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000003b5000
[28981.653774] R13: ffff8805ef32eb08 R14: 0000000000000000 R15: 00000000003b5fff
[28981.661727] FS:  0000000000000000(0000) GS:ffff88063f240000(0000)
knlGS:0000000000000000
[28981.670744] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[28981.677146] CR2: 0000000007737000 CR3: 0000000001a03000 CR4: 00000000000006e0
[28981.685098] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[28981.693050] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[28981.701010] Process btrfs-fixup-0 (pid: 1814, threadinfo
ffff8805ee734000, task ffff8805f3f54bc0)
[28981.710901] Stack:
[28981.713146]  ffff88045dbf4d20 ffff8805ef32e9a8 0000000000012bc0
ffff88027dcdbd20
[28981.721434]  0000000000000000 ffff8805ef99ede0 ffff8805ef99ee30
ffff8805ef99edf8
[28981.729723]  ffff88045dbf4d50 ffff8805ee735e80 ffff8805ee735ee0
ffffffffa02b39ce
[28981.738013] Call Trace:
[28981.740763]  [<ffffffffa02b39ce>] worker_loop+0x13e/0x540 [btrfs]
[28981.747577]  [<ffffffffa02b3890>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
[28981.755263]  [<ffffffffa02b3890>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
[28981.762931]  [<ffffffff81085c96>] kthread+0x96/0xa0
[28981.768373]  [<ffffffff81556844>] kernel_thread_helper+0x4/0x10
[28981.774976]  [<ffffffff81085c00>] ? kthread_worker_fn+0x1a0/0x1a0
[28981.781772]  [<ffffffff81556840>] ? gs_change+0x13/0x13
[28981.787593] Code: e0 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f c9 c3
48 8b 7d b8 48 8d 4d c8 41 b8 50 00 00 00 4c 89 fa 4c 89 e6 e8 96 38
01 00 eb bd <0f> 0b eb fe 48 89 df e8 c8 0e e7 e0 eb 9d 66 0f 1f 44 00
00 55
[28981.809294] RIP  [<ffffffffa0292f3c>]
btrfs_writepage_fixup_worker+0x14c/0x160 [btrfs]
[28981.818150]  RSP <ffff8805ee735dd0>
[28981.822721] ---[ end trace 0236051622523829 ]---
