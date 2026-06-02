Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2519E3E9C3A
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780409663; cv=none; b=PDXY7gZVMpVvSbvNJ/udPk8n7wS7EzwbFzYlLt13/jKLfmpHnUa1N+gIYzREvV9FfMWnZmPduR5AEo958eIWnQRnkw2WbHmJn/WSATKij04wxQQ5PWYB02jCayHZ7BCvIQMBiff7jVfZBdnsNrNxOhPN47+AseG66UqBIAuxQMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780409663; c=relaxed/simple;
	bh=MrXOaTIDXdAVFAhZDf7Fukb6tIhqk7RyK7vb/fvrwkE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=R2QXZ8+gMnN1bHKL7dwAA74WMfRnL6YHGiwUurXmfwBZVeIHYeDN72E1+h0MlEzOBVRfjYf/fKqAC2fFFtGTfny3jbNuBi0qRCRjAeNYwZjCsTf5MtzXu7ezwFS+/IuKSCJg9XFC1uzNtV/r+h9YXl+GlV8UARIBurtL43GNKOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+DMg5q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+DMg5q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D38B1F00898
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780409662;
	bh=GJOx4YO1dhSQfZ20U908mJ18sNK8XI2qc5YqZXJdFXY=;
	h=From:To:Subject:Date;
	b=X+DMg5q7rL56RKz+OY36nVu9PyZA/ycc9y/3roI+UXeBSZqPbhpKHbdbMAWIprShE
	 18t8jMmJY7Np8HdQPfFOuHST4BFwTexsAKs0Y60FN1Tobyb4co3R3qJ/8UV/fXYoYM
	 VuQn1FY1UWtM5LJBvH/6B5ueP3f41jX3MCQUZXEb2k/lc/Lmjb2GYze3K/6PpEe/na
	 G1b/fKKukb0tsyR4QrR2o9QPVTQWtutqysvAPTSfRxcagNxd//dOz/Bu0S/qFtMjLS
	 qq1106AvII3nmSC0RGsY6a0aLhrV5uJVCn93eFTVUvGaWH+1wmtm6DcQTTsziodmaY
	 78480tv/gERNA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use verbose assertions in backref.c
Date: Tue,  2 Jun 2026 15:14:11 +0100
Message-ID: <b6f6b52824e4b9e6ee9f883e09e53da9eb8152ee.1780409231.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

While debugging a relocation issue I hit an assertion in backref.c but it
was not super useful, since it could not tell what was the unexpected
value that triggered the assertion. The stack trace was this:

  [583246.338097] assertion failed: !cache->nr_nodes, in fs/btrfs/backref.c:3158
  [583246.339588] ------------[ cut here ]------------
  [583246.340573] kernel BUG at fs/btrfs/backref.c:3158!
  [583246.342075] Oops: invalid opcode: 0000 [#1] SMP PTI
  [583246.343294] CPU: 5 UID: 0 PID: 677957 Comm: btrfs Not tainted 7.1.0-rc4-btrfs-next-234+ #1 PREEMPT(full)
  [583246.345715] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
  [583246.348694] RIP: 0010:btrfs_backref_release_cache.cold+0x61/0x84 [btrfs]
  [583246.350759] Code: 90 d5 7c (...)
  [583246.354923] RSP: 0018:ffffd4fc88c93ad8 EFLAGS: 00010246
  [583246.355982] RAX: 000000000000003e RBX: ffff8dec90d97020 RCX: 0000000000000000
  [583246.357459] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000ffffffff
  [583246.359517] RBP: ffff8dec8eeb78c0 R08: 0000000000000000 R09: 3fffffffffefffff
  [583246.361180] R10: ffffd4fc88c93970 R11: 0000000000000003 R12: ffff8decd21f3470
  [583246.363184] R13: 00000000fffffffe R14: ffff8decd21f3000 R15: ffff8decd21f3000
  [583246.364666] FS:  00007f9a51751400(0000) GS:ffff8df3f4255000(0000) knlGS:0000000000000000
  [583246.366287] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [583246.367443] CR2: 00007f9a518ed8f5 CR3: 00000004467c8002 CR4: 0000000000370ef0
  [583246.368969] Call Trace:
  [583246.369541]  <TASK>
  [583246.370040]  relocate_block_group+0xf2/0x520 [btrfs]
  [583246.371243]  btrfs_relocate_block_group+0x9a9/0x22e0 [btrfs]
  [583246.372443]  ? preempt_count_add+0x47/0xa0
  [583247.532978]  ? btrfs_tree_read_lock_nested+0x19/0x90 [btrfs]
  [583247.534520]  ? mutex_lock+0x1a/0x40
  [583247.602233]  ? btrfs_scrub_pause+0x2e/0x120 [btrfs]
  [583247.603543]  btrfs_relocate_chunk+0x3b/0x1a0 [btrfs]
  [583247.604893]  btrfs_balance+0x9d5/0x1920 [btrfs]
  [583247.606189]  ? preempt_count_add+0x69/0xa0
  [583247.607030]  btrfs_ioctl+0x260c/0x2a20 [btrfs]
  [583247.608015]  ? __memcg_slab_free_hook+0x156/0x1a0
  [583247.636971]  __x64_sys_ioctl+0x92/0xe0
  [583247.679247]  do_syscall_64+0x60/0xf20
  [583247.753297]  ? clear_bhb_loop+0x60/0xb0
  [583247.756321]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [583247.787018] RIP: 0033:0x7f9a5186a8db
  [583247.787787] Code: 00 48 89 (...)
  [583247.791410] RSP: 002b:00007fff2ffa6ac0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  [583247.792897] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f9a5186a8db
  [583247.794319] RDX: 00007fff2ffa6bb0 RSI: 00000000c4009420 RDI: 0000000000000003
  [583247.795714] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
  [583247.797149] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff2ffa903f
  [583247.798685] R13: 00007fff2ffa6bb0 R14: 0000000000000002 R15: 0000000000000002
  [583247.800136]  </TASK>

So update all simple assertions in backref.c to print out the values when
they aren't testing simple boolean conditions.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/backref.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 0abcec0ceead..23c3eeb58dc1 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1256,7 +1256,7 @@ static bool lookup_backref_shared_cache(struct btrfs_backref_share_check_ctx *ct
 	 * realizing. We cache results only for extent buffers that lead from
 	 * the root node down to the leaf with the file extent item.
 	 */
-	ASSERT(level >= 0);
+	ASSERT(level >= 0, "level=%d", level);
 
 	entry = &ctx->path_cache_entries[level];
 
@@ -1327,7 +1327,7 @@ static void store_backref_shared_cache(struct btrfs_backref_share_check_ctx *ctx
 	 * realizing. We cache results only for extent buffers that lead from
 	 * the root node down to the leaf with the file extent item.
 	 */
-	ASSERT(level >= 0);
+	ASSERT(level >= 0, "level=%d", level);
 
 	if (is_shared)
 		gen = btrfs_get_last_root_drop_gen(fs_info);
@@ -2964,7 +2964,9 @@ int btrfs_backref_iter_next(struct btrfs_fs_info *fs_info, struct btrfs_backref_
 
 	if (btrfs_backref_iter_is_inline_ref(iter)) {
 		/* We're still inside the inline refs */
-		ASSERT(iter->cur_ptr < iter->end_ptr);
+		ASSERT(iter->cur_ptr < iter->end_ptr,
+		       "iter->cur_ptr=%u iter->end_ptr=%u",
+		       iter->cur_ptr, iter->end_ptr);
 
 		if (btrfs_backref_has_tree_block_info(iter)) {
 			/* First tree block info */
@@ -3030,7 +3032,7 @@ struct btrfs_backref_node *btrfs_backref_alloc_node(
 {
 	struct btrfs_backref_node *node;
 
-	ASSERT(level >= 0 && level < BTRFS_MAX_LEVEL);
+	ASSERT(level >= 0 && level < BTRFS_MAX_LEVEL, "level=%d", level);
 	node = kzalloc_obj(*node, GFP_NOFS);
 	if (!node)
 		return node;
@@ -3052,7 +3054,7 @@ void btrfs_backref_free_node(struct btrfs_backref_cache *cache,
 	if (node) {
 		ASSERT(list_empty(&node->list));
 		ASSERT(list_empty(&node->lower));
-		ASSERT(node->eb == NULL);
+		ASSERT(node->eb == NULL, "node->eb->start=%llu", node->eb->start);
 		cache->nr_nodes--;
 		btrfs_put_root(node->root);
 		kfree(node);
@@ -3155,15 +3157,18 @@ void btrfs_backref_release_cache(struct btrfs_backref_cache *cache)
 
 	ASSERT(list_empty(&cache->pending_edge));
 	ASSERT(list_empty(&cache->useless_node));
-	ASSERT(!cache->nr_nodes);
-	ASSERT(!cache->nr_edges);
+	ASSERT(!cache->nr_nodes, "cache->nr_nodes=%d", cache->nr_nodes);
+	ASSERT(!cache->nr_edges, "cache->nr_edges=%d", cache->nr_edges);
 }
 
 static void btrfs_backref_link_edge(struct btrfs_backref_edge *edge,
 				    struct btrfs_backref_node *lower,
 				    struct btrfs_backref_node *upper)
 {
-	ASSERT(upper && lower && upper->level == lower->level + 1);
+	ASSERT(upper != NULL);
+	ASSERT(lower != NULL);
+	ASSERT(upper->level == lower->level + 1, "upper->level=%d lower->level=%d",
+	       upper->level, lower->level);
 	edge->node[LOWER] = lower;
 	edge->node[UPPER] = upper;
 	list_add_tail(&edge->list[LOWER], &lower->upper);
@@ -3283,7 +3288,9 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
 
 	if (btrfs_root_level(&root->root_item) == cur->level) {
 		/* Tree root */
-		ASSERT(btrfs_root_bytenr(&root->root_item) == cur->bytenr);
+		ASSERT(btrfs_root_bytenr(&root->root_item) == cur->bytenr,
+		       "root_bytenr=%llu cur->bytenr=%llu",
+		       btrfs_root_bytenr(&root->root_item), cur->bytenr);
 		/*
 		 * For reloc backref cache, we may ignore reloc root.  But for
 		 * general purpose backref cache, we can't rely on
@@ -3333,8 +3340,9 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
 	/* Add all nodes and edges in the path */
 	for (; level < BTRFS_MAX_LEVEL; level++) {
 		if (!path->nodes[level]) {
-			ASSERT(btrfs_root_bytenr(&root->root_item) ==
-			       lower->bytenr);
+			ASSERT(btrfs_root_bytenr(&root->root_item) == lower->bytenr,
+			       "root_bytenr=%llu lower->bytenr=%llu",
+			       btrfs_root_bytenr(&root->root_item), lower->bytenr);
 			/* Same as previous should_ignore_reloc_root() call */
 			if (btrfs_should_ignore_reloc_root(root) &&
 			    cache->is_reloc) {
-- 
2.47.2

