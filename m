Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32919 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbINGE3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 02:04:29 -0400
Received: by pacex6 with SMTP id ex6so134322084pac.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2015 23:04:28 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 4/9] Btrfs: refactor caching_thread()
Date: Sun, 13 Sep 2015 23:04:11 -0700
Message-Id: <35a1871019e42d2c753c1e3a8f7a2940023482c3.1442209006.git.osandov@osandov.com>
In-Reply-To: <cover.1442209006.git.osandov@osandov.com>
References: <cover.1442209006.git.osandov@osandov.com>
In-Reply-To: <cover.1442209006.git.osandov@osandov.com>
References: <cover.1442209006.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We're also going to load the free space tree from caching_thread(), so
we should refactor some of the common code.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ctree.h       |  3 +++
 fs/btrfs/extent-tree.c | 59 ++++++++++++++++++++++++++++----------------------
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 83d760378c3c..7ad1bdb667db 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1262,6 +1262,9 @@ struct btrfs_caching_control {
 	atomic_t count;
 };
 
+/* Once caching_thread() finds this much free space, it will wake up waiters. */
+#define CACHING_CTL_WAKE_UP (1024 * 1024 * 2)
+
 struct btrfs_io_ctl {
 	void *cur, *orig;
 	struct page *page;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 07204bf601ed..20b04edf1079 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -375,11 +375,10 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 	return total_added;
 }
 
-static noinline void caching_thread(struct btrfs_work *work)
+static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 {
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_fs_info *fs_info;
-	struct btrfs_caching_control *caching_ctl;
 	struct btrfs_root *extent_root;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -387,16 +386,15 @@ static noinline void caching_thread(struct btrfs_work *work)
 	u64 total_found = 0;
 	u64 last = 0;
 	u32 nritems;
-	int ret = -ENOMEM;
+	int ret;
 
-	caching_ctl = container_of(work, struct btrfs_caching_control, work);
 	block_group = caching_ctl->block_group;
 	fs_info = block_group->fs_info;
 	extent_root = fs_info->extent_root;
 
 	path = btrfs_alloc_path();
 	if (!path)
-		goto out;
+		return -ENOMEM;
 
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 
@@ -413,15 +411,11 @@ static noinline void caching_thread(struct btrfs_work *work)
 	key.objectid = last;
 	key.offset = 0;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
-again:
-	mutex_lock(&caching_ctl->mutex);
-	/* need to make sure the commit_root doesn't disappear */
-	down_read(&fs_info->commit_root_sem);
 
 next:
 	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
 	if (ret < 0)
-		goto err;
+		goto out;
 
 	leaf = path->nodes[0];
 	nritems = btrfs_header_nritems(leaf);
@@ -446,12 +440,14 @@ next:
 				up_read(&fs_info->commit_root_sem);
 				mutex_unlock(&caching_ctl->mutex);
 				cond_resched();
-				goto again;
+				mutex_lock(&caching_ctl->mutex);
+				down_read(&fs_info->commit_root_sem);
+				goto next;
 			}
 
 			ret = btrfs_next_leaf(extent_root, path);
 			if (ret < 0)
-				goto err;
+				goto out;
 			if (ret)
 				break;
 			leaf = path->nodes[0];
@@ -489,7 +485,7 @@ next:
 			else
 				last = key.objectid + key.offset;
 
-			if (total_found > (1024 * 1024 * 2)) {
+			if (total_found > CACHING_CTL_WAKE_UP) {
 				total_found = 0;
 				wake_up(&caching_ctl->wait);
 			}
@@ -503,25 +499,36 @@ next:
 					  block_group->key.offset);
 	caching_ctl->progress = (u64)-1;
 
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static noinline void caching_thread(struct btrfs_work *work)
+{
+	struct btrfs_block_group_cache *block_group;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_caching_control *caching_ctl;
+	int ret;
+
+	caching_ctl = container_of(work, struct btrfs_caching_control, work);
+	block_group = caching_ctl->block_group;
+	fs_info = block_group->fs_info;
+
+	mutex_lock(&caching_ctl->mutex);
+	down_read(&fs_info->commit_root_sem);
+
+	ret = load_extent_tree_free(caching_ctl);
+
 	spin_lock(&block_group->lock);
 	block_group->caching_ctl = NULL;
-	block_group->cached = BTRFS_CACHE_FINISHED;
+	block_group->cached = ret ? BTRFS_CACHE_ERROR : BTRFS_CACHE_FINISHED;
 	spin_unlock(&block_group->lock);
 
-err:
-	btrfs_free_path(path);
 	up_read(&fs_info->commit_root_sem);
-
-	free_excluded_extents(extent_root, block_group);
-
+	free_excluded_extents(fs_info->extent_root, block_group);
 	mutex_unlock(&caching_ctl->mutex);
-out:
-	if (ret) {
-		spin_lock(&block_group->lock);
-		block_group->caching_ctl = NULL;
-		block_group->cached = BTRFS_CACHE_ERROR;
-		spin_unlock(&block_group->lock);
-	}
+
 	wake_up(&caching_ctl->wait);
 
 	put_caching_control(caching_ctl);
-- 
2.5.2

