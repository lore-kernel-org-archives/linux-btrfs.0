Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38365 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751822AbeCHLvd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 06:51:33 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A9920AED7
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 11:51:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Cleanup waitqueue_active and barriers
Date: Thu,  8 Mar 2018 12:49:11 +0100
Message-Id: <cover.1520509627.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is depends on current misc-next with "btrfs: Relax memory barrier
in btrfs_tree_unlock".

David Sterba (2):
  btrfs: introduce conditional wakeup helpers
  btrfs: replace waitqueue_actvie with cond_wake_up

 fs/btrfs/compression.c   |  7 +------
 fs/btrfs/ctree.h         | 23 +++++++++++++++++++++++
 fs/btrfs/delayed-inode.c |  9 +++------
 fs/btrfs/dev-replace.c   | 10 ++++------
 fs/btrfs/extent-tree.c   |  7 +------
 fs/btrfs/inode.c         |  9 +++------
 fs/btrfs/locking.c       | 34 +++++++++++-----------------------
 fs/btrfs/ordered-data.c  | 14 ++++----------
 fs/btrfs/transaction.c   |  7 +------
 fs/btrfs/tree-log.c      | 28 ++++++++--------------------
 10 files changed, 59 insertions(+), 89 deletions(-)

-- 
2.16.2

