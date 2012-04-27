From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs: kill unreachable code in push_node_left
Date: Fri, 27 Apr 2012 17:03:50 +0200
Message-ID: <1335539030-17306-1-git-send-email-list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We had the following code in push_node_left:

	x = min(y, x);
        if (x < y) {
		/* confusing comment here */
		...
	}

That if's condition can't become true, so just kill the entire block. Plus:
no one will ever need to worry about the removed confusing comment.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e801f22..0d2f4e5 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1999,19 +1999,9 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 	if (push_items <= 0)
 		return 1;
 
-	if (empty) {
+	if (empty)
 		push_items = min(src_nritems, push_items);
-		if (push_items < src_nritems) {
-			/* leave at least 8 pointers in the node if
-			 * we aren't going to empty it
-			 */
-			if (src_nritems - push_items < 8) {
-				if (push_items <= 8)
-					return 1;
-				push_items -= 8;
-			}
-		}
-	} else
+	else
 		push_items = min(src_nritems - 8, push_items);
 
 	copy_extent_buffer(dst, src,
-- 
1.7.3.4

