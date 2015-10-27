Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37306 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbbJ0JlO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 05:41:14 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 27 Oct 2015 19:41:12 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 61744357804F
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 20:41:08 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9R9f0pW59572244
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 20:41:08 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9R9eZEj018436
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 20:40:35 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V7 00/13] Btrfs: Pre subpagesize-blocksize cleanups
Date: Tue, 27 Oct 2015 15:09:33 +0530
Message-Id: <1445938786-12488-1-git-send-email-chandan@linux.vnet.ibm.com>
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

Chandan Rajendra (13):
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
  Btrfs: Return valid delalloc range when the page does not have
    PG_Dirty flag set or has been invalidated

 fs/btrfs/ctree.c     |  34 +++----
 fs/btrfs/ctree.h     |   5 +-
 fs/btrfs/extent_io.c |   5 +-
 fs/btrfs/file-item.c |  92 ++++++++++++-------
 fs/btrfs/file.c      | 115 ++++++++++++++++--------
 fs/btrfs/inode.c     | 248 ++++++++++++++++++++++++++++++++++++---------------
 6 files changed, 336 insertions(+), 163 deletions(-)

-- 
2.1.0

