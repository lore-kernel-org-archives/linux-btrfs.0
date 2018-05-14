Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46595 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752333AbeENM00 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 08:26:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CC435AB35
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 12:26:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v3 0/3] Cleanup waitqueue_active and barriers
Date: Mon, 14 May 2018 14:23:44 +0200
Message-Id: <cover.1526300425.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reduce number of standalone barriers before waitqueue_active calls.

Changes v3:
* fix wrong use of the _nomb variant in tree-log.c:btrfs_sync_log,
* update comments to be more specific about the waitqueue_active and
  barrier

Changes v2:
* add 2 barriers to btrfs_sync_log and do not assume they're implied,
  (pointed out by Nikolay)

git://github.com/kdave/btrfs-devel.git cleanup/cond-wake

David Sterba (3):
  btrfs: introduce conditional wakeup helpers
  btrfs: add barriers to btrfs_sync_log before log_commit_wait wakeups
  btrfs: replace waitqueue_actvie with cond_wake_up

 fs/btrfs/compression.c   |  7 +------
 fs/btrfs/ctree.h         | 22 ++++++++++++++++++++++
 fs/btrfs/delayed-inode.c |  9 +++------
 fs/btrfs/dev-replace.c   | 10 ++++------
 fs/btrfs/extent-tree.c   |  7 +------
 fs/btrfs/inode.c         |  9 +++------
 fs/btrfs/locking.c       | 34 +++++++++++-----------------------
 fs/btrfs/ordered-data.c  | 14 ++++----------
 fs/btrfs/transaction.c   |  7 +------
 fs/btrfs/tree-log.c      | 28 ++++++++++++----------------
 10 files changed, 62 insertions(+), 85 deletions(-)

-- 
2.16.2

