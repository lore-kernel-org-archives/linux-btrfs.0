From: David Sterba <dave@jikos.cz>
Subject: Drive without DISCARD support crashes btrfs
Date: Tue, 17 May 2011 17:27:43 +0200
Message-ID: <20110517152743.GU12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: lidongyang@novell.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while playing with lockedp, I started to hit consistent crashes with
xfstests/013 (fsstress):

[  537.284234] ------------[ cut here ]------------
[  537.288040] kernel BUG at fs/btrfs/tree-log.c:1792!
[  537.288040] invalid opcode: 0000 [#1] SMP
[  537.288040] last sysfs file: /sys/devices/virtual/bdi/btrfs-10/uevent
[  537.288040] CPU 1
[  537.288040] Modules linked in: btrfs
[  537.288040]
[  537.288040] Pid: 12069, comm: fsstress Not tainted 2.6.39-rc7-default+ #24 Intel
[  537.288040] RIP: 0010:[<ffffffffa0063c79>]  [<ffffffffa0063c79>] walk_up_log_tree+0x2f9/0x330 [btrfs]
[  537.288040] RSP: 0018:ffff880058191c08  EFLAGS: 00010282
[  537.288040] RAX: 00000000ffffffa1 RBX: ffff88004f863910 RCX: 0000000000000001
[  537.288040] RDX: 0000000000000f0e RSI: 0000000000000001 RDI: ffff880078bd8600
[  537.288040] RBP: ffff880058191c88 R08: 0000000000000000 R09: 0000000000000001
[  537.288040] R10: 0000000000000000 R11: 0000000000006945 R12: ffff880058191cb4
[  537.288040] R13: 0000000000000000 R14: ffff880000000000 R15: ffff880058191cf8
[  537.288040] FS:  00007f469ba3d700(0000) GS:ffff88007e600000(0000) knlGS:0000000000000000
[  537.288040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  537.288040] CR2: 00007f469af27430 CR3: 000000007ba3c000 CR4: 00000000000006e0
[  537.288040] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  537.288040] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  537.288040] Process fsstress (pid: 12069, threadinfo ffff880058190000, task ffff8800782f1140)
[  537.288040] Stack:
[  537.288040]  ffff880058191fd8 ffff88005e326f20 ffff880058191fd8 fffffffffffffffa
[  537.288040]  ffff880058191fd8 ffff880058191fd8 ffff880058191fd8 ffff880058191fd8
[  537.288040]  ffff88004eca4598 ffff8800580a6000 ffff880058191da8 0000000000000000
[  537.288040] Call Trace:
[  537.288040]  [<ffffffffa0064348>] walk_log_tree+0x108/0x2a0 [btrfs]
[  537.288040]  [<ffffffffa0064523>] free_log_tree+0x43/0xc0 [btrfs]
[  537.288040]  [<ffffffffa0061950>] ? insert_one_name+0xc0/0xc0 [btrfs]
[  537.288040]  [<ffffffffa006663f>] btrfs_free_log+0x1f/0x30 [btrfs]
[  537.288040]  [<ffffffffa002bb61>] commit_fs_roots+0x91/0x150 [btrfs]
[  537.288040]  [<ffffffffa002cc70>] ? btrfs_commit_transaction+0x340/0x7d0 [btrfs]
[  537.288040]  [<ffffffffa002cc70>] ? btrfs_commit_transaction+0x340/0x7d0 [btrfs]
[  537.288040]  [<ffffffffa002cc7b>] btrfs_commit_transaction+0x34b/0x7d0 [btrfs]
[  537.288040]  [<ffffffff810b8c80>] ? wake_up_bit+0x40/0x40
[  537.288040]  [<ffffffff811a8cb0>] ? __sync_filesystem+0x90/0x90
[  537.288040]  [<ffffffffa0003210>] btrfs_sync_fs+0x60/0xe0 [btrfs]
[  537.288040]  [<ffffffff811a8c7e>] __sync_filesystem+0x5e/0x90
[  537.288040]  [<ffffffff811a8ccf>] sync_one_sb+0x1f/0x30
[  537.288040]  [<ffffffff8117f287>] iterate_supers+0x77/0xe0
[  537.288040]  [<ffffffff811a8bd0>] sync_filesystems+0x20/0x30
[  537.616540]  [<ffffffff811a8d71>] sys_sync+0x21/0x40
[  537.616540]  [<ffffffff81e94f42>] system_call_fastpath+0x16/0x1b
[  537.616540] Code: 00 00 48 83 c4 58 b8 01 00 00 00 5b 41 5c 41 5d 41 5e 41 5f c9 c3 0f 1f 40 00 48 83 c4 58 b0 01 5b 41 5c 41 5d 41 5e 41 5f c9 c3 <0f> 0b be fc 06 00 00 48 c7 c7 c8 f4 07 a0 e8 34 08 03 e1 e9 c0
[  537.616540] RIP  [<ffffffffa0063c79>] walk_up_log_tree+0x2f9/0x330 [btrfs]
[  537.616540]  RSP <ffff880058191c08>
[  537.619306] ---[ end trace 5f9597f2f24fa95c ]---

it's applied on top of today's linus c1d10d18c5. Mount options are
compress and discard.

fsstress process is in D-state with
# cat /proc/12068/stack
[<ffffffffa002d419>] start_transaction+0x79/0x2f0 [btrfs]
[<ffffffffa002da13>] btrfs_start_transaction+0x13/0x20 [btrfs]
[<ffffffffa002e1aa>] __unlink_start_trans+0x4a/0x400 [btrfs]
[<ffffffffa0035997>] btrfs_unlink+0x37/0xe0 [btrfs]
[<ffffffff8118ab6a>] vfs_unlink+0x8a/0xf0
[<ffffffff8118ad53>] do_unlinkat+0x183/0x1c0
[<ffffffff8118bbc6>] sys_unlink+0x16/0x20
[<ffffffff81e94f42>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

shutdown is stuck, sync of btrfs does not proceed due to blocked
transaction commit due to previsou failures.

crash site:
1789                                 ret = btrfs_free_reserved_extent(root,
1790                                                 path->nodes[*level]->start,
1791                                                 path->nodes[*level]->len);
1792                                 BUG_ON(ret);

if EAX contains ret, 0xFFFFFFa1, which seems to be EOPNOTSUPP comming from
discard handling in btrfs_free_reserved_extent().

walk_up_log_tree
  btrfs_free_reserved_extent
    btrfs_discard_extent
      return -EOPNOTSUPP
    BUG_ON ret

I suspect line 1793 in btrfs_discard_extent():

1766 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
1767                                 u64 num_bytes, u64 *actual_bytes)
1768 {
...
1793         if (discarded_bytes && ret == -EOPNOTSUPP)
1794                 ret = 0;
...
1800         return ret;
1801 }

discarded_bytes is initially 0, ret is EOPNOTSUPP from not-done
btrfs_issue_discard, true branch is not taken and nonzero retcode is
propagated.

I think the "discarded_bytes != 0" check should be dropped, I do not see why
it's there. Going to test now.


david
