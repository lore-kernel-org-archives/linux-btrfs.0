Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44503 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaIHOPC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 10:15:02 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 8 Sep 2014 19:44:59 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 4A3723940045
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Sep 2014 19:44:58 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s88EHJ7n3146012
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Sep 2014 19:47:19 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s88EEu9X021959
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Sep 2014 19:44:57 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V6 00/15] ] Btrfs: Subpagesize-blocksize: Get rid of whole page I/O.
Date: Mon,  8 Sep 2014 19:44:11 +0530
Message-Id: <1410185666-23308-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset continues with the work posted earlier at
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35926.html.

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

Xfstests' generic tests were run on an x86_64 machine with the patches
applied. The Btrfs kernel module was compiled without ACL and quotas support
and hence tests related to those were not run.

On multiple runs of the tests with 4k blocksize, 'umount' process would
sometimes get blocked indefinitely causing 'hung task detector' to print the
function call trace.

For 2k blocksize, the following xfstests' generic tests failed:
091, 125, 127, 224, 263, 274.

The following is a list of known TODO items which will be implemented in
future revisions of this patchset:
1. Get Xfstests' generic tests to successfully run on both 4k and 2k
   blocksizes.
2. Remove PAGE_CACHE_SIZE delalloc reservation in btrfs_writepage_fixup_worker().
3. Create separate slab caches for 'extent buffer head' and 'extent buffer'.
4. Add 'leak list' tracking for 'extent buffer' instances.
5. Rename EXTENT_BUFFER_TREE_REF and EXTENT_BUFFER_IN_TREE to
   EXTENT_BUFFER_HEAD_TREE_REF and EXTENT_BUFFER_HEAD_IN_TREE respectively.
  
Chandan Rajendra (13):
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
 fs/btrfs/extent_io.c         | 1100 ++++++++++++++++++++++++++++--------------
 fs/btrfs/extent_io.h         |   48 +-
 fs/btrfs/file-item.c         |   87 ++--
 fs/btrfs/file.c              |   77 +--
 fs/btrfs/inode.c             |  569 ++++++++++++++--------
 fs/btrfs/ordered-data.c      |   17 +
 fs/btrfs/ordered-data.h      |    4 +
 fs/btrfs/volumes.c           |    2 +-
 include/trace/events/btrfs.h |    2 +-
 16 files changed, 1334 insertions(+), 712 deletions(-)

-- 
1.8.3.1

