Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60861 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965388AbaGPOrw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 10:47:52 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 17 Jul 2014 00:47:50 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 7397D357804F
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:47:18 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6GEl1T811338016
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:47:02 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6GElGag007194
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:47:17 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org
Subject: [RFC PATCH V4 00/12] Btrfs: Subpagesize-blocksize: Get rid of whole page I/O.
Date: Wed, 16 Jul 2014 20:15:58 +0530
Message-Id: <1405521970-8119-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset continues with the work posted earlier at
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg34954.html.

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

Xfstests' generic tests were run on an x86_64 machine with the patches
applied. The Btrfs kernel module was compiled without ACL and quotas support
and hence tests related to those were not run.

On multiple runs of the tests with 4k blocksize, 'umount' process would
sometimes get blocked indefinitely causing 'hung task detector' to print the
function call trace.

For 2k blocksize about 15 xfstests' generic test cases fail (reasons include
checksum failures, softlockups and BUG_ON()s).

The following is a list of known TODO items which will be implemented in
future revisions of this patchset:
1. Remove usage of bvec->{bv_offset, bv_len} from btrfs_csum_one_bio.
2. Remove PAGE_CACHE_SIZE delalloc reservation in btrfs_writepage_fixup_worker().
3. Create separate slab caches for 'extent buffer head' and 'extent buffer'.
4. Add 'leak list' tracking for 'extent buffer' instances.
5. Rename EXTENT_BUFFER_TREE_REF and EXTENT_BUFFER_IN_TREE to
   EXTENT_BUFFER_HEAD_TREE_REF and EXTENT_BUFFER_HEAD_IN_TREE respectively.
6. Get Xfstests' generic tests to successfully run on both 4k and 2k
   blocksizes.

Chandan Rajendra (10):
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

Chandra Seetharaman (2):
  Btrfs: subpagesize-blocksize: Define extent_buffer_head.
  Btrfs: subpagesize-blocksize: Allow mounting filesystems where
    sectorsize != PAGE_SIZE

 fs/btrfs/backref.c           |    2 +-
 fs/btrfs/ctree.c             |    2 +-
 fs/btrfs/ctree.h             |    8 +-
 fs/btrfs/disk-io.c           |  117 ++---
 fs/btrfs/disk-io.h           |    3 +
 fs/btrfs/extent-tree.c       |    6 +-
 fs/btrfs/extent_io.c         | 1111 ++++++++++++++++++++++++++++++------------
 fs/btrfs/extent_io.h         |   48 +-
 fs/btrfs/file-item.c         |   85 ++--
 fs/btrfs/file.c              |   67 +--
 fs/btrfs/inode.c             |  158 +++---
 fs/btrfs/volumes.c           |    2 +-
 fs/btrfs/volumes.h           |    3 +
 include/trace/events/btrfs.h |    2 +-
 14 files changed, 1097 insertions(+), 517 deletions(-)

-- 
1.8.3.1

