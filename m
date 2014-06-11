Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39433 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaFKLdV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 07:33:21 -0400
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 11 Jun 2014 17:03:19 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 0BA8D1258054
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 17:02:08 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5BBXc8749873112
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 17:03:39 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5BBWiYP014710
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 17:02:44 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [RFC PATCH V2 0/8] Btrfs: Subpagesize-blocksize: Get rid of whole page I/O
Date: Wed, 11 Jun 2014 17:02:13 +0530
Message-Id: <1402486341-592-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset continues with the work posted earlier at
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg34036.html.

Changes from V1:
1. Remove usage of bio_vec->bv_{len,offset} in end_bio_extent_readpage()
   and end_bio_extent_writepage().

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
1. Remove usage of bvec->{bv_offset, bv_len} from btrfs_csum_one_bio.
2. Get __extent_writepage() to write dirty blocks that don't start at
   page_offset(page). In such a scenario and with the current
   patchset, brfs_csum_one_bio() hits a BUG_ON() when searching for a
   non-existant ordered extent that would begin at file offset mapped by
   the first byte of the corresponding page.
3. Remove PAGE_CACHE_SIZE delalloc reservation in btrfs_writepage_fixup_worker().
4. Create separate slab caches for 'extent buffer head' and 'extent buffer'.
5. Add 'leak list' tracking for 'extent buffer' instances.
6. Rename EXTENT_BUFFER_TREE_REF and EXTENT_BUFFER_IN_TREE to
   EXTENT_BUFFER_HEAD_TREE_REF and EXTENT_BUFFER_HEAD_IN_TREE respectively.
7. Get Xfstests' generic tests to successfully run on both 4k and 2k
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

 fs/btrfs/backref.c           |    2 +-
 fs/btrfs/ctree.c             |    2 +-
 fs/btrfs/ctree.h             |    6 +-
 fs/btrfs/disk-io.c           |  117 +++--
 fs/btrfs/disk-io.h           |    3 +
 fs/btrfs/extent-tree.c       |    6 +-
 fs/btrfs/extent_io.c         | 1131 +++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.h         |   48 +-
 fs/btrfs/file-item.c         |   85 ++--
 fs/btrfs/file.c              |   32 +-
 fs/btrfs/inode.c             |   45 +-
 fs/btrfs/volumes.c           |    2 +-
 fs/btrfs/volumes.h           |    3 +
 include/trace/events/btrfs.h |    2 +-
 14 files changed, 1004 insertions(+), 480 deletions(-)

-- 
1.8.3.1

