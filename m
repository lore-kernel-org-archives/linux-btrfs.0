From: Diego Calleja <diegocg@gmail.com>
Subject: [PATCH] Remove useless check in find_delalloc_range
Date: Wed, 29 Jul 2009 01:43:06 +0200
Message-ID: <200907290143.06402.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

'found' is always 0 at that point, so the test is redundant.


Signed-off-by: Diego Calleja <diegocg@gmail.com>
---
 fs/btrfs/extent_io.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/fs/btrfs/extent_io.c
===================================================================
--- linux.orig/fs/btrfs/extent_io.c	2009-07-29 01:16:22.010765781 +0200
+++ linux/fs/btrfs/extent_io.c	2009-07-29 01:17:31.874765725 +0200
@@ -1092,8 +1092,7 @@ static noinline u64 find_delalloc_range(
 	 */
 	node = tree_search(tree, cur_start);
 	if (!node) {
-		if (!found)
-			*end = (u64)-1;
+		*end = (u64)-1;
 		goto out;
 	}
 
