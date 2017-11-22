Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:47604 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdKVJEC (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 22 Nov 2017 04:04:02 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 02/11] btrfs-progs: lowmem check: Fix NULL pointer access caused by large tree reloc tree
Date: Wed, 22 Nov 2017 17:03:16 +0800
Message-Id: <20171122090325.29458-3-wqu@suse.com>
In-Reply-To: <20171122090325.29458-1-wqu@suse.com>
References: <20171122090325.29458-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
v4.14 btrfs-progs can't pass new self test image with large tree reloc
trees.
It will fail with later "shared_block_ref_only.raw.xz" test image with
NULL pointer access.

[CAUSE]
For image with higher (level >= 2) tree reloc tree, for function
need_check() its ulist will be empty as tree reloc tree won't be
accounted in btrfs_find_all_roots().
Then accessing ulist->roots with rb_first() will return NULL pointer.

[FIX]
For need_check() function, if @roots is empty, meaning it's a tree reloc
tree, always check them.
Although this can be slow, but at least it's safe that we won't skip any
possible wrong tree block.

Fixes: 5e2dc770471b ("btrfs-progs: check: skip shared node or leaf check for low_memory mode")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 644ee084cb8e..03ff89a4221c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2149,7 +2149,12 @@ static int need_check(struct btrfs_root *root, struct ulist *roots)
 	struct rb_node *node;
 	struct ulist_node *u;
 
-	if (roots->nnodes == 1)
+	/*
+	 * @roots can be empty if it belongs to tree reloc tree
+	 * In that case, we should always check the leaf, as we can't use
+	 * the tree owner to ensure some other root will check it.
+	 */
+	if (roots->nnodes == 1 || roots->nnodes == 0)
 		return 1;
 
 	node = rb_first(&roots->root);
-- 
2.15.0

