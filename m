Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54773 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaBXMDt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 07:03:49 -0500
Received: by mail-wi0-f178.google.com with SMTP id cc10so2937276wib.5
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 04:03:48 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: more efficient split extent state insertion
Date: Mon, 24 Feb 2014 12:03:42 +0000
Message-Id: <1393243422-16454-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1392217553-10872-1-git-send-email-fdmanana@gmail.com>
References: <1392217553-10872-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we split an extent state there's no need to start the rbtree search
from the root node - we can start it from the original extent state node,
since we would end up in its subtree if we do the search starting at the
root node anyway.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Made the intention more clear, that it works only if the tree is not
    empty (which is always the case when spliting extent states).

 fs/btrfs/extent_io.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fbe501d..eb465e9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -229,12 +229,14 @@ void free_extent_state(struct extent_state *state)
 	}
 }
 
-static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
+static struct rb_node *tree_insert(struct rb_root *root,
+				   struct rb_node *search_start,
+				   u64 offset,
 				   struct rb_node *node,
 				   struct rb_node ***p_in,
 				   struct rb_node **parent_in)
 {
-	struct rb_node **p = &root->rb_node;
+	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct tree_entry *entry;
 
@@ -244,6 +246,7 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
 		goto do_insert;
 	}
 
+	p = search_start ? &search_start : &root->rb_node;
 	while (*p) {
 		parent = *p;
 		entry = rb_entry(parent, struct tree_entry, rb_node);
@@ -430,7 +433,7 @@ static int insert_state(struct extent_io_tree *tree,
 
 	set_state_bits(tree, state, bits);
 
-	node = tree_insert(&tree->state, end, &state->rb_node, p, parent);
+	node = tree_insert(&tree->state, NULL, end, &state->rb_node, p, parent);
 	if (node) {
 		struct extent_state *found;
 		found = rb_entry(node, struct extent_state, rb_node);
@@ -477,8 +480,8 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 	prealloc->state = orig->state;
 	orig->start = split;
 
-	node = tree_insert(&tree->state, prealloc->end, &prealloc->rb_node,
-			   NULL, NULL);
+	node = tree_insert(&tree->state, &orig->rb_node, prealloc->end,
+			   &prealloc->rb_node, NULL, NULL);
 	if (node) {
 		free_extent_state(prealloc);
 		return -EEXIST;
-- 
1.7.9.5

