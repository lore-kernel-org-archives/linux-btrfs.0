Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34517 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbKPHKF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:10:05 -0500
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 12:40:03 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 1BA261258088
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:40:08 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG79wwa27066606
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:39:58 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG78upe027213
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:57 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [RFC PATCH V12 00/14] Btrfs: Subpagesize-blocksize: Allow I/O on blocks whose size is less than page size.
Date: Mon, 16 Nov 2015 12:38:27 +0530
Message-Id: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs assumes block size to be the same as the machine's page
size. This would mean that a Btrfs instance created on a 4k page size
machine (e.g. x86) will not be mountable on machines with larger page
sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
incompatibility.

This patchset continues with the work posted previously at
https://lwn.net/Articles/646937/.

I have reverted the upstream commit "btrfs: fix lockups from
btrfs_clear_path_blocking" (f82c458a2c3ffb94b431fc6ad791a79df1b3713e)
since this led to soft-lockups when the patch "Btrfs:
subpagesize-blocksize: Prevent writes to an extent buffer when
PG_writeback flag is set" is applied.

The commits for the Btrfs kernel module can be found at
https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.

The commits for Btrfs-progs can be found at
https://github.com/chandanr/btrfs-progs/tree/btrfs/subpagesize-blocksize.

Changes from V11:
1. Addressed the review comments provided by Liu Bo for version V11.
2. Fixed file defragmentation code to work in subpagesize-blocksize
   scenario.
3. Many "hard to reproduce" bugs were fixed.

fstests run status:
1. On x86_64, all the tests (i.e. both generic and btrfs specific
   tests) pass
   - With 2k and 4k data blocksize combinations.
   - With and without nodatacow option.
2. On ppc64, generic tests were run with 4k data block size and 16k
   metadata block size. generic/300 fails because of an issue with the
   fio tool. The failure is seen even when running the test for other
   filesystems (i.e. ext4 and xfs).

The following is a list of known TODO items which will be implemented in
future revisions of this patchset:
1. Currently, We read one metadata block at a time. Pages mapping
   multiple extent buffers are currently marked with PG_Uptodate flag
   only when all the extent buffers of the page have EXTENT_UPTODATE
   flag set. Some of the blocks mapped by the page may not even
   contain a valid metadata block. Hence such pages can never have
   PG_Uptodate flag set.
2. Fix btrfs_assert_tree_locked() invocation (inside "#if DEBUG") in
   btree_set_page_dirty().

Chandan Rajendra (14):
  Btrfs: subpagesize-blocksize: Fix whole page read.
  Btrfs: subpagesize-blocksize: Fix whole page write
  Btrfs: subpagesize-blocksize: Make sure delalloc range intersects with
    the locked page's range
  Btrfs: subpagesize-blocksize: Define extent_buffer_head.
  Btrfs: subpagesize-blocksize: Read tree blocks whose size is <
    PAGE_SIZE.
  Btrfs: subpagesize-blocksize: Write only dirty extent buffers
    belonging to a page
  Btrfs: subpagesize-blocksize: Allow mounting filesystems where
    sectorsize != PAGE_SIZE
  Btrfs: subpagesize-blocksize: Deal with partial ordered extent
    allocations.
  Btrfs: subpagesize-blocksize: Explicitly track I/O status of blocks of
    an ordered extent.
  Btrfs: subpagesize-blocksize: btrfs_punch_hole: Use EXTENT_UPTODATE
    bit to check for the presence of block in page cache
  Btrfs: subpagesize-blocksize: Prevent writes to an extent buffer when
    PG_writeback flag is set.
  Revert "btrfs: fix lockups from btrfs_clear_path_blocking"
  Btrfs: subpagesize-blocksize: Fix file defragmentation code
  Btrfs: subpagesize-blocksize: extent_clear_unlock_delalloc: Prevent
    page from being unlocked more than once

 fs/btrfs/backref.c           |    2 +-
 fs/btrfs/btrfs_inode.h       |    2 -
 fs/btrfs/ctree.c             |   37 +-
 fs/btrfs/ctree.h             |    6 +-
 fs/btrfs/disk-io.c           |  161 +++--
 fs/btrfs/disk-io.h           |    3 +
 fs/btrfs/extent-tree.c       |   17 +-
 fs/btrfs/extent_io.c         | 1608 ++++++++++++++++++++++++++++++------------
 fs/btrfs/extent_io.h         |  102 ++-
 fs/btrfs/file.c              |   20 +-
 fs/btrfs/inode.c             |  494 +++++++++----
 fs/btrfs/ioctl.c             |  194 +++--
 fs/btrfs/locking.c           |   24 +-
 fs/btrfs/locking.h           |    2 -
 fs/btrfs/ordered-data.c      |   19 +
 fs/btrfs/ordered-data.h      |    4 +
 fs/btrfs/relocation.c        |    3 +
 fs/btrfs/root-tree.c         |    2 +-
 fs/btrfs/volumes.c           |    2 +-
 include/trace/events/btrfs.h |    2 +-
 20 files changed, 1907 insertions(+), 797 deletions(-)

-- 
2.1.0

