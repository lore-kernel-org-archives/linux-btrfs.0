Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E15FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 04:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FDEE20842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 04:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfBYEiI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 Feb 2019 23:38:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:43358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726755AbfBYEiH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Feb 2019 23:38:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DF67BACD8;
        Mon, 25 Feb 2019 04:38:05 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2] btrfs: extent_io: Always return error pointer for extent buffer allocation failure
Date:   Mon, 25 Feb 2019 12:38:01 +0800
Message-Id: <20190225043801.17321-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are 5 extent buffer allocation functions in btrfs:
__alloc_extent_buffer();
alloc_extent_buffer();
__alloc_dummy_extent_buffer();
alloc_dummy_extent_buffer();
alloc_test_extent_buffer();

However they return different value for error:
__alloc_extent_buffer()		Never fail
alloc_extent_buffer()		ERR_PTR()
__alloc_dummy_extent_buffer()	NULL
alloc_dummy_extent_buffer()	NULL
alloc_test_extent_buffer()	NULL

This makes certain wrapper function to have 2 different failure modes,
e.g. btrfs_find_create_tree_block() can return NULL or PTR_ERR(-ENOMEM).

Under most case, the NULL return value is only possible for selftest and
super rare to hit, but this inconsistent behavior still makes static
checker and reader crazy.

This patch will make all the following functions to return error pointer
for error:
__alloc_extent_buffer()
alloc_extent_buffer()
__alloc_dummy_extent_buffer()
alloc_dummy_extent_buffer()
alloc_test_extent_buffer()
btrfs_clone_extent_buffer()
btrfs_find_create_tree_block()

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
- Merge all previous 5 patches into one
  Split patches doesn't make much sense for such small cleanup, and has
  already confused reviewers.
- Fix a missing IS_ERR() check in btrfs_compare_trees()
---
 fs/btrfs/backref.c                     |  8 ++--
 fs/btrfs/ctree.c                       | 18 ++++----
 fs/btrfs/extent_io.c                   | 58 ++++++++++++++++++--------
 fs/btrfs/qgroup.c                      |  5 ++-
 fs/btrfs/tests/extent-buffer-tests.c   |  6 ++-
 fs/btrfs/tests/extent-io-tests.c       |  4 +-
 fs/btrfs/tests/free-space-tree-tests.c |  3 +-
 fs/btrfs/tests/inode-tests.c           |  6 ++-
 fs/btrfs/tests/qgroup-tests.c          |  3 +-
 9 files changed, 71 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 78556447e1d5..b6e469a12011 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2016,8 +2016,8 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 		parent = found_key.offset;
 		slot = path->slots[0];
 		eb = btrfs_clone_extent_buffer(path->nodes[0]);
-		if (!eb) {
-			ret = -ENOMEM;
+		if (IS_ERR(eb)) {
+			ret = PTR_ERR(eb);
 			break;
 		}
 		btrfs_release_path(path);
@@ -2075,8 +2075,8 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
 
 		slot = path->slots[0];
 		eb = btrfs_clone_extent_buffer(path->nodes[0]);
-		if (!eb) {
-			ret = -ENOMEM;
+		if (IS_ERR(eb)) {
+			ret = PTR_ERR(eb);
 			break;
 		}
 		btrfs_release_path(path);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5a6c39b44c84..ebd640f2ad86 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1293,7 +1293,7 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
 		BUG_ON(tm->slot != 0);
 		eb_rewin = alloc_dummy_extent_buffer(fs_info, eb->start);
-		if (!eb_rewin) {
+		if (IS_ERR(eb_rewin)) {
 			btrfs_tree_read_unlock_blocking(eb);
 			free_extent_buffer(eb);
 			return NULL;
@@ -1384,7 +1384,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		free_extent_buffer(eb_root);
 	}
 
-	if (!eb)
+	if (IS_ERR(eb))
 		return NULL;
 	btrfs_tree_read_lock(eb);
 	if (old_root) {
@@ -2624,8 +2624,8 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 			down_read(&fs_info->commit_root_sem);
 			b = btrfs_clone_extent_buffer(root->commit_root);
 			up_read(&fs_info->commit_root_sem);
-			if (!b)
-				return ERR_PTR(-ENOMEM);
+			if (IS_ERR(b))
+				return b;
 
 		} else {
 			b = root->commit_root;
@@ -5429,9 +5429,10 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	left_root_level = left_level;
 	left_path->nodes[left_level] =
 			btrfs_clone_extent_buffer(left_root->commit_root);
-	if (!left_path->nodes[left_level]) {
+	if (IS_ERR(left_path->nodes[left_level])) {
 		up_read(&fs_info->commit_root_sem);
-		ret = -ENOMEM;
+		ret = PTR_ERR(left_path->nodes[left_level]);
+		left_path->nodes[left_level] = NULL;
 		goto out;
 	}
 
@@ -5439,9 +5440,10 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	right_root_level = right_level;
 	right_path->nodes[right_level] =
 			btrfs_clone_extent_buffer(right_root->commit_root);
-	if (!right_path->nodes[right_level]) {
+	if (IS_ERR(right_path->nodes[right_level])) {
 		up_read(&fs_info->commit_root_sem);
-		ret = -ENOMEM;
+		ret = PTR_ERR(right_path->nodes[right_level]);
+		right_path->nodes[right_level] = NULL;
 		goto out;
 	}
 	up_read(&fs_info->commit_root_sem);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 52abe4082680..e0a96f74e81e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4661,6 +4661,11 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 	__free_extent_buffer(eb);
 }
 
+/*
+ * This function should not fail due to its __GFP_NOFAIL flag.
+ *
+ * But caller should check IS_ERR() to be future-proof.
+ */
 static struct extent_buffer *
 __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 		      unsigned long len)
@@ -4668,6 +4673,8 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	struct extent_buffer *eb = NULL;
 
 	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
+	if (!eb)
+		return ERR_PTR(-ENOMEM);
 	eb->start = start;
 	eb->len = len;
 	eb->fs_info = fs_info;
@@ -4707,14 +4714,14 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	int num_pages = num_extent_pages(src);
 
 	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
-	if (new == NULL)
-		return NULL;
+	if (IS_ERR(new))
+		return new;
 
 	for (i = 0; i < num_pages; i++) {
 		p = alloc_page(GFP_NOFS);
 		if (!p) {
 			btrfs_release_extent_buffer(new);
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 		}
 		attach_extent_buffer_page(new, p);
 		WARN_ON(PageDirty(p));
@@ -4729,6 +4736,13 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	return new;
 }
 
+/*
+ * Allocate an extent buffer for selftest.
+ *
+ * Return valid pointer if everything goes well.
+ * Return PTR_ERR() for error.
+ * Will NEVER return NULL.
+ */
 struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						  u64 start, unsigned long len)
 {
@@ -4737,8 +4751,8 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 	int i;
 
 	eb = __alloc_extent_buffer(fs_info, start, len);
-	if (!eb)
-		return NULL;
+	if (IS_ERR(eb))
+		return eb;
 
 	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
@@ -4755,7 +4769,7 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 	for (; i > 0; i--)
 		__free_page(eb->pages[i - 1]);
 	__free_extent_buffer(eb);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
@@ -4851,6 +4865,7 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 }
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+/* Will either return valid pointer or PTR_ERR(), NEVER NULL pointer. */
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 					u64 start)
 {
@@ -4861,13 +4876,15 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (eb)
 		return eb;
 	eb = alloc_dummy_extent_buffer(fs_info, start);
-	if (!eb)
-		return NULL;
+	if (IS_ERR(eb))
+		return eb;
 	eb->fs_info = fs_info;
 again:
 	ret = radix_tree_preload(GFP_NOFS);
-	if (ret)
-		goto free_eb;
+	if (ret) {
+		btrfs_release_extent_buffer(eb);
+		return ERR_PTR(ret);
+	}
 	spin_lock(&fs_info->buffer_lock);
 	ret = radix_tree_insert(&fs_info->buffer_radix,
 				start >> PAGE_SHIFT, eb);
@@ -4875,21 +4892,26 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
 		exists = find_extent_buffer(fs_info, start);
-		if (exists)
-			goto free_eb;
-		else
-			goto again;
+		if (exists) {
+			btrfs_release_extent_buffer(eb);
+			return exists;
+		}
+		goto again;
 	}
 	check_buffer_tree_ref(eb);
 	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
 
 	return eb;
-free_eb:
-	btrfs_release_extent_buffer(eb);
-	return exists;
 }
 #endif
 
+/*
+ * Allocate an extent buffer structure, with all its pages attached and locked.
+ *
+ * Return valid pointer if nothing goes wrong.
+ * Return PTR_ERR() if failed.
+ * Will never return NULL.
+ */
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 start)
 {
@@ -4914,7 +4936,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 		return eb;
 
 	eb = __alloc_extent_buffer(fs_info, start, len);
-	if (!eb)
+	if (IS_ERR(eb))
 		return ERR_PTR(-ENOMEM);
 
 	num_pages = num_extent_pages(eb);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e473a998219..ccfa992a10bf 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3105,8 +3105,9 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
 	fs_info->qgroup_rescan_progress.objectid = found.objectid + 1;
 
 	scratch_leaf = btrfs_clone_extent_buffer(path->nodes[0]);
-	if (!scratch_leaf) {
-		ret = -ENOMEM;
+	if (IS_ERR(scratch_leaf)) {
+		ret = PTR_ERR(scratch_leaf);
+		scratch_leaf = NULL;
 		mutex_unlock(&fs_info->qgroup_rescan_lock);
 		goto out;
 	}
diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index 7d72eab6d32c..edf2ab6a7d74 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -48,12 +48,14 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 		goto out;
 	}
 
-	path->nodes[0] = eb = alloc_dummy_extent_buffer(fs_info, nodesize);
-	if (!eb) {
+	eb = alloc_dummy_extent_buffer(fs_info, nodesize);
+	if (IS_ERR(eb)) {
+		eb = NULL;
 		test_err("could not allocate dummy buffer");
 		ret = -ENOMEM;
 		goto out;
 	}
+	path->nodes[0] = eb;
 	path->slots[0] = 0;
 
 	key.objectid = 0;
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 3c46d7f23456..d1f3b727fbf2 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -396,7 +396,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	}
 
 	eb = __alloc_dummy_extent_buffer(fs_info, 0, len);
-	if (!eb) {
+	if (IS_ERR(eb)) {
 		test_err("couldn't allocate test extent buffer");
 		kfree(bitmap);
 		return -ENOMEM;
@@ -409,7 +409,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	/* Do it over again with an extent buffer which isn't page-aligned. */
 	free_extent_buffer(eb);
 	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
-	if (!eb) {
+	if (IS_ERR(eb)) {
 		test_err("couldn't allocate test extent buffer");
 		kfree(bitmap);
 		return -ENOMEM;
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 89346da890cf..025fce63959a 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -462,7 +462,8 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 	root->fs_info->tree_root = root;
 
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
+		root->node = NULL;
 		test_err("couldn't allocate dummy buffer");
 		ret = -ENOMEM;
 		goto out;
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index af0c8e30d9e2..56a112a39211 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -249,7 +249,8 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	}
 
 	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
+		root->node = NULL;
 		test_err("couldn't allocate dummy buffer");
 		goto out;
 	}
@@ -850,7 +851,8 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 	}
 
 	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
+		root->node = NULL;
 		test_err("couldn't allocate dummy buffer");
 		goto out;
 	}
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 412b910b04cc..536600eb4d9d 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -484,7 +484,8 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 	 * *cough*backref walking code*cough*
 	 */
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
-	if (!root->node) {
+	if (IS_ERR(root->node)) {
+		root->node = NULL;
 		test_err("couldn't allocate dummy buffer");
 		ret = -ENOMEM;
 		goto out;
-- 
2.20.1

