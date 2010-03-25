From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 04/18] btrfs: Simplify btrfs_item_ptr macro
Date: Thu, 25 Mar 2010 20:29:46 +0800
Message-ID: <4BAB573A.3080003@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

btrfs_item_ptr is just a type_cast wrapper of btrfs_item_ptr_offset().

We can use btrfs_item_ptr_offset() in btrfs_item_ptr() to avoid code
duplication.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1111584..72228b2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1947,13 +1947,11 @@ static inline u32 btrfs_level_size(struct btrfs_root *root, int level)
 }
 
 /* helper function to cast into the data area of the leaf. */
-#define btrfs_item_ptr(leaf, slot, type) \
-	((type *)(btrfs_leaf_data(leaf) + \
-	btrfs_item_offset_nr(leaf, slot)))
-
 #define btrfs_item_ptr_offset(leaf, slot) \
 	((unsigned long)(btrfs_leaf_data(leaf) + \
 	btrfs_item_offset_nr(leaf, slot)))
+#define btrfs_item_ptr(leaf, slot, type) \
+	((type *)btrfs_item_ptr_offset(leaf, slot))
 
 static inline struct dentry *fdentry(struct file *file)
 {
-- 
1.6.5.2


