From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs: make sure all pending extent operations are complete
Date: Tue, 27 Jan 2009 15:52:04 -0500
Message-ID: <1233089524-17631-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Theres a slight problem with finish_current_insert, if we set all to 1 and then
go through and don't actually skip any of the extents on the pending list, we
could exit right after we've added new extents.  This is a problem because by
inserting the new extents we could have gotten new COW's to happen and such, so
we may have some pending updates to do or even more inserts to do after that.
So this patch will only exit if we have never skipped any of the extents in the
pending list, and we have no extents to insert, this will make sure that all of
the pending work is truly done before we return.  I've been running with this
patch for a few days with all of my other testing and have not seen issues.
Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/extent-tree.c |   44 +++++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9e56287..e273fa5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2266,13 +2266,12 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	u64 end;
 	u64 priv;
 	u64 search = 0;
-	u64 skipped = 0;
 	struct btrfs_fs_info *info = extent_root->fs_info;
 	struct btrfs_path *path;
 	struct pending_extent_op *extent_op, *tmp;
 	struct list_head insert_list, update_list;
 	int ret;
-	int num_inserts = 0, max_inserts;
+	int num_inserts = 0, max_inserts, restart = 0;
 
 	path = btrfs_alloc_path();
 	INIT_LIST_HEAD(&insert_list);
@@ -2288,19 +2287,19 @@ again:
 		ret = find_first_extent_bit(&info->extent_ins, search, &start,
 					    &end, EXTENT_WRITEBACK);
 		if (ret) {
-			if (skipped && all && !num_inserts &&
+			if (restart && !num_inserts &&
 			    list_empty(&update_list)) {
-				skipped = 0;
+				restart = 0;
 				search = 0;
 				continue;
 			}
-			mutex_unlock(&info->extent_ins_mutex);
 			break;
 		}
 
 		ret = try_lock_extent(&info->extent_ins, start, end, GFP_NOFS);
 		if (!ret) {
-			skipped = 1;
+			if (all)
+				restart = 1;
 			search = end + 1;
 			if (need_resched()) {
 				mutex_unlock(&info->extent_ins_mutex);
@@ -2319,7 +2318,7 @@ again:
 			list_add_tail(&extent_op->list, &insert_list);
 			search = end + 1;
 			if (num_inserts == max_inserts) {
-				mutex_unlock(&info->extent_ins_mutex);
+				restart = 1;
 				break;
 			}
 		} else if (extent_op->type == PENDING_BACKREF_UPDATE) {
@@ -2335,7 +2334,6 @@ again:
 	 * somebody marked this thing for deletion then just unlock it and be
 	 * done, the free_extents will handle it
 	 */
-	mutex_lock(&info->extent_ins_mutex);
 	list_for_each_entry_safe(extent_op, tmp, &update_list, list) {
 		clear_extent_bits(&info->extent_ins, extent_op->bytenr,
 				  extent_op->bytenr + extent_op->num_bytes - 1,
@@ -2364,9 +2362,9 @@ again:
 	 * need to make sure everything is cleaned then reset everything and
 	 * go back to the beginning
 	 */
-	if (!num_inserts && all && skipped) {
+	if (!num_inserts && restart) {
 		search = 0;
-		skipped = 0;
+		restart = 0;
 		INIT_LIST_HEAD(&update_list);
 		INIT_LIST_HEAD(&insert_list);
 		goto again;
@@ -2423,27 +2421,19 @@ again:
 	BUG_ON(ret);
 
 	/*
-	 * if we broke out of the loop in order to insert stuff because we hit
-	 * the maximum number of inserts at a time we can handle, then loop
-	 * back and pick up where we left off
-	 */
-	if (num_inserts == max_inserts) {
-		INIT_LIST_HEAD(&insert_list);
-		INIT_LIST_HEAD(&update_list);
-		num_inserts = 0;
-		goto again;
-	}
-
-	/*
-	 * again, if we need to make absolutely sure there are no more pending
-	 * extent operations left and we know that we skipped some, go back to
-	 * the beginning and do it all again
+	 * if restart is set for whatever reason we need to go back and start
+	 * searching through the pending list again.
+	 *
+	 * We just inserted some extents, which could have resulted in new
+	 * blocks being allocated, which would result in new blocks needing
+	 * updates, so if all is set we _must_ restart to get the updated
+	 * blocks.
 	 */
-	if (all && skipped) {
+	if (restart || all) {
 		INIT_LIST_HEAD(&insert_list);
 		INIT_LIST_HEAD(&update_list);
 		search = 0;
-		skipped = 0;
+		restart = 0;
 		num_inserts = 0;
 		goto again;
 	}
-- 
1.5.4.3

