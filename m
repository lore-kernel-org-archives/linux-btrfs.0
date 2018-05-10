Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41475 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934935AbeEJMpB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:01 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 06D4CACC2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:00 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 01/17] btrfs: Make btrfs_init_dummy_trans initialize trans' fs_info field
Date: Thu, 10 May 2018 15:44:40 +0300
Message-Id: <1525956296-32118-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This will be necessary for future cleanups which remove the fs_info
argument from some freespace tree functions.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/tests/btrfs-tests.c           |  4 +++-
 fs/btrfs/tests/btrfs-tests.h           |  3 ++-
 fs/btrfs/tests/free-space-tree-tests.c |  2 +-
 fs/btrfs/tests/qgroup-tests.c          | 12 ++++++------
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 30ed438da2a9..db72b3b6209e 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -219,11 +219,13 @@ void btrfs_free_dummy_block_group(struct btrfs_block_group_cache *cache)
 	kfree(cache);
 }
 
-void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans)
+void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info)
 {
 	memset(trans, 0, sizeof(*trans));
 	trans->transid = 1;
 	trans->type = __TRANS_DUMMY;
+	trans->fs_info = fs_info;
 }
 
 int btrfs_run_sanity_tests(void)
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index a5a0b9500d3e..4c11cffb377c 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -28,7 +28,8 @@ void btrfs_free_dummy_root(struct btrfs_root *root);
 struct btrfs_block_group_cache *
 btrfs_alloc_dummy_block_group(struct btrfs_fs_info *fs_info, unsigned long length);
 void btrfs_free_dummy_block_group(struct btrfs_block_group_cache *cache);
-void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans);
+void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info);
 #else
 static inline int btrfs_run_sanity_tests(void)
 {
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index e1f9666c4974..a24ead6ceb2b 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -482,7 +482,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 	cache->needs_free_space = 1;
 	cache->fs_info = root->fs_info;
 
-	btrfs_init_dummy_trans(&trans);
+	btrfs_init_dummy_trans(&trans, root->fs_info);
 
 	path = btrfs_alloc_path();
 	if (!path) {
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 39b95783f736..df4bcce20ba5 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -24,7 +24,7 @@ static int insert_normal_tree_ref(struct btrfs_root *root, u64 bytenr,
 	u32 size = sizeof(*item) + sizeof(*iref) + sizeof(*block_info);
 	int ret;
 
-	btrfs_init_dummy_trans(&trans);
+	btrfs_init_dummy_trans(&trans, NULL);
 
 	ins.objectid = bytenr;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
@@ -74,7 +74,7 @@ static int add_tree_ref(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 	u64 refs;
 	int ret;
 
-	btrfs_init_dummy_trans(&trans);
+	btrfs_init_dummy_trans(&trans, NULL);
 
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -124,7 +124,7 @@ static int remove_extent_item(struct btrfs_root *root, u64 bytenr,
 	struct btrfs_path *path;
 	int ret;
 
-	btrfs_init_dummy_trans(&trans);
+	btrfs_init_dummy_trans(&trans, NULL);
 
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -158,7 +158,7 @@ static int remove_extent_ref(struct btrfs_root *root, u64 bytenr,
 	u64 refs;
 	int ret;
 
-	btrfs_init_dummy_trans(&trans);
+	btrfs_init_dummy_trans(&trans, NULL);
 
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -213,7 +213,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	struct ulist *new_roots = NULL;
 	int ret;
 
-	btrfs_init_dummy_trans(&trans);
+	btrfs_init_dummy_trans(&trans, fs_info);
 
 	test_msg("Qgroup basic add\n");
 	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FS_TREE_OBJECTID);
@@ -314,7 +314,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 	struct ulist *new_roots = NULL;
 	int ret;
 
-	btrfs_init_dummy_trans(&trans);
+	btrfs_init_dummy_trans(&trans, fs_info);
 
 	test_msg("Qgroup multiple refs test\n");
 
-- 
2.7.4

