From: Daniel Cadete <danielcadete10@gmail.com>
Subject: [PATCH] Remove of redundant btrfs_header_level
Date: Mon, 20 Jul 2009 12:18:31 +0100
Message-ID: <60f1813f0907200418i88a8e9x572ae04dc7d762fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This removes the continues call's of btrfs_header_level. One call of
btrfs_header_level(c) its enough.

Signed-off-by Daniel Cadete <danielncadete10@gmail.com>

---
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 6d6523d..533c82d 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -309,7 +309,7 @@ void btrfs_print_tree(struct btrfs_root *root,
struct extent_buffer *c)
        }
        printk(KERN_INFO "node %llu level %d total ptrs %d free spc %u\n",
               (unsigned long long)btrfs_header_bytenr(c),
-              btrfs_header_level(c), nr,
+              level, nr,
               (u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr);
        for (i = 0; i < nr; i++) {
                btrfs_node_key_to_cpu(c, &key, i);
@@ -326,10 +326,10 @@ void btrfs_print_tree(struct btrfs_root *root,
struct extent_buffer *c)
                                        btrfs_level_size(root, level - 1),
                                        btrfs_node_ptr_generation(c, i));
                if (btrfs_is_leaf(next) &&
-                   btrfs_header_level(c) != 1)
+                   level != 1)
                        BUG();
                if (btrfs_header_level(next) !=
-                       btrfs_header_level(c) - 1)
+                       level - 1)
                        BUG();
                btrfs_print_tree(root, next);
                free_extent_buffer(next);
--
