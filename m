Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48963 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753321AbeFTMt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:29 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2EB23AE90
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:29 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 32/34] btrfs: Remove fs_info from btrfs_inc_block_group_ro
Date: Wed, 20 Jun 2018 15:49:14 +0300
Message-Id: <1529498956-4241-33-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed bg cache.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/relocation.c  | 2 +-
 fs/btrfs/scrub.c       | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index eba0b1530843..caeca7592013 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2801,8 +2801,7 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
 void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_rsv *block_rsv,
 			     u64 num_bytes);
-int btrfs_inc_block_group_ro(struct btrfs_fs_info *fs_info,
-			     struct btrfs_block_group_cache *cache);
+int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache);
 void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
 u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 06823f69637b..d6f82a5c79d3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9392,10 +9392,10 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 	return ret;
 }
 
-int btrfs_inc_block_group_ro(struct btrfs_fs_info *fs_info,
-			     struct btrfs_block_group_cache *cache)
+int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache)
 
 {
+	struct btrfs_fs_info *fs_info = cache->fs_info;
 	struct btrfs_trans_handle *trans;
 	u64 alloc_flags;
 	int ret;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 879b76fa881a..ef1b5aad035e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4375,7 +4375,7 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 	rc->block_group = btrfs_lookup_block_group(fs_info, group_start);
 	BUG_ON(!rc->block_group);
 
-	ret = btrfs_inc_block_group_ro(fs_info, rc->block_group);
+	ret = btrfs_inc_block_group_ro(rc->block_group);
 	if (ret) {
 		err = ret;
 		goto out;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 572306036477..7599c4ff950e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3862,7 +3862,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 * -> btrfs_scrub_pause()
 		 */
 		scrub_pause_on(fs_info);
-		ret = btrfs_inc_block_group_ro(fs_info, cache);
+		ret = btrfs_inc_block_group_ro(cache);
 		if (!ret && is_dev_replace) {
 			/*
 			 * If we are doing a device replace wait for any tasks
-- 
2.7.4

