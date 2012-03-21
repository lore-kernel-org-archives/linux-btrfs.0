From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix return value check of read_tree_block
Date: Thu, 22 Mar 2012 08:23:39 +0900
Message-ID: <201203212323.AA00046@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

read_tree_block() has the possibility of returning NULL.
So, the code in which it is checked whether the return value is
NULL is added.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/print-tree.c |    1 +
 fs/btrfs/relocation.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index f38e452..9ea50b9 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -330,6 +330,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c)
 					btrfs_node_blockptr(c, i),
 					btrfs_level_size(root, level - 1),
 					btrfs_node_ptr_generation(c, i));
+		BUG_ON(!next);
 		if (btrfs_is_leaf(next) &&
 		   level != 1)
 			BUG();
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8c1aae2..88221a8 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1884,7 +1884,7 @@ int walk_down_reloc_tree(struct btrfs_root *root, struct btrfs_path *path,
 		bytenr = btrfs_node_blockptr(eb, path->slots[i]);
 		blocksize = btrfs_level_size(root, i - 1);
 		eb = read_tree_block(root, bytenr, blocksize, ptr_gen);
-		BUG_ON(btrfs_header_level(eb) != i - 1);
+		BUG_ON(!eb || btrfs_header_level(eb) != i - 1);
 		path->nodes[i - 1] = eb;
 		path->slots[i - 1] = 0;
 	}

