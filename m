Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54104 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2HOTlE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 15:41:04 -0400
Received: by vcbfk26 with SMTP id fk26so1773438vcb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2012 12:41:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Aug 2012 12:41:02 -0700
Message-ID: <CAKgsxVT69MPeQJik6oCx9rXOpze7UU7Nh2RRKtQv9pXajS8X=g@mail.gmail.com>
Subject: btrfsck crash, irreparable filesystem
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been experimenting with btrfs for a few weeks now, and things
have been going smoothly, until yesterday.  Today my filesystem seems
to be in an irrecoverable situation.

I had btrfs running on a small (4GB) MD RAID5 array for a while, and
things were working well.  I started running out of space, so I
decided I would add a couple disk partitions to the btrfs storage pool
to give me some more space.  Everything looked good after that, until
I rebooted.  At that point, I got "kernel BUG at
mm/page-writeback.c:1285".  On my kernel (I'm based off Oracle UEK
v2.6.39-200.29.1, plus several patches pulled in from the kernel.org
3.0-stable series, x86_64 arch), that points to
BUG_ON(!PageLocked(page)) in clear_page_dirty_for_io().
Unfortunately, I lost the rest of the backtrace information.  My
machine was frozen, so I rebooted once again.

This time, when I tried mounting the filesystem, I got another BUG_ON
from fs/btrfs/disk-io.c:2404.  This points to an error being returned
by btrfs_cleanup_fs_roots() in open_ctree().  Okay, so I had to reboot
again.  I tried mounting with -o recovery, but that didn't work
either.  My kernel log said:

btrfs: enabling auto recovery
btrfs: disk space caching is enabled
btrfs csum failed ino 24231 off 172032 csum 1182238171 private 3178218629
BTRFS: inode 24231 still on the orphan list
btrfs: could not do orphan cleanup -5
btrfs: open_ctree failed

So, I decided to pull the latest btrfs-progs from git master and try
btrfsck --recover.  This produced a segmentation fault.  Running
through valgrind, it looks like there are several things that btrfsck
does that valgrind doesn't like -- at least on my filesystem.  Almost
all of them come from use of read_extent_buffer() and
write_extent_buffer(), including the invalid write that causes the
segfault.

==2673== Memcheck, a memory error detector
==2673== Copyright (C) 2002-2011, and GNU GPL'd, by Julian Seward et al.
==2673== Using Valgrind-3.7.0 and LibVEX; rerun with -h for copyright info
==2673== Command: ./btrfsck --repair /dev/md0
==2673==
enabling repair mode
==2673== Syscall param ioctl(generic) points to uninitialised byte(s)
==2673==    at 0x5387727: ioctl (syscall-template.S:82)
==2673==    by 0x41CDCE: btrfs_register_one_device (utils.c:945)
==2673==    by 0x41D50E: btrfs_scan_block_devices (utils.c:1213)
==2673==    by 0x41D563: btrfs_scan_for_fsid (utils.c:1057)
==2673==    by 0x41D5E1: check_mounted_where (utils.c:843)
==2673==    by 0x41D75C: check_mounted (utils.c:820)
==2673==    by 0x406CFE: main (btrfsck.c:3535)
==2673==  Address 0x7fefff3f0 is on thread 1's stack
==2673==
==2673== Invalid read of size 2
==2673==    at 0x4C2A840: memcpy (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x418FF4: write_extent_buffer (string3.h:52)
==2673==    by 0x41B4A9: btrfs_read_sys_array (volumes.c:1487)
==2673==    by 0x40E2AE: __open_ctree_fd (disk-io.c:729)
==2673==    by 0x40E81C: open_ctree_fs_info (disk-io.c:864)
==2673==    by 0x406D82: main (btrfsck.c:3543)
==2673==  Address 0x56523e6 is 390 bytes inside a block of size 4,096 free'd
==2673==    at 0x4C27D4E: free (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x4195E3: btrfs_scan_one_device (volumes.c:224)
==2673==    by 0x40DFF5: __open_ctree_fd (disk-io.c:635)
==2673==    by 0x40E81C: open_ctree_fs_info (disk-io.c:864)
==2673==    by 0x406D82: main (btrfsck.c:3543)
==2673==
==2673== Invalid read of size 2
==2673==    at 0x4C2A854: memcpy (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x418FF4: write_extent_buffer (string3.h:52)
==2673==    by 0x41B4A9: btrfs_read_sys_array (volumes.c:1487)
==2673==    by 0x40E2AE: __open_ctree_fd (disk-io.c:729)
==2673==    by 0x40E81C: open_ctree_fs_info (disk-io.c:864)
==2673==    by 0x406D82: main (btrfsck.c:3543)
==2673==  Address 0x56523e2 is 386 bytes inside a block of size 4,096 free'd
==2673==    at 0x4C27D4E: free (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x4195E3: btrfs_scan_one_device (volumes.c:224)
==2673==    by 0x40DFF5: __open_ctree_fd (disk-io.c:635)
==2673==    by 0x40E81C: open_ctree_fs_info (disk-io.c:864)
==2673==    by 0x406D82: main (btrfsck.c:3543)
==2673==
==2673== Invalid read of size 1
==2673==    at 0x4C2A76E: memcpy (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x418FDB: read_extent_buffer (string3.h:52)
==2673==    by 0x415870: btrfs_find_last_root (root-tree.c:53)
==2673==    by 0x40DBC5: find_and_setup_root (disk-io.c:439)
==2673==    by 0x40E401: __open_ctree_fd (disk-io.c:770)
==2673==    by 0x40E81C: open_ctree_fs_info (disk-io.c:864)
==2673==    by 0x406D82: main (btrfsck.c:3543)
==2673==  Address 0x5668aa8 is 0 bytes after a block of size 4,200 alloc'd
==2673==    at 0x4C28BED: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x418D88: alloc_extent_buffer (extent_io.c:568)
==2673==    by 0x40CACF: btrfs_find_create_tree_block (disk-io.c:123)
==2673==    by 0x40D9AB: read_tree_block (disk-io.c:199)
==2673==    by 0x408BAE: read_node_slot (ctree.c:789)
==2673==    by 0x40B738: btrfs_search_slot (ctree.c:1266)
==2673==    by 0x4157C1: btrfs_find_last_root (root-tree.c:40)
==2673==    by 0x40DBC5: find_and_setup_root (disk-io.c:439)
==2673==    by 0x40E401: __open_ctree_fd (disk-io.c:770)
==2673==    by 0x40E81C: open_ctree_fs_info (disk-io.c:864)
==2673==    by 0x406D82: main (btrfsck.c:3543)
==2673==
==2673== Invalid read of size 1
==2673==    at 0x4C2A760: memcpy (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x418FDB: read_extent_buffer (string3.h:52)
==2673==    by 0x415870: btrfs_find_last_root (root-tree.c:53)
==2673==    by 0x40DBC5: find_and_setup_root (disk-io.c:439)
==2673==    by 0x40E401: __open_ctree_fd (disk-io.c:770)
==2673==    by 0x40E81C: open_ctree_fs_info (disk-io.c:864)
==2673==    by 0x406D82: main (btrfsck.c:3543)
==2673==  Address 0x5668aaa is 2 bytes after a block of size 4,200 alloc'd
==2673==    at 0x4C28BED: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x418D88: alloc_extent_buffer (extent_io.c:568)
==2673==    by 0x40CACF: btrfs_find_create_tree_block (disk-io.c:123)
==2673==    by 0x40D9AB: read_tree_block (disk-io.c:199)
==2673==    by 0x408BAE: read_node_slot (ctree.c:789)
==2673==    by 0x40B738: btrfs_search_slot (ctree.c:1266)
==2673==    by 0x4157C1: btrfs_find_last_root (root-tree.c:40)
==2673==    by 0x40DBC5: find_and_setup_root (disk-io.c:439)
==2673==    by 0x40E401: __open_ctree_fd (disk-io.c:770)
==2673==    by 0x40E81C: open_ctree_fs_info (disk-io.c:864)
==2673==    by 0x406D82: main (btrfsck.c:3543)
==2673==
checking extents
==2673== Invalid read of size 1
==2673==    at 0x4C2A884: memcpy (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x418FDB: read_extent_buffer (string3.h:52)
==2673==    by 0x405727: check_extents (btrfsck.c:3440)
==2673==    by 0x406F4B: main (btrfsck.c:3571)
==2673==  Address 0x5668b6b is not stack'd, malloc'd or (recently) free'd
==2673==
checking fs roots
checking root refs
==2673== Invalid write of size 1
==2673==    at 0x4C2A88A: memcpy (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x418FF4: write_extent_buffer (string3.h:52)
==2673==    by 0x415991: btrfs_update_root (root-tree.c:82)
==2673==    by 0x40C743: commit_tree_roots (disk-io.c:333)
==2673==    by 0x40D435: btrfs_commit_transaction (disk-io.c:413)
==2673==    by 0x40729E: main (btrfsck.c:3585)
==2673==  Address 0x9a454bb is not stack'd, malloc'd or (recently) free'd
==2673==

valgrind: m_mallocfree.c:266 (mk_plain_bszB): Assertion 'bszB != 0' failed.
valgrind: This is probably caused by your program erroneously writing past the
end of a heap block and corrupting heap metadata.  If you fix any
invalid writes reported by Memcheck, this assertion failure will
probably go away.  Please try that before reporting this as a bug.

==2673==    at 0x3804C60F: ??? (in /usr/lib/valgrind/memcheck-amd64-linux)
==2673==    by 0x3804C752: ??? (in /usr/lib/valgrind/memcheck-amd64-linux)
==2673==    by 0x38000883: ??? (in /usr/lib/valgrind/memcheck-amd64-linux)
==2673==    by 0x38057EE1: ??? (in /usr/lib/valgrind/memcheck-amd64-linux)
==2673==    by 0x3802124C: ??? (in /usr/lib/valgrind/memcheck-amd64-linux)
==2673==    by 0x380213DA: ??? (in /usr/lib/valgrind/memcheck-amd64-linux)
==2673==    by 0x3808F3E6: ??? (in /usr/lib/valgrind/memcheck-amd64-linux)
==2673==    by 0x3809E449: ??? (in /usr/lib/valgrind/memcheck-amd64-linux)

sched status:
  running_tid=1

Thread 1: status = VgTs_Runnable
==2673==    at 0x4C28BED: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2673==    by 0x4182CD: alloc_extent_state (extent_io.c:46)
==2673==    by 0x41859B: clear_extent_bits (extent_io.c:211)
==2673==    by 0x412573: btrfs_write_dirty_block_groups (extent-tree.c:1701)
==2673==    by 0x40C76B: commit_tree_roots (disk-io.c:337)
==2673==    by 0x40D435: btrfs_commit_transaction (disk-io.c:413)
==2673==    by 0x40729E: main (btrfsck.c:3585)


After a few runs of this, the mount command would hang in an
uninterruptible state whenever I would try mounting it.  That symptom
has now gone away after running a couple more times, but the
filesystem is still unmountable unless I mount read-only.

So, where should I go from here?  Make btrfs-image files of the base
(or all) devs for this fs for someone to look at?  Try btrfsck
--init-csum-tree?  Forget about it and just start over, if these are
known issues?

-Justin
