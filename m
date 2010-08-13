From: Cheng Renquan <crquan@gmail.com>
Subject: [PATCH] btrfs: avoid duplications by moving the static int array from header to c file
Date: Fri, 13 Aug 2010 09:55:48 +0800
Message-ID: <1281664548-10189-1-git-send-email-crquan@gmail.com>
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com, Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The commit 607d432d referred a static int array defined in ctree.h,
and a static inline function (btrfs_super_csum_size) using this array,
the obvious problem is every c file using that function would have a
local copy of that int array, multiple c files calling would result
multiple copies of that array:

$ nm fs/btrfs/btrfs.ko | grep btrfs_csum_sizes
0000010c r btrfs_csum_sizes
00000114 r btrfs_csum_sizes
000001c0 r btrfs_csum_sizes
000005a0 r btrfs_csum_sizes

the original commit has 4 c files called this static inline function,
till now there are still those 4 c files calling it, so there are 4 copies
of btrfs_csum_sizes; but future code may call it in more c files,
resulting in more copies;

 fs/btrfs/ctree.h     |   19 ++++++++++++++++-
 fs/btrfs/disk-io.c   |   25 +++++++++++++++++----
 fs/btrfs/file-item.c |   56 ++++++++++++++++++++++++++++---------------------
 fs/btrfs/ioctl.c     |    9 ++++---
 fs/btrfs/tree-log.c  |   10 +++++---
 5 files changed, 81 insertions(+), 38 deletions(-)

multiple copies are just wasting memory; move it to a c file can avoid
duplications; and since the inline function referred ARRAY_SIZE of that
array, must know the array size at compile time, so cannot be inlined
anyway.

The cost is originally inlined function calling changed to external function
calling.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 fs/btrfs/ctree.c |    9 +++++++++
 fs/btrfs/ctree.h |    9 +--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c3df14c..3a89207 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -24,6 +24,15 @@
 #include "print-tree.h"
 #include "locking.h"
 
+int btrfs_super_csum_size(struct btrfs_super_block *s)
+{
+	static const int btrfs_csum_sizes[] = { 4, 0 };
+
+	int t = btrfs_super_csum_type(s);
+	BUG_ON(t >= ARRAY_SIZE(btrfs_csum_sizes));
+	return btrfs_csum_sizes[t];
+}
+
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
 static int split_leaf(struct btrfs_trans_handle *trans, struct btrfs_root
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e9bf864..99220ee 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -132,8 +132,6 @@ struct btrfs_ordered_sum;
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
 
-static int btrfs_csum_sizes[] = { 4, 0 };
-
 /* four bytes for CRC32 */
 #define BTRFS_EMPTY_DIR_SIZE 0
 
@@ -1877,12 +1875,7 @@ BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
 
-static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
-{
-	int t = btrfs_super_csum_type(s);
-	BUG_ON(t >= ARRAY_SIZE(btrfs_csum_sizes));
-	return btrfs_csum_sizes[t];
-}
+int btrfs_super_csum_size(struct btrfs_super_block *s);
 
 static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
 {
-- 
1.7.0.4

