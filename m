Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41591 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752229AbdBMJe1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:27 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DAB5CABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:20 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/29] btrfs: remove unused parameter from btrfs_prepare_extent_commit
Date: Mon, 13 Feb 2017 10:33:52 +0100
Message-Id: <6ac74e62110a8cd9f5aa04f9b664287a5d115e5b.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added but never used.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 3 +--
 fs/btrfs/transaction.c | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0f5b85772023..e7dbda3dd3b8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2630,8 +2630,7 @@ int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
 			       u64 start, u64 len, int delalloc);
 int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
 				       u64 start, u64 len);
-void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
-				 struct btrfs_fs_info *fs_info);
+void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 			       struct btrfs_fs_info *fs_info);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b33e2c8325c8..2500e3df3250 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6558,8 +6558,7 @@ static int btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
 	spin_unlock(&space_info->lock);
 	return ret;
 }
-void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info)
+void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_caching_control *next;
 	struct btrfs_caching_control *caching_ctl;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7d1d71259cd0..8bfb5e2c31f9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2211,7 +2211,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		goto scrub_continue;
 	}
 
-	btrfs_prepare_extent_commit(trans, fs_info);
+	btrfs_prepare_extent_commit(fs_info);
 
 	cur_trans = fs_info->running_transaction;
 
-- 
2.10.1

