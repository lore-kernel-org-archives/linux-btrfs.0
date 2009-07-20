From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix corner case in btrfs_next_leaf
Date: Mon, 20 Jul 2009 19:27:44 +0800
Message-ID: <4A6454B0.4030703@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

if 1 is returned by btrfs_search_slot, the path already points to the
first item with 'key > searching key'. So increasing path->slots[0] by
one is superfluous in that case.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.c 2/fs/btrfs/ctree.c
--- 1/fs/btrfs/ctree.c	2009-07-17 16:05:20.583924545 +0800
+++ 2/fs/btrfs/ctree.c	2009-07-20 14:52:49.715697336 +0800
@@ -4146,7 +4175,8 @@ again:
 	 * advance the path if there are now more items available.
 	 */
 	if (nritems > 0 && path->slots[0] < nritems - 1) {
-		path->slots[0]++;
+		if (ret == 0)
+			path->slots[0]++;
 		ret = 0;
 		goto done;
 	}

