Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:46764 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbcBDGre (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 01:47:34 -0500
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 4 Feb 2016 16:47:32 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 610DD2BB004D
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Feb 2016 17:47:28 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u146ku3H45482130
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Feb 2016 17:47:04 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u146ktZ6014320
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Feb 2016 17:46:56 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [PATCH V14 00/15] Btrfs: Subpagesize-blocksize: Allow I/O on blocks whose size is less than page size.
Date: Thu,  4 Feb 2016 12:16:07 +0530
Message-Id: <1454568382-2020-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs assumes block size to be the same as the machine's page
size. This would mean that a Btrfs instance created on a 4k page size
machine (e.g. x86) will not be mountable on machines with larger page
sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
incompatibility.

This patchset continues with the work posted previously at
http://article.gmane.org/gmane.comp.file-systems.btrfs/52408.

I have reverted the upstream commit "btrfs: fix lockups from
btrfs_clear_path_blocking" (f82c458a2c3ffb94b431fc6ad791a79df1b3713e)
since this led to soft-lockups when the patch "Btrfs:
subpagesize-blocksize: Prevent writes to an extent buffer when
PG_writeback flag is set" is applied. During 2015's Vault Conference
Btrfs meetup, Chris Mason had suggested that he will write up a
suitable locking function to be used when writing dirty pages that map
metadata blocks. Until we have a suitable locking function available,
this patchset temporarily disables the commit
f82c458a2c3ffb94b431fc6ad791a79df1b3713e.

The commits for the Btrfs kernel module can be found at
https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.

To create a filesystem with block size < page size, a patched version
of the Btrfs-progs package is required. The corresponding fixes for
Btrfs-progs can be found at
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
     option, all the *generic* tests that succeed with
     linux-btrfs/integration-4.5 branch also do so with the patches
     applied.
   - With 64k sectorsize & nodesize, all the tests that succeed with
     linux-btrfs/integration-4.5 branch also do so with the patches
     applied.

Changes from V13:
1. Enable dedup ioctl to work in subpagesize-blocksize scenario.

Changes from V12:
1. The logic in the function btrfs_punch_hole() has been fixed to
   check for the presence of BLK_STATE_UPTODATE flags for blocks in
   pages which partially map the file range being punched.
   
Changes from V11:
1. Addressed the review comments provided by Liu Bo for version V11.
2. Fixed file defragmentation code to work in subpagesize-blocksize
   scenario.
3. Many "hard to reproduce" bugs were fixed.

Chandan Rajendra (15):
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
  Btrfs: subpagesize-blocksize: Enable dedup ioctl

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
 fs/btrfs/ioctl.c             |  205 ++++--
 fs/btrfs/locking.c           |   24 +-
 fs/btrfs/locking.h           |    2 -
 fs/btrfs/ordered-data.c      |   19 +
 fs/btrfs/ordered-data.h      |    4 +
 fs/btrfs/relocation.c        |    3 +
 fs/btrfs/root-tree.c         |    2 +-
 fs/btrfs/volumes.c           |    2 +-
 include/trace/events/btrfs.h |    2 +-
 19 files changed, 1966 insertions(+), 804 deletions(-)

-- 
2.1.0

