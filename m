From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix deadlock on metadata reservation when evicting
 a inode
Date: Fri, 18 Nov 2011 17:43:00 +0800
Message-ID: <4EC628A4.10000@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When I ran the xfstests, I found the test tasks was blocked on meta-data
reservation.

By debugging, I found the reason of this bug:
   start transaction
        |
	v
   reserve meta-data space
	|
	v
   flush delay allocation -> iput inode -> evict inode
	^					|
	|					v
   wait for delay allocation flush <- reserve meta-data space

And besides that, the flush on evicting inode will block the thread, which
is reclaiming the memory, and make oom happen easily.

Fix this bug by skipping the flush step when evicting inode.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |    3 +++
 fs/btrfs/extent-tree.c |   22 ++++++++++++++++++----
 fs/btrfs/inode.c       |    2 +-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b1cb3c0..04631af 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2368,6 +2368,9 @@ int btrfs_block_rsv_check(struct btrfs_root *root,
 int btrfs_block_rsv_refill(struct btrfs_root *root,
 			  struct btrfs_block_rsv *block_rsv,
 			  u64 min_reserved);
+int btrfs_block_rsv_refill_noflush(struct btrfs_root *root,
+				   struct btrfs_block_rsv *block_rsv,
+				   u64 min_reserved);
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
 			    struct btrfs_block_rsv *dst_rsv,
 			    u64 num_bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0f47b3e..33f4b0b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3846,9 +3846,9 @@ int btrfs_block_rsv_check(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_block_rsv_refill(struct btrfs_root *root,
-			  struct btrfs_block_rsv *block_rsv,
-			  u64 min_reserved)
+static inline int __btrfs_block_rsv_refill(struct btrfs_root *root,
+					   struct btrfs_block_rsv *block_rsv,
+					   u64 min_reserved, int flush)
 {
 	u64 num_bytes = 0;
 	int ret = -ENOSPC;
@@ -3867,7 +3867,7 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 	if (!ret)
 		return 0;
 
-	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, 1);
+	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
 	if (!ret) {
 		block_rsv_add_bytes(block_rsv, num_bytes, 0);
 		return 0;
@@ -3876,6 +3876,20 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 	return ret;
 }
 
+int btrfs_block_rsv_refill(struct btrfs_root *root,
+			   struct btrfs_block_rsv *block_rsv,
+			   u64 min_reserved)
+{
+	return __btrfs_block_rsv_refill(root, block_rsv, min_reserved, 1);
+}
+
+int btrfs_block_rsv_refill_noflush(struct btrfs_root *root,
+				   struct btrfs_block_rsv *block_rsv,
+				   u64 min_reserved)
+{
+	return __btrfs_block_rsv_refill(root, block_rsv, min_reserved, 0);
+}
+
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
 			    struct btrfs_block_rsv *dst_rsv,
 			    u64 num_bytes)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e16215f..d026666 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3490,7 +3490,7 @@ void btrfs_evict_inode(struct inode *inode)
 	 * doing the truncate.
 	 */
 	while (1) {
-		ret = btrfs_block_rsv_refill(root, rsv, min_size);
+		ret = btrfs_block_rsv_refill_noflush(root, rsv, min_size);
 
 		/*
 		 * Try and steal from the global reserve since we will
-- 
1.7.1
