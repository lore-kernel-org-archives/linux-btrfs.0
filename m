Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AC0C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7539F20866
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731570AbeL1IiN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 03:38:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:34452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726580AbeL1IiM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 03:38:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34B2AAB93
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2018 08:38:11 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs-progs: Refactor excluded extent functions to use fs_info
Date:   Fri, 28 Dec 2018 16:38:01 +0800
Message-Id: <20181228083806.3204-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20181228083806.3204-1-wqu@suse.com>
References: <20181228083806.3204-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The following functions are just using @root to reach fs_info:
- exclude_super_stripes
- free_excluded_extents
- add_excluded_extent

Refactor them to use fs_info directly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c  |  4 ++--
 ctree.h       |  4 ++--
 extent-tree.c | 20 ++++++++++----------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/check/main.c b/check/main.c
index eb6a4a50db98..54ab146d0d13 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5531,7 +5531,7 @@ static int check_space_cache(struct btrfs_root *root)
 		}
 
 		if (btrfs_fs_compat_ro(root->fs_info, FREE_SPACE_TREE)) {
-			ret = exclude_super_stripes(root, cache);
+			ret = exclude_super_stripes(root->fs_info, cache);
 			if (ret) {
 				errno = -ret;
 				fprintf(stderr,
@@ -5540,7 +5540,7 @@ static int check_space_cache(struct btrfs_root *root)
 				continue;
 			}
 			ret = load_free_space_tree(root->fs_info, cache);
-			free_excluded_extents(root, cache);
+			free_excluded_extents(root->fs_info, cache);
 			if (ret < 0) {
 				errno = -ret;
 				fprintf(stderr,
diff --git a/ctree.h b/ctree.h
index 6a10e5994a6b..7f332161de1d 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2557,9 +2557,9 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 			      u64 num_bytes);
 int btrfs_free_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info, u64 bytenr, u64 len);
-void free_excluded_extents(struct btrfs_root *root,
+void free_excluded_extents(struct btrfs_fs_info *fs_info,
 			   struct btrfs_block_group_cache *cache);
-int exclude_super_stripes(struct btrfs_root *root,
+int exclude_super_stripes(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_group_cache *cache);
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		       struct btrfs_fs_info *info, u64 start, u64 end);
diff --git a/extent-tree.c b/extent-tree.c
index 8c9cdeff3b02..2a8b278285e8 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3116,7 +3116,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		if (btrfs_chunk_readonly(info, cache->key.objectid))
 			cache->ro = 1;
 
-		exclude_super_stripes(root, cache);
+		exclude_super_stripes(info, cache);
 
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
@@ -3160,7 +3160,7 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
-	exclude_super_stripes(fs_info->extent_root, cache);
+	exclude_super_stripes(fs_info, cache);
 	ret = update_space_info(fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
@@ -3951,16 +3951,16 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 }
 
 
-static int add_excluded_extent(struct btrfs_root *root,
+static int add_excluded_extent(struct btrfs_fs_info *fs_info,
 			       u64 start, u64 num_bytes)
 {
 	u64 end = start + num_bytes - 1;
-	set_extent_bits(&root->fs_info->pinned_extents,
+	set_extent_bits(&fs_info->pinned_extents,
 			start, end, EXTENT_UPTODATE);
 	return 0;
 }
 
-void free_excluded_extents(struct btrfs_root *root,
+void free_excluded_extents(struct btrfs_fs_info *fs_info,
 			   struct btrfs_block_group_cache *cache)
 {
 	u64 start, end;
@@ -3968,11 +3968,11 @@ void free_excluded_extents(struct btrfs_root *root,
 	start = cache->key.objectid;
 	end = start + cache->key.offset - 1;
 
-	clear_extent_bits(&root->fs_info->pinned_extents,
+	clear_extent_bits(&fs_info->pinned_extents,
 			  start, end, EXTENT_UPTODATE);
 }
 
-int exclude_super_stripes(struct btrfs_root *root,
+int exclude_super_stripes(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_group_cache *cache)
 {
 	u64 bytenr;
@@ -3983,7 +3983,7 @@ int exclude_super_stripes(struct btrfs_root *root,
 	if (cache->key.objectid < BTRFS_SUPER_INFO_OFFSET) {
 		stripe_len = BTRFS_SUPER_INFO_OFFSET - cache->key.objectid;
 		cache->bytes_super += stripe_len;
-		ret = add_excluded_extent(root, cache->key.objectid,
+		ret = add_excluded_extent(fs_info, cache->key.objectid,
 					  stripe_len);
 		if (ret)
 			return ret;
@@ -3991,7 +3991,7 @@ int exclude_super_stripes(struct btrfs_root *root,
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = btrfs_rmap_block(root->fs_info,
+		ret = btrfs_rmap_block(fs_info,
 				       cache->key.objectid, bytenr,
 				       &logical, &nr, &stripe_len);
 		if (ret)
@@ -4018,7 +4018,7 @@ int exclude_super_stripes(struct btrfs_root *root,
 			}
 
 			cache->bytes_super += len;
-			ret = add_excluded_extent(root, start, len);
+			ret = add_excluded_extent(fs_info, start, len);
 			if (ret) {
 				kfree(logical);
 				return ret;
-- 
2.20.1

