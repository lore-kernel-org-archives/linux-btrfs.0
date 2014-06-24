Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33939 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbaFXO3r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 10:29:47 -0400
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 24 Jun 2014 19:59:45 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 1592C3940060
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:43 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5OEUn3J57147410
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 20:00:50 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5OETZP2023052
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:36 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [RFC PATCH V3 0/9] Btrfs: Subpagesize-blocksize: Get rid of whole page I/O
Date: Tue, 24 Jun 2014 19:58:59 +0530
Message-Id: <1403620148-28774-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset continues with the work posted earlier at
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg34527.html.

Changes from V1:
1. Remove usage of bio_vec->bv_{len,offset} in end_bio_extent_readpage()
   and end_bio_extent_writepage().

Changes from V2:
1. Get __extent_writepage() to write only the dirty blocks of a page.
2. Fix "page private not zero on page" warning message which is printed
   when running xfstests.

Xfstests' generic tests were run on an x86_64 machine with the patches
applied.

On multiple runs of the tests with 4k blocksize, 'umount' process would
sometimes get blocked indefinitely causing 'hung task detector' to print the
function call trace.

For 2k blocksize only a few Xfstests' generic tests pass.

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

Chandan Rajendra (7):
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

Chandra Seetharaman (2):
  Btrfs: subpagesize-blocksize: Define extent_buffer_head.
  Btrfs: subpagesize-blocksize: Allow mounting filesystems where
    sectorsize != PAGE_SIZE

 fs/btrfs/backref.c           |    2 +-
 fs/btrfs/ctree.c             |    2 +-
 fs/btrfs/ctree.h             |    6 +-
 fs/btrfs/disk-io.c           |  117 ++---
 fs/btrfs/disk-io.h           |    3 +
 fs/btrfs/extent-tree.c       |    6 +-
 fs/btrfs/extent_io.c         | 1121 ++++++++++++++++++++++++++++++------------
 fs/btrfs/extent_io.h         |   48 +-
 fs/btrfs/file-item.c         |   85 ++--
 fs/btrfs/file.c              |   32 +-
 fs/btrfs/inode.c             |   74 ++-
 fs/btrfs/volumes.c           |    2 +-
 fs/btrfs/volumes.h           |    3 +
 include/trace/events/btrfs.h |    2 +-
 14 files changed, 1044 insertions(+), 459 deletions(-)

-- 
1.8.3.1

