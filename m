Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17DEC43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 11:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7143120851
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 11:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbfCGLbm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 06:31:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:50486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbfCGLbm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 06:31:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 969416A072
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2019 11:31:39 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs-progs: Use @fs_info to replace @root for btrfs_check_leaf/node()
Date:   Thu,  7 Mar 2019 19:31:30 +0800
Message-Id: <20190307113133.27003-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c        | 12 ++++++------
 check/mode-lowmem.c |  8 ++++----
 ctree.c             | 32 ++++++++++++++++----------------
 ctree.h             |  8 ++++----
 4 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/check/main.c b/check/main.c
index 7547209c5604..51724a92af5f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1808,9 +1808,9 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 		}
 
 		if (btrfs_is_leaf(next))
-			status = btrfs_check_leaf(root, NULL, next);
+			status = btrfs_check_leaf(fs_info, NULL, next);
 		else
-			status = btrfs_check_node(root, NULL, next);
+			status = btrfs_check_node(fs_info, NULL, next);
 		if (status != BTRFS_TREE_BLOCK_CLEAN) {
 			free_extent_buffer(next);
 			err = -EIO;
@@ -3403,9 +3403,9 @@ static int check_fs_root(struct btrfs_root *root,
 
 	/* We may not have checked the root block, lets do that now */
 	if (btrfs_is_leaf(root->node))
-		status = btrfs_check_leaf(root, NULL, root->node);
+		status = btrfs_check_leaf(root->fs_info, NULL, root->node);
 	else
-		status = btrfs_check_node(root, NULL, root->node);
+		status = btrfs_check_node(root->fs_info, NULL, root->node);
 	if (status != BTRFS_TREE_BLOCK_CLEAN)
 		return -EIO;
 
@@ -4244,9 +4244,9 @@ static int check_block(struct btrfs_root *root,
 	rec->info_level = level;
 
 	if (btrfs_is_leaf(buf))
-		status = btrfs_check_leaf(root, &rec->parent_key, buf);
+		status = btrfs_check_leaf(root->fs_info, &rec->parent_key, buf);
 	else
-		status = btrfs_check_node(root, &rec->parent_key, buf);
+		status = btrfs_check_node(root->fs_info, &rec->parent_key, buf);
 
 	if (status != BTRFS_TREE_BLOCK_CLEAN) {
 		if (repair)
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index fc6228a05a1b..c32cbe028ec6 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4617,7 +4617,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 		if (*level == 0) {
 			/* skip duplicate check */
 			if (check || !check_all) {
-				ret = btrfs_check_leaf(root, NULL, cur);
+				ret = btrfs_check_leaf(fs_info, NULL, cur);
 				if (ret != BTRFS_TREE_BLOCK_CLEAN) {
 					err |= -EIO;
 					break;
@@ -4634,7 +4634,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			break;
 		}
 		if (check || !check_all) {
-			ret = btrfs_check_node(root, NULL, cur);
+			ret = btrfs_check_node(fs_info, NULL, cur);
 			if (ret != BTRFS_TREE_BLOCK_CLEAN) {
 				err |= -EIO;
 				break;
@@ -4682,9 +4682,9 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			break;
 
 		if (btrfs_is_leaf(next))
-			status = btrfs_check_leaf(root, NULL, next);
+			status = btrfs_check_leaf(fs_info, NULL, next);
 		else
-			status = btrfs_check_node(root, NULL, next);
+			status = btrfs_check_node(fs_info, NULL, next);
 		if (status != BTRFS_TREE_BLOCK_CLEAN) {
 			free_extent_buffer(next);
 			err |= -EIO;
diff --git a/ctree.c b/ctree.c
index 7cb3f8451542..f93a60e42b65 100644
--- a/ctree.c
+++ b/ctree.c
@@ -434,8 +434,8 @@ static inline unsigned int leaf_data_end(const struct btrfs_fs_info *fs_info,
 }
 
 enum btrfs_tree_block_status
-btrfs_check_node(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
-		 struct extent_buffer *buf)
+btrfs_check_node(struct btrfs_fs_info *fs_info,
+		 struct btrfs_disk_key *parent_key, struct extent_buffer *buf)
 {
 	int i;
 	struct btrfs_key cpukey;
@@ -443,7 +443,7 @@ btrfs_check_node(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 	u32 nritems = btrfs_header_nritems(buf);
 	enum btrfs_tree_block_status ret = BTRFS_TREE_BLOCK_INVALID_NRITEMS;
 
-	if (nritems == 0 || nritems > BTRFS_NODEPTRS_PER_BLOCK(root->fs_info))
+	if (nritems == 0 || nritems > BTRFS_NODEPTRS_PER_BLOCK(fs_info))
 		goto fail;
 
 	ret = BTRFS_TREE_BLOCK_INVALID_PARENT_KEY;
@@ -466,7 +466,7 @@ fail:
 			btrfs_disk_key_to_cpu(&cpukey, parent_key);
 		else
 			btrfs_node_key_to_cpu(buf, &cpukey, 0);
-		btrfs_add_corrupt_extent_record(root->fs_info, &cpukey,
+		btrfs_add_corrupt_extent_record(fs_info, &cpukey,
 						buf->start, buf->len,
 						btrfs_header_level(buf));
 	}
@@ -474,8 +474,8 @@ fail:
 }
 
 enum btrfs_tree_block_status
-btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
-		 struct extent_buffer *buf)
+btrfs_check_leaf(struct btrfs_fs_info *fs_info,
+		 struct btrfs_disk_key *parent_key, struct extent_buffer *buf)
 {
 	int i;
 	struct btrfs_key cpukey;
@@ -531,18 +531,18 @@ btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 			goto fail;
 		}
 		if (i == 0 && btrfs_item_end_nr(buf, i) !=
-		    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
+		    BTRFS_LEAF_DATA_SIZE(fs_info)) {
 			ret = BTRFS_TREE_BLOCK_INVALID_OFFSETS;
 			fprintf(stderr, "bad item end %u wanted %u\n",
 				btrfs_item_end_nr(buf, i),
-				(unsigned)BTRFS_LEAF_DATA_SIZE(root->fs_info));
+				(unsigned)BTRFS_LEAF_DATA_SIZE(fs_info));
 			goto fail;
 		}
 	}
 
 	for (i = 0; i < nritems; i++) {
 		if (btrfs_item_end_nr(buf, i) >
-				BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
+				BTRFS_LEAF_DATA_SIZE(fs_info)) {
 			btrfs_item_key(buf, &key, 0);
 			btrfs_print_key(&key);
 			fflush(stdout);
@@ -550,7 +550,7 @@ btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 			fprintf(stderr, "slot end outside of leaf %llu > %llu\n",
 				(unsigned long long)btrfs_item_end_nr(buf, i),
 				(unsigned long long)BTRFS_LEAF_DATA_SIZE(
-					root->fs_info));
+					fs_info));
 			goto fail;
 		}
 	}
@@ -563,13 +563,13 @@ fail:
 		else
 			btrfs_item_key_to_cpu(buf, &cpukey, 0);
 
-		btrfs_add_corrupt_extent_record(root->fs_info, &cpukey,
+		btrfs_add_corrupt_extent_record(fs_info, &cpukey,
 						buf->start, buf->len, 0);
 	}
 	return ret;
 }
 
-static int noinline check_block(struct btrfs_root *root,
+static int noinline check_block(struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path, int level)
 {
 	struct btrfs_disk_key key;
@@ -585,9 +585,9 @@ static int noinline check_block(struct btrfs_root *root,
 		key_ptr = &key;
 	}
 	if (level == 0)
-		ret =  btrfs_check_leaf(root, key_ptr, path->nodes[0]);
+		ret = btrfs_check_leaf(fs_info, key_ptr, path->nodes[0]);
 	else
-		ret = btrfs_check_node(root, key_ptr, path->nodes[level]);
+		ret = btrfs_check_node(fs_info, key_ptr, path->nodes[level]);
 	if (ret == BTRFS_TREE_BLOCK_CLEAN)
 		return 0;
 	return -EIO;
@@ -871,7 +871,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		}
 	}
 	/* double check we haven't messed things up */
-	check_block(root, path, level);
+	check_block(root->fs_info, path, level);
 	if (orig_ptr !=
 	    btrfs_node_blockptr(path->nodes[level], path->slots[level]))
 		BUG();
@@ -1169,7 +1169,7 @@ again:
 			WARN_ON(1);
 		level = btrfs_header_level(b);
 		p->nodes[level] = b;
-		ret = check_block(root, p, level);
+		ret = check_block(fs_info, p, level);
 		if (ret)
 			return -1;
 		ret = bin_search(b, key, level, &slot);
diff --git a/ctree.h b/ctree.h
index abc20e283fdc..6f2bb5fc2cda 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2570,11 +2570,11 @@ int btrfs_comp_cpu_keys(const struct btrfs_key *k1, const struct btrfs_key *k2);
 int btrfs_del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 		int level, int slot);
 enum btrfs_tree_block_status
-btrfs_check_node(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
-		 struct extent_buffer *buf);
+btrfs_check_node(struct btrfs_fs_info *fs_info,
+		 struct btrfs_disk_key *parent_key, struct extent_buffer *buf);
 enum btrfs_tree_block_status
-btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
-		 struct extent_buffer *buf);
+btrfs_check_leaf(struct btrfs_fs_info *fs_info,
+		 struct btrfs_disk_key *parent_key, struct extent_buffer *buf);
 void reada_for_search(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		      int level, int slot, u64 objectid);
 struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
-- 
2.21.0

