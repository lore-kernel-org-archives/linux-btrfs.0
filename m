Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57476 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1756352AbcK2HvG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 02:51:06 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH v2 0/3] Qgroup and inode_cache fix, with small cleanups
Date: Tue, 29 Nov 2016 15:50:41 +0800
Message-Id: <20161129075044.16158-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes a qgroup bug when using with inode_cache mount option.

The bug reminds us that the design of separate
btrfs_qgroup_prepare_account_extents() is a bad practice especially the
safest timing is to call prepare just before btrfs_qgroup_account_extents().

So the patchset will cleanup btrfs_qgroup_prepare_account_extents() to
avoid further similar bugs.

And add a quick exit for non-fs extents for qgroup, mainly to reduce the
noise of qgroup trace events.

v2:
  Fix the missing mutex_unlock() at error path of 1st patch.

Qu Wenruo (3):
  btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount
    option
  btrfs: qgroup: Add quick exit for non-fs extents
  btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function

 fs/btrfs/qgroup.c      | 82 +++++++++++++++++++++++++++++---------------------
 fs/btrfs/qgroup.h      |  2 --
 fs/btrfs/transaction.c | 21 +++++++------
 3 files changed, 59 insertions(+), 46 deletions(-)

-- 
2.7.4



