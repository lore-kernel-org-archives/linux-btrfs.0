Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425213AbeE1PyJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:54:09 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B9DB4AE75
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 15:54:07 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: Delay block group auto removal to avoid interfering qgroups
Date: Mon, 28 May 2018 14:58:41 +0800
Message-Id: <20180528065844.21248-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github:
https://github.com/adam900710/linux/tree/delayed_bg_removal

It's based on v4.17-rc5 branch.

This bug is reported from SUSE openQA, although it's pretty hard to hit
in real world (even real world VM), it's believed block group auto
removal (anyway, there isn't much thing can remove a chunk mapping in
btrfs) could interfere with qgroup's search on commit root.

Full details can be found in the 3rd patch.

The patchset uses 2 submitted cleanup/refactor patches as basis, and the
3rd patch will ensure unused block group will only be deleted after
current transaction is done.

Qu Wenruo (3):
  btrfs: trace: Add trace points for unused block groups
  btrfs: Use btrfs_mark_bg_unused() to replace open code
  btrfs: Delayed empty block group auto removal to next transaction

 fs/btrfs/ctree.h             |  2 ++
 fs/btrfs/extent-tree.c       | 62 ++++++++++++++++++++++++++----------
 fs/btrfs/scrub.c             |  8 +----
 fs/btrfs/transaction.c       |  7 ++++
 fs/btrfs/transaction.h       | 10 ++++++
 include/trace/events/btrfs.h | 42 ++++++++++++++++++++++++
 6 files changed, 107 insertions(+), 24 deletions(-)

-- 
2.17.0

