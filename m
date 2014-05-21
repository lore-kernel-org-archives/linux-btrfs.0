Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35718 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaEUJl3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 05:41:29 -0400
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 21 May 2014 15:11:27 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 474A31258054
	for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 15:10:31 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s4L9fmoh52035646
	for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 15:11:48 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s4L9fLYe018026
	for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 15:11:22 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [RFC PATCH 0/8] Btrfs: Subpagesize-blocksize: Get rid of whole page I/O
Date: Wed, 21 May 2014 15:11:10 +0530
Message-Id: <1400665278-4091-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset continues with the work posted earlier at
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg32143.html. The
following are the high level changes brought in by this patchset:
1. Rewrite 'extent buffer' handling code to incorporate comments posted to
   Chandra Seetharaman's patchset
   <http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg29534.html>.
2. Compute and look up checksums for data extents in sectorsize units.

Xfstests' generic tests were run on an x86_64 machine with the patches
applied.

On multiple runs of the tests with 4k blocksize, 'umount' process would
sometimes get blocked indefinitely causing 'hung task detector' to print the
function call trace. Also, there are occasional instances where warning
messages from btree_invalidatepage() is being printed to indicate that
PG_private flag of a page is still set.

For 2k blocksize only a few Xfstests' generic tests pass.

The following is a list of known TODO items which will be implemented in
future revisions of this patchset:
1. Create separate slab caches for 'extent buffer head' and 'extent buffer'.
2. Add 'leak list' tracking for 'extent buffer' instances.
3. Rename EXTENT_BUFFER_TREE_REF and EXTENT_BUFFER_IN_TREE to
   EXTENT_BUFFER_HEAD_TREE_REF and EXTENT_BUFFER_HEAD_IN_TREE respectively.
4. Remove usage of bvec->{bv_offset, bv_len} from end_bio_extent_readpage()
   end_bio_extent_writepage() and btrfs_csum_one_bio.
5. Get Xfstests' generic tests to successfully run on both 4k and 2k
   blocksizes.

Chandan Rajendra (6):
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

Chandra Seetharaman (2):
  Btrfs: subpagesize-blocksize: Define extent_buffer_head.
  Btrfs: subpagesize-blocksize: Allow mounting filesystems where
    sectorsize != PAGE_SIZE

 fs/btrfs/backref.c           |   2 +-
 fs/btrfs/ctree.c             |   2 +-
 fs/btrfs/ctree.h             |   6 +-
 fs/btrfs/disk-io.c           | 117 +++---
 fs/btrfs/disk-io.h           |   3 +
 fs/btrfs/extent-tree.c       |   6 +-
 fs/btrfs/extent_io.c         | 980 +++++++++++++++++++++++++++++++++----------
 fs/btrfs/extent_io.h         |  46 +-
 fs/btrfs/file-item.c         |  85 ++--
 fs/btrfs/file.c              |  32 +-
 fs/btrfs/inode.c             |  24 +-
 fs/btrfs/volumes.c           |   2 +-
 fs/btrfs/volumes.h           |   3 +
 include/trace/events/btrfs.h |   2 +-
 14 files changed, 947 insertions(+), 363 deletions(-)

-- 
1.8.3.1

