From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 1/7] Btrfs: Remove unused btrfs_block_group_free_space()
Date: Mon, 25 Apr 2011 16:58:22 +0800
Message-ID: <4DB537AE.3080204@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We've already recorded the value in block_group->frees_space.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   15 ---------------
 fs/btrfs/free-space-cache.h |    1 -
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 11d2e9c..3af64c6 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1685,21 +1685,6 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 	       "\n", count);
 }
 
-u64 btrfs_block_group_free_space(struct btrfs_block_group_cache *block_group)
-{
-	struct btrfs_free_space *info;
-	struct rb_node *n;
-	u64 ret = 0;
-
-	for (n = rb_first(&block_group->free_space_offset); n;
-	     n = rb_next(n)) {
-		info = rb_entry(n, struct btrfs_free_space, offset_index);
-		ret += info->bytes;
-	}
-
-	return ret;
-}
-
 /*
  * for a given cluster, put all of its extents back into the free
  * space cache.  If the block group passed doesn't match the block group
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 65c3b93..12b2b51 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -55,7 +55,6 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
 			       u64 offset, u64 bytes, u64 empty_size);
 void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 			   u64 bytes);
-u64 btrfs_block_group_free_space(struct btrfs_block_group_cache *block_group);
 int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_block_group_cache *block_group,
-- 
1.7.3.1
