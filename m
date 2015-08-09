Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:41171 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbbHIPKh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Aug 2015 11:10:37 -0400
Received: from /spool/local
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 10 Aug 2015 01:10:35 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 7FDE13578057
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 01:10:31 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t79FANFY40173798
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 01:10:31 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t79F9w66008935
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 01:09:58 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V3 00/11] Btrfs: Pre subpagesize-blocksize cleanups
Date: Sun,  9 Aug 2015 20:39:21 +0530
Message-Id: <1439132972-24321-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

The patches posted along with this cover letter are cleanups made
during the developement of subpagesize-blocksize patchset. I believe
that they can be integrated with the mainline kernel. Hence I have
posted them separately from the subpagesize-blocksize patchset.

I have testsed the patchset by running xfstests on ppc64 and
x86_64. On ppc64, some of the Btrfs specific tests and generic/255
fail because they assume 4K as the filesystem's block size. I have
fixed some of the test cases. I will fix the rest and mail them to the
fstests mailing list in the near future.

Changes from V2:
1. For detecting logical errors, Use ASSERT() calls instead of calls to
   BUG_ON().
2. In the patch "Btrfs: Compute and look up csums based on sectorsized
   blocks", fix usage of kmap_atomic/kunmap_atomic such that between the
   kmap_atomic() and kunmap_atomic() calls we do not invoke any function
   that might cause the current task to sleep.
   
Changes from V1:
1. Call round_[down,up]() functions instead of doing hard coded alignment.

Chandan Rajendra (11):
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

 fs/btrfs/ctree.c     |  34 ++++----
 fs/btrfs/ctree.h     |   2 +-
 fs/btrfs/extent_io.c |   3 +-
 fs/btrfs/file-item.c |  93 ++++++++++++--------
 fs/btrfs/file.c      | 103 ++++++++++++++--------
 fs/btrfs/inode.c     | 239 ++++++++++++++++++++++++++++++++++++---------------
 6 files changed, 313 insertions(+), 161 deletions(-)

-- 
2.1.0

