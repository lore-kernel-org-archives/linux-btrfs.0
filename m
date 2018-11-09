Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECD6C0044C
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82AD320825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82AD320825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbeKIXt3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:49:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:49818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728689AbeKIXt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 18:49:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0447AF80
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 14:08:42 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 7/9] btrfs: Remove extent_io_ops::clear_bit_hook callback
Date:   Fri,  9 Nov 2018 16:08:36 +0200
Message-Id: <20181109140838.10457-8-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181109140838.10457-1-nborisov@suse.com>
References: <20181109140838.10457-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is the counterpart to ex-set_bit_hook (now btrfs_set_delalloc_extent),
similar to what was done before remove clear_bit_hook and rename the
function. No functional changes.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h     |  2 ++
 fs/btrfs/extent_io.c | 12 ++++--------
 fs/btrfs/extent_io.h |  3 ---
 fs/btrfs/inode.c     | 13 ++++++-------
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 071a6144d2eb..ca38bb8e7bf2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3152,6 +3152,8 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     u64 new_dirid);
 void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
 			       unsigned *bits);
+void btrfs_clear_delalloc_extent(struct inode *inode,
+				 struct extent_state *state, unsigned *bits);
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio,
 			 unsigned long bio_flags);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1678adae7963..b9aadbf1a9f9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -404,13 +404,6 @@ static void merge_state(struct extent_io_tree *tree,
 	}
 }
 
-static void clear_state_cb(struct extent_io_tree *tree,
-			   struct extent_state *state, unsigned *bits)
-{
-	if (tree->ops && tree->ops->clear_bit_hook)
-		tree->ops->clear_bit_hook(tree->private_data, state, bits);
-}
-
 static void set_state_bits(struct extent_io_tree *tree,
 			   struct extent_state *state, unsigned *bits,
 			   struct extent_changeset *changeset);
@@ -525,7 +518,10 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 		WARN_ON(range > tree->dirty_bytes);
 		tree->dirty_bytes -= range;
 	}
-	clear_state_cb(tree, state, bits);
+
+	if (tree->private_data && is_data_inode(tree->private_data))
+		btrfs_clear_delalloc_extent(tree->private_data, state, bits);
+
 	ret = add_extent_changeset(state, bits_to_clear, changeset, 0);
 	BUG_ON(ret < 0);
 	state->state &= ~bits_to_clear;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b3235d46b5c3..a3a3302f3625 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -106,9 +106,6 @@ struct extent_io_ops {
 	/*
 	 * Optional hooks, called if the pointer is not NULL
 	 */
-	void (*clear_bit_hook)(void *private_data,
-			struct extent_state *state,
-			unsigned *bits);
 	void (*merge_extent_hook)(void *private_data,
 				  struct extent_state *new,
 				  struct extent_state *other);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1a17f88b73df..5de0885bf8a8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1806,14 +1806,14 @@ void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
 }
 
 /*
- * extent_io.c clear_bit_hook, see set_bit_hook for why
+ * Once a range is no longer delalloc this function ensures that proper
+ * accounting happens.
  */
-static void btrfs_clear_bit_hook(void *private_data,
-				 struct extent_state *state,
-				 unsigned *bits)
+void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
+				 struct extent_state *state, unsigned *bits)
 {
-	struct btrfs_inode *inode = BTRFS_I((struct inode *)private_data);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
+	struct btrfs_fs_info *fs_info = btrfs_sb(vfs_inode->i_sb);
 	u64 len = state->end + 1 - state->start;
 	u32 num_extents = count_max_extents(len);
 
@@ -10497,7 +10497,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
-	.clear_bit_hook = btrfs_clear_bit_hook,
 	.merge_extent_hook = btrfs_merge_extent_hook,
 	.split_extent_hook = btrfs_split_extent_hook,
 };
-- 
2.17.1

