From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5/8] Btrfs: add __get_block_group_index() helper
Date: Tue, 27 Mar 2012 18:04:25 +0300
Message-ID: <1332860668-27298-6-git-send-email-idryomov@gmail.com>
References: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add __get_block_group_index() helper to be able to derive block group
index from an arbitary set of flags.  Implement get_block_group_index()
in terms of it.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index faf52e0..c44aa96 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5248,22 +5248,29 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 	return 0;
 }
 
-static int get_block_group_index(struct btrfs_block_group_cache *cache)
+static int __get_block_group_index(u64 flags)
 {
 	int index;
-	if (cache->flags & BTRFS_BLOCK_GROUP_RAID10)
+
+	if (flags & BTRFS_BLOCK_GROUP_RAID10)
 		index = 0;
-	else if (cache->flags & BTRFS_BLOCK_GROUP_RAID1)
+	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
 		index = 1;
-	else if (cache->flags & BTRFS_BLOCK_GROUP_DUP)
+	else if (flags & BTRFS_BLOCK_GROUP_DUP)
 		index = 2;
-	else if (cache->flags & BTRFS_BLOCK_GROUP_RAID0)
+	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
 		index = 3;
 	else
 		index = 4;
+
 	return index;
 }
 
+static int get_block_group_index(struct btrfs_block_group_cache *cache)
+{
+	return __get_block_group_index(cache->flags);
+}
+
 enum btrfs_loop_type {
 	LOOP_CACHING_NOWAIT = 0,
 	LOOP_CACHING_WAIT = 1,
-- 
1.7.9.1

