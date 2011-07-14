From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH] btrfs: make btrfs_set_root_node void
Date: Thu, 14 Jul 2011 14:23:06 -0700
Message-ID: <20110714212306.GE10500@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is fairly trivial - btrfs_set_root_node() - always returns zero so we
can just make it void.  All callers ignore the return code now anyway.  I
also made sure to check that none of the functions that
btrfs_set_root_node() calls returns an error that we might have needed to
catch and pass back.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/ctree.h     |    4 ++--
 fs/btrfs/root-tree.c |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3b859a3..20bd05f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2404,8 +2404,8 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid, struct
 			 btrfs_root_item *item, struct btrfs_key *key);
 int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid);
 int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
-int btrfs_set_root_node(struct btrfs_root_item *item,
-			struct extent_buffer *node);
+void btrfs_set_root_node(struct btrfs_root_item *item,
+			 struct extent_buffer *node);
 void btrfs_check_and_init_root_item(struct btrfs_root_item *item);
 
 /* dir-item.c */
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ea96ab8..d411cb4 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -71,13 +71,12 @@ out:
 	return ret;
 }
 
-int btrfs_set_root_node(struct btrfs_root_item *item,
-			struct extent_buffer *node)
+void btrfs_set_root_node(struct btrfs_root_item *item,
+			 struct extent_buffer *node)
 {
 	btrfs_set_root_bytenr(item, node->start);
 	btrfs_set_root_level(item, btrfs_header_level(node));
 	btrfs_set_root_generation(item, btrfs_header_generation(node));
-	return 0;
 }
 
 /*
-- 
1.7.5.3

