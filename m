From: Andrew Schretter <schrett@math.duke.edu>
Subject: btrfsck segmentation fault
Date: Fri, 07 Jan 2011 16:15:44 -0500
Message-ID: <4D278280.4060907@math.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a 10TB btrfs filesystem over iSCSI that is currently unmountable.  I'm
currently running Fedora 13 with a recent Fedora 14 kernel (2.6.35.9-64.fc14.i686.PAE)
and the system hung with messages like :

parent transid verify failed on 5937615339520 wanted 48547 found 48542

I've rebooted and and am attempting to recover with btrfsck from the btrfs-progs-unstable
git tree, but it is segfaulting after finding a superblock and listing out 3 of the
"parent transid" messages.  Anyone have any ideas?

I tried btrfsck /dev/sdb, btrfsck -s 1 /dev/sdb, and btrfsck -s 2 /dev/sdb with the
same result for each.  The btrfsck binary I compiled does work on a small (800MB) test
btrfs file system.  I suspect it may be due to the size of the filesystem I am trying
to repair.

Running btrfsck with gdb returns :
#0  find_first_block_group (root=0x8067178, path=0x80677f8, key=0xbffff24b) at extent-tree.c:3028
#1  0x08055603 in btrfs_read_block_groups (root=0x8067178) at extent-tree.c:3072
#2  0x08053009 in open_ctree_fd (fp=7, path=0xbffff63a "/dev/sdb", sb_bytenr=<value optimized out>, writes=0) at disk-io.c:760
#3  0x080530e8 in open_ctree (filename=0xbffff63a "/dev/sdb", sb_bytenr=0, writes=0) at disk-io.c:587
#4  0x0804d3fc in main (ac=<value optimized out>, av=Cannot access memory at address 0x4

In any event, recovering the data would be nice and any ideas to do so would be appreciated.

-- 

Andrew Schretter
Systems Programmer, Duke University
Dept. of Mathematics (919) 660-2866

