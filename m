Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12166 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751104AbdCMHwt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:52:49 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C632147D8B9C
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 15:52:42 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 0/9] Qgroup fixes
Date: Mon, 13 Mar 2017 15:52:07 +0800
Message-ID: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patchset can be fetched from my github:
https://github.com/adam900710/linux.git qgroup_fixes

The new base is v4.11-rc1, only minor conflicts and are all easy to handle.

This pull request includes:
1) Fix for inode_cache mount option
   Although no one really cares inode_cache mount option, it will screw
   qgroup for a long time.
   Not only it will screw up qgroup test uses golden output, but also
   new test cases use btrfsck to verify qgroup.

2) Fix for btrfs/104 kernel warning
   This is caused by quota enabling with dirty buffers not written to
   disc.

   Fixed by checking EXTENT_QGROUP_RESERVED flag other than just
   decreasing qgroup->reserved.

3) Fix qgroup underflow caused by freeing ranges not reserved by caller
   Mainly exposed by Chandan on PPC64.

   It's possible that buffered write is blocked by reserving metadata,
   and in error path we will release reserved space for both data and
   metadata.

   However the reserved data can already be reserved by another process
   writing the same page.

   In that case, data reserved space can be freed by two process, one
   for error path, one for normal write routine, causing underflow.

   Fixed by checking if that data range is reserved by ourselves and
   only free it if it's reserved by ourselves.

Update since 2016/12/09:
  Rebased to latest for-linux-4.11.

  Add missing reviewed-by and tested-by tags.

  Add more comment for btrfs_qgroup_reserve_data() for error handling.

  Add more comment for qgroup_free_reserved_data() for later
  enhancement (not function enhancement).

v2:
  Add reviewed-by tag for 2nd patch
  Update the first patch to follow the new trace point standard

Qu Wenruo (9):
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

 fs/btrfs/ctree.h             |  12 +-
 fs/btrfs/extent-tree.c       |  31 ++++--
 fs/btrfs/extent_io.h         |  14 ++-
 fs/btrfs/file.c              |  46 +++++---
 fs/btrfs/inode-map.c         |   6 +-
 fs/btrfs/inode.c             |  64 +++++++----
 fs/btrfs/ioctl.c             |  11 +-
 fs/btrfs/qgroup.c            | 258 ++++++++++++++++++++++++++-----------------
 fs/btrfs/qgroup.h            |  58 ++++++++--
 fs/btrfs/relocation.c        |  13 ++-
 fs/btrfs/transaction.c       |  21 ++--
 include/trace/events/btrfs.h |  44 ++++++++
 12 files changed, 396 insertions(+), 182 deletions(-)

-- 
2.12.0



