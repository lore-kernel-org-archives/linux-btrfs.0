Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:40695 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaIUSzn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 14:55:43 -0400
Received: from /spool/local
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 22 Sep 2014 04:55:41 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 975113578047
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:55:39 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s8LIVYpI55246922
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:31:34 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s8LItcgh017537
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:55:39 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V7 00/16] Btrfs: Subpagesize-blocksize: Get rid of whole page I/O.
Date: Mon, 22 Sep 2014 00:25:14 +0530
Message-Id: <1411325730-21817-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset continues with the work posted earlier at
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg37041.html.

Changes from V1:
1. Remove usage of bio_vec->bv_{len,offset} in end_bio_extent_readpage()
   and end_bio_extent_writepage().

Changes from V2:
1. Get __extent_writepage() to write only the dirty blocks of a page.
2. Fix "page private not zero on page" warning message which is printed
   when running xfstests.

Changes from V3:
1. Get "Hole punching" and "Extent preallocation" to work correctly in
   subpagesize-blocksize scenario.
2. Get btrfs_page_mkwrite() to reserve space in sectorsized units.

Changes from V4:
1. V2's "Btrfs: subpagesize-blocksize: Get rid of whole page reads"
   patch was incorrectly replaced with an older version when working
   on V3 patches. Fix this.
2. Fix btrfs_endio_direct_read() to compute checksums for all possible
   blocks in a page.

Changes from V5:
1. Rebased patchset on top of current btrfs-next tree (i.e. commit
   8d875f95da43c6a8f18f77869f2ef26e9594fecc). This involved using
   "immutable biovecs".
2. Deal with partially allocated ordered extents across a page.
3. Explicitly track I/O status of blocks of an ordered extent.

Changes from V6:
1. Fix softlockup issue that occured during unmounting a 4k blocksized
   filesystem instance.
2. Track blocks of an ordered extent submitted for write I/O to avoid
   I/O resubmission in certain scenarios.

Xfstests' generic tests were run on an x86_64 machine with the patches
applied. The Btrfs kernel module was compiled without ACL and quotas support
and hence tests related to those were not run.

For 2k blocksize, the following xfstests' generic tests failed:
1. generic/091
2. generic/125
3. generic/127 (softlockup)
4. generic/251 (ENOSPC),

The following xfstests' generic tests failed for both 2k and 4k blocksize:
1. generic/224 (OOM)
   This looks mostly an issue caused by non-btrfs code as the test failed
   for the exact same reason when run on an ext4 filesystem instance.
2. generic/263
   FALLOC_FL_ZERO_RANGE isn't supported by Btrfs. Hence the test fails.

The following is a list of known TODO items which will be implemented in
future revisions of this patchset:
1. Get Xfstests' generic tests to successfully run on both 4k and 2k
   blocksizes.
2. Remove PAGE_CACHE_SIZE delalloc reservation in btrfs_writepage_fixup_worker().
3. Create separate slab caches for 'extent buffer head' and 'extent buffer'.
4. Add 'leak list' tracking for 'extent buffer' instances.
5. Rename EXTENT_BUFFER_TREE_REF and EXTENT_BUFFER_IN_TREE to
   EXTENT_BUFFER_HEAD_TREE_REF and EXTENT_BUFFER_HEAD_IN_TREE respectively.
   
Chandan Rajendra (14):
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

Chandra Seetharaman (2):
  Btrfs: subpagesize-blocksize: Define extent_buffer_head.
  Btrfs: subpagesize-blocksize: Allow mounting filesystems where
    sectorsize != PAGE_SIZE

 fs/btrfs/backref.c           |    2 +-
 fs/btrfs/btrfs_inode.h       |    2 -
 fs/btrfs/ctree.c             |    2 +-
 fs/btrfs/ctree.h             |    8 +-
 fs/btrfs/disk-io.c           |  117 ++---
 fs/btrfs/disk-io.h           |    3 +
 fs/btrfs/extent-tree.c       |    6 +-
 fs/btrfs/extent_io.c         | 1123 ++++++++++++++++++++++++++++--------------
 fs/btrfs/extent_io.h         |   48 +-
 fs/btrfs/file-item.c         |   87 ++--
 fs/btrfs/file.c              |   77 +--
 fs/btrfs/inode.c             |  569 +++++++++++++--------
 fs/btrfs/ordered-data.c      |   19 +
 fs/btrfs/ordered-data.h      |    8 +
 fs/btrfs/volumes.c           |    2 +-
 include/trace/events/btrfs.h |    2 +-
 16 files changed, 1363 insertions(+), 712 deletions(-)

-- 
2.1.0

