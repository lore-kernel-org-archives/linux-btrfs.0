Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33125 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaI3OlC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 10:41:02 -0400
Received: by mail-pd0-f172.google.com with SMTP id p10so2938717pdj.17
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 07:41:01 -0700 (PDT)
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: bo.li.liu@oracle.com
Subject: [PATCH] btrfs-progs: do not reclaim extent buffer
Date: Tue, 30 Sep 2014 23:40:56 +0900
Message-ID: <87zjdh41dz.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should kill free_some_buffers() to stop reclaiming extent buffers or
we will hit a problem described below.

As of commit 53ee1bccf99cd5b474fe1aa857b7dd176e3a1407, we are not
counting a reference for tree->lru anymore. However free_some_buffers()
is still left and is reclaiming extent buffers whose @refs == 1. This
cause extent buffers to be reclaimed unintentionally. Thus the following
steps could happen:

1. A buffer at address A is reclaimed by free_some_buffers()
   (address A is also free()ed)
2. Some code call alloc_extent_buffer()
3. Address A is assigned to newly allocated buffer
4. You see a buffer pointed by A suddenly changed its content

This problem is also pointed out here and it has a reproducer:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36703.html

This commit drop free_some_buffers() and related variables, and also it
modify extent_io_tree_cleanup() to catch non-free'ed buffers properly.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 extent_io.c | 37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/extent_io.c b/extent_io.c
index 1df377d..425af8a 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -30,9 +30,6 @@
 #include "ctree.h"
 #include "volumes.h"
 
-static u64 cache_soft_max = 1024 * 1024 * 256;
-static u64 cache_hard_max = 1 * 1024 * 1024 * 1024;
-
 void extent_io_tree_init(struct extent_io_tree *tree)
 {
 	cache_tree_init(&tree->state);
@@ -77,12 +74,9 @@ void extent_io_tree_cleanup(struct extent_io_tree *tree)
 
 	while(!list_empty(&tree->lru)) {
 		eb = list_entry(tree->lru.next, struct extent_buffer, lru);
-		if (eb->refs != 1) {
-			fprintf(stderr, "extent buffer leak: "
-				"start %llu len %u\n",
-				(unsigned long long)eb->start, eb->len);
-			eb->refs = 1;
-		}
+		fprintf(stderr, "extent buffer leak: "
+			"start %llu len %u\n",
+			(unsigned long long)eb->start, eb->len);
 		free_extent_buffer(eb);
 	}
 
@@ -541,30 +535,6 @@ out:
 	return ret;
 }
 
-static int free_some_buffers(struct extent_io_tree *tree)
-{
-	u32 nrscan = 0;
-	struct extent_buffer *eb;
-	struct list_head *node, *next;
-
-	if (tree->cache_size < cache_soft_max)
-		return 0;
-
-	list_for_each_safe(node, next, &tree->lru) {
-		eb = list_entry(node, struct extent_buffer, lru);
-		if (eb->refs == 1 && !(eb->flags & EXTENT_DIRTY)) {
-			free_extent_buffer(eb);
-			if (tree->cache_size < cache_hard_max)
-				break;
-		} else {
-			list_move_tail(&eb->lru, &tree->lru);
-		}
-		if (nrscan++ > 64 && tree->cache_size < cache_hard_max)
-			break;
-	}
-	return 0;
-}
-
 static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 						   u64 bytenr, u32 blocksize)
 {
@@ -589,7 +559,6 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->cache_node.size = blocksize;
 	INIT_LIST_HEAD(&eb->recow);
 
-	free_some_buffers(tree);
 	ret = insert_cache_extent(&tree->cache, &eb->cache_node);
 	if (ret) {
 		free(eb);
-- 
2.1.1

