Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:60869 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbbHFKKv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 06:10:51 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 6 Aug 2015 15:40:48 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id D8C8E1258067
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2015 15:43:54 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t76AAfnR2097586
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 15:40:41 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t76AAbFp020775
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 15:40:40 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [PATCH 00/11] Btrfs: Pre subpagesize-blocksize cleanups
Date: Thu,  6 Aug 2015 15:40:08 +0530
Message-Id: <1438855819-4328-1-git-send-email-chandan@linux.vnet.ibm.com>
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
 fs/btrfs/file-item.c |  90 ++++++++++++-------
 fs/btrfs/file.c      |  99 +++++++++++++--------
 fs/btrfs/inode.c     | 239 ++++++++++++++++++++++++++++++++++++---------------
 6 files changed, 308 insertions(+), 159 deletions(-)

-- 
2.1.0

