Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38268 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbbHGHHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 03:07:20 -0400
Received: from /spool/local
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 7 Aug 2015 17:07:17 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id AD1183578058
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2015 17:07:14 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t77776uD32833726
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 17:07:14 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7776fbp031609
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 17:06:42 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com,
        quwenruo@cn.fujitsu.com
Subject: [PATCH V2 00/11] Btrfs: Pre subpagesize-blocksize cleanups
Date: Fri,  7 Aug 2015 12:35:47 +0530
Message-Id: <1438931158-20888-1-git-send-email-chandan@linux.vnet.ibm.com>
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
 fs/btrfs/file-item.c |  90 ++++++++++++-------
 fs/btrfs/file.c      | 103 ++++++++++++++--------
 fs/btrfs/inode.c     | 239 ++++++++++++++++++++++++++++++++++++---------------
 6 files changed, 311 insertions(+), 160 deletions(-)

-- 
2.1.0

