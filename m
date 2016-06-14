Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7300 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbcFNHLg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 03:11:36 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5E79Jij118983
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 03:11:35 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23gf59b82g-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 03:11:35 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 14 Jun 2016 01:11:33 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [PATCH V19 00/19] Allow I/O on blocks whose size is less than page size
Date: Tue, 14 Jun 2016 12:40:57 +0530
Message-Id: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs assumes block size to be the same as the machine's page
size. This would mean that a Btrfs instance created on a 4k page size
machine (e.g. x86) will not be mountable on machines with larger page
sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
incompatibility.

This patchset continues with the work posted previously at
http://thread.gmane.org/gmane.comp.file-systems.btrfs/55653.

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

The patchset is based off kdave/master branch. I had cherry picked the
following fixes to self-tests (from kdave/for-next branch) before
applying the subpage-blocksize patchset:

Btrfs: self-tests: Fix extent buffer bitmap test fail on BE system
Btrfs: self-tests: Fix test_bitmaps fail on 64k sectorsize
Btrfs: self-tests: Use macros instead of constants and add missing newline
Btrfs: self-tests: Support testing all possible sectorsizes and nodesizes
Btrfs: self-tests: Execute page straddling test only when nodesize < PAGE_SIZE
Btrfs: self-tests: Support non-4k page size
Btrfs: Fix integer overflow when calculating bytes_per_bitmap
Btrfs: test_check_exists: Fix infinite loop when searching for free space entries

Fstests run status:
1. x86_64
   - With 4k sectorsize, all the tests that succeed with the master
     branch at git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
     branch also do so with the patches applied.
   - With 2k sectorsize, generic/027 never seems to complete. In my
     case, the test did not complete even after 45 mins of run time.
2. ppc64
   - With 4k sectorsize, 16k nodesize and with "nospace_cache" mount
     option, except for scrub and compression tests, all the tests
     that succeed with the master branch at
     git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
     branch also do so with the patches applied.
   - With 64k sectorsize & nodesize, all the tests that succeed with
     the master branch at
     git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
     branch also do so with the patches applied.

TODO:
1. On ppc64, btrfsck segfaults when checking a filesystem instance
   having 2k sectorsize.
2. I am planning to fix scrub & compression via a separate patchset.

Changes from V18:
1. The per-page bitmap used to track the block status is now allocated
   from a slab cache.
2. The per-page bitmap is allocated and used only in cases where
   sectorsize < PAGE_SIZE.
3. The new patch "Btrfs: subpage-blocksize: Disable compression"
   disables compression in subpage-blocksize scenario.

Changes from V17:
1. Due to mistakes made during git rebase operations, fixes ended up
   in incorrect patches. This patchset gets the fixes in the right
   patches.

Changes from V16:
1. The V15 patchset consisted of patches obtained from an incorrect
   git branch. Apologies for the mistake. All the entries listed under
   "Changes from V15" hold good for V16.

Changes from V15:
1. The invocation of cleancache_get_page() in __do_readpage() assumed
   blocksize to be same as PAGE_SIZE. We now invoke cleancache_get_page()
   only if blocksize is same as PAGE_SIZE. Thanks to David Sterba for
   pointing this out.
2. In __extent_writepage_io() we used to accumulate all the contiguous
   dirty blocks within the page before submitting the file offset range
   for I/O. In some cases this caused the bio to span across more than
   a stripe. For example, With 4k block size, 64K stripe size
   and 64K page size, assume
   - All the blocks mapped by the page are contiguous on the logical
     address space.
   - The first block of the page is mapped to the second block of the
     stripe.
   In such a scenario, we would add all the blocks of the page to
   bio. This would mean that we would overflow the stripe by one 4K
   block. Hence this patchset removes the optimization and invokes
   submit_extent_page() for every dirty 4K block.
3. The following patches are newly added:
   - Btrfs: subpage-blocksize: __btrfs_lookup_bio_sums: Set offset
     when moving to a new bio_vec 
   - Btrfs: subpage-blocksize: Make file extent relocate code subpage
     blocksize aware 
   - Btrfs: btrfs_clone: Flush dirty blocks of a page that do not map
     the clone range

Changes from V14:
1. Fix usage of cleancache_get_page() in __do_readpage().
   In filesystems which support subpage-blocksize scenario, a page can
   map one or more blocks. Hence cleancache_get_page() should be
   invoked only when the page maps a non-hole extent and block size
   being used is equal to the page size. Thanks to David Sterba for
   pointing this out.
2. Replace page_read_complete() and page_write_complete() functions
   with page_io_complete().
3. Provide more documentation (as part of both commit message and code
   comments) about the usage of the per-page
   btrfs_page_private->io_lock.

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

Chandan Rajendra (19):
  Btrfs: subpage-blocksize: Fix whole page read.
  Btrfs: subpage-blocksize: Fix whole page write
  Btrfs: subpage-blocksize: Make sure delalloc range intersects with the
    locked page's range
  Btrfs: subpage-blocksize: Define extent_buffer_head
  Btrfs: subpage-blocksize: Read tree blocks whose size is < PAGE_SIZE
  Btrfs: subpage-blocksize: Write only dirty extent buffers belonging to
    a page
  Btrfs: subpage-blocksize: Allow mounting filesystems where sectorsize
    < PAGE_SIZE
  Btrfs: subpage-blocksize: Deal with partial ordered extent
    allocations.
  Btrfs: subpage-blocksize: Explicitly track I/O status of blocks of an
    ordered extent.
  Btrfs: subpage-blocksize: btrfs_punch_hole: Fix uptodate blocks check
  Btrfs: subpage-blocksize: Prevent writes to an extent buffer when
    PG_writeback flag is set
  Revert "btrfs: fix lockups from btrfs_clear_path_blocking"
  Btrfs: subpage-blocksize: Fix file defragmentation code
  Btrfs: subpage-blocksize: extent_clear_unlock_delalloc: Prevent page
    from being unlocked more than once
  Btrfs: subpage-blocksize: Enable dedupe ioctl
  Btrfs: subpage-blocksize: btrfs_clone: Flush dirty blocks of a page
    that do not map the clone range
  Btrfs: subpage-blocksize: Make file extent relocate code subpage
    blocksize aware
  Btrfs: subpage-blocksize: __btrfs_lookup_bio_sums: Set offset when
    moving to a new bio_vec
  Btrfs: subpage-blocksize: Disable compression

 fs/btrfs/ctree.c                       |   37 +-
 fs/btrfs/ctree.h                       |    6 +-
 fs/btrfs/disk-io.c                     |  167 ++--
 fs/btrfs/disk-io.h                     |    5 +-
 fs/btrfs/extent-tree.c                 |   21 +-
 fs/btrfs/extent_io.c                   | 1702 +++++++++++++++++++++++---------
 fs/btrfs/extent_io.h                   |  152 ++-
 fs/btrfs/file-item.c                   |    7 +-
 fs/btrfs/file.c                        |  106 +-
 fs/btrfs/inode.c                       |  503 +++++++---
 fs/btrfs/ioctl.c                       |  232 +++--
 fs/btrfs/locking.c                     |   24 +-
 fs/btrfs/locking.h                     |    2 -
 fs/btrfs/ordered-data.c                |   19 +
 fs/btrfs/ordered-data.h                |    4 +
 fs/btrfs/relocation.c                  |   53 +-
 fs/btrfs/root-tree.c                   |    2 +-
 fs/btrfs/super.c                       |   27 +-
 fs/btrfs/tests/btrfs-tests.c           |   12 +-
 fs/btrfs/tests/extent-io-tests.c       |    5 +-
 fs/btrfs/tests/free-space-tree-tests.c |   79 +-
 fs/btrfs/tree-log.c                    |    2 +-
 fs/btrfs/volumes.c                     |   11 +-
 include/trace/events/btrfs.h           |    2 +-
 24 files changed, 2263 insertions(+), 917 deletions(-)

-- 
2.1.0

