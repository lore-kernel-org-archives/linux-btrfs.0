From: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: linux 3.0: kernel BUG at fs/btrfs/inode.c:1584!
Date: Wed, 31 Aug 2011 21:31:36 +0200
Message-ID: <201108312131.36670.maciej.rutecki@gmail.com>
References: <20110825093242.GA8450@msgid.wurtel.net>
Reply-To: maciej.rutecki@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: linux-kernel@vger.kernel.org
To: Paul Slootman <paul@wurtel.net>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110825093242.GA8450@msgid.wurtel.net>
List-ID: <linux-btrfs.vger.kernel.org>

On czwartek, 25 sierpnia 2011 o 11:32:42 Paul Slootman wrote:
> I got the following message just now:
> 
> Aug 25 09:53:14 duimalot kernel: kernel BUG at fs/btrfs/inode.c:1584!
> Aug 25 09:53:14 duimalot kernel: invalid opcode: 0000 [#1] SMP
> Aug 25 09:53:14 duimalot kernel: CPU 1
> Aug 25 09:53:14 duimalot kernel: Modules linked in: loop 8021q acpi_cpufreq
> mperf e1000 sg sr_mod e1000e cdrom processor container button evdev
> thermal_sys i3000_edac arcmsr edac_core Aug 25 09:53:14 duimalot kernel:
> Aug 25 09:53:14 duimalot kernel: Pid: 12162, comm: btrfs-fixup-0 Tainted: G
>        W   3.0.0-vs2.3.1-pre8 #2 Supermicro PDSM4+/PDSM4+ Aug 25 09:53:14
> duimalot kernel: RIP: 0010:[<ffffffff812220e8>]  [<ffffffff812220e8>]
> btrfs_writepage_fixup_worker+0x158/0x160 Aug 25 09:53:14 duimalot kernel:
> RSP: 0018:ffff880117f13df0  EFLAGS: 00010246 Aug 25 09:53:14 duimalot
> kernel: RAX: 0000000000000000 RBX: 000000000a45b000 RCX: 0000000000000000
> Aug 25 09:53:14 duimalot kernel: RDX: 000000025a32b7f4 RSI:
> 000000000a45b000 RDI: ffff880016ca90a0 Aug 25 09:53:14 duimalot kernel:
> RBP: ffffea00038a4058 R08: ffffea00002c30a8 R09: ffffffff8124290f Aug 25
> 09:53:14 duimalot kernel: R10: 0000000000000010 R11: 0000000000000000 R12:
> 000000000a45bfff Aug 25 09:53:14 duimalot kernel: R13: ffff880016ca9178
> R14: ffff880016ca9010 R15: 0000000000000000 Aug 25 09:53:14 duimalot
> kernel: FS:  0000000000000000(0000) GS:ffff88011fd00000(0000)
> knlGS:0000000000000000 Aug 25 09:53:14 duimalot kernel: CS:  0010 DS: 0000
> ES: 0000 CR0: 000000008005003b Aug 25 09:53:14 duimalot kernel: CR2:
> 000000001b0a62f8 CR3: 0000000025608000 CR4: 00000000000006e0 Aug 25
> 09:53:14 duimalot kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000 Aug 25 09:53:14 duimalot kernel: DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400 Aug 25 09:53:14 duimalot
> kernel: Process btrfs-fixup-0 (pid: 12162, threadinfo ffff880117f12000,
> task ffff880118920760) Aug 25 09:53:14 duimalot kernel: Stack:
> Aug 25 09:53:14 duimalot kernel:  ffff880056cbb420 0000000000000000
> ffff8800748aec00 ffff880056cbb428 Aug 25 09:53:14 duimalot kernel: 
> ffff880056cbb450 ffff8801064aa840 ffff8801064aa890 ffff8801064aa858 Aug 25
> 09:53:14 duimalot kernel:  ffff8801064aa848 ffffffff8124d419
> ffff880117f13e90 ffff880117f13e80 Aug 25 09:53:14 duimalot kernel: Call
> Trace:
> Aug 25 09:53:14 duimalot kernel:  [<ffffffff8124d419>] ?
> worker_loop+0x169/0x520 Aug 25 09:53:14 duimalot kernel: 
> [<ffffffff8124d2b0>] ? btrfs_queue_worker+0x2f0/0x2f0 Aug 25 09:53:14
> duimalot kernel:  [<ffffffff81065956>] ? kthread+0x96/0xb0 Aug 25 09:53:14
> duimalot kernel:  [<ffffffff81495394>] ? kernel_thread_helper+0x4/0x10 Aug
> 25 09:53:14 duimalot kernel:  [<ffffffff810658c0>] ?
> kthread_worker_fn+0x180/0x180 Aug 25 09:53:14 duimalot kernel: 
> [<ffffffff81495390>] ? gs_change+0xb/0xb Aug 25 09:53:14 duimalot kernel:
> Code: 5c 41 5d 41 5e 41 5f c3 0f 1f 00 41 b8 50 00 00 00 48 8d 4c 24 10 4c
> 89 e2 48 89 de 4c 89 f7 e8 7f 1e 02 00 eb ba 0f 1f 44 00 00 <0f> 0b eb fe
> 0f 1f 40 00 41 56 49 89 fe 41 55 41 54 55 53 48 83 Aug 25 09:53:14
> duimalot kernel: RIP  [<ffffffff812220e8>]
> btrfs_writepage_fixup_worker+0x158/0x160 Aug 25 09:53:14 duimalot kernel: 
> RSP <ffff880117f13df0>
> Aug 25 09:53:14 duimalot kernel: ---[ end trace 948b88b1d8dd7dc8 ]---
> 
> The system has been running previously just fine for more than a year
> before I upgraded it to linux 3.0 and added a btrfs filesystem.
> This is a storage system, and the btrfs filesystem is 41TB in size.
> Currently it's 17% full.
> 
> If any other info is needed, let me know.
> 
> 

Cany you check that eg 2.6.39 works OK and/or try bisecton?

(add CCs)

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
