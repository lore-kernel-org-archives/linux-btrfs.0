Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33851 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaKLISU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 03:18:20 -0500
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 12 Nov 2014 18:18:17 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 4BA082CE8066
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:12 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAC8K6sK41550030
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:20:06 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAC8IAQi008376
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:11 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com, steve.capper@linaro.org
Subject: [RFC PATCH V8 00/16] Btrfs: Subpagesize-blocksize: Get rid of whole page I/O.
Date: Wed, 12 Nov 2014 13:47:32 +0530
Message-Id: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset continues with the work posted earlier at
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg37484.html.

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

Changes from V7:
1. Fix a softlockup issue that occured because the page corresponding
   to the delalloc region did not exist. This bug was introduced by
   the code added in btrfs_invalidatepage and related functions in V7
   version.

Unfortunately until now, I have been running xfstests on a guest with
just one virtual cpu. Hence some synchronization issues had been
masked away. So the below results are applicable only for the 1 vcpu
scenario (although the synchronization issues will be fixed in future
revisions of the patchset).

Xfstests' generic tests were run on an x86_64 machine with the patches
applied. The Btrfs kernel module was compiled without ACL support and
hence tests related to that were not run.

For 2k blocksize, the following xfstests' generic tests failed:
1. generic/091
2. generic/125
3. generic/251

The following xfstests' generic tests failed for both 2k and 4k blocksize:
1. generic/224 (OOM)
   This looks mostly an issue caused by non-btrfs code as the test failed
   for the exact same reason when run on an ext4 filesystem instance.
2. generic/263
   FALLOC_FL_ZERO_RANGE isn't supported by Btrfs. Hence the test fails.

The following is a list of known TODO items which will be implemented in
future revisions of this patchset:
1. Fix synchronization issues that occur in multiprocessor scenario.
2. Get Xfstests' generic tests to successfully run on both 4k and 2k
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
 fs/btrfs/disk-io.c           |  117 +++--
 fs/btrfs/disk-io.h           |    3 +
 fs/btrfs/extent-tree.c       |    6 +-
 fs/btrfs/extent_io.c         | 1142 ++++++++++++++++++++++++++++--------------
 fs/btrfs/extent_io.h         |   53 +-
 fs/btrfs/file-item.c         |   87 ++--
 fs/btrfs/file.c              |   77 +--
 fs/btrfs/inode.c             |  580 +++++++++++++--------
 fs/btrfs/ordered-data.c      |   19 +
 fs/btrfs/ordered-data.h      |    8 +
 fs/btrfs/volumes.c           |    2 +-
 include/trace/events/btrfs.h |    2 +-
 16 files changed, 1381 insertions(+), 729 deletions(-)

-- 
2.1.0

