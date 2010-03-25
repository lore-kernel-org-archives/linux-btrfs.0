From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 11/18] btrfs: Simplify btrfs_search_slot() for performance
Date: Thu, 25 Mar 2010 20:34:27 +0800
Message-ID: <4BAB5853.9030402@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

This patch include following modify:
1: It isn't necessary to use following type of goto statement:
     if (cow) {
         if (!should_cow_block(trans, root, b))
             goto cow_done;
         ...
     }
     cow_done:
     ...
2: Updating of p->nodes[level] is only necessary on cow.
   we move these code into if (cow) {} block.
3: Updating of level and p->locks[level] is only necessary when
   level is changed, so we avoid no-use operation in old code.
4: Add a unlikely() for rare case.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.c |   34 ++++++++++++++++------------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c4bc570..4f258ba 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1724,15 +1724,12 @@ again:
 		if (!p->skip_locking)
 			p->locks[level] = 1;
 
-		if (cow) {
-			/*
-			 * if we don't really need to cow this block
-			 * then we don't want to set the path blocking,
-			 * so we test it here
-			 */
-			if (!should_cow_block(trans, root, b))
-				goto cow_done;
-
+		/*
+		 * if we don't really need to cow this block
+		 * then we don't want to set the path blocking,
+		 * so we test it here
+		 */
+		if (cow && should_cow_block(trans, root, b)) {
 			btrfs_set_path_blocking(p);
 
 			err = btrfs_cow_block(trans, root, b,
@@ -1743,17 +1740,18 @@ again:
 				ret = err;
 				goto done;
 			}
-		}
-cow_done:
-		BUG_ON(!cow && ins_len);
-		if (level != btrfs_header_level(b))
-			WARN_ON(1);
-		level = btrfs_header_level(b);
 
-		p->nodes[level] = b;
-		if (!p->skip_locking)
-			p->locks[level] = 1;
+			if (unlikely(level != btrfs_header_level(b))) {
+				WARN_ON(1);
+				level = btrfs_header_level(b);
+				if (!p->skip_locking)
+					p->locks[level] = 1;
+			}
 
+			p->nodes[level] = b;
+		}
+
+		BUG_ON(!cow && ins_len);
 		btrfs_clear_path_blocking(p, NULL);
 
 		/*
-- 
1.6.5.2


