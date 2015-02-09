Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17775 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760902AbbBIUDy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:54 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 03/16] Btrfs-progs: handle -eagain properly
Date: Mon, 9 Feb 2015 15:03:06 -0500
Message-ID: <1423512199-16552-4-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we fix bad blocks during run_next_block we will return -EAGAIN to loop around
and start again.  The deal_with_roots work messed up this handling, this patch
fixes it.  With this patch we can properly deal with broken tree blocks.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 93 +++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 64 insertions(+), 29 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ca40e35..e74fa0f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7649,6 +7649,18 @@ static int add_root_item_to_list(struct list_head *head,
 	return 0;
 }
 
+static void free_root_item_list(struct list_head *list)
+{
+	struct root_item_record *ri_rec;
+
+	while (!list_empty(list)) {
+		ri_rec = list_first_entry(list, struct root_item_record,
+					  list);
+		list_del_init(&ri_rec->list);
+		free(ri_rec);
+	}
+}
+
 static int deal_root_from_list(struct list_head *list,
 			       struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
@@ -7846,50 +7858,49 @@ again:
 		path.slots[0]++;
 	}
 	btrfs_release_path(&path);
+
+	/*
+	 * check_block can return -EAGAIN if it fixes something, please keep
+	 * this in mind when dealing with return values from these functions, if
+	 * we get -EAGAIN we want to fall through and restart the loop.
+	 */
 	ret = deal_root_from_list(&normal_trees, trans, root,
 				  bits, bits_nr, &pending, &seen,
 				  &reada, &nodes, &extent_cache,
 				  &chunk_cache, &dev_cache, &block_group_cache,
 				  &dev_extent_cache);
-	if (ret < 0)
+	if (ret < 0) {
+		if (ret == -EAGAIN)
+			goto loop;
 		goto out;
+	}
 	ret = deal_root_from_list(&dropping_trees, trans, root,
 				  bits, bits_nr, &pending, &seen,
 				  &reada, &nodes, &extent_cache,
-				  &chunk_cache, &dev_cache, &block_group_cache,
+				  &chunk_cache, &dev_cache,
+				  &block_group_cache,
 				  &dev_extent_cache);
-	if (ret < 0)
+	if (ret < 0) {
+		if (ret == -EAGAIN)
+			goto loop;
 		goto out;
-	if (ret >= 0)
-		ret = check_extent_refs(trans, root, &extent_cache);
-	if (ret == -EAGAIN) {
-		ret = btrfs_commit_transaction(trans, root);
-		if (ret)
-			goto out;
-
-		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans)) {
-			ret = PTR_ERR(trans);
-			goto out;
-		}
-
-		free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
-		free_extent_cache_tree(&seen);
-		free_extent_cache_tree(&pending);
-		free_extent_cache_tree(&reada);
-		free_extent_cache_tree(&nodes);
-		free_chunk_cache_tree(&chunk_cache);
-		free_block_group_tree(&block_group_cache);
-		free_device_cache_tree(&dev_cache);
-		free_device_extent_tree(&dev_extent_cache);
-		free_extent_record_cache(root->fs_info, &extent_cache);
-		goto again;
 	}
 
 	err = check_chunks(&chunk_cache, &block_group_cache,
 			   &dev_extent_cache, NULL, NULL, NULL, 0);
-	if (err && !ret)
-		ret = err;
+	if (err) {
+		if (err == -EAGAIN)
+			goto loop;
+		if (!ret)
+			ret = err;
+	}
+
+	ret = check_extent_refs(trans, root, &extent_cache);
+	if (ret < 0) {
+		if (ret == -EAGAIN)
+			goto loop;
+		goto out;
+	}
 
 	err = check_devices(&dev_cache, &dev_extent_cache);
 	if (err && !ret)
@@ -7917,6 +7928,30 @@ out:
 	free_extent_cache_tree(&reada);
 	free_extent_cache_tree(&nodes);
 	return ret;
+loop:
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret)
+		goto out;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
+	free_extent_cache_tree(&seen);
+	free_extent_cache_tree(&pending);
+	free_extent_cache_tree(&reada);
+	free_extent_cache_tree(&nodes);
+	free_chunk_cache_tree(&chunk_cache);
+	free_block_group_tree(&block_group_cache);
+	free_device_cache_tree(&dev_cache);
+	free_device_extent_tree(&dev_extent_cache);
+	free_extent_record_cache(root->fs_info, &extent_cache);
+	free_root_item_list(&normal_trees);
+	free_root_item_list(&dropping_trees);
+	goto again;
 }
 
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
-- 
1.8.3.1

