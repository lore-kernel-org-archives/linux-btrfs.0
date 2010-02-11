From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/4] btrfs: add discard_compat support
Date: Thu, 11 Feb 2010 14:15:51 +0300
Message-ID: <87tytoqazc.fsf@openvz.org>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
	<1265886074-22135-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1265886074-22135-1-git-send-email-dmonakhov@openvz.org> (Dmitry
	Monakhov's message of "Thu, 11 Feb 2010 14:01:14 +0300")
List-ID: <linux-btrfs.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> If any device in the list has no native discard support we add
> discard compat support. Devices with native discard support still
> getting real discard requests.
Note: Seems what enabling discard requests result in triggering
hidden bug. Orphan list corruption.

  ------------[ cut here ]------------
 WARNING: at lib/list_debug.c:26 __list_add+0x3f/0x81()
 Hardware name:         
 list_add corruption. next->prev should be prev (ffff88012029eb20), but was ffff88012239c730. (next=ffff8801223bc348).
 Modules linked in: btrfs zlib_deflate libcrc32c cpufreq_ondemand acpi_cpufreq freq_table ppdev parport_pc parport pcspkr [last unloaded: btrfs]
 Pid: 1254, comm: fsstress Not tainted 2.6.33-rc5 #3
 Call Trace:
 [<ffffffff81038f79>] warn_slowpath_common+0x7c/0x94
 [<ffffffff81038fe8>] warn_slowpath_fmt+0x41/0x43
 [<ffffffffa00df87a>] ? btrfs_unlink_inode+0x243/0x258 [btrfs]
 [<ffffffff811c0e22>] __list_add+0x3f/0x81
 [<ffffffffa00dfac7>] btrfs_orphan_add+0x61/0x80 [btrfs]
 [<ffffffffa00e015a>] btrfs_unlink+0xb2/0xf2 [btrfs]
 [<ffffffff810ec5a3>] vfs_unlink+0x67/0xa2
 [<ffffffff810eafec>] ? lookup_hash+0x36/0x3a
 [<ffffffff810edd97>] do_unlinkat+0xcd/0x15b
 [<ffffffff810eabc4>] ? path_put+0x22/0x27
 [<ffffffff8107edac>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff810ede3b>] sys_unlink+0x16/0x18
 [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
 ---[ end trace 18d84c057a649cf7 ]---
 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/inode.c:3320!
 invalid opcode: 0000 [#1] SMP 
 last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/uevent
 CPU 3 
 Pid: 1250, comm: fsstress Tainted: G        W  2.6.33-rc5 #3 DH55TC                /        
 RIP: 0010:[<ffffffffa00e071b>]  [<ffffffffa00e071b>] btrfs_setattr+0x101/0x244 [btrfs]
 RSP: 0018:ffff88012095de08  EFLAGS: 00010292
 RAX: 0000000000000021 RBX: ffff8801223b4bd8 RCX: 000000000000711a
 RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff81730984
 RBP: ffff88012095de48 R08: ffff88012095ddb4 R09: 0000000000000000
 R10: 0000000000000001 R11: ffff88012095dd00 R12: ffff88012095ded8
 R13: ffff88012029e800 R14: ffff88012233d140 R15: 0000000000000000
 FS:  00007f313c3c6700(0000) GS:ffff8800282c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fffa0ac3f4c CR3: 00000001212c7000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process fsstress (pid: 1250, threadinfo ffff88012095c000, task ffff880122c68000)
 Stack:
 ffff8801223b4cb0 ffff88011c452180 ffff88012095de28 ffff88012095ded8
 <0> ffff88011c452180 ffff8801223b4bd8 0000000000000008 0000000000000008
 <0> ffff88012095deb8 ffffffff810f5e52 ffff88012095df38 ffffffff810ee418
 Call Trace:
 [<ffffffff810f5e52>] notify_change+0x17b/0x2c9
 [<ffffffff810ee418>] ? user_path_at+0x64/0x93
 [<ffffffff810e1e0d>] do_truncate+0x6a/0x87
 [<ffffffff810ea962>] ? generic_permission+0x1c/0x9f
 [<ffffffff810eaa5e>] ? get_write_access+0x1d/0x48
 [<ffffffff810e1f46>] sys_truncate+0x11c/0x160
 [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
 Code: e0 48 89 de 4c 89 f7 49 89 46 20 e8 66 f3 ff ff 85 c0 74 1b 89 c2 48 c7 c6 e0 b4 10 a0 48 c7 c7 9c d1 10 a0 31 c0 e8 7c 5c 25 e1 <0f> 0b eb 3d 49 8b 46 10 4c 89 ee 4c 89 f7 48 89 45 c8 e8 47 7d 
 RIP  [<ffffffffa00e071b>] btrfs_setattr+0x101/0x244 [btrfs]
 RSP <ffff88012095de08>
 ---[ end trace 18d84c057a649cf8 ]---
