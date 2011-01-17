From: Andy Isaacson <adi@hexapodia.org>
Subject: atime updates stuck under btrfs_dirty_inode
Date: Sun, 16 Jan 2011 23:34:40 -0800
Message-ID: <20110117073440.GB7508@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm seeing processes block (for minutes or longer) in directory access
on btrfs.  I'm running

commit ccda756d13f13a9276edc8d53d05aaecbf3c4baa
Merge: 0c21e3a 65e5341
Author: Andy Isaacson <adi@hexapodia.org>
Date:   Sun Jan 9 12:37:23 2011 -0800

    Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable

on a quad core Core i7.

There seem to be a few failure cases.  My most recent ls has been stuck
like this for several hours, on a directory that should have somewhere
between 6 and 50 entries:

% ps u 15028
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
adi      15028  0.0  0.0  27032  1204 pts/8    S+   22:18   0:00 ls -l /btr/foo
% cat /proc/15028/stack
[<ffffffffa013af78>] shrink_delalloc+0x112/0x147 [btrfs]
[<ffffffffa013b09f>] reserve_metadata_bytes+0xf2/0x1a8 [btrfs]
[<ffffffffa013b2d0>] btrfs_block_rsv_add+0x28/0x49 [btrfs]
[<ffffffffa013b33e>] btrfs_trans_reserve_metadata+0x4d/0x75 [btrfs]
[<ffffffffa014b4d4>] start_transaction+0x13e/0x1d8 [btrfs]
[<ffffffffa014b5c6>] btrfs_start_transaction+0x13/0x15 [btrfs]
[<ffffffffa014f9db>] btrfs_dirty_inode+0x6c/0xfd [btrfs]
[<ffffffff8111d82f>] __mark_inode_dirty+0x2b/0x1ab
[<ffffffff8111297a>] touch_atime+0x10e/0x131
[<ffffffff8110d49d>] vfs_readdir+0x79/0xa0
[<ffffffff8110d60d>] sys_getdents+0x81/0xd1
[<ffffffff81009e97>] tracesys+0xd9/0xde
[<ffffffffffffffff>] 0xffffffffffffffff

Sometimes, if I poll fast enough I see this stack instead:

% cat /proc/15028/stack
[<ffffffffa0149b2d>] wait_for_commit+0x99/0xe2 [btrfs]
[<ffffffffa014ac20>] btrfs_commit_transaction+0xfe/0x612 [btrfs]
[<ffffffffa014b4e7>] start_transaction+0x151/0x1d8 [btrfs]
[<ffffffffa014b5c6>] btrfs_start_transaction+0x13/0x15 [btrfs]
[<ffffffffa014f9db>] btrfs_dirty_inode+0x6c/0xfd [btrfs]
[<ffffffff8111d82f>] __mark_inode_dirty+0x2b/0x1ab
[<ffffffff8111297a>] touch_atime+0x10e/0x131
[<ffffffff8110d49d>] vfs_readdir+0x79/0xa0
[<ffffffff8110d60d>] sys_getdents+0x81/0xd1
[<ffffffff81009e97>] tracesys+0xd9/0xde
[<ffffffffffffffff>] 0xffffffffffffffff

Another ls has been accumulating runtime for several days:

 7406 pts/3    R+   2973:56  |   \_ ls -F

the directory it's reading has around 200 files in it, I think.

When I catch it in kernel mode its stack looks like this:

% cat /proc/7406/stack
[<ffffffff8111d293>] writeback_inodes_sb_nr+0x76/0x7d
[<ffffffff8111d6b0>] writeback_inodes_sb_nr_if_idle+0x41/0x55
[<ffffffffa013af15>] shrink_delalloc+0xaf/0x147 [btrfs]
[<ffffffffa013b09f>] reserve_metadata_bytes+0xf2/0x1a8 [btrfs]
[<ffffffffa013b2d0>] btrfs_block_rsv_add+0x28/0x49 [btrfs]
[<ffffffffa013b33e>] btrfs_trans_reserve_metadata+0x4d/0x75 [btrfs]
[<ffffffffa014b4d4>] start_transaction+0x13e/0x1d8 [btrfs]
[<ffffffffa014b5c6>] btrfs_start_transaction+0x13/0x15 [btrfs]
[<ffffffffa014f9db>] btrfs_dirty_inode+0x6c/0xfd [btrfs]
[<ffffffff8111d82f>] __mark_inode_dirty+0x2b/0x1ab
[<ffffffff8111297a>] touch_atime+0x10e/0x131
[<ffffffff8110d49d>] vfs_readdir+0x79/0xa0
[<ffffffff8110d60d>] sys_getdents+0x81/0xd1
[<ffffffff81009c82>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

vmstat is rather odd:

% vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  0      0 124348 177388 11276228    0    0   157    24    3    0  2 10 87  1
 1  0      0 122108 177388 11278540    0    0   536   112 2870 813309  2 13 83  2
 2  0      0 119628 177388 11280852    0    0   704     0 2938 887219  2 11 87  0
 2  0      0 117768 177388 11282684    0    0   800     0 2936 883427  2 15 82  1
 2  0      0 114872 177388 11285464    0    0  1104     0 2819 883498  1  8 90  0
 1  0      0 112704 177388 11287388    0    0   612     0 2961 880957  2 14 84  0
^C

One of the three block devices on this btrfs is reading a few hundred
blocks per second, but is nowhere near 100% busy; the CS count is
extremely high; and we have less than a full CPU spent in system time
(even though there are two ls processes "blocked").

If anyone can point me to a good place to start tracking down the root
cause, I'd appreciate it.

Thanks,
-andy
