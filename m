Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53124 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab3CSQLE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 12:11:04 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 0E8027C065C
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2013 10:11:04 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 12RwJvdtbl00NgVK (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2013 10:11:01 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: handle a bogus chunk tree nicely
Date: Tue, 19 Mar 2013 12:18:20 -0400
Message-ID: <1363709900-1431-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you restore a btrfs-image file system and try to mount that file system we'll
panic.  That's because btrfs-image restores and just makes one big chunk to
envelope the whole disk, since they are really only meant to be messed with by
our btrfs-progs.  So fix up btrfs_rmap_block and the callers of it for mount so
that we no longer panic but instead just return an error and fail to mount.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   35 ++++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.c     |   13 ++++++++++++-
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a08d0fe..7e91583 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -257,7 +257,8 @@ static int exclude_super_stripes(struct btrfs_root *root,
 		cache->bytes_super += stripe_len;
 		ret = add_excluded_extent(root, cache->key.objectid,
 					  stripe_len);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret)
+			return ret;
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
@@ -265,13 +266,17 @@ static int exclude_super_stripes(struct btrfs_root *root,
 		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
 				       cache->key.objectid, bytenr,
 				       0, &logical, &nr, &stripe_len);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret)
+			return ret;
 
 		while (nr--) {
 			cache->bytes_super += stripe_len;
 			ret = add_excluded_extent(root, logical[nr],
 						  stripe_len);
-			BUG_ON(ret); /* -ENOMEM */
+			if (ret) {
+				kfree(logical);
+				return ret;
+			}
 		}
 
 		kfree(logical);
@@ -8120,7 +8125,17 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		 * info has super bytes accounted for, otherwise we'll think
 		 * we have more space than we actually do.
 		 */
-		exclude_super_stripes(root, cache);
+		ret = exclude_super_stripes(root, cache);
+		if (ret) {
+			/*
+			 * We may have excluded something, so call this just in
+			 * case.
+			 */
+			free_excluded_extents(root, cache);
+			kfree(cache->free_space_ctl);
+			kfree(cache);
+			goto error;
+		}
 
 		/*
 		 * check for two cases, either we are full, and therefore
@@ -8262,7 +8277,17 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 	cache->last_byte_to_unpin = (u64)-1;
 	cache->cached = BTRFS_CACHE_FINISHED;
-	exclude_super_stripes(root, cache);
+	ret = exclude_super_stripes(root, cache);
+	if (ret) {
+		/*
+		 * We may have excluded something, so call this just in
+		 * case.
+		 */
+		free_excluded_extents(root, cache);
+		kfree(cache->free_space_ctl);
+		kfree(cache);
+		return ret;
+	}
 
 	add_new_free_space(cache, root->fs_info, chunk_offset,
 			   chunk_offset + size);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5989a92..2854c82 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4935,7 +4935,18 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	em = lookup_extent_mapping(em_tree, chunk_start, 1);
 	read_unlock(&em_tree->lock);
 
-	BUG_ON(!em || em->start != chunk_start);
+	if (!em) {
+		printk(KERN_ERR "btrfs: couldn't find em for chunk %Lu\n",
+		       chunk_start);
+		return -EIO;
+	}
+
+	if (em->start != chunk_start) {
+		printk(KERN_ERR "btrfs: bad chunk start, em=%Lu, wanted=%Lu\n",
+		       em->start, chunk_start);
+		free_extent_map(em);
+		return -EIO;
+	}
 	map = (struct map_lookup *)em->bdev;
 
 	length = em->len;
-- 
1.7.7.6

