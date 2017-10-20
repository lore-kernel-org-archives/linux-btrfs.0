Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53332 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751869AbdJTPLI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 11:11:08 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, mathieu.desnoyers@efficios.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Remove unused function
Date: Fri, 20 Oct 2017 18:10:59 +0300
Message-Id: <1508512259-16867-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1508512259-16867-1-git-send-email-nborisov@suse.com>
References: <1508512259-16867-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's sole callsite was removed in a previous patch so just nuke it for good.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0b8ddcbf8462..3509a68d274f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -489,11 +489,6 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 chunk_offset);
 
-static inline int btrfs_dev_stats_dirty(struct btrfs_device *dev)
-{
-	return atomic_read(&dev->dev_stats_ccnt);
-}
-
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
 {
-- 
2.7.4

