From: David Sterba <dave@jikos.cz>
Subject: Re: [BUG] Kernel Bug at fs/btrfs/volumes.c:3638
Date: Thu, 1 Mar 2012 01:27:55 +0100
Message-ID: <20120301002755.GV1046@twin.jikos.cz>
References: <4F476959.2010400@linux.vnet.ibm.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	chris.mason@oracle.com, kamalesh@linux.vnet.ibm.com
To: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F476959.2010400@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

I just noticed that there's a bugreport from opensuse user tripping over
the same BUG() during log replay (and his problem was solved by
btrfs-zero-log), probably after some crash. The kernel version was 3.1
ie. without the corruption fixes, so while it happened during normal use
(and not via a crafted fs image), I'm not sure if this is still the case
with recent kernels.

Turning the BUG in __btrfs_map_block to return needs checking the value
in not-so-few callers and from various callpaths, it's not
straightforward to do eg. a quick return during mount, as in your case.

Good that Jeff Mahoney's error handling series reduce the number of
callers to update.


david

------------[ cut here ]------------
WARNING: at /home/abuild/rpmbuild/BUILD/kernel-desktop-3.1.0/linux-3.1/fs/btrfs/tree-log.c:1729 walk_down_log_tree+0x
15a/0x3e0 [btrfs]()
Pid: 8978, comm: mount Not tainted 3.1.0-1.2-desktop #1
Call Trace:
 [<ffffffff810043fa>] dump_trace+0xaa/0x2b0
 [<ffffffff81582a4a>] dump_stack+0x69/0x6f
 [<ffffffff8105386b>] warn_slowpath_common+0x7b/0xc0
 [<ffffffffa0573cba>] walk_down_log_tree+0x15a/0x3e0 [btrfs]
 [<ffffffffa0574267>] walk_log_tree+0xc7/0x1f0 [btrfs]
 [<ffffffffa057803c>] btrfs_recover_log_trees+0x1ec/0x2d0 [btrfs]
 [<ffffffffa0544303>] open_ctree+0x13c3/0x1740 [btrfs]
 [<ffffffffa0522733>] btrfs_fill_super.isra.36+0x73/0x150 [btrfs]
 [<ffffffffa0523b29>] btrfs_mount+0x359/0x3e0 [btrfs]
 [<ffffffff81156465>] mount_fs+0x45/0x1d0
 [<ffffffff8116fdb6>] vfs_kern_mount+0x66/0xd0
 [<ffffffff81171383>] do_kern_mount+0x53/0x120
 [<ffffffff81172e35>] do_mount+0x1a5/0x260
 [<ffffffff811732da>] sys_mount+0x9a/0xf0
 [<ffffffff815a3292>] system_call_fastpath+0x16/0x1b
 [<00007fc524137daa>] 0x7fc524137da9
---[ end trace 2bf4520d35da960f ]---
unable to find logical 5493736079360 len 4096
------------[ cut here ]------------

1728                 if (btrfs_header_level(cur) != *level)
1729                         WARN_ON(1);


kernel BUG at /home/abuild/rpmbuild/BUILD/kernel-desktop-3.1.0/linux-3.1/fs/btrfs/volumes.c:2891!
invalid opcode: 0000 [#1] PREEMPT SMP
CPU 1

Pid: 8978, comm: mount Tainted: G        W   3.1.0-1.2-desktop #1
RIP: 0010:[<ffffffffa0568e28>]  [<ffffffffa0568e28>] __btrfs_map_block+0x7c8/0x890 [btrfs]
RSP: 0018:ffff8801b7507798  EFLAGS: 00010296
RAX: 0000000000000043 RBX: 000004ff1c300000 RCX: 0000000000002a82
RDX: 000000000000723a RSI: 0000000000000046 RDI: 0000000000000202
RBP: ffff8801b7507860 R08: 000000000000000a R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801dcd10cc0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
FS:  00007fc524c587e0(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faea5cb8000 CR3: 00000001b74f4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 8978, threadinfo ffff8801b7506000, task ffff8801b0d9c740)
Call Trace:
 [<ffffffffa056baa7>] btrfs_map_bio+0x57/0x210 [btrfs]
 [<ffffffffa05600d4>] submit_one_bio+0x64/0xa0 [btrfs]
 [<ffffffffa05653c7>] read_extent_buffer_pages+0x367/0x4a0 [btrfs]
 [<ffffffffa053fd10>] btree_read_extent_buffer_pages.isra.63+0x80/0xc0 [btrfs]
 [<ffffffffa0542b3a>] btrfs_read_buffer+0x2a/0x40 [btrfs]
 [<ffffffffa0576d56>] replay_one_buffer+0x46/0x360 [btrfs]
 [<ffffffffa0573d6d>] walk_down_log_tree+0x20d/0x3e0 [btrfs]
 [<ffffffffa0574267>] walk_log_tree+0xc7/0x1f0 [btrfs]
 [<ffffffffa057803c>] btrfs_recover_log_trees+0x1ec/0x2d0 [btrfs]
 [<ffffffffa0544303>] open_ctree+0x13c3/0x1740 [btrfs]
 [<ffffffffa0522733>] btrfs_fill_super.isra.36+0x73/0x150 [btrfs]
 [<ffffffffa0523b29>] btrfs_mount+0x359/0x3e0 [btrfs]
 [<ffffffff81156465>] mount_fs+0x45/0x1d0
 [<ffffffff8116fdb6>] vfs_kern_mount+0x66/0xd0
 [<ffffffff81171383>] do_kern_mount+0x53/0x120
 [<ffffffff81172e35>] do_mount+0x1a5/0x260
 [<ffffffff811732da>] sys_mount+0x9a/0xf0
 [<ffffffff815a3292>] system_call_fastpath+0x16/0x1b
 [<00007fc524137daa>] 0x7fc524137da9
