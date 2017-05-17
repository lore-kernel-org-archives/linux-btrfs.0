Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24182 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750944AbdEQC4g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 22:56:36 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [RFC PATCH v3.2 0/6] Qgroup fixes, Non-stack version
Date: Wed, 17 May 2017 10:56:22 +0800
Message-ID: <20170517025628.303-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The remaining qgroup fixes patches, based on the Chris' for-linus-4.12
branch with commit 9bcaaea7418d09691f1ffab5c49aacafe3eef9d0 as base.

Can be fetched from github:
https://github.com/adam900710/linux/tree/qgroup_fixes_non_stack

This update is commit message update only.

v2:
  Add reviewed-by tag for 2nd patch
  Update the first patch to follow the new trace point standard
RFC v3:
  Use non-stack (dyanamic allocation) for extent_changeset structure, in
  5th patch, to reduce impact for quota disabled cases.
  Rebase to latest for-linus-4.12 branch.
RFC v3.1:
  Update comment to include the newly introduced parameter
  Use init/release function to replace open coded ulist_init/release().
RFC v3.2:
  Update commit message of 1st and 3rd patch.

Qu Wenruo (6):
  btrfs: qgroup: Add quick exit for non-fs extents
  btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function
  btrfs: qgroup: Return actually freed bytes for qgroup release or free
    data
  btrfs: qgroup: Fix qgroup reserved space underflow caused by buffered
    write and quota enable
  btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
  btrfs: qgroup: Fix qgroup reserved space underflow by only freeing
    reserved ranges

 fs/btrfs/ctree.h       |  12 ++-
 fs/btrfs/extent-tree.c |  37 +++++----
 fs/btrfs/extent_io.h   |  36 ++++++++-
 fs/btrfs/file.c        |  41 ++++++----
 fs/btrfs/inode-map.c   |   4 +-
 fs/btrfs/inode.c       |  58 ++++++++-----
 fs/btrfs/ioctl.c       |   9 ++-
 fs/btrfs/qgroup.c      | 215 ++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/qgroup.h      |   8 +-
 fs/btrfs/relocation.c  |  12 +--
 fs/btrfs/transaction.c |  10 ---
 11 files changed, 303 insertions(+), 139 deletions(-)

-- 
2.13.0



