Return-Path: <SRS0=NMa+=4O=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF5CC4BA0D
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Feb 2020 05:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C1E4206E2
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Feb 2020 05:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgBZF5K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:57:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:36600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgBZF5K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Feb 2020 00:57:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AA532B06B
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2020 05:57:07 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 04/10] btrfs: relocation: Rename mark_block_processed() and __mark_block_processed()
Date:   Wed, 26 Feb 2020 13:56:46 +0800
Message-Id: <20200226055652.24857-5-wqu@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226055652.24857-1-wqu@suse.com>
References: <20200226055652.24857-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

These two functions are weirdly named, mark_block_processed() in fact
just mark a range dirty unconditionally, while __mark_block_processed()
does extra check before doing the marking.

Rename mark_block_processed() to mark_range_processed(), and rename
__mark_block_processed() to mark_block_processed().

Since we're here, also kill the forward declaration.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 65 +++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1fe34d8eef6d..d81fa6d63129 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -189,8 +189,34 @@ struct reloc_control {
 
 static void remove_backref_node(struct backref_cache *cache,
 				struct backref_node *node);
-static void __mark_block_processed(struct reloc_control *rc,
-				   struct backref_node *node);
+
+static int in_block_group(u64 bytenr, struct btrfs_block_group *block_group)
+{
+	if (bytenr >= block_group->start &&
+	    bytenr < block_group->start + block_group->length)
+		return 1;
+	return 0;
+}
+
+static void mark_range_processed(struct reloc_control *rc,
+				 u64 bytenr, u32 blocksize)
+{
+	set_extent_bits(&rc->processed_blocks, bytenr, bytenr + blocksize - 1,
+			EXTENT_DIRTY);
+}
+
+static void mark_block_processed(struct reloc_control *rc,
+				 struct backref_node *node)
+{
+	u32 blocksize;
+	if (node->level == 0 ||
+	    in_block_group(node->bytenr, rc->block_group)) {
+		blocksize = rc->extent_root->fs_info->nodesize;
+		mark_range_processed(rc, node->bytenr, blocksize);
+	}
+	node->processed = 1;
+}
+
 
 static void mapping_tree_init(struct mapping_tree *tree)
 {
@@ -1045,7 +1071,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 			if (list_empty(&lower->upper))
 				list_add(&lower->list, &useless);
 		}
-		__mark_block_processed(rc, upper);
+		mark_block_processed(rc, upper);
 		if (upper->level > 0) {
 			list_add(&upper->list, &cache->detached);
 			upper->detached = 1;
@@ -1509,14 +1535,6 @@ static struct inode *find_next_inode(struct btrfs_root *root, u64 objectid)
 	return NULL;
 }
 
-static int in_block_group(u64 bytenr, struct btrfs_block_group *block_group)
-{
-	if (bytenr >= block_group->start &&
-	    bytenr < block_group->start + block_group->length)
-		return 1;
-	return 0;
-}
-
 /*
  * get new location of data
  */
@@ -2537,7 +2555,7 @@ struct btrfs_root *select_reloc_root(struct btrfs_trans_handle *trans,
 			next->root = root;
 			list_add_tail(&next->list,
 				      &rc->backref_cache.changed);
-			__mark_block_processed(rc, next);
+			mark_block_processed(rc, next);
 			break;
 		}
 
@@ -2887,25 +2905,6 @@ static int finish_pending_nodes(struct btrfs_trans_handle *trans,
 	return err;
 }
 
-static void mark_block_processed(struct reloc_control *rc,
-				 u64 bytenr, u32 blocksize)
-{
-	set_extent_bits(&rc->processed_blocks, bytenr, bytenr + blocksize - 1,
-			EXTENT_DIRTY);
-}
-
-static void __mark_block_processed(struct reloc_control *rc,
-				   struct backref_node *node)
-{
-	u32 blocksize;
-	if (node->level == 0 ||
-	    in_block_group(node->bytenr, rc->block_group)) {
-		blocksize = rc->extent_root->fs_info->nodesize;
-		mark_block_processed(rc, node->bytenr, blocksize);
-	}
-	node->processed = 1;
-}
-
 /*
  * mark a block and all blocks directly/indirectly reference the block
  * as processed.
@@ -2924,7 +2923,7 @@ static void update_processed_blocks(struct reloc_control *rc,
 			if (next->processed)
 				break;
 
-			__mark_block_processed(rc, next);
+			mark_block_processed(rc, next);
 
 			if (list_empty(&next->upper))
 				break;
@@ -4663,7 +4662,7 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 		}
 
 		if (first_cow)
-			__mark_block_processed(rc, node);
+			mark_block_processed(rc, node);
 
 		if (first_cow && level > 0)
 			rc->nodes_relocated += buf->len;
-- 
2.25.1

