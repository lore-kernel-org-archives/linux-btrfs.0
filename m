From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.29-rc2] insert_dir_item hitting assertion during log replay
Date: Sun, 10 Apr 2011 16:29:27 +0800
Message-ID: <BANLkTi=M5q6WbkgNMURWkBCi-46E6-UOkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When rebooting from a crash, thus during log replay on 2.6.29-rc2,
btrfs_insert_dir_item caused an assertion failure [1]. The fs was
being mounted clear_cache on an SSD.

Probably it's not so easy to reproduce, but better to report it...

--- [1]

kernel BUG at fs/btrfs/inode.c:4665!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file:
/sys/devices/virtual/wmi/A80593CE-A997-11DA-B012-B622A1EF5492/uevent
CPU 3
Modules linked in: video sdhci_pci sdhci mmc_core

Pid: 328, comm: mount Not tainted 2.6.39-rc2-350cd+ #1 Dell Inc.
Latitude E5420/0H5TG2
RIP: 0010:[<ffffffff812a2962>]  [<ffffffff812a2962>] btrfs_add_link+0x132/0x190
RSP: 0018:ffff88021e1097d8  EFLAGS: 00010282
RAX: 00000000ffffffef RBX: ffff88021d965f70 RCX: 0000000000000006
RDX: 00000000ffffffef RSI: ffff88021efe4710 RDI: ffff88021efe4020
RBP: ffff88021e109848 R08: 0000000000000000 R09: ffff88022d7c03f0
R10: 0000000000000001 R11: 0000000000000001 R12: ffff88021d966720
R13: ffff88021e0261b0 R14: 000000000000000f R15: ffff88021d959000
FS:  00007fcee7b3d800(0000) GS:ffff88022ec60000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f5e5ffff700 CR3: 000000021e6ef000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 328, threadinfo ffff88021e108000, task ffff88021efe4020)
Stack:
 ffff880200000001 0000000000000016 ffff88021e109978 0000000000000016
 000000000010555e 0000000000000001 0000000000001000 0000000000000000
 ffff88021e03a000 0000000000000000 00000000000000b0 ffff88021e109ae8
Call Trace:
 [<ffffffff812ccb45>] add_inode_ref+0x2f5/0x3b0
 [<ffffffff81058e61>] ? get_parent_ip+0x11/0x50
 [<ffffffff812cdff6>] replay_one_buffer+0x2c6/0x3a0
 [<ffffffff81099fd0>] ? mark_held_locks+0x70/0xa0
 [<ffffffff81058e61>] ? get_parent_ip+0x11/0x50
 [<ffffffff812ca978>] walk_up_log_tree+0x168/0x320
 [<ffffffff812cdd30>] ? replay_one_dir_item+0xe0/0xe0
 [<ffffffff812cb188>] walk_log_tree+0xe8/0x290
 [<ffffffff8109a18d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff812d0000>] btrfs_recover_log_trees+0x220/0x320
 [<ffffffff812cdd30>] ? replay_one_dir_item+0xe0/0xe0
 [<ffffffff81295521>] open_ctree+0x1301/0x16b0
 [<ffffffff81331ab4>] ? snprintf+0x34/0x40
 [<ffffffff812701e3>] btrfs_fill_super.clone.14+0x73/0x130
 [<ffffffff811a4aaf>] ? disk_name+0x5f/0xc0
 [<ffffffff8132ef77>] ? strlcpy+0x47/0x60
 [<ffffffff812705e0>] btrfs_mount+0x340/0x3e0
 [<ffffffff81143e9b>] mount_fs+0x1b/0xd0
 [<ffffffff8115fece>] vfs_kern_mount+0x5e/0xd0
 [<ffffffff8116045f>] do_kern_mount+0x4f/0x100
 [<ffffffff81161ea4>] do_mount+0x1e4/0x220
 [<ffffffff8116228b>] sys_mount+0x8b/0xe0
 [<ffffffff8170adfb>] system_call_fastpath+0x16/0x1b
Code: 4c 89 d2 44 89 f1 4c 89 ee 4c 89 1c 24 4c 89 55 a8 4c 89 5d a0
e8 5f c6 fe ff 4c 8b 5d a0 4c 8b 55 a8 85 c0 75 bc e9 31 ff ff ff <0f>
0b 48 8b b2 d0 fc ff ff 48 8d 7d b0 b9 11 00 00 00 4d 89 d9
RIP  [<ffffffff812a2962>] btrfs_add_link+0x132/0x190
 RSP <ffff88021e1097d8>
-- 
Daniel J Blueman
