From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: kernel BUG at extent_map.c:275!
Date: Tue, 22 Jul 2008 14:04:57 -0400
Message-ID: <1216749897.3019.18.camel@shinybook.infradead.org>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
	 <1216697801.18980.40.camel@shinybook.infradead.org>
	 <1216722065.6932.125.camel@think.oraclecorp.com>
	 <1216737343.18980.98.camel@shinybook.infradead.org>
	 <1216746235.6932.129.camel@think.oraclecorp.com>
	 <1216748498.3019.9.camel@shinybook.infradead.org>
	 <48861C07.3040103@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48861C07.3040103@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-07-22 at 10:42 -0700, Zach Brown wrote:
> David Woodhouse wrote:
> > On Tue, 2008-07-22 at 13:03 -0400, Chris Mason wrote:
> >> Well, the test is there to make sure the caller is doing the right
> >> thing.  Before we remove it, I'd like to understand why it is failing.
> > 
> > Because this is a uniprocessor kernel. So spin_lock() and spin_unlock()
> > both do absolutely nothing, and spin_trylock() _always_ returns 1.
> 
> How about using assert_spin_locked()?

Yeah, that should work if we still need these checks.

diff --git a/extent_map.c b/extent_map.c
index 71b1ac1..c68abd8 100644
--- a/extent_map.c
+++ b/extent_map.c
@@ -209,7 +209,7 @@ int add_extent_mapping(struct extent_map_tree *tree,
 	struct extent_map *merge = NULL;
 	struct rb_node *rb;
 
-	BUG_ON(spin_trylock(&tree->lock));
+	assert_spin_locked(&tree->lock);
 	rb = tree_insert(&tree->map, em->start, &em->rb_node);
 	if (rb) {
 		ret = -EEXIST;
@@ -272,7 +272,7 @@ struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 	struct rb_node *next = NULL;
 	u64 end = range_end(start, len);
 
-	BUG_ON(spin_trylock(&tree->lock));
+	assert_spin_locked(&tree->lock);
 	em = tree->last;
 	if (em && end > em->start && start < extent_map_end(em))
 		goto found;
@@ -324,7 +324,7 @@ int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 	int ret = 0;
 
 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
-	BUG_ON(spin_trylock(&tree->lock));
+	assert_spin_locked(&tree->lock);
 	rb_erase(&em->rb_node, &tree->map);
 	em->in_tree = 0;
 	if (tree->last == em)

-- 
dwmw2

