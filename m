Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56523 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbbKPHGe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:06:34 -0500
Received: from localhost
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 17:06:32 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id D96A33578047
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:06:26 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG76CED34734246
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:06:20 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG75rhg029393
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:05:54 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V9 00/12] Btrfs: Pre subpagesize-blocksize cleanups
Date: Mon, 16 Nov 2015 12:35:20 +0530
Message-Id: <1447657532-9393-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patches posted along with this cover letter are cleanups made
during the development of subpagesize-blocksize patchset. I believe
that they can be integrated with the mainline kernel. Hence I have
posted them separately from the subpagesize-blocksize patchset.

I have tested the patchset by running xfstests on ppc64 and
x86_64. On ppc64, some of the Btrfs specific tests and generic/255
fail because they assume 4K as the filesystem's block size. I have
fixed some of the test cases. I will fix the rest and mail them to the
fstests mailing list in the near future.

Changes from V8:
1. Removed the patch "Btrfs: Return valid delalloc range when the page
   does not have PG_Dirty flag set or has been invalidated". The patch
   was written with the understanding that writepage_delalloc() could
   return delalloc_start which is greater than
   "page_offset(locked_page) + PAGE_CACHE_SIZE - 1". This scenario can
   never occur with the mainline kernel because in
   find_delalloc_range() even if EXTENT_DELALLOC bit isn't set for
   the file range corresponding to the locked page, we would
   definitely have EXTENT_UPTODATE bit set.
   The core subpagesize-blocksize patchset tracks "uptodate" status
   using a per-page bitmap and this caused find_delalloc_range to
   change its default behaviour.

Changes from V7:
1. The second argument passed to btrfs_delalloc_release_space() in
   btrfs_page_mkwrite() was incorrect. Version V8 fixes this.
   
Changes from V6:
1. Rebased on linux-btrfs/integration-4.4 branch. As a result the
   following patches have been trivially modified.
`  - Btrfs: __btrfs_buffered_write: Reserve/release extents aligned
     to block size.
   - Btrfs: fallocate: Work with sectorsized blocks.
   - Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units.

Changes from V5:
1. Introduced BTRFS_BYTES_TO_BLKS() helper to compute the number of
   filesystem blocks spanning across a range of bytes. A call to this
   macro replaces code such as "nr_blks = bytes >> inode->i_blkbits".

Changes from V4:
1. Removed the RFC tag.

Changes from V3:
Two new issues have been been fixed by the patches,
1. Btrfs: prepare_pages: Retry adding a page to the page cache.
2. Btrfs: Return valid delalloc range when the page does not have
   PG_Dirty flag set or has been invalidated.
IMHO, The above issues are also applicable to the "page size == block
size" scenario but for reasons unknown to me they aren't seen even
when the tests are run for a long time.

Changes from V2:
1. For detecting logical errors, Use ASSERT() calls instead of calls to
   BUG_ON().
2. In the patch "Btrfs: Compute and look up csums based on sectorsized
   blocks", fix usage of kmap_atomic/kunmap_atomic such that between the
   kmap_atomic() and kunmap_atomic() calls we do not invoke any function
   that might cause the current task to sleep.
   
Changes from V1:
1. Call round_[down,up]() functions instead of doing hard coded alignment.


Chandan Rajendra (12):
  Btrfs: __btrfs_buffered_write: Reserve/release extents aligned to
    block size
  Btrfs: Compute and look up csums based on sectorsized blocks
  Btrfs: Direct I/O read: Work on sectorsized blocks
  Btrfs: fallocate: Work with sectorsized blocks
  Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units
  Btrfs: Search for all ordered extents that could span across a page
  Btrfs: Use (eb->start, seq) as search key for tree modification log
  Btrfs: btrfs_submit_direct_hook: Handle map_length < bio vector length
  Btrfs: Limit inline extents to root->sectorsize
  Btrfs: Fix block size returned to user space
  Btrfs: Clean pte corresponding to page straddling i_size
  Btrfs: prepare_pages: Retry adding a page to the page cache

 fs/btrfs/ctree.c     |  34 +++----
 fs/btrfs/ctree.h     |   5 +-
 fs/btrfs/extent_io.c |   3 +-
 fs/btrfs/file-item.c |  92 ++++++++++++-------
 fs/btrfs/file.c      | 115 ++++++++++++++++--------
 fs/btrfs/inode.c     | 248 ++++++++++++++++++++++++++++++++++++---------------
 6 files changed, 334 insertions(+), 163 deletions(-)

-- 
2.1.0

