From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix enospc error caused by wrong checks of the chunk
 allocation
Date: Tue, 17 Jan 2012 17:24:03 +0800
Message-ID: <4F153E33.8070803@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we did sysbench test for inline files, enospc error happened easily though
there was lots of free disk space which could be allocated for new chunks.

Reproduce steps:
 # mkfs.btrfs -b $((2 * 1024 * 1024 * 1024)) <test partition>
 # mount <test partition> /mnt
 # ulimit -n 102400
 # cd /mnt
 # sysbench --num-threads=1 --test=fileio --file-num=81920 \
 > --file-total-size=80M --file-block-size=1K --file-io-mode=sync \
 > --file-test-mode=seqwr prepare
 # sysbench --num-threads=1 --test=fileio --file-num=81920 \
 > --file-total-size=80M --file-block-size=1K --file-io-mode=sync \
 > --file-test-mode=seqwr run
 <soon later, BUG_ON() was triggered by enospc error>

The reason of this bug is:
Now, we can reserve space which is larger than the free space in the chunks if
we have enough free disk space which can be used for new chunks. By this way,
the space allocator should allocate a new chunk by force if there is no free
space in the free space cache. But there are two wrong checks which break this
operation.

One is
	if (ret == -ENOSPC && num_bytes > min_alloc_size)
in btrfs_reserve_extent(), it is wrong, we should try to allocate a new chunk
even we fail to allocate free space by minimum allocable size.

The other is
	if (space_info->force_alloc)
		force = space_info->force_alloc;
in do_chunk_alloc(). It makes the allocator ignore CHUNK_ALLOC_FORCE If someone
sets ->force_alloc to CHUNK_ALLOC_LIMITED, and makes the enospc error happen.

Fix these two wrong checks. Especially the second one, we fix it by changing
the value of CHUNK_ALLOC_LIMITED and CHUNK_ALLOC_FORCE, and make
CHUNK_ALLOC_FORCE greater than CHUNK_ALLOC_LIMITED since CHUNK_ALLOC_FORCE has
higher priority. And if the value which is passed in by the caller is greater
than ->force_alloc, use the passed value.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is based on the new viro branch.
---
 fs/btrfs/extent-tree.c |   49 ++++++++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 700879e..283af7a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -34,23 +34,24 @@
 #include "locking.h"
 #include "free-space-cache.h"
 
-/* control flags for do_chunk_alloc's force field
+/*
+ * control flags for do_chunk_alloc's force field
  * CHUNK_ALLOC_NO_FORCE means to only allocate a chunk
  * if we really need one.
  *
- * CHUNK_ALLOC_FORCE means it must try to allocate one
- *
  * CHUNK_ALLOC_LIMITED means to only try and allocate one
  * if we have very few chunks already allocated.  This is
  * used as part of the clustering code to help make sure
  * we have a good pool of storage to cluster in, without
  * filling the FS with empty chunks
  *
+ * CHUNK_ALLOC_FORCE means it must try to allocate one
+ *
  */
 enum {
 	CHUNK_ALLOC_NO_FORCE = 0,
-	CHUNK_ALLOC_FORCE = 1,
-	CHUNK_ALLOC_LIMITED = 2,
+	CHUNK_ALLOC_LIMITED = 1,
+	CHUNK_ALLOC_FORCE = 2,
 };
 
 /*
@@ -3414,7 +3415,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 
 again:
 	spin_lock(&space_info->lock);
-	if (space_info->force_alloc)
+	if (force < space_info->force_alloc)
 		force = space_info->force_alloc;
 	if (space_info->full) {
 		spin_unlock(&space_info->lock);
@@ -5794,6 +5795,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			 u64 search_end, struct btrfs_key *ins,
 			 u64 data)
 {
+	bool final_tried = false;
 	int ret;
 	u64 search_start = 0;
 
@@ -5813,22 +5815,25 @@ again:
 			       search_start, search_end, hint_byte,
 			       ins, data);
 
-	if (ret == -ENOSPC && num_bytes > min_alloc_size) {
-		num_bytes = num_bytes >> 1;
-		num_bytes = num_bytes & ~(root->sectorsize - 1);
-		num_bytes = max(num_bytes, min_alloc_size);
-		do_chunk_alloc(trans, root->fs_info->extent_root,
-			       num_bytes, data, CHUNK_ALLOC_FORCE);
-		goto again;
-	}
-	if (ret == -ENOSPC && btrfs_test_opt(root, ENOSPC_DEBUG)) {
-		struct btrfs_space_info *sinfo;
-
-		sinfo = __find_space_info(root->fs_info, data);
-		printk(KERN_ERR "btrfs allocation failed flags %llu, "
-		       "wanted %llu\n", (unsigned long long)data,
-		       (unsigned long long)num_bytes);
-		dump_space_info(sinfo, num_bytes, 1);
+	if (ret == -ENOSPC) {
+		if (!final_tried) {
+			num_bytes = num_bytes >> 1;
+			num_bytes = num_bytes & ~(root->sectorsize - 1);
+			num_bytes = max(num_bytes, min_alloc_size);
+			do_chunk_alloc(trans, root->fs_info->extent_root,
+				       num_bytes, data, CHUNK_ALLOC_FORCE);
+			if (num_bytes == min_alloc_size)
+				final_tried = true;
+			goto again;
+		} else if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
+			struct btrfs_space_info *sinfo;
+
+			sinfo = __find_space_info(root->fs_info, data);
+			printk(KERN_ERR "btrfs allocation failed flags %llu, "
+			       "wanted %llu\n", (unsigned long long)data,
+			       (unsigned long long)num_bytes);
+			dump_space_info(sinfo, num_bytes, 1);
+		}
 	}
 
 	trace_btrfs_reserved_extent_alloc(root, ins->objectid, ins->offset);
-- 
1.7.6.5
