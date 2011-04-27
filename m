From: Marco Neubauer <icetea1@gmx.net>
Subject: kernel BUG at fs/btrfs/inode.c:2271!
Date: Wed, 27 Apr 2011 20:52:00 +0200
Message-ID: <383ECFA9-9E51-4CCD-BE24-21FD30813217@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is happening mostly every night. I can't reproduce it right now.
vanilla kernel 2.6.38.4

Apr 27 03:41:54 mainframe kernel: ------------[ cut here ]------------
Apr 27 03:41:54 mainframe kernel: WARNING: at fs/btrfs/inode.c:6488 btrfs_truncate+0x49/0x580()
Apr 27 03:41:54 mainframe kernel: Hardware name: System Product Name
Apr 27 03:41:54 mainframe kernel: Modules linked in: md4 cifs hwmon_vid coretemp vboxnetadp vboxnetflt vboxdrv firewire_ohci firewire_core i915 asus_atk0110 hwmon drm_kms_helper video backlight
Apr 27 03:41:54 mainframe kernel: Pid: 32572, comm: updatedb Not tainted 2.6.38.4 #1
Apr 27 03:41:54 mainframe kernel: Call Trace:
Apr 27 03:41:54 mainframe kernel: [<ffffffff8103f59b>] ? warn_slowpath_common+0x7b/0xc0
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124a1d9>] ? btrfs_truncate+0x49/0x580
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124a863>] ? btrfs_iget+0x53/0x4a0
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124af09>] ? btrfs_orphan_cleanup+0x259/0x340
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124a863>] ? btrfs_iget+0x53/0x4a0
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124b3f8>] ? btrfs_lookup_dentry+0x408/0x480
Apr 27 03:41:54 mainframe kernel: [<ffffffff81263123>] ? set_extent_bit+0x143/0x520
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124b479>] ? btrfs_lookup+0x9/0x20
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f628c>] ? d_alloc_and_lookup+0x3c/0x90
Apr 27 03:41:54 mainframe kernel: [<ffffffff811006ae>] ? d_lookup+0x2e/0x60
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f8002>] ? do_lookup+0x1a2/0x2e0
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f921a>] ? link_path_walk+0x53a/0xa30
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f6e22>] ? path_init_rcu+0xa2/0x200
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f99d6>] ? do_path_lookup+0x56/0x130
Apr 27 03:41:54 mainframe kernel: [<ffffffff810fa75a>] ? user_path_at+0x5a/0xb0
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f99e1>] ? do_path_lookup+0x61/0x130
Apr 27 03:41:54 mainframe kernel: [<ffffffff810effb0>] ? cp_new_stat+0xe0/0x100
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f00b0>] ? vfs_fstatat+0x40/0x80
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f017f>] ? sys_newlstat+0x1f/0x50
Apr 27 03:41:54 mainframe kernel: [<ffffffff81002e7b>] ? system_call_fastpath+0x16/0x1b
Apr 27 03:41:54 mainframe kernel: ---[ end trace 71530b801e4a68c0 ]---
Apr 27 03:41:54 mainframe kernel: ------------[ cut here ]------------
Apr 27 03:41:54 mainframe kernel: kernel BUG at fs/btrfs/inode.c:2271!
Apr 27 03:41:54 mainframe kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Apr 27 03:41:54 mainframe kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sdd/sdd2/stat
Apr 27 03:41:54 mainframe kernel: CPU 1 
Apr 27 03:41:54 mainframe kernel: Modules linked in: md4 cifs hwmon_vid coretemp vboxnetadp vboxnetflt vboxdrv firewire_ohci firewire_core i915 asus_atk0110 hwmon drm_kms_helper video backlight
Apr 27 03:41:54 mainframe kernel: 
Apr 27 03:41:54 mainframe kernel: Pid: 32572, comm: updatedb Tainted: G        W   2.6.38.4 #1 System manufacturer System Product Name/V-P5G45
Apr 27 03:41:54 mainframe kernel: RIP: 0010:[<ffffffff81246006>]  [<ffffffff81246006>] btrfs_orphan_del+0xe6/0xf0
Apr 27 03:41:54 mainframe kernel: RSP: 0018:ffff8801ad615ab8  EFLAGS: 00010282
Apr 27 03:41:54 mainframe kernel: RAX: 00000000fffffffe RBX: ffff880170fe9d60 RCX: ffff88022f84abd0
Apr 27 03:41:54 mainframe kernel: RDX: ffff8800c7a95ce8 RSI: ffff88022f84aea0 RDI: ffff88022f84aea0
Apr 27 03:41:54 mainframe kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8801ad615930
Apr 27 03:41:54 mainframe kernel: R10: 0000000000000025 R11: 0000000000000000 R12: ffff88022b40bc80
Apr 27 03:41:54 mainframe kernel: R13: ffff88022ef06000 R14: ffff88022ef06330 R15: 0000000000000001
Apr 27 03:41:54 mainframe kernel: FS:  00007f4f36914700(0000) GS:ffff8800c7a80000(0000) knlGS:0000000000000000
Apr 27 03:41:54 mainframe kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Apr 27 03:41:54 mainframe kernel: CR2: 00000000006ff228 CR3: 00000001bfc26000 CR4: 00000000000406e0
Apr 27 03:41:54 mainframe kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr 27 03:41:54 mainframe kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 27 03:41:54 mainframe kernel: Process updatedb (pid: 32572, threadinfo ffff8801ad614000, task ffff880217171350)
Apr 27 03:41:54 mainframe kernel: Stack:
Apr 27 03:41:54 mainframe kernel: ffff88022ef06000 ffff88022ef06000 ffff88022f84ac60 ffff88022ef06330
Apr 27 03:41:54 mainframe kernel: ffff88022ef06338 ffff8801ad615b58 ffff8801ad615b18 ffffffff8124aed0
Apr 27 03:41:54 mainframe kernel: ffff8801ad615b88 ffff880170fe9d60 ffff88022b40bc80 000000015014c5fa
Apr 27 03:41:54 mainframe kernel: Call Trace:
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124aed0>] ? btrfs_orphan_cleanup+0x220/0x340
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124a863>] ? btrfs_iget+0x53/0x4a0
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124b3f8>] ? btrfs_lookup_dentry+0x408/0x480
Apr 27 03:41:54 mainframe kernel: [<ffffffff81263123>] ? set_extent_bit+0x143/0x520
Apr 27 03:41:54 mainframe kernel: [<ffffffff8124b479>] ? btrfs_lookup+0x9/0x20
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f628c>] ? d_alloc_and_lookup+0x3c/0x90
Apr 27 03:41:54 mainframe kernel: [<ffffffff811006ae>] ? d_lookup+0x2e/0x60
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f8002>] ? do_lookup+0x1a2/0x2e0
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f921a>] ? link_path_walk+0x53a/0xa30
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f6e22>] ? path_init_rcu+0xa2/0x200
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f99d6>] ? do_path_lookup+0x56/0x130
Apr 27 03:41:54 mainframe kernel: [<ffffffff810fa75a>] ? user_path_at+0x5a/0xb0
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f99e1>] ? do_path_lookup+0x61/0x130
Apr 27 03:41:54 mainframe kernel: [<ffffffff810effb0>] ? cp_new_stat+0xe0/0x100
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f00b0>] ? vfs_fstatat+0x40/0x80
Apr 27 03:41:54 mainframe kernel: [<ffffffff810f017f>] ? sys_newlstat+0x1f/0x50
Apr 27 03:41:54 mainframe kernel: [<ffffffff81002e7b>] ? system_call_fastpath+0x16/0x1b
Apr 27 03:41:54 mainframe kernel: Code: 4c 8b 6c 24 20 4c 8b 74 24 28 4c 8b 7c 24 30 48 83 c4 38 c3 90 48 8b 93 a8 00 00 00 4c 89 ee 4c 89 e7 e8 ee f5 02 00 85 c0 74 b8 <0f> 0b eb fe 66 0f 1f 44 00 00 53 48 8d 86 38 03 00 00 48 89 f3 
Apr 27 03:41:54 mainframe kernel: RIP  [<ffffffff81246006>] btrfs_orphan_del+0xe6/0xf0
Apr 27 03:41:54 mainframe kernel: RSP <ffff8801ad615ab8>
Apr 27 03:41:54 mainframe kernel: ---[ end trace 71530b801e4a68c1 ]---

-marco