Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757927AbeDXNNb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 09:13:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 21B23AE20
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 13:13:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 0/3] Cleanup waitqueue_active and barriers
Date: Tue, 24 Apr 2018 15:10:57 +0200
Message-Id: <cover.1524575208.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reduce number of standalone barriers before waitqueue_active calls.

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
 fs/btrfs/tree-log.c      | 29 +++++++++++++----------------
 10 files changed, 63 insertions(+), 85 deletions(-)

-- 
2.16.2

