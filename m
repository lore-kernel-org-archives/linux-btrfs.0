Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:48413 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab2IQTgI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 15:36:08 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id evVex4CCZxVUqAgm (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 13:36:06 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not hold the write_lock on the extent tree while logging V2
Date: Mon, 17 Sep 2012 15:41:34 -0400
Message-ID: <1347910894-5031-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave Sterba pointed out a sleeping while atomic bug while doing fsync.  This
is because I'm an idiot and didn't realize that rwlock's were spin locks, so
we've been holding this thing while doing allocations and such which is not
good.  This patch fixes this by dropping the write lock before we do
anything heavy and re-acquire it when it is done.  We also need to take a
ref on the em's in case their corresponding pages are evicted and mark them
as being logged so that releasepage does not remove them and doesn't remove
them from our local list.  Thanks,

Reported-by: Dave Sterba <dave@jikos.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: drop our ref if we had an error
 fs/btrfs/extent_map.c |    3 ++-
 fs/btrfs/extent_map.h |    1 +
 fs/btrfs/tree-log.c   |   20 ++++++++++++++++----
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 8d1364d..b8cbc8d 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -407,7 +407,8 @@ int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 
 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
 	rb_erase(&em->rb_node, &tree->map);
-	list_del_init(&em->list);
+	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
+		list_del_init(&em->list);
 	em->in_tree = 0;
 	return ret;
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 8e6294b..6792255 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -13,6 +13,7 @@
 #define EXTENT_FLAG_COMPRESSED 1
 #define EXTENT_FLAG_VACANCY 2 /* no file extent item found */
 #define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
+#define EXTENT_FLAG_LOGGING 4 /* Logging this extent */
 
 struct extent_map {
 	struct rb_node rb_node;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 038a522..a3e88cf 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2945,6 +2945,9 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		list_del_init(&em->list);
 		if (em->generation <= test_gen)
 			continue;
+		/* Need a ref to keep it from getting evicted from cache */
+		atomic_inc(&em->refs);
+		set_bit(EXTENT_FLAG_LOGGING, &em->flags);
 		list_add_tail(&em->list, &extents);
 	}
 
@@ -2954,13 +2957,18 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		em = list_entry(extents.next, struct extent_map, list);
 
 		list_del_init(&em->list);
+		clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
 
 		/*
 		 * If we had an error we just need to delete everybody from our
 		 * private list.
 		 */
-		if (ret)
+		if (ret) {
+			free_extent_map(em);
 			continue;
+		}
+
+		write_unlock(&tree->lock);
 
 		/*
 		 * If the previous EM and the last extent we left off on aren't
@@ -2971,21 +2979,25 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 			ret = copy_items(trans, inode, dst_path, args.src,
 					 args.start_slot, args.nr,
 					 LOG_INODE_ALL);
-			if (ret)
+			if (ret) {
+				free_extent_map(em);
 				continue;
+			}
 			btrfs_release_path(path);
 			args.nr = 0;
 		}
 
 		ret = log_one_extent(trans, inode, root, em, path, dst_path, &args);
+		free_extent_map(em);
+		write_lock(&tree->lock);
 	}
+	WARN_ON(!list_empty(&extents));
+	write_unlock(&tree->lock);
 
 	if (!ret && args.nr)
 		ret = copy_items(trans, inode, dst_path, args.src,
 				 args.start_slot, args.nr, LOG_INODE_ALL);
 	btrfs_release_path(path);
-	WARN_ON(!list_empty(&extents));
-	write_unlock(&tree->lock);
 	return ret;
 }
 
-- 
1.7.7.6

