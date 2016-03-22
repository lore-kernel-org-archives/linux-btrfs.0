Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758099AbcCVBio (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:44 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 27/27] btrfs: dedupe: Fix a space cache delalloc bytes underflow bug
Date: Tue, 22 Mar 2016 09:35:52 +0800
Message-Id: <1458610552-9845-28-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dedupe has a bug that underflow block_group_cache->delalloc_bytes, makes
it unable to return to 0.
This will cause free space cache for that block group never written to
disk.

And cause the following kernel message at umount:
BTRFS info (device vdc): The free space cache file (1485570048) is
invalid. skip it

Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |  8 ++++++--
 fs/btrfs/inode.c       | 11 +++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 016d2ec..f6dbef3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6256,8 +6256,12 @@ static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
 		cache->reserved -= num_bytes;
 		space_info->bytes_reserved -= num_bytes;
 
-		if (delalloc)
-			cache->delalloc_bytes -= num_bytes;
+		if (delalloc) {
+			if (WARN_ON(num_bytes > cache->delalloc_bytes))
+				cache->delalloc_bytes = 0;
+			else
+				cache->delalloc_bytes -= num_bytes;
+		}
 	}
 	spin_unlock(&cache->lock);
 	spin_unlock(&space_info->lock);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8a2a76a..5014ece 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3045,7 +3045,10 @@ static void btrfs_release_delalloc_bytes(struct btrfs_root *root,
 	ASSERT(cache);
 
 	spin_lock(&cache->lock);
-	cache->delalloc_bytes -= len;
+	if (WARN_ON(len > cache->delalloc_bytes))
+		cache->delalloc_bytes = 0;
+	else
+		cache->delalloc_bytes -= len;
 	spin_unlock(&cache->lock);
 
 	btrfs_put_block_group(cache);
@@ -3154,6 +3157,9 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->file_offset +
 						logical_len);
 	} else {
+		/* Must be checked before hash modified*/
+		int hash_hit = btrfs_dedupe_hash_hit(ordered_extent->hash);
+
 		BUG_ON(root == root->fs_info->tree_root);
 		ret = insert_reserved_file_extent(trans, inode,
 						ordered_extent->file_offset,
@@ -3163,7 +3169,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						compress_type, 0, 0,
 						BTRFS_FILE_EXTENT_REG,
 						ordered_extent->hash);
-		if (!ret)
+		/* Hash hit case doesn't reserved delalloc bytes */
+		if (!ret && !hash_hit)
 			btrfs_release_delalloc_bytes(root,
 						     ordered_extent->start,
 						     ordered_extent->disk_len);
-- 
2.7.3



