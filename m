Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39945 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325AbaHAXMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:49 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/12] btrfs: factor btrfs_read_roots() out of open_ctree()
Date: Fri,  1 Aug 2014 18:12:45 -0500
Message-Id: <1406934766-16974-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also, remove the two local variables create_uuid_tree
and check_uuid_tree; we can use the existence of
the uuid root and/or the RESCAN_UUID_TREE flag to
determine what action to take.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |  141 ++++++++++++++++++++++++++--------------------------
 1 files changed, 71 insertions(+), 70 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0465d43..a50beca 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2381,6 +2381,70 @@ static int btrfs_alloc_workqueues(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static int btrfs_read_roots(struct btrfs_fs_info *fs_info,
+			    struct btrfs_root *tree_root)
+{
+	struct btrfs_root *extent_root;
+	struct btrfs_root *dev_root;
+	struct btrfs_root *csum_root;
+	struct btrfs_root *quota_root;
+	struct btrfs_root *uuid_root;
+	struct btrfs_key location;
+	int ret;
+
+	location.objectid = BTRFS_EXTENT_TREE_OBJECTID;
+	location.type = BTRFS_ROOT_ITEM_KEY;
+	location.offset = 0;
+
+	extent_root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(extent_root))
+		return PTR_ERR(extent_root);
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &extent_root->state);
+	fs_info->extent_root = extent_root;
+
+	location.objectid = BTRFS_DEV_TREE_OBJECTID;
+	dev_root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(dev_root))
+		return PTR_ERR(dev_root);
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &dev_root->state);
+	fs_info->dev_root = dev_root;
+	btrfs_init_devices_late(fs_info);
+
+	location.objectid = BTRFS_CSUM_TREE_OBJECTID;
+	csum_root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(csum_root))
+		return PTR_ERR(csum_root);
+	set_bit(BTRFS_ROOT_TRACK_DIRTY, &csum_root->state);
+	fs_info->csum_root = csum_root;
+
+	location.objectid = BTRFS_QUOTA_TREE_OBJECTID;
+	quota_root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(quota_root)) {
+		ret = PTR_ERR(quota_root);
+		/* It's fine to not have quotas */
+		if (ret != -ENOENT)
+			return ret;
+	} else {
+		set_bit(BTRFS_ROOT_TRACK_DIRTY, &quota_root->state);
+		fs_info->quota_enabled = 1;
+		fs_info->pending_quota_state = 1;
+		fs_info->quota_root = quota_root;
+	}
+
+	location.objectid = BTRFS_UUID_TREE_OBJECTID;
+	uuid_root = btrfs_read_tree_root(tree_root, &location);
+	if (IS_ERR(uuid_root)) {
+		ret = PTR_ERR(uuid_root);
+		if (ret != -ENOENT)
+			return ret;
+	} else {
+		set_bit(BTRFS_ROOT_TRACK_DIRTY, &uuid_root->state);
+		fs_info->uuid_root = uuid_root;
+	}
+
+	return 0;
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2396,20 +2460,13 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_super_block *disk_super;
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_root *tree_root;
-	struct btrfs_root *extent_root;
-	struct btrfs_root *csum_root;
 	struct btrfs_root *chunk_root;
-	struct btrfs_root *dev_root;
-	struct btrfs_root *quota_root;
-	struct btrfs_root *uuid_root;
 	struct btrfs_root *log_tree_root;
 	int ret;
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
 	int max_active;
-	bool create_uuid_tree;
-	bool check_uuid_tree;
 
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
@@ -2752,66 +2809,9 @@ retry_root_backup:
 	tree_root->commit_root = btrfs_root_node(tree_root);
 	btrfs_set_root_refs(&tree_root->root_item, 1);
 
-	location.objectid = BTRFS_EXTENT_TREE_OBJECTID;
-	location.type = BTRFS_ROOT_ITEM_KEY;
-	location.offset = 0;
-
-	extent_root = btrfs_read_tree_root(tree_root, &location);
-	if (IS_ERR(extent_root)) {
-		ret = PTR_ERR(extent_root);
-		goto recovery_tree_root;
-	}
-	set_bit(BTRFS_ROOT_TRACK_DIRTY, &extent_root->state);
-	fs_info->extent_root = extent_root;
-
-	location.objectid = BTRFS_DEV_TREE_OBJECTID;
-	dev_root = btrfs_read_tree_root(tree_root, &location);
-	if (IS_ERR(dev_root)) {
-		ret = PTR_ERR(dev_root);
-		goto recovery_tree_root;
-	}
-	set_bit(BTRFS_ROOT_TRACK_DIRTY, &dev_root->state);
-	fs_info->dev_root = dev_root;
-	btrfs_init_devices_late(fs_info);
-
-	location.objectid = BTRFS_CSUM_TREE_OBJECTID;
-	csum_root = btrfs_read_tree_root(tree_root, &location);
-	if (IS_ERR(csum_root)) {
-		ret = PTR_ERR(csum_root);
+	ret = btrfs_read_roots(fs_info, tree_root);
+	if (ret)
 		goto recovery_tree_root;
-	}
-	set_bit(BTRFS_ROOT_TRACK_DIRTY, &csum_root->state);
-	fs_info->csum_root = csum_root;
-
-	location.objectid = BTRFS_QUOTA_TREE_OBJECTID;
-	quota_root = btrfs_read_tree_root(tree_root, &location);
-	if (IS_ERR(quota_root)) {
-		ret = PTR_ERR(quota_root);
-		/* It's fine to not have quotas */
-		if (ret != -ENOENT)
-			goto recovery_tree_root;
-	} else {
-		set_bit(BTRFS_ROOT_TRACK_DIRTY, &quota_root->state);
-		fs_info->quota_enabled = 1;
-		fs_info->pending_quota_state = 1;
-		fs_info->quota_root = quota_root;
-	}
-
-	location.objectid = BTRFS_UUID_TREE_OBJECTID;
-	uuid_root = btrfs_read_tree_root(tree_root, &location);
-	if (IS_ERR(uuid_root)) {
-		ret = PTR_ERR(uuid_root);
-		if (ret != -ENOENT)
-			goto recovery_tree_root;
-		create_uuid_tree = true;
-		check_uuid_tree = false;
-	} else {
-		set_bit(BTRFS_ROOT_TRACK_DIRTY, &uuid_root->state);
-		fs_info->uuid_root = uuid_root;
-		create_uuid_tree = false;
-		check_uuid_tree =
-		    generation != btrfs_super_uuid_tree_generation(disk_super);
-	}
 
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
@@ -2849,7 +2849,7 @@ retry_root_backup:
 		goto fail_sysfs;
 	}
 
-	ret = btrfs_read_block_groups(extent_root);
+	ret = btrfs_read_block_groups(fs_info->extent_root);
 	if (ret) {
 		printk(KERN_ERR "BTRFS: Failed to read block groups: %d\n", ret);
 		goto fail_sysfs;
@@ -3011,7 +3011,7 @@ retry_root_backup:
 
 	btrfs_qgroup_rescan_resume(fs_info);
 
-	if (create_uuid_tree) {
+	if (!fs_info->uuid_root) {
 		pr_info("BTRFS: creating UUID tree\n");
 		ret = btrfs_create_uuid_tree(fs_info);
 		if (ret) {
@@ -3020,8 +3020,9 @@ retry_root_backup:
 			close_ctree(tree_root);
 			return ret;
 		}
-	} else if (check_uuid_tree ||
-		   btrfs_test_opt(tree_root, RESCAN_UUID_TREE)) {
+	} else if (btrfs_test_opt(tree_root, RESCAN_UUID_TREE) ||
+		   fs_info->generation !=
+				btrfs_super_uuid_tree_generation(disk_super)) {
 		pr_info("BTRFS: checking UUID tree\n");
 		ret = btrfs_check_uuid_tree(fs_info);
 		if (ret) {
-- 
1.7.1

