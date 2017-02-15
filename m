Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57379 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752287AbdBOV2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:28:41 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3DC67AD62
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 21:28:40 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/8] btrfs: convert btrfs_inc_block_group_ro to accept fs_info
Date: Wed, 15 Feb 2017 16:28:29 -0500
Message-Id: <1487194114-12786-4-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-1-git-send-email-jeffm@suse.com>
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_inc_block_group_ro is either passed the extent root or the dev
root, but it doesn't do anything with the dev tree.  Let's convert
to passing an fs_info and using the extent root.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       | 2 +-
 fs/btrfs/extent-tree.c | 5 ++---
 fs/btrfs/relocation.c  | 2 +-
 fs/btrfs/scrub.c       | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6a82371..49f520c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2724,7 +2724,7 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
 void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_rsv *block_rsv,
 			     u64 num_bytes);
-int btrfs_inc_block_group_ro(struct btrfs_root *root,
+int btrfs_inc_block_group_ro(struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_group_cache *cache);
 void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b005378..20bedc7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9363,17 +9363,16 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 	return ret;
 }
 
-int btrfs_inc_block_group_ro(struct btrfs_root *root,
+int btrfs_inc_block_group_ro(struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_group_cache *cache)
 
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_trans_handle *trans;
 	u64 alloc_flags;
 	int ret;
 
 again:
-	trans = btrfs_join_transaction(root);
+	trans = btrfs_join_transaction(fs_info->extent_root);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3797110..2e9deb9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4334,7 +4334,7 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 	rc->block_group = btrfs_lookup_block_group(fs_info, group_start);
 	BUG_ON(!rc->block_group);
 
-	ret = btrfs_inc_block_group_ro(extent_root, rc->block_group);
+	ret = btrfs_inc_block_group_ro(fs_info, rc->block_group);
 	if (ret) {
 		err = ret;
 		goto out;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9a94670..3a9607dc 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3584,7 +3584,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 * -> btrfs_scrub_pause()
 		 */
 		scrub_pause_on(fs_info);
-		ret = btrfs_inc_block_group_ro(root, cache);
+		ret = btrfs_inc_block_group_ro(fs_info, cache);
 		if (!ret && is_dev_replace) {
 			/*
 			 * If we are doing a device replace wait for any tasks
-- 
2.7.1

