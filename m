From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/7] Btrfs: Remove unused btrfs_block_group_free_space()
Date: Wed, 16 Mar 2011 16:49:32 +0800
Message-ID: <4D80799C.3060908@cn.fujitsu.com>
References: <4D807977.1040506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D807977.1040506@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   15 ---------------
 fs/btrfs/free-space-cache.h |    1 -
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a039065..4e27eaa 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1601,21 +1601,6 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
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
index e49ca5c..ef5d7e1 100644
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
