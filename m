Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750833AbcJBNZU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNHUB125595
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:10 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25u06gcdb3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:10 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:10 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 00/19] Allow I/O on blocks whose size is less than page size
Date: Sun,  2 Oct 2016 18:54:09 +0530
Message-Id: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs assumes block size to be the same as the machine's page
size. This would mean that a Btrfs instance created on a 4k page size
machine (e.g. x86) will not be mountable on machines with larger page
sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
incompatibility.

This patchset continues with the work posted previously at
http://marc.info/?l=linux-btrfs&m=146760691422240&w=2

This patchset is based on top of Josef's
1. Metadata throttling in writeback patches
2. Kill the btree inode patches

The major change in this version is the usage of kmalloc()-ed memory for
holding metadata blocks whose size is less than the machine's page size. This
vastly reduces the complexity of extent buffer mangement (Thanks to Josef's
"Kill the btree inode patches").

When writing back dirty extent buffers, we currently track the corresponding
extent buffers using the pointer at page->private. With kmalloc-ed() memory
this isn't possible and hence we track the first extent buffer under writeback
using bio->bi_private. Also, For kmalloc-ed() extent buffers this patchset
currently limits the number of dirty extent buffers in a "write" bio to
1. This limit will be removed in a future patchset.

The commits for the Btrfs kernel module can be found at
https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.

To create a filesystem with block size < page size, a patched version
of the Btrfs-progs package is required. The corresponding fixes for
Btrfs-progs can be found at
https://github.com/chandanr/btrfs-progs/tree/btrfs/subpagesize-blocksize.

Fstests run status:
1. x86_64
   - With 4k sectorsize, all the tests that succeed with the for-linus-4.8
     branch at
     git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git 
     branch also do so with the patches applied.
2. ppc64
   - With 4k sectorsize, 16k nodesize and with "nospace_cache" mount
     option, except for scrub and compression tests, all the tests
     that succeed with the for-next branch at
     git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
     branch also do so with the patches applied.
   - With 64k sectorsize & nodesize, all the tests that succeed with
     the for-linus-4.8 branch at
     git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
     branch also do so with the patches applied.

TODO:
1. On ppc64, btrfsck segfaults when checking a filesystem instance
   having 2k sectorsize.
2. I am planning to fix scrub & compression via a separate patchset.

Changes from V20:
1. Applied all the review comments suggested by Josef for version V20.
   However, There are still some instances of
   	    if (compare_sectorsize_with_page_size)
	       /* do something */
   One such instance is in check_page_uptodate() where we would need to check
   for BLK_STATE_UPTODATE only if page_size < sectorsize. For page_size ==
   sectorsize case, we unconditionally set PG_uptodate flag.

Changes from V19:
1. The patchset has been rebased on top of kdave/for-next branch.
2. The patch "Btrfs: subpage-blocksize: extent_clear_unlock_delalloc:
   Prevent page from being unlocked more than once" changes the
   signatures of the functions "cow_file_range" &
   "extent_clear_unlock_delalloc". This patch has now been moved to be
   the first patch in the patchset.
3. A new patch "Btrfs: subpage-blocksize: Rate limit scrub error
   message" has been added. btrfs/073 invokes the scrub ioctl in a
   tight loop. In subpage-blocksize scenario this results in a lot of
   "scrub: size assumption sectorsize != PAGE_SIZE" messages being
   printed on the console. Hence this patch rate limits such error
   messages.

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
  Btrfs: subpage-blocksize: extent_clear_unlock_delalloc: Prevent page
    from being unlocked more than once
  Btrfs: subpage-blocksize: Make sure delalloc range intersects with the
    locked page's range
  Btrfs: subpage-blocksize: Use PG_Uptodate flag to track block uptodate
    status
  Btrfs: Remove extent_io_tree's track_uptodate member
  Btrfs: subpage-blocksize: Fix whole page read.
  Btrfs: subpage-blocksize: Fix whole page write
  Btrfs: subpage-blocksize: Use kmalloc()-ed memory to hold metadata
    blocks
  Btrfs: subpage-blocksize: Execute sanity tests on all possible block
    sizes
  Btrfs: subpage-blocksize: Compute free space tree BITMAP_RANGE based
    on sectorsize
  Btrfs: subpage-blocksize: Allow mounting filesystems where sectorsize
    < PAGE_SIZE
  Btrfs: subpage-blocksize: Deal with partial ordered extent
    allocations.
  Btrfs: subpage-blocksize: Explicitly track I/O status of blocks of an
    ordered extent.
  Btrfs: subpage-blocksize: btrfs_punch_hole: Fix uptodate blocks check
  Btrfs: subpage-blocksize: Fix file defragmentation code
  Btrfs: subpage-blocksize: Enable dedupe ioctl
  Btrfs: subpage-blocksize: btrfs_clone: Flush dirty blocks of a page
    that do not map the clone range
  Btrfs: subpage-blocksize: Make file extent relocate code subpage
    blocksize aware
  Btrfs: subpage-blocksize: __btrfs_lookup_bio_sums: Set offset when
    moving to a new bio_vec
  Btrfs: subpage-blocksize: Disable compression

 fs/btrfs/ctree.h                       |   6 +-
 fs/btrfs/disk-io.c                     |  49 +--
 fs/btrfs/disk-io.h                     |   2 +-
 fs/btrfs/extent-tree.c                 |   4 +-
 fs/btrfs/extent_io.c                   | 739 +++++++++++++++++++++------------
 fs/btrfs/extent_io.h                   |  99 ++++-
 fs/btrfs/file-item.c                   |   7 +-
 fs/btrfs/file.c                        | 105 ++++-
 fs/btrfs/inode.c                       | 472 +++++++++++++++------
 fs/btrfs/ioctl.c                       | 232 +++++++----
 fs/btrfs/ordered-data.c                |  19 +
 fs/btrfs/ordered-data.h                |   4 +
 fs/btrfs/relocation.c                  |  87 +++-
 fs/btrfs/super.c                       |  19 +
 fs/btrfs/tests/btrfs-tests.c           |   8 +-
 fs/btrfs/tests/extent-io-tests.c       |   4 +-
 fs/btrfs/tests/free-space-tree-tests.c |  79 ++--
 fs/btrfs/tree-log.c                    |   2 +-
 fs/btrfs/volumes.c                     |  10 +-
 19 files changed, 1373 insertions(+), 574 deletions(-)

-- 
2.5.5

