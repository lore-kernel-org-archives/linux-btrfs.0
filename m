Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F64C004D5
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54852216E3
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:04:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54852216E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbeI1I0Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 04:26:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:58280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbeI1I0Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 04:26:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2B30ABB1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 02:04:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/6] btrfs-progs: Introduce function to find next sibling tree block
Date:   Fri, 28 Sep 2018 10:04:43 +0800
Message-Id: <20180928020446.21467-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928020446.21467-1-wqu@suse.com>
References: <20180928020446.21467-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduce a new function, btrfs_next_sibling_tree_block(), which could
find any sibling tree blocks at path->lowest_level, unlike level 0
limited btrfs_next_leaf().

Since this function is more generic than btrfs_next_leaf(), also make
btrfs_next_leaf() a wrapper of btrfs_next_sibling_tree_block(), to keep
the interface the same as kernel.

This would provide the basis for later breadth-first search print-tree.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.c | 14 +++++++++-----
 ctree.h | 15 ++++++++++++++-
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/ctree.c b/ctree.c
index 042fae19344d..43d47f19c9cd 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2875,18 +2875,22 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 }
 
 /*
- * walk up the tree as far as required to find the next leaf.
+ * walk up the tree as far as required to find the next sibling tree block.
+ * more generic version of btrfs_next_leaf(), as it could find sibling nodes
+ * if @path->lowest_level is not 0.
+ *
  * returns 0 if it found something or 1 if there are no greater leaves.
  * returns < 0 on io errors.
  */
-int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
+int btrfs_next_sibling_tree_block(struct btrfs_fs_info *fs_info,
+				  struct btrfs_path *path)
 {
 	int slot;
-	int level = 1;
+	int level = path->lowest_level + 1;
 	struct extent_buffer *c;
 	struct extent_buffer *next = NULL;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 
+	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
 	while(level < BTRFS_MAX_LEVEL) {
 		if (!path->nodes[level])
 			return 1;
@@ -2915,7 +2919,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		free_extent_buffer(c);
 		path->nodes[level] = next;
 		path->slots[level] = 0;
-		if (!level)
+		if (level == path->lowest_level)
 			break;
 		if (path->reada)
 			reada_for_search(fs_info, path, level, 0, 0);
diff --git a/ctree.h b/ctree.h
index 6df6075865c2..939c584d0301 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2633,7 +2633,20 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 	return btrfs_insert_empty_items(trans, root, path, key, &data_size, 1);
 }
 
-int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
+int btrfs_next_sibling_tree_block(struct btrfs_fs_info *fs_info,
+				  struct btrfs_path *path);
+/*
+ * walk up the tree as far as required to find the next leaf.
+ * returns 0 if it found something or 1 if there are no greater leaves.
+ * returns < 0 on io errors.
+ */
+static inline int btrfs_next_leaf(struct btrfs_root *root,
+				  struct btrfs_path *path)
+{
+	path->lowest_level = 0;
+	return btrfs_next_sibling_tree_block(root->fs_info, path);
+}
+
 static inline int btrfs_next_item(struct btrfs_root *root,
 				  struct btrfs_path *p)
 {
-- 
2.19.0

