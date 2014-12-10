Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:45374 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaLJNOm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 08:14:42 -0500
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 10 Dec 2014 18:44:38 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 6EB7E1258054
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:45:00 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sBADFCSx53084362
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:45:13 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sBADEYIU031720
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:44:35 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V10 00/19] Btrfs: Subpagesize-blocksize: Get rid of whole page I/O.
Date: Wed, 10 Dec 2014 18:44:02 +0530
Message-Id: <1418217261-17273-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset continues with the work posted earlier at
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg38862.html.

Changes from V9:
1. Earlier, In read_extent_buffer_pages(), we used to check for extent buffer
   pages' PG_uptodate flag immediately after the page was unlocked by the
   endio function. However, the PG_uptodate flag is set on the pages only
   after the read operation on all pages complete successfully and the
   verification of the extent buffer's contents is done. Fix this by checking
   only for EXTENT_BUFFER_UPTODATE flag in read_extent_buffer_pages().
2. Add the new EXTENT_READ_IO extent state bit to reliably unlock pages in
   readpage's end bio function.
3. Use (eb->start, seq) as search key for tree modification log.
4. btrfs_submit_direct_hook: Prevent zero length bios from being submitted
   when map_length < bio vector length.
5. Enabled POSIX ACL support.   

Changes from V8:
1. In subpagesize-blocksize scenario, prevent writes to an extent
   buffer when the corresponding page's PG_writeback flag is set. This
   race condition was triggered when running xfstests' generic/083
   test. With the new patch applied, I have run the complete xfstests
   suite as well as run generic/083 multiple times on both 4k and 2k
   block size setups. There were 2 non-related test failures that
   occured rarely, but they were reproducible even when the patch was
   not applied.

Changes from V7:
1. Fix a softlockup issue that occured because the page corresponding
   to the delalloc region did not exist. This bug was introduced by
   the code added in btrfs_invalidatepage and related functions in V7
   version.

Changes from V6:
1. Fix softlockup issue that occured during unmounting a 4k blocksized
   filesystem instance.
2. Track blocks of an ordered extent submitted for write I/O to avoid
   I/O resubmission in certain scenarios.

Changes from V5:
1. Rebased patchset on top of current btrfs-next tree (i.e. commit
   8d875f95da43c6a8f18f77869f2ef26e9594fecc). This involved using
   "immutable biovecs".
2. Deal with partially allocated ordered extents across a page.
3. Explicitly track I/O status of blocks of an ordered extent.

Changes from V4:
1. V2's "Btrfs: subpagesize-blocksize: Get rid of whole page reads"
   patch was incorrectly replaced with an older version when working
   on V3 patches. Fix this.
2. Fix btrfs_endio_direct_read() to compute checksums for all possible
   blocks in a page.

Changes from V3:
1. Get "Hole punching" and "Extent preallocation" to work correctly in
   subpagesize-blocksize scenario.
2. Get btrfs_page_mkwrite() to reserve space in sectorsized units.

Changes from V2:
1. Get __extent_writepage() to write only the dirty blocks of a page.
2. Fix "page private not zero on page" warning message which is printed
   when running xfstests.

Changes from V1:
1. Remove usage of bio_vec->bv_{len,offset} in end_bio_extent_readpage()
   and end_bio_extent_writepage().

Xfstests' generic tests were run on an x86_64 machine with the patches
applied for blocksizes 2k and 4k.

For 2k blocksize, the following xfstests' generic tests failed:
1. generic/068

The following xfstests' generic tests failed for both 2k and 4k blocksize:
1. generic/008 - FALLOC_FL_ZERO_RANGE is not supported by Btrfs.
2. generic/091 - FALLOC_FL_ZERO_RANGE is not supported by Btrfs.
3. generic/224
   This looks mostly an issue caused by non-btrfs code as the test failed
   for the exact same reason when run on an ext4 filesystem instance.
4. generic/263 - FALLOC_FL_ZERO_RANGE is not supported by Btrfs.
5. generic/274
   This test very rarely results in a hung task.

The following is a list of known TODO items which will be implemented in
future revisions of this patchset:
1. The xfstests suite was based off the corresponding git tree as available on
   March 2014. Pull the latest from the xfstests git tree and execute the
   tests.
2. Rebase the patches on top of the current linux-btrfs/next branch.
3. Get Xfstests' generic tests to successfully run on both 4k and 2k
   blocksizes.
4. Remove PAGE_CACHE_SIZE delalloc reservation in btrfs_writepage_fixup_worker().
5. Create separate slab caches for 'extent buffer head' and 'extent buffer'.
6. Add 'leak list' tracking for 'extent buffer' instances.
7. Rename EXTENT_BUFFER_TREE_REF and EXTENT_BUFFER_IN_TREE to
   EXTENT_BUFFER_HEAD_TREE_REF and EXTENT_BUFFER_HEAD_IN_TREE respectively.
   
Chandan Rajendra (17):
  Btrfs: subpagesize-blocksize: Get rid of whole page reads.
  Btrfs: subpagesize-blocksize: Get rid of whole page writes.
  Btrfs: subpagesize-blocksize: __btrfs_buffered_write: Reserve/release
    extents aligned to block size.
  Btrfs: subpagesize-blocksize: Read tree blocks whose size is
    <PAGE_CACHE_SIZE.
  Btrfs: subpagesize-blocksize: Write only dirty extent buffers
    belonging to a page
  Btrfs: subpagesize-blocksize: Compute and look up csums based on
    sectorsized blocks.
  Btrfs: subpagesize-blocksize: __extent_writepage: Write only dirty
    blocks of a page.
  Btrfs: subpagesize-blocksize: fallocate: Work with sectorsized units.
  Btrfs: subpagesize-blocksize: btrfs_page_mkwrite: Reserve space in
    sectorsized units.
  Btrfs: subpagesize-blocksize: Search for all ordered extents that
    could span across a page.
  Btrfs: subpagesize-blocksize: Deal with partial ordered extent
    allocations.
  Btrfs: subpagesize-blocksize: Explicitly Track I/O status of blocks of
    an ordered extent.
  Btrfs: subpagesize-blocksize: Revert commit
    fc4adbff823f76577ece26dcb88bf6f8392dbd43.
  Btrfs: subpagesize-blocksize: Track blocks of ordered extent submitted
    for write I/O.
  Btrfs: subpagesize-blocksize: Prevent writes to an extent buffer when
    PG_writeback flag is set.
  Btrfs: subpagesize-blocksize: Use (eb->start, seq) as search key for
    tree modification log.
  Btrfs: subpagesize-blocksize: btrfs_submit_direct_hook: Handle
    map_length < bio vector length

Chandra Seetharaman (2):
  Btrfs: subpagesize-blocksize: Define extent_buffer_head.
  Btrfs: subpagesize-blocksize: Allow mounting filesystems where
    sectorsize != PAGE_SIZE

 fs/btrfs/backref.c           |    2 +-
 fs/btrfs/btrfs_inode.h       |    2 -
 fs/btrfs/ctree.c             |   56 +-
 fs/btrfs/ctree.h             |    8 +-
 fs/btrfs/disk-io.c           |  117 ++--
 fs/btrfs/disk-io.h           |    3 +
 fs/btrfs/extent-tree.c       |   18 +-
 fs/btrfs/extent_io.c         | 1274 +++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.h         |   60 +-
 fs/btrfs/file-item.c         |   87 +--
 fs/btrfs/file.c              |   77 +--
 fs/btrfs/inode.c             |  603 ++++++++++++--------
 fs/btrfs/ordered-data.c      |   19 +
 fs/btrfs/ordered-data.h      |    8 +
 fs/btrfs/volumes.c           |    2 +-
 include/trace/events/btrfs.h |    2 +-
 16 files changed, 1573 insertions(+), 765 deletions(-)

-- 
2.1.0

