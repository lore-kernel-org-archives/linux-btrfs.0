Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38442 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbFAPYM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 11:24:12 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 2 Jun 2015 01:24:09 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 875802BB004D
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2015 01:24:05 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t51FNuMH52297940
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:24:04 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t51FNW0L027065
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:23:33 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V11 00/21] Btrfs: Subpagesize-blocksize: Allow I/O on blocks whose size is less than page size.
Date: Mon,  1 Jun 2015 20:52:35 +0530
Message-Id: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs assumes block size to be the same as the machine's page
size. This would mean that a Btrfs instance created on a 4k page size
machine (e.g. x86) will not be mountable on machines with larger page
sizes (e.g. PPC64/AARCH64). This patchset aims to resolve this
incompatibility.

Based on the discussion during Btrfs BoF meetup at Vault conference,
this patchset now tracks the Dirty, Uptodate and I/O status of each
block of a page in a bitmap pointed to by page->private.

The patchset is based off the contents of linux-btrfs/next branch as
available on 07 May 2015 (i.e. commit
e082f56313f374d723b0366978ddb062c8fe79ea). I have also added "Btrfs:
fill ->last_trans for delayed inode in btrfs_fill_inode" commit (from
linux-btrfs/for-linus-4.1) to prevent a failure when executing
xfstests' generic/311.

I have reverted the upstream commit "btrfs: fix lockups from
btrfs_clear_path_blocking" (f82c458a2c3ffb94b431fc6ad791a79df1b3713e)
since this led to soft-lockups when "Btrfs: subpagesize-blocksize:
Prevent writes to an extent buffer when PG_writeback flag is set"
patch is applied.

The commits for the Btrfs kernel module can be found at
https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize.

The commits for Btrfs-progs can be found at
https://github.com/chandanr/btrfs-progs/tree/btrfs/subpagesize-blocksize.

xfstests' generic tests were run on an x86_64 machine with the
following setups:
1. 4k data block size and 16k metadata block size
   The following tests failed,
   - 018 (Defrag failure)
   - 019 (Fails on linux-btrfs/next branch)
   - 038 
   - 224 (Fails on linux-btrfs/next branch)
   - 251 (Fails on linux-btrfs/next branch)
   - 256 (The test never completes nor causes a softlock up or Hung
          task timeout).
   - 324 (Defrag failure)
2. 2k data block size and 2k metadata block size
   Apart from the tests listed above, the following tests failed,
   - 029
   - 030

The following is a list of known TODO items which will be implemented in
future revisions of this patchset:
1. Split the trivial/non-controversial patches and mail them for
   upstream inclusion.
2. Get Xfstests' generic tests to successfully run on both 2k and 4k
   blocksizes (with both 4k and 64k page sizes).
3. Create separate caches for 'extent buffer head' and 'extent buffer'.
4. Add 'leak list' tracking for 'extent buffer' instances.
5. Rename EXTENT_BUFFER_TREE_REF and EXTENT_BUFFER_IN_TREE to
   EXTENT_BUFFER_HEAD_TREE_REF and EXTENT_BUFFER_HEAD_IN_TREE
   respectively.

Chandan Rajendra (21):
  Btrfs: subpagesize-blocksize: Fix whole page read.
  Btrfs: subpagesize-blocksize: Fix whole page write.
  Btrfs: subpagesize-blocksize: __btrfs_buffered_write: Reserve/release
    extents aligned to block size.
  Btrfs: subpagesize-blocksize: Define extent_buffer_head.
  Btrfs: subpagesize-blocksize: Read tree blocks whose size is <
    PAGE_SIZE.
  Btrfs: subpagesize-blocksize: Write only dirty extent buffers
    belonging to a page
  Btrfs: subpagesize-blocksize: Allow mounting filesystems where
    sectorsize != PAGE_SIZE
  Btrfs: subpagesize-blocksize: Compute and look up csums based on
    sectorsized blocks.
  Btrfs: subpagesize-blocksize: Direct I/O read: Work on sectorsized
    blocks.
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
  Btrfs: subpagesize-blocksize: Prevent writes to an extent buffer when
    PG_writeback flag is set.
  Btrfs: subpagesize-blocksize: Use (eb->start, seq) as search key for
    tree modification log.
  Btrfs: subpagesize-blocksize: btrfs_submit_direct_hook: Handle
    map_length < bio vector length
  Revert "btrfs: fix lockups from btrfs_clear_path_blocking"
  Btrfs: subpagesize-blockssize: Limit inline extents to
    root->sectorsize.
  Btrfs: subpagesize-blocksize: Fix block size returned to user space.

 fs/btrfs/backref.c           |    2 +-
 fs/btrfs/btrfs_inode.h       |    2 -
 fs/btrfs/ctree.c             |   71 ++-
 fs/btrfs/ctree.h             |    8 +-
 fs/btrfs/disk-io.c           |  169 +++--
 fs/btrfs/disk-io.h           |    3 +
 fs/btrfs/extent-tree.c       |   17 +-
 fs/btrfs/extent_io.c         | 1447 +++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.h         |   73 ++-
 fs/btrfs/file-item.c         |   87 ++-
 fs/btrfs/file.c              |  107 +++-
 fs/btrfs/inode.c             |  602 +++++++++++++-----
 fs/btrfs/locking.c           |   24 +-
 fs/btrfs/locking.h           |    2 -
 fs/btrfs/ordered-data.c      |   17 +
 fs/btrfs/ordered-data.h      |    4 +
 fs/btrfs/volumes.c           |    2 +-
 include/trace/events/btrfs.h |    2 +-
 18 files changed, 1842 insertions(+), 797 deletions(-)

-- 
2.1.0

