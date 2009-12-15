From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/4] btrfs: fix the bug that __tree_search() returns the wrong
 result in extent_map.c
Date: Tue, 15 Dec 2009 14:54:08 +0800
Message-ID: <4B273290.6090503@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

__tree_search() returns the reverse result about the prev node and the next node. And we can
get the prev node and the next node directly by rb_prev() and rb_next(), so it is unnecessary
to use while loop to get them.

This patch fixes this bug of the wrong result.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_map.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 46bea0f..16744f4 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -136,20 +136,15 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
 
 	if (prev_ret) {
 		orig_prev = prev;
-		while (prev && offset >= extent_map_end(prev_entry)) {
-			prev = rb_next(prev);
-			prev_entry = rb_entry(prev, struct extent_map, rb_node);
-		}
+		if (prev && offset < prev_entry->start)
+			prev = rb_prev(prev);
 		*prev_ret = prev;
 		prev = orig_prev;
 	}
 
 	if (next_ret) {
-		prev_entry = rb_entry(prev, struct extent_map, rb_node);
-		while (prev && offset < prev_entry->start) {
-			prev = rb_prev(prev);
-			prev_entry = rb_entry(prev, struct extent_map, rb_node);
-		}
+		if (prev && offset >= extent_map_end(prev_entry))
+			prev = rb_next(prev);
 		*next_ret = prev;
 	}
 	return NULL;
-- 
1.6.5.2


