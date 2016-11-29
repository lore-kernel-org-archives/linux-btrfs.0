Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56327 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752561AbcK2Ent (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 23:43:49 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id C324B41B4BC6
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 12:42:56 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Qgroup and inode_cache fix, with small cleanups
Date: Tue, 29 Nov 2016 12:42:38 +0800
Message-Id: <20161129044241.27407-1-quwenruo@cn.fujitsu.com>
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

Qu Wenruo (3):
  btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount
    option
  btrfs: qgroup: Add quick exit for non-fs extents
  btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function

 fs/btrfs/qgroup.c      | 82 +++++++++++++++++++++++++++++---------------------
 fs/btrfs/qgroup.h      |  2 --
 fs/btrfs/transaction.c | 20 ++++++------
 3 files changed, 58 insertions(+), 46 deletions(-)

-- 
2.10.2



