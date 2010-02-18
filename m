From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Kernel BUG on mounting BtrFS / after reboot
Date: Thu, 18 Feb 2010 00:35:18 +0000 (UTC)
Message-ID: <loom.20100218T013258-629@post.gmane.org>
References: <loom.20100212T220341-877@post.gmane.org> <20100217141813.GH29430@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason <at> oracle.com> writes:

> 
> On Fri, Feb 12, 2010 at 09:04:39PM +0000, Alex Elsayed wrote:
> > I'm getting a rather nasty BUG when I try to mount this filesystem, 
> > _including_ when I specify -o ro. I'm unsure what caused it, but the problem 
> > manifested after my computer hardlocked while reading my RSS feeds, complete 
> > with flashing lights. After I rebooted it, the screen filled with panic 
> > messages when the initramfs tried to mount it RO to pivot into. I am running 
> > 2.6.33-rc6. The BUG message is as follows:
> 
> The good news is this looks like a bug that Yan Zheng fixed.  2.6.33-rc7
> or later should mount without problems.  If you're having trouble
> getting that image onto that box, I'll get a usb boot image up with it
> running for you.
> 
> -chris

No such luck. -rc8 still BUGs. Trace below:

[ 1340.258885] ------------[ cut here ]------------
[ 1340.258895] kernel BUG at fs/btrfs/tree-log.c:809!
[ 1340.258901] invalid opcode: 0000 [#1] PREEMPT SMP
[ 1340.258910] last sysfs file: /sys/fs/ecryptfs/version
[ 1340.258915] CPU 0
[ 1340.258924] Pid: 2795, comm: mount Not tainted 2.6.33-rc8-zen1 #1 MS-
1651/GX620
[ 1340.258930] RIP: 0010:[<ffffffff8124662c>]  [<ffffffff8124662c>] 
add_inode_ref+0x69/0x423
[ 1340.258947] RSP: 0018:ffff880037ae7888  EFLAGS: 00010246
[ 1340.258952] RAX: 0000000000000000 RBX: ffff8800375df090 RCX: ffff880104b41f80
[ 1340.258958] RDX: ffff880037ae77e8 RSI: ffff8800bd5b7800 RDI: ffff88013b6c3800
[ 1340.258964] RBP: ffff880037ae7948 R08: ffff880005a12800 R09: ffff88010bebe0d0
[ 1340.258970] R10: ffff880037ae7758 R11: 0000000000000000 R12: ffff8800bd5b7800
[ 1340.258976] R13: ffff880104b41940 R14: 0000000000000000 R15: ffff880037ae79a8
[ 1340.258983] FS:  00007f8363b58740(0000) GS:ffff880005a00000(0000) 
knlGS:0000000000000000
[ 1340.258989] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1340.258995] CR2: 00007fa762002000 CR3: 0000000037af2000 CR4: 00000000000006f0
[ 1340.259001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1340.259007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1340.259013] Process mount (pid: 2795, threadinfo ffff880037ae6000, task 
ffff880037971700)
[ 1340.259018] Stack:
[ 1340.259022]  ffff880037ae7900 ffffffff00000004 ffff8800bd5b4800 
00000000000000ac
[ 1340.259032] <0> 0000000000000065 00000002375995a0 0000000000000097 
ffffffff81728165
[ 1340.259042] <0> ffff880037ae78d8 ffffffff81235642 ffff880037ae7948 
ffffffff8122be16
[ 1340.259054] Call Trace:
[ 1340.259066]  [<ffffffff81728165>] ? sub_preempt_count+0x9/0x83
[ 1340.259074]  [<ffffffff81235642>] ? unmap_extent_buffer+0x13/0x2e
[ 1340.259083]  [<ffffffff8122be16>] ? btrfs_item_size+0xbb/0xcb
[ 1340.259092]  [<ffffffff81247788>] replay_one_buffer+0x27e/0x310
[ 1340.259102]  [<ffffffff81244a6c>] walk_down_log_tree+0x277/0x5fd
[ 1340.259111]  [<ffffffff81244ed1>] walk_log_tree+0xdf/0x250
[ 1340.259119]  [<ffffffff81724cf1>] ? _raw_spin_unlock+0x15/0x30
[ 1340.259128]  [<ffffffff81246048>] btrfs_recover_log_trees+0x1be/0x2d6
[ 1340.259137]  [<ffffffff8124750a>] ? replay_one_buffer+0x0/0x310
[ 1340.259146]  [<ffffffff812185fd>] ? btree_read_extent_buffer_pages+0x71/0xaf
[ 1340.259156]  [<ffffffff8121c568>] open_ctree+0x12bc/0x15c9
[ 1340.259165]  [<ffffffff812dda73>] ? vsnprintf+0x1d8/0x44b
[ 1340.259177]  [<ffffffff811ff32d>] btrfs_get_sb+0x1d0/0x3ec
[ 1340.259188]  [<ffffffff81124f46>] vfs_kern_mount+0xa9/0x168
[ 1340.259196]  [<ffffffff8112506d>] do_kern_mount+0x4d/0xed
[ 1340.259206]  [<ffffffff8113b917>] do_mount+0x786/0x7fd
[ 1340.259215]  [<ffffffff810effe4>] ? strndup_user+0x5d/0x85
[ 1340.259223]  [<ffffffff8113ba16>] sys_mount+0x88/0xc2
[ 1340.259233]  [<ffffffff81009c52>] system_call_fastpath+0x16/0x1b
[ 1340.259238] Code: 89 e7 e8 05 eb ff ff 49 89 c5 b8 fe ff ff ff 4d 85 ed 0f 84 
bb 03 00 00 49 8b 37 4c 89 e7 e8 e9 ea ff ff 49 89 c6 48 85 c0 75 04 <0f> 0b eb 
fe 48 63 85 6c ff ff ff 48 8b 7d b0 48 6b c0 19 48 83
[ 1340.259327] RIP  [<ffffffff8124662c>] add_inode_ref+0x69/0x423
[ 1340.259337]  RSP <ffff880037ae7888>
[ 1340.259377] ---[ end trace 81037f7cb67410e7 ]---

