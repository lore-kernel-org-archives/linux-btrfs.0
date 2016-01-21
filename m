Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:39466 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934438AbcAUK2E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 05:28:04 -0500
Received: from localhost
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 21 Jan 2016 20:28:00 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 878E02CE8054
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:27:58 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0LARevV39256304
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:27:48 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0LARPlV025477
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 21:27:26 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [PATCH V13 00/14] Btrfs: Subpagesize-blocksize: Allow I/O on blocks whose size is less than page size.
Date: Thu, 21 Jan 2016 15:56:47 +0530
Message-Id: <1453372021-5089-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs assumes block size to be the same as the machine's page
size. This would mean that a Btrfs instance created on a 4k page size
machine (e.g. x86) will not be mountable on machines with larger page
sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
incompatibility.

This patchset continues with the work posted previously at
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg48478.html.

I have reverted the upstream commit "btrfs: fix lockups from
btrfs_clear_path_blocking" (f82c458a2c3ffb94b431fc6ad791a79df1b3713e)
since this led to soft-lockups when the patch "Btrfs:
subpagesize-blocksize: Prevent writes to an extent buffer when
PG_writeback flag is set" is applied.

The commits for the Btrfs kernel module can be found at
https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.

The commits for Btrfs-progs can be found at
https://github.com/chandanr/btrfs-progs/tree/btrfs/subpagesize-blocksize.

Fstests run status:
1. x86_64
   - With 4k sectorsize, all the tests that succeed with
     linux-btrfs/integration-4.5 branch also do so with the patches
     applied.
   - With 2k sectorsize, all the *generic* tests that succeed with
     linux-btrfs/integration-4.5 branch also do so with the patches
     applied.
2. ppc64
   - With 4k sectorsize, 16k nodesize and with "nospace_cache" mount
     option, the newly introduced dedup tests fail. Also, some of the
     newly introduced reflink tests fail as well. I am planning to
     fix them up in a seperate patchset.
   - With 64k sectorsize & nodesize, all the tests that succeed with
     linux-btrfs/integration-4.5 branch also do so with the patches
     applied.

Changes from V12:
1. The logic in the function btrfs_punch_hole() has been fixed to
   check for the presence of BLK_STATE_UPTODATE flags for blocks in
   pages which partially map the file range being punched.
   
Changes from V11:
1. Addressed the review comments provided by Liu Bo for version V11.
2. Fixed file defragmentation code to work in subpagesize-blocksize
   scenario.
3. Many "hard to reproduce" bugs were fixed.


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
  Btrfs: subpagesize-blocksize: btrfs_punch_hole: Fix uptodate blocks
    check
  Btrfs: subpagesize-blocksize: Prevent writes to an extent buffer when
    PG_writeback flag is set.
  Revert "btrfs: fix lockups from btrfs_clear_path_blocking"
  Btrfs: subpagesize-blocksize: Fix file defragmentation code
  Btrfs: subpagesize-blocksize: extent_clear_unlock_delalloc: Prevent
    page from being unlocked more than once

 fs/btrfs/backref.c           |    2 +-
 fs/btrfs/ctree.c             |   37 +-
 fs/btrfs/ctree.h             |    6 +-
 fs/btrfs/disk-io.c           |  161 +++--
 fs/btrfs/disk-io.h           |    3 +
 fs/btrfs/extent-tree.c       |   17 +-
 fs/btrfs/extent_io.c         | 1606 ++++++++++++++++++++++++++++++------------
 fs/btrfs/extent_io.h         |  102 ++-
 fs/btrfs/file.c              |   82 ++-
 fs/btrfs/inode.c             |  491 +++++++++----
 fs/btrfs/ioctl.c             |  194 +++--
 fs/btrfs/locking.c           |   24 +-
 fs/btrfs/locking.h           |    2 -
 fs/btrfs/ordered-data.c      |   19 +
 fs/btrfs/ordered-data.h      |    4 +
 fs/btrfs/relocation.c        |    3 +
 fs/btrfs/root-tree.c         |    2 +-
 fs/btrfs/volumes.c           |    2 +-
 include/trace/events/btrfs.h |    2 +-
 19 files changed, 1965 insertions(+), 794 deletions(-)

-- 
2.1.0

