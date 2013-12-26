Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31668 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab3LZFLj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Dec 2013 00:11:39 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBQ5BZ6x004287
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Dec 2013 13:11:35 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: remove unused argument from select_reloc_root()
Date: Thu, 26 Dec 2013 13:10:49 +0800
Message-Id: <1388034651-2778-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@nr is no longer used, remove it from select_reloc_root()

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8cf99c4..277b8e3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2454,7 +2454,7 @@ static noinline_for_stack
 struct btrfs_root *select_reloc_root(struct btrfs_trans_handle *trans,
 				     struct reloc_control *rc,
 				     struct backref_node *node,
-				     struct backref_edge *edges[], int *nr)
+				     struct backref_edge *edges[])
 {
 	struct backref_node *next;
 	struct btrfs_root *root;
@@ -2496,7 +2496,6 @@ struct btrfs_root *select_reloc_root(struct btrfs_trans_handle *trans,
 	if (!root)
 		return NULL;
 
-	*nr = index;
 	next = node;
 	/* setup backref node path for btrfs_reloc_cow_block */
 	while (1) {
@@ -2643,7 +2642,6 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 	u32 blocksize;
 	u64 bytenr;
 	u64 generation;
-	int nr;
 	int slot;
 	int ret;
 	int err = 0;
@@ -2656,7 +2654,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 		cond_resched();
 
 		upper = edge->node[UPPER];
-		root = select_reloc_root(trans, rc, upper, edges, &nr);
+		root = select_reloc_root(trans, rc, upper, edges);
 		BUG_ON(!root);
 
 		if (upper->eb && !upper->locked) {
-- 
1.8.3.1

