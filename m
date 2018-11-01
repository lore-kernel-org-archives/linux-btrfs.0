Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB17C6786F
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F84220820
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F84220820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbeKAVMo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 17:12:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:46010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728492AbeKAVMk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 17:12:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D29AAFB3
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Nov 2018 12:09:57 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/8] btrfs: Remove extent_io_ops::clear_bit_hook callback
Date:   Thu,  1 Nov 2018 14:09:51 +0200
Message-Id: <1541074194-22227-7-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1541074194-22227-1-git-send-email-nborisov@suse.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is the counterpart to ex-set_bit_hook (now btrfs_set_delalloc_extent),
similar to what was done before remove clear_bit_hook and rename the
function. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h     |  2 ++
 fs/btrfs/extent_io.c | 12 ++++--------
 fs/btrfs/extent_io.h |  3 ---
 fs/btrfs/inode.c     | 13 ++++++-------
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8fd9db7aa8de..49d52180e14c 100644
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
index 31bdc596e623..a3081c0ca3e3 100644
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
+	if (tree->private_data)
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
index d1c56c56a413..41c655cd9d23 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1808,14 +1808,14 @@ void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
 }
 
 /*
- * extent_io.c clear_bit_hook, see set_bit_hook for why
+ * Once a range is no longer delalloc this function ensures proper accounting
+ * happens.
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
 
@@ -10505,7 +10505,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
-	.clear_bit_hook = btrfs_clear_bit_hook,
 	.merge_extent_hook = btrfs_merge_extent_hook,
 	.split_extent_hook = btrfs_split_extent_hook,
 };
-- 
2.7.4

