Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6E7C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F382920866
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbeL1IiT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 03:38:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:34506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726580AbeL1IiS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 03:38:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8E394ABCE
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2018 08:38:16 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs-progs: mkfs: Introduce -O bg-tree
Date:   Fri, 28 Dec 2018 16:38:04 +0800
Message-Id: <20181228083806.3204-5-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20181228083806.3204-1-wqu@suse.com>
References: <20181228083806.3204-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This allow mkfs.btrfs to create a btrfs with bg-tree feature.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fsfeatures.c  |  6 ++++++
 mkfs/common.c |  7 +++++--
 mkfs/common.h |  1 +
 mkfs/main.c   | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++
 transaction.c |  1 +
 5 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/fsfeatures.c b/fsfeatures.c
index 13ad030870cd..6458253f05ff 100644
--- a/fsfeatures.c
+++ b/fsfeatures.c
@@ -86,6 +86,12 @@ static const struct btrfs_fs_feature {
 		VERSION_TO_STRING2(4,0),
 		NULL, 0,
 		"no explicit hole extents for files" },
+	{ "bg-tree", BTRFS_FEATURE_INCOMPAT_BG_TREE,
+		"bg_tree",
+		VERSION_TO_STRING2(5, 0),
+		NULL, 0,
+		NULL, 0,
+		"store block group items in dedicated tree" },
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
diff --git a/mkfs/common.c b/mkfs/common.c
index 1f5e1d03a6e3..2916ab3035f5 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -110,6 +110,9 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 	return ret;
 }
 
+/* These features will not be set in the temporary fs */
+#define MASKED_FEATURES		(~(BTRFS_FEATURE_INCOMPAT_BG_TREE))
+
 /*
  * @fs_uuid - if NULL, generates a UUID, returns back the new filesystem UUID
  *
@@ -203,7 +206,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_super_chunk_root_generation(&super, 1);
 	btrfs_set_super_cache_generation(&super, -1);
-	btrfs_set_super_incompat_flags(&super, cfg->features);
+	btrfs_set_super_incompat_flags(&super, cfg->features & MASKED_FEATURES);
 	if (cfg->label)
 		__strncpy_null(super.label, cfg->label, BTRFS_LABEL_SIZE - 1);
 
@@ -868,7 +871,7 @@ static int __create_tree(struct btrfs_trans_handle *trans,
  *
  * Caller must ensure at the time of calling, csum tree is still empty
  */
-static int create_empty_tree(struct btrfs_trans_handle *trans, u64 objectid)
+int create_empty_tree(struct btrfs_trans_handle *trans, u64 objectid)
 {
 	struct btrfs_root *csum_root = trans->fs_info->csum_root;
 
diff --git a/mkfs/common.h b/mkfs/common.h
index adb5d561c38d..dfb82f9c84a3 100644
--- a/mkfs/common.h
+++ b/mkfs/common.h
@@ -75,6 +75,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 int test_status_for_mkfs(const char *file, bool force_overwrite);
 int test_dev_for_mkfs(const char *file, int force_overwrite);
 
+int create_empty_tree(struct btrfs_trans_handle *trans, u64 objectid);
 int create_uuid_tree(struct btrfs_trans_handle *trans);
 int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid);
 
diff --git a/mkfs/main.c b/mkfs/main.c
index ea3d1ae80e5e..62f6a0115f91 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -677,6 +677,54 @@ static void update_chunk_allocation(struct btrfs_fs_info *fs_info,
 	}
 }
 
+/* Helper to convert to bg_tree feature */
+static int convert_to_bg_tree(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_block_group_cache *bg;
+	struct btrfs_root *bg_root;
+	struct btrfs_key key;
+	u64 features = btrfs_super_incompat_flags(fs_info->super_copy);
+	int ret;
+
+	/* create bg tree first */
+	ret = create_empty_tree(trans, BTRFS_BLOCK_GROUP_TREE_OBJECTID);
+	if (ret < 0) {
+		errno = -ret;
+		error("failed to create bg tree: %m");
+		return ret;
+	}
+	key.objectid = BTRFS_BLOCK_GROUP_TREE_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+	bg_root = btrfs_read_fs_root_no_cache(fs_info, &key);
+	if (IS_ERR(bg_root)) {
+		errno = -PTR_ERR(bg_root);
+		error("failed to read bg root: %m");
+		return PTR_ERR(bg_root);
+	}
+	fs_info->bg_root = bg_root;
+	fs_info->bg_root->track_dirty = 1;
+	fs_info->bg_root->ref_cows = 0;
+
+	/* set BG_TREE feature and mark the fs into bg_tree convert status */
+	btrfs_set_super_incompat_flags(fs_info->super_copy,
+			features | BTRFS_FEATURE_INCOMPAT_BG_TREE);
+	fs_info->convert_to_bg_tree = 1;
+
+	/*
+	 * Mark all block groups dirty so they will get converted to bg tree at
+	 * commit transaction time
+	 */
+	for (bg = btrfs_lookup_first_block_group(fs_info, 0); bg;
+	     bg = btrfs_lookup_first_block_group(fs_info,
+				bg->key.objectid + bg->key.offset))
+		set_extent_bits(&fs_info->block_group_cache, bg->key.objectid,
+				bg->key.objectid + bg->key.offset - 1,
+				BLOCK_GROUP_DIRTY);
+	return 0;
+}
+
 int main(int argc, char **argv)
 {
 	char *file;
@@ -1182,6 +1230,15 @@ raid_groups:
 		warning(
 	"unable to create uuid tree, will be created after mount: %d", ret);
 
+	/* Bg tree are converted after the fs is created */
+	if (mkfs_cfg.features & BTRFS_FEATURE_INCOMPAT_BG_TREE) {
+		ret = convert_to_bg_tree(trans);
+		if (ret < 0) {
+			errno = -ret;
+			error(
+		"bg-tree feature will not be enabled, due to error: %m");
+		}
+	}
 	ret = btrfs_commit_transaction(trans, root);
 	if (ret) {
 		error("unable to commit transaction: %d", ret);
diff --git a/transaction.c b/transaction.c
index e756db332fec..3c07f589d670 100644
--- a/transaction.c
+++ b/transaction.c
@@ -205,6 +205,7 @@ commit_tree:
 	root->commit_root = NULL;
 	fs_info->running_transaction = NULL;
 	fs_info->last_trans_committed = transid;
+	fs_info->convert_to_bg_tree = 0;
 out:
 	return ret;
 }
-- 
2.20.1

