From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/6] Btrfs: Abstract similar code for btrfs_block_rsv_add{,
 _noflush}()
Date: Thu, 10 Nov 2011 14:28:23 +0800
Message-ID: <4EBB6F07.6000009@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_block_rsv_add{, _noflush}() have similar code, so abstract that code.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1311beb..6703a43 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3796,16 +3796,16 @@ void btrfs_free_block_rsv(struct btrfs_root *root,
 	kfree(rsv);
 }
 
-int btrfs_block_rsv_add(struct btrfs_root *root,
-			struct btrfs_block_rsv *block_rsv,
-			u64 num_bytes)
+static inline int __block_rsv_add(struct btrfs_root *root,
+				  struct btrfs_block_rsv *block_rsv,
+				  u64 num_bytes, int flush)
 {
 	int ret;
 
 	if (num_bytes == 0)
 		return 0;
 
-	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, 1);
+	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
 	if (!ret) {
 		block_rsv_add_bytes(block_rsv, num_bytes, 1);
 		return 0;
@@ -3814,22 +3814,18 @@ int btrfs_block_rsv_add(struct btrfs_root *root,
 	return ret;
 }
 
+int btrfs_block_rsv_add(struct btrfs_root *root,
+			struct btrfs_block_rsv *block_rsv,
+			u64 num_bytes)
+{
+	return __block_rsv_add(root, block_rsv, num_bytes, 1);
+}
+
 int btrfs_block_rsv_add_noflush(struct btrfs_root *root,
 				struct btrfs_block_rsv *block_rsv,
 				u64 num_bytes)
 {
-	int ret;
-
-	if (num_bytes == 0)
-		return 0;
-
-	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, 0);
-	if (!ret) {
-		block_rsv_add_bytes(block_rsv, num_bytes, 1);
-		return 0;
-	}
-
-	return ret;
+	return __block_rsv_add(root, block_rsv, num_bytes, 0);
 }
 
 int btrfs_block_rsv_check(struct btrfs_root *root,
-- 
1.7.6.4
