Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54939 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751802AbcLICaB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 21:30:01 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, chandan@linux.vnet.ibm.com
Subject: [PATCH 00/10] Qgroup fixes for kdave/for-next-20161125 branch
Date: Fri,  9 Dec 2016 10:28:35 +0800
Message-Id: <20161209022835.10168-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The branch can be fetched from github:
https://github.com/adam900710/linux.git for-david-next-qgroup-fixes

If David wants to push these fixes to 4.10, then I can rebase these patches to
Chris' for-linus branch.

Recent qgroup fixes for several problems:
1) Qgroup reserved space underflow
   Caused by several reasons, from buffer write happens before qgroup enable,
   to freeing qgroup space not reserved by caller.

2) inode_cache mount option corruption

3) Enhance qgroup trace point
   Used for debugging above problems.

All patches are already submitted to mail list.
The 1st patch is the diff between V4 and V5 patch which adds WARN_ON() for
underflowing qgroup reserved space.

Qu Wenruo (10):
  btrfs: qgroup: Fix wrong qgroup passed to reserved space error report
  btrfs: qgroup: Add trace point for qgroup reserved space
  btrfs: qgroup: Re-arrange tracepoint timing to co-operate with
    reserved space tracepoint
  btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount
    option
  btrfs: qgroup: Add quick exit for non-fs extents
  btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function
  btrfs: qgroup: Return actually freed bytes for qgroup release or free
    data
  btrfs: qgroup: Fix qgroup reserved space underflow caused by buffered
    write and quota enable
  btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
  btrfs: qgroup: Fix qgroup reserved space underflow by only freeing
    reserved ranges

 fs/btrfs/ctree.h             |  14 +--
 fs/btrfs/extent-tree.c       |  32 ++++---
 fs/btrfs/extent_io.h         |  24 +++++-
 fs/btrfs/file.c              |  45 ++++++----
 fs/btrfs/inode-map.c         |   4 +-
 fs/btrfs/inode.c             |  69 +++++++++------
 fs/btrfs/ioctl.c             |   9 +-
 fs/btrfs/qgroup.c            | 197 +++++++++++++++++++++++++++++++------------
 fs/btrfs/qgroup.h            |  14 ++-
 fs/btrfs/relocation.c        |  12 +--
 fs/btrfs/transaction.c       |  20 ++---
 include/trace/events/btrfs.h |  43 ++++++++++
 12 files changed, 341 insertions(+), 142 deletions(-)

-- 
2.10.2



