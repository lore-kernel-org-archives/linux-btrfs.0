From: Chris Samuel <chris@csamuel.org>
Subject: [PATCH] [Coccinelle] Convert various if() BUG(); to BUG_ON();
Date: Wed, 28 Apr 2010 07:50:56 -0400
Message-ID: <4BD82120.4030008@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch converts the remaining manual tests which
call BUG() directly after a test to just use BUG_ON()
instead.

It is a simple inplace change using Coccinelle's
BUG_ON.cocci test.

Signed-off-by: Chris Samuel <chris@csamuel.org>
---
  fs/btrfs/ctree.c      |    7 ++-----
  fs/btrfs/print-tree.c |    8 ++------
  fs/btrfs/tree-log.c   |    4 +---
  fs/btrfs/volumes.c    |    3 +--
  4 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6795a71..8f6491f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1178,9 +1178,7 @@ static noinline int balance_level(struct 
btrfs_trans_handle *trans,
         }
         /* double check we haven't messed things up */
         check_block(root, path, level);
-       if (orig_ptr !=
-           btrfs_node_blockptr(path->nodes[level], path->slots[level]))
-               BUG();
+       BUG_ON(orig_ptr != btrfs_node_blockptr(path->nodes[level], 
path->slots[level]));
  enospc:
         if (right) {
                 btrfs_tree_unlock(right);
@@ -2137,8 +2135,7 @@ static int insert_ptr(struct btrfs_trans_handle 
*trans, struct btrfs_root
         lower = path->nodes[level];
         nritems = btrfs_header_nritems(lower);
         BUG_ON(slot > nritems);
-       if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
-               BUG();
+       BUG_ON(nritems == BTRFS_NODEPTRS_PER_BLOCK(root));
         if (slot != nritems) {
                 memmove_extent_buffer(lower,
                               btrfs_node_key_ptr_offset(slot + 1),
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 0d126be..2d5e1d9 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -325,12 +325,8 @@ void btrfs_print_tree(struct btrfs_root *root, 
struct extent_buffer *c)
                                         btrfs_node_blockptr(c, i),
                                         btrfs_level_size(root, level - 1),
                                         btrfs_node_ptr_generation(c, i));
-               if (btrfs_is_leaf(next) &&
-                  level != 1)
-                       BUG();
-               if (btrfs_header_level(next) !=
-                      level - 1)
-                       BUG();
+               BUG_ON(btrfs_is_leaf(next) && level != 1);
+               BUG_ON(btrfs_header_level(next) != level - 1);
                 btrfs_print_tree(root, next);
                 free_extent_buffer(next);
         }
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index af57dd2..7a55957 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -375,9 +375,7 @@ insert:
                                                 item_size - found_size);
                         BUG_ON(ret);
                 }
-       } else if (ret) {
-               BUG();
-       }
+       } else BUG_ON(ret);
         dst_ptr = btrfs_item_ptr_offset(path->nodes[0],
                                         path->slots[0]);

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8db7b14..480edee 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1860,8 +1860,7 @@ again:
                                                    found_key.offset);
                         if (ret == -ENOSPC)
                                 failed++;
-                       else if (ret)
-                               BUG();
+                       else BUG_ON(ret);
                 }

                 if (found_key.offset == 0)
-- 
1.7.0.4

-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
