From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: setup free ino caching in a more asynchronous way
Date: Thu, 26 May 2011 11:38:39 +0800
Message-ID: <4DDDCB3F.8040305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

For a filesystem that has lots of files in it, the first time we mount
it with free ino caching support, it can take quite a long time to
setup the caching before we can create new files.

Here we fill the cache with [highest_ino, BTRFS_LAST_FREE_OBJECTID]
before we start the caching thread to search through the extent tree.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

based on the integration-test branch

---
 fs/btrfs/inode-map.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 0009705..d2561ae 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -60,12 +60,12 @@ again:
 
 	while (1) {
 		smp_mb();
-		if (fs_info->closing > 1)
+		if (fs_info->closing)
 			goto out;
 
 		leaf = path->nodes[0];
 		slot = path->slots[0];
-		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0)
 				goto out;
@@ -100,7 +100,7 @@ again:
 		if (key.type != BTRFS_INODE_ITEM_KEY)
 			goto next;
 
-		if (key.objectid >= BTRFS_LAST_FREE_OBJECTID)
+		if (key.objectid >= root->highest_objectid)
 			break;
 
 		if (last != (u64)-1 && last + 1 != key.objectid) {
@@ -114,9 +114,9 @@ next:
 		path->slots[0]++;
 	}
 
-	if (last < BTRFS_LAST_FREE_OBJECTID - 1) {
+	if (last < root->highest_objectid - 1) {
 		__btrfs_add_free_space(ctl, last + 1,
-				       BTRFS_LAST_FREE_OBJECTID - last - 1);
+				       root->highest_objectid - last - 1);
 	}
 
 	spin_lock(&root->cache_lock);
@@ -136,8 +136,10 @@ out:
 
 static void start_caching(struct btrfs_root *root)
 {
+	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
 	struct task_struct *tsk;
 	int ret;
+	u64 objectid;
 
 	spin_lock(&root->cache_lock);
 	if (root->cached != BTRFS_CACHE_NO) {
@@ -156,6 +158,19 @@ static void start_caching(struct btrfs_root *root)
 		return;
 	}
 
+	/*
+	 * It can be quite time-consuming to fill the cache by searching
+	 * through the extent tree, and this can keep ino allocation path
+	 * waiting. Therefore at start we quickly find out the highest
+	 * inode number and we know we can use inode numbers which fall in
+	 * [highest_ino + 1, BTRFS_LAST_FREE_OBJECTID].
+	 */
+	ret = btrfs_find_free_objectid(root, &objectid);
+	if (!ret && objectid <= BTRFS_LAST_FREE_OBJECTID) {
+		__btrfs_add_free_space(ctl, objectid,
+				       BTRFS_LAST_FREE_OBJECTID - objectid + 1);
+	}
+
 	tsk = kthread_run(caching_kthread, root, "btrfs-ino-cache-%llu\n",
 			  root->root_key.objectid);
 	BUG_ON(IS_ERR(tsk));
@@ -209,7 +224,8 @@ again:
 
 		start_caching(root);
 
-		if (objectid <= root->cache_progress)
+		if (objectid <= root->cache_progress ||
+		    objectid >= root->highest_objectid)
 			__btrfs_add_free_space(ctl, objectid, 1);
 		else
 			__btrfs_add_free_space(pinned, objectid, 1);
-- 
1.7.3.1

