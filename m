Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46414 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab3FTRif (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 13:38:35 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8103E9A0370
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 11:38:34 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id 5zyULOMmsQyjQnqS (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 11:38:33 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use a percpu to keep track of possibly pinned bytes V2
Date: Thu, 20 Jun 2013 13:38:31 -0400
Message-ID: <1371749911-15538-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are all of these checks in the ENOSPC code to see if committing the
transaction would free up enough space to make the allocation.  This is because
early on we just committed the transaction and hoped and prayed, which resulted
in cases where it took _forever_ to get an ENOSPC when we really were out of
space.  So we check space_info->bytes_pinned, except this isn't completely true
because it doesn't account for space we may free but are stuck in delayed refs.
So tests like xfstests 226 would fail because we wouldn't commit the transaction
to free up the data space.  So instead add a percpu counter that will be a
little fuzzier, it will add bytes as soon as we try to free up the space, and
remove any space it doesn't actually free up when we get around to doing the
actual free.  We then 0 out this counter every transaction period so we have a
better idea of how much space we will actually free up by committing this
transaction.  With this patch we now pass xfstests 226.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2:
-fix space_info leak on init failure
-use percpu_counter_compare() everywhere for consistency

 fs/btrfs/ctree.h       |   12 +++++++++
 fs/btrfs/extent-tree.c |   59 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 76e4983..b528a55 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1102,6 +1102,18 @@ struct btrfs_space_info {
 				   account */
 
 	/*
+	 * bytes_pinned is kept in line with what is actually pinned, as in
+	 * we've called update_block_group and dropped the bytes_used counter
+	 * and increased the bytes_pinned counter.  However this means that
+	 * bytes_pinned does not reflect the bytes that will be pinned once the
+	 * delayed refs are flushed, so this counter is inc'ed everytime we call
+	 * btrfs_free_extent so it is a realtime count of what will be freed
+	 * once the transaction is committed.  It will be zero'ed everytime the
+	 * transaction commits.
+	 */
+	struct percpu_counter total_bytes_pinned;
+
+	/*
 	 * we bump reservation progress every time we decrement
 	 * bytes_reserved.  This way people waiting for reservations
 	 * know something good has happened and they can check
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6d5c5f7..bbd3db7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -24,6 +24,7 @@
 #include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/percpu_counter.h>
 #include "compat.h"
 #include "hash.h"
 #include "ctree.h"
@@ -3357,6 +3358,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	struct btrfs_space_info *found;
 	int i;
 	int factor;
+	int ret;
 
 	if (flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
 		     BTRFS_BLOCK_GROUP_RAID10))
@@ -3380,6 +3382,12 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	if (!found)
 		return -ENOMEM;
 
+	ret = percpu_counter_init(&found->total_bytes_pinned, 0);
+	if (ret) {
+		kfree(found);
+		return ret;
+	}
+
 	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
 		INIT_LIST_HEAD(&found->block_groups[i]);
 	init_rwsem(&found->groups_sem);
@@ -3612,10 +3620,11 @@ alloc:
 		}
 
 		/*
-		 * If we have less pinned bytes than we want to allocate then
-		 * don't bother committing the transaction, it won't help us.
+		 * If we don't have enough pinned space to deal with this
+		 * allocation don't bother committing the transaction.
 		 */
-		if (data_sinfo->bytes_pinned < bytes)
+		if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
+					   bytes) < 0)
 			committed = 1;
 		spin_unlock(&data_sinfo->lock);
 
@@ -3624,6 +3633,7 @@ commit_trans:
 		if (!committed &&
 		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
 			committed = 1;
+
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
@@ -4044,7 +4054,8 @@ static int may_commit_transaction(struct btrfs_root *root,
 
 	/* See if there is enough pinned space to make this reservation */
 	spin_lock(&space_info->lock);
-	if (space_info->bytes_pinned >= bytes) {
+	if (percpu_counter_compare(&space_info->total_bytes_pinned,
+				   bytes) >= 0) {
 		spin_unlock(&space_info->lock);
 		goto commit;
 	}
@@ -4059,7 +4070,8 @@ static int may_commit_transaction(struct btrfs_root *root,
 
 	spin_lock(&space_info->lock);
 	spin_lock(&delayed_rsv->lock);
-	if (space_info->bytes_pinned + delayed_rsv->size < bytes) {
+	if (percpu_counter_compare(&space_info->total_bytes_pinned,
+				   bytes - delayed_rsv->size) >= 0) {
 		spin_unlock(&delayed_rsv->lock);
 		spin_unlock(&space_info->lock);
 		return -ENOSPC;
@@ -5397,6 +5409,7 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 	struct btrfs_caching_control *next;
 	struct btrfs_caching_control *caching_ctl;
 	struct btrfs_block_group_cache *cache;
+	struct btrfs_space_info *space_info;
 
 	down_write(&fs_info->extent_commit_sem);
 
@@ -5419,6 +5432,9 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 
 	up_write(&fs_info->extent_commit_sem);
 
+	list_for_each_entry_rcu(space_info, &fs_info->space_info, list)
+		percpu_counter_set(&space_info->total_bytes_pinned, 0);
+
 	update_global_block_rsv(fs_info);
 }
 
@@ -5516,6 +5532,27 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static void add_pinned_bytes(struct btrfs_fs_info *fs_info, u64 num_bytes,
+			     u64 owner, u64 root_objectid)
+{
+	struct btrfs_space_info *space_info;
+	u64 flags;
+
+	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
+		if (root_objectid == BTRFS_CHUNK_TREE_OBJECTID)
+			flags = BTRFS_BLOCK_GROUP_SYSTEM;
+		else
+			flags = BTRFS_BLOCK_GROUP_METADATA;
+	} else {
+		flags = BTRFS_BLOCK_GROUP_DATA;
+	}
+
+	space_info = __find_space_info(fs_info, flags);
+	BUG_ON(!space_info); /* Logic bug */
+	percpu_counter_add(&space_info->total_bytes_pinned, num_bytes);
+}
+
+
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
@@ -5736,6 +5773,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				goto out;
 			}
 		}
+		add_pinned_bytes(root->fs_info, -num_bytes, owner_objectid,
+				 root_objectid);
 	} else {
 		if (found_extent) {
 			BUG_ON(is_data && refs_to_drop !=
@@ -5859,6 +5898,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   u64 parent, int last_ref)
 {
 	struct btrfs_block_group_cache *cache = NULL;
+	int pin = 1;
 	int ret;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
@@ -5891,8 +5931,14 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 
 		btrfs_add_free_space(cache, buf->start, buf->len);
 		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE);
+		pin = 0;
 	}
 out:
+	if (pin)
+		add_pinned_bytes(root->fs_info, buf->len,
+				 btrfs_header_level(buf),
+				 root->root_key.objectid);
+
 	/*
 	 * Deleting the buffer, clear the corrupt flag since it doesn't matter
 	 * anymore.
@@ -5909,6 +5955,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
+	add_pinned_bytes(root->fs_info, num_bytes, owner, root_objectid);
+
 	/*
 	 * tree log blocks never actually go into the extent allocation
 	 * tree, just update pinning info and exit early.
@@ -8152,6 +8200,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 				dump_space_info(space_info, 0, 0);
 			}
 		}
+		percpu_counter_destroy(&space_info->total_bytes_pinned);
 		list_del(&space_info->list);
 		kfree(space_info);
 	}
-- 
1.7.7.6

