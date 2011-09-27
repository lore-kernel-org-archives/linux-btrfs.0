From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 00/21] [RFC] Btrfs: restriper
Date: Tue, 27 Sep 2011 14:47:34 +0200
Message-ID: <20110927124734.GY22205@twin.jikos.cz>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, hugo@carfax.org.uk,
	linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've hit a problem with restriper but under ragher unclear conditions:

[12308.210636] ------------[ cut here ]------------
[12308.214185] kernel BUG at fs/btrfs/relocation.c:2047!
[12308.214185] invalid opcode: 0000 [#1] SMP
[12308.214185] CPU 0
[12308.214185] Modules linked in: loop btrfs aoe
[12308.214185]
[12308.214185] Pid: 31102, comm: btrfs Not tainted 3.1.0-rc7-default+ #32 Intel Corporation Santa Rosa platform/Matanzas
[12308.214185] RIP: 0010:[<ffffffffa0084af5>]  [<ffffffffa0084af5>] merge_reloc_root+0x5d5/0x600 [btrfs]
[12308.214185] RSP: 0018:ffff88003e0159f8  EFLAGS: 00010293
[12308.214185] RAX: 00000000ffffffe4 RBX: ffff880051bc1c70 RCX: 0000000000000000
[12308.214185] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff880053a9ccb8
[12308.214185] RBP: ffff88003e015ae8 R08: 0000000000000000 R09: 0000000000000000
[12308.214185] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880075041000
[12308.214185] R13: ffff8800585bb198 R14: ffff880000000000 R15: ffff880026e04000
[12308.214185] FS:  00007fda377f3740(0000) GS:ffff88007e400000(0000) knlGS:0000000000000000
[12308.214185] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12308.214185] CR2: 00007f049bb1c000 CR3: 0000000026c97000 CR4: 00000000000006f0
[12308.214185] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12308.214185] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[12308.214185] Process btrfs (pid: 31102, threadinfo ffff88003e014000, task ffff880040d549c0)
[12308.214185] Stack:
[12308.214185]  000000003e015a08 ffff880057b98070 ffff880026fc30fc 0000000000000246
[12308.214185]  ffff880057b98070 ffff880057b98058 000000000000e000 ffff880026fc3000
[12308.214185]  ffff880057b98058 ffff880057b98058 ffff88003e015a68 ffffffff81c2835b
[12308.214185] Call Trace:
[12308.214185]  [<ffffffff81c2835b>] ? _raw_spin_unlock+0x2b/0x50
[12308.214185]  [<ffffffffa00364ad>] ? btrfs_read_fs_root_no_name+0x1fd/0x310 [btrfs]
[12308.214185]  [<ffffffffa0084c44>] merge_reloc_roots+0x124/0x150 [btrfs]
[12308.214185]  [<ffffffffa0085258>] relocate_block_group+0x398/0x610 [btrfs]
[12308.214185]  [<ffffffffa003bcf7>] ? btrfs_clean_old_snapshots+0x197/0x1c0 [btrfs]
[12308.214185]  [<ffffffffa0085680>] btrfs_relocate_block_group+0x1b0/0x2e0 [btrfs]
[12308.214185]  [<ffffffffa0060b7b>] btrfs_relocate_chunk+0x8b/0x6c0 [btrfs]
[12308.214185]  [<ffffffff810e0e10>] ? trace_hardirqs_on_caller+0x20/0x1d0
[12308.214185]  [<ffffffff81089383>] ? __wake_up+0x53/0x70
[12308.214185]  [<ffffffffa006ef80>] ? btrfs_tree_read_unlock_blocking+0x40/0x60 [btrfs]
[12308.214185]  [<ffffffffa0064ca9>] btrfs_restripe+0x689/0xb00 [btrfs]
[12308.214185]  [<ffffffff811858e4>] ? __kmalloc+0x234/0x260
[12308.214185]  [<ffffffffa006e871>] btrfs_ioctl+0x14e1/0x1560 [btrfs]
[12308.214185]  [<ffffffff81c2c660>] ? do_page_fault+0x2d0/0x580
[12308.214185]  [<ffffffff811a4568>] do_vfs_ioctl+0x98/0x560
[12308.214185]  [<ffffffff810da369>] ? trace_hardirqs_off_caller+0x29/0xc0
[12308.214185]  [<ffffffff81c28bd9>] ? retint_swapgs+0x13/0x1b
[12308.214185]  [<ffffffff81192a6b>] ? fget_light+0x17b/0x3c0
[12308.214185]  [<ffffffff811a4a7f>] sys_ioctl+0x4f/0x80
[12308.214185]  [<ffffffff81c312c2>] system_call_fastpath+0x16/0x1b
[12308.214185] Code: ff ff 41 bd f4 ff ff ff eb b9 48 8d 95 70 ff ff ff 48 8d 75 90 4c 89 ff e8 a9 9f ff ff eb a4 48 89 df e8 cf 28 f9 ff eb 9a 0f 0b <0f> 0b 0f 0b 0f 0b be ef 07 00 00 48 c7 c7 b4 49 09 a0 e8 54 99
[12308.214185] RIP  [<ffffffffa0084af5>] merge_reloc_root+0x5d5/0x600 [btrfs]
[12308.214185]  RSP <ffff88003e0159f8>
[12308.652440] ---[ end trace a106d7cf9f82a8ff ]---


steps before the crash
- data: a freshly created raid10, 5 devices with about 4 gigs of data, lots of
  chained snapshots, lots of them deleted (both numbers are in order of 10)
- device remove
- restripe
- device add
- restriper start [blocked]
- restripe cancel [blocked]
- *crash*

- successive mount is ok
- rebalance continues, can be started/cancelled without problems


the error is ENOSPC from snapshot cleanup.

one thing that was visible only on disk activity monitor was a steady
several-megs of writes performed by freespace thread. I've seen this already,
but I'm not able to reproduce it reliably.

the tree is from my experimental integration branch
http://repo.or.cz/w/linux-2.6/btrfs-unstable.git integration/btrfs-next-experimental

(linus+josef+mark+janosch+restriper+hotfixes from mailinglist)

apart from that, basic switching of raids works nicely.


david
