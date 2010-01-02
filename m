From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: 2.6.33-rc2+ bug in fs/btrfs/ordered-data.c:672
Date: Sat, 2 Jan 2010 23:34:17 +0100
Message-ID: <20100102223416.GA6090@Pilar>
References: <20100102103227.GA3678@Pilar.aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100102103227.GA3678@Pilar.aei.mpg.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sa  2.Jan'10 at 11:32:27 +0100, Carlos R. Mafra wrote:
> I started testing btrfs for my /home a few days ago and yesterday
> I hit a kernel bug, using 2.6.33-rc2-00187-g08d869a.
> 
> I wasn't doing any stress test with it, I was simply watching a
> DVD with xine while chrome was open in another workspace.

Today I hit the bug twice, and it was always with chrome. I've
seen the other two reports in kerneloops.org involving
btrfs_ordered_update_i_size() and chrome was there too.

And now I saved the dmesg in the ext3 partition, so now there
is no need for the photo,


[13450.613952] ------------[ cut here ]------------
[13450.613957] kernel BUG at fs/btrfs/ordered-data.c:672!
[13450.613960] invalid opcode: 0000 [#1] SMP 
[13450.613963] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[13450.613966] CPU 1 
[13450.613970] Pid: 3372, comm: chrome Not tainted 2.6.33-rc2-fs-00187-g08d869a #293 VAIO/VGN-FZ240E
[13450.613973] RIP: 0010:[<ffffffff811d9537>]  [<ffffffff811d9537>] btrfs_ordered_update_i_size+0x237/0x3d0
[13450.613982] RSP: 0018:ffff880071355da8  EFLAGS: 00010287
[13450.613984] RAX: ffff88007f0c0728 RBX: 0000000000000000 RCX: ffff880077c0c6a8
[13450.613986] RDX: 00000000002b5000 RSI: 0000000000000000 RDI: ffff880077c0c6b8
[13450.613989] RBP: ffff880071355e18 R08: 0000000000000000 R09: 0000000000000000
[13450.613991] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800729dd260
[13450.613993] R13: 00000000002b4b24 R14: 0000000000000000 R15: 00000000002b4b24
[13450.613996] FS:  00007f2b3db68910(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
[13450.613999] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13450.614001] CR2: 00007f2b3c2a4000 CR3: 0000000071167000 CR4: 00000000000006e0
[13450.614003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[13450.614005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[13450.614008] Process chrome (pid: 3372, threadinfo ffff880071354000, task ffff88007d380640)
[13450.614010] Stack:
[13450.614011]  ffff8800729dd0c0 0000000000000000 fffffffffffff000 0000000000000fff
[13450.614015] <0> ffff8800729dd0f0 ffff88007c7cc000 ffff8800729dd0c0 ffff8800729dd170
[13450.614019] <0> ffff880071355e18 ffff880071355ee8 ffff8800729dd260 0000000000000000
[13450.614023] Call Trace:
[13450.614028]  [<ffffffff811c915d>] btrfs_setattr+0x17d/0x270
[13450.614033]  [<ffffffff810e5fe4>] notify_change+0x104/0x2e0
[13450.614037]  [<ffffffff810ce84f>] do_truncate+0x5f/0x90
[13450.614041]  [<ffffffff810d0002>] ? vfs_write+0x132/0x180
[13450.614044]  [<ffffffff810cef79>] sys_ftruncate+0xe9/0x130
[13450.614049]  [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b
[13450.614050] Code: 0f 1f 40 00 eb 88 66 0f 1f 44 00 00 49 8b 84 24 38 ff ff ff 48 85 c0 74 1b 48 8b 50 98 49 39 d5 72 12 48 03 50 a8 49 39 d5 73 09 <0f> 0b eb fe 0f 1f 44 00 00 49 8b 94 24 30 ff ff ff 48 89 55 b8 
[13450.614082] RIP  [<ffffffff811d9537>] btrfs_ordered_update_i_size+0x237/0x3d0
[13450.614087]  RSP <ffff880071355da8>
[13450.614090] ---[ end trace 74172209f4d15206 ]---
