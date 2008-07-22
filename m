From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Remove BUG_ON(spin_trylock()) checks which have false
	positives on UP
Date: Tue, 22 Jul 2008 10:43:46 -0400
Message-ID: <1216737826.18980.104.camel@shinybook.infradead.org>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
	 <1216697801.18980.40.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216697801.18980.40.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On uniprocessor kernels without spinlock debugging, spinlock operations
are all no-ops and spin_trylock() will always succeed.

These BUG_ON() sanity checks are effectively an unconditional BUG() in
that case.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/extent_map.c b/extent_map.c
index 71b1ac1..6a72961 100644
--- a/extent_map.c
+++ b/extent_map.c
@@ -209,7 +209,6 @@ int add_extent_mapping(struct extent_map_tree *tree,
 	struct extent_map *merge = NULL;
 	struct rb_node *rb;
 
-	BUG_ON(spin_trylock(&tree->lock));
 	rb = tree_insert(&tree->map, em->start, &em->rb_node);
 	if (rb) {
 		ret = -EEXIST;
@@ -272,7 +271,6 @@ struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 	struct rb_node *next = NULL;
 	u64 end = range_end(start, len);
 
-	BUG_ON(spin_trylock(&tree->lock));
 	em = tree->last;
 	if (em && end > em->start && start < extent_map_end(em))
 		goto found;
@@ -324,7 +322,6 @@ int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 	int ret = 0;
 
 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
-	BUG_ON(spin_trylock(&tree->lock));
 	rb_erase(&em->rb_node, &tree->map);
 	em->in_tree = 0;
 	if (tree->last == em)


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

