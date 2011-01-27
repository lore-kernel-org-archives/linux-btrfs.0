From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 02/12] btrfs: Add helper function free_bitmap()
Date: Thu, 27 Jan 2011 16:42:56 +0800
Message-ID: <4D413010.7060100@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Remove some duplicated code.

This prepares for the next patch.

Reviewed-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 42f4015..850104f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1175,6 +1175,16 @@ static void add_new_bitmap(struct btrfs_block_group_cache *block_group,
 	recalculate_thresholds(block_group);
 }
 
+static void free_bitmap(struct btrfs_block_group_cache *block_group,
+			struct btrfs_free_space *bitmap_info)
+{
+	unlink_free_space(block_group, bitmap_info);
+	kfree(bitmap_info->bitmap);
+	kfree(bitmap_info);
+	block_group->total_bitmaps--;
+	recalculate_thresholds(block_group);
+}
+
 static noinline int remove_from_bitmap(struct btrfs_block_group_cache *block_group,
 			      struct btrfs_free_space *bitmap_info,
 			      u64 *offset, u64 *bytes)
@@ -1215,13 +1225,8 @@ again:
 
 	if (*bytes) {
 		struct rb_node *next = rb_next(&bitmap_info->offset_index);
-		if (!bitmap_info->bytes) {
-			unlink_free_space(block_group, bitmap_info);
-			kfree(bitmap_info->bitmap);
-			kfree(bitmap_info);
-			block_group->total_bitmaps--;
-			recalculate_thresholds(block_group);
-		}
+		if (!bitmap_info->bytes)
+			free_bitmap(block_group, bitmap_info);
 
 		/*
 		 * no entry after this bitmap, but we still have bytes to
@@ -1254,13 +1259,8 @@ again:
 			return -EAGAIN;
 
 		goto again;
-	} else if (!bitmap_info->bytes) {
-		unlink_free_space(block_group, bitmap_info);
-		kfree(bitmap_info->bitmap);
-		kfree(bitmap_info);
-		block_group->total_bitmaps--;
-		recalculate_thresholds(block_group);
-	}
+	} else if (!bitmap_info->bytes)
+		free_bitmap(block_group, bitmap_info);
 
 	return 0;
 }
@@ -1689,13 +1689,8 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 	ret = offset;
 	if (entry->bitmap) {
 		bitmap_clear_bits(block_group, entry, offset, bytes);
-		if (!entry->bytes) {
-			unlink_free_space(block_group, entry);
-			kfree(entry->bitmap);
-			kfree(entry);
-			block_group->total_bitmaps--;
-			recalculate_thresholds(block_group);
-		}
+		if (!entry->bytes)
+			free_bitmap(block_group, entry);
 	} else {
 		unlink_free_space(block_group, entry);
 		entry->offset += bytes;
-- 
1.6.3
