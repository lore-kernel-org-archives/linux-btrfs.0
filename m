From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 2/7] btrfs: Don't BUG_ON alloc_path errors in replay_one_buffer()
Date: Thu, 14 Jul 2011 15:14:57 -0700
Message-ID: <1310681702-13922-3-git-send-email-mfasheh@suse.com>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com>
 <1310681702-13922-2-git-send-email-mfasheh@suse.com>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310681702-13922-2-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

The two ->process_func call sites in tree-log.c which were ignoring a return
code have also been updated to gracefully exit as well.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/tree-log.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4ce8a9f..f3cacc0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1617,7 +1617,8 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 		return 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	nritems = btrfs_header_nritems(eb);
 	for (i = 0; i < nritems; i++) {
@@ -1723,7 +1724,9 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 			return -ENOMEM;
 
 		if (*level == 1) {
-			wc->process_func(root, next, wc, ptr_gen);
+			ret = wc->process_func(root, next, wc, ptr_gen);
+			if (ret)
+				return ret;
 
 			path->slots[*level]++;
 			if (wc->free) {
@@ -1788,8 +1791,11 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 				parent = path->nodes[*level + 1];
 
 			root_owner = btrfs_header_owner(parent);
-			wc->process_func(root, path->nodes[*level], wc,
+			ret = wc->process_func(root, path->nodes[*level], wc,
 				 btrfs_header_generation(path->nodes[*level]));
+			if (ret)
+				return ret;
+
 			if (wc->free) {
 				struct extent_buffer *next;
 
-- 
1.7.5.3

