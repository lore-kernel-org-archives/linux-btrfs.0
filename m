Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753869AbcHWKnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B9D47AD92
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/13] btrfs-progs: mkfs: improve error handling in recow_roots
Date: Tue, 23 Aug 2016 12:25:12 +0200
Message-Id: <1471947917-5324-9-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Return and handle errors in the callchain.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 mkfs.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 94b349f157ca..3f0a3322cc76 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -190,32 +190,50 @@ static int make_root_dir(struct btrfs_trans_handle *trans, struct btrfs_root *ro
 	return ret;
 }
 
-static void __recow_root(struct btrfs_trans_handle *trans,
+static int __recow_root(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root)
 {
-	int ret;
 	struct extent_buffer *tmp;
+	int ret;
 
 	if (trans->transid != btrfs_root_generation(&root->root_item)) {
 		extent_buffer_get(root->node);
 		ret = __btrfs_cow_block(trans, root, root->node,
 					NULL, 0, &tmp, 0, 0);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		free_extent_buffer(tmp);
 	}
+
+	return 0;
 }
 
-static void recow_roots(struct btrfs_trans_handle *trans,
+static int recow_roots(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root)
 {
 	struct btrfs_fs_info *info = root->fs_info;
+	int ret;
 
-	__recow_root(trans, info->fs_root);
-	__recow_root(trans, info->tree_root);
-	__recow_root(trans, info->extent_root);
-	__recow_root(trans, info->chunk_root);
-	__recow_root(trans, info->dev_root);
-	__recow_root(trans, info->csum_root);
+	ret = __recow_root(trans, info->fs_root);
+	if (ret)
+		return ret;
+	ret = __recow_root(trans, info->tree_root);
+	if (ret)
+		return ret;
+	ret = __recow_root(trans, info->extent_root);
+	if (ret)
+		return ret;
+	ret = __recow_root(trans, info->chunk_root);
+	if (ret)
+		return ret;
+	ret = __recow_root(trans, info->dev_root);
+	if (ret)
+		return ret;
+	ret = __recow_root(trans, info->csum_root);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 static int create_one_raid_group(struct btrfs_trans_handle *trans,
@@ -291,9 +309,9 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 		if (ret)
 			return ret;
 	}
-	recow_roots(trans, root);
+	ret = recow_roots(trans, root);
 
-	return 0;
+	return ret;
 }
 
 static int create_data_reloc_tree(struct btrfs_trans_handle *trans,
-- 
2.7.1

