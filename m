From: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 2/3] btrfs: Fix ulist related problems in backref walking code
Date: Fri,  4 May 2012 20:54:24 +0200
Message-ID: <1336157665-17328-2-git-send-email-ablock84@googlemail.com>
References: <1336157665-17328-1-git-send-email-ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org,
	Alexander Block <ablock84@googlemail.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1336157665-17328-1-git-send-email-ablock84@googlemail.com>
List-ID: <linux-btrfs.vger.kernel.org>

1. in btrfs_find_all_roots
   This method uses a ulist to solve the recursion. The local variable
   node is used in combination with ulist_next to iterate through the
   list. Calls to find_parent_nodes fill up this list. The problem is,
   adding new nodes to the ulist may cause the ulist->nodes pointer to
   change in case the ulist needs to realloc the buffer. The call to
   ulist_next may use a wrong prev pointer in that case, resulting in
   undefined behaviour. It is changed now to not use ulist_next.
2. in __iterate_extent_inodes
   the first while loop calls btrfs_find_all_roots, which then allocates
   a new ulist for the roots. In case the first while loops loops more
   then once, we leak the previous ulist as it is not freed.

Point 1 was also causing missed backrefs because the iteration stopped
too early.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/backref.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f28ecba..b08cf93 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -791,6 +791,7 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
 	int ret;
+	int cur;
 
 	tmp = ulist_alloc(GFP_NOFS);
 	if (!tmp)
@@ -801,7 +802,14 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
-	while (1) {
+	cur = 0;
+	ulist_add(tmp, bytenr, 0, GFP_NOFS);
+
+	while (cur < tmp->nnodes) {
+		node = &tmp->nodes[cur++];
+		bytenr = node->val;
+
+		/* this will add new nodes to the tmp ulist */
 		ret = find_parent_nodes(trans, fs_info, bytenr, seq,
 					tmp, *roots);
 		if (ret < 0 && ret != -ENOENT) {
@@ -809,10 +817,6 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 			ulist_free(*roots);
 			return ret;
 		}
-		node = ulist_next(tmp, node);
-		if (!node)
-			break;
-		bytenr = node->val;
 	}
 
 	ulist_free(tmp);
@@ -1231,10 +1235,14 @@ static int __iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 						match_with_offset,
 						iterate, ctx);
 		}
+		if (roots)
+			ulist_free(roots);
+		roots = NULL;
 	}
 
 	ulist_free(refs);
-	ulist_free(roots);
+	if (roots)
+		ulist_free(roots);
 out:
 	if (!search_commit_root) {
 		btrfs_put_delayed_seq(delayed_refs, &seq_elem);
-- 
1.7.3.4

