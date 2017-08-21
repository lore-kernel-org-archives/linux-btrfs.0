Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751897AbdHUJn4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 05:43:56 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2E54FABBC
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:43:55 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 05/10] btrfs: Remove unused arguments from btrfs_changed_cb_t
Date: Mon, 21 Aug 2017 12:43:45 +0300
Message-Id: <1503308630-6652-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1503308630-6652-1-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_changed_cb_t represents the signature of the callback being passed to
btrfs_compare_trees. Currently there is only one such callback, namely
changed_cb in send.c. This function doesn't really uses the first 2 parameters,
i.e. the roots. Since there are not other functions implementing the
btrfs_changed_cb_t let's remove the unused parameters from the prototype and
implementation

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 15 +++++----------
 fs/btrfs/ctree.h |  4 +---
 fs/btrfs/send.c  |  8 +++-----
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6d49db7d86be..19b9c5131745 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5496,8 +5496,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 			goto out;
 		} else if (left_end_reached) {
 			if (right_level == 0) {
-				ret = changed_cb(left_root, right_root,
-						left_path, right_path,
+				ret = changed_cb(left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
 						ctx);
@@ -5508,8 +5507,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 			continue;
 		} else if (right_end_reached) {
 			if (left_level == 0) {
-				ret = changed_cb(left_root, right_root,
-						left_path, right_path,
+				ret = changed_cb(left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
 						ctx);
@@ -5523,8 +5521,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 		if (left_level == 0 && right_level == 0) {
 			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
 			if (cmp < 0) {
-				ret = changed_cb(left_root, right_root,
-						left_path, right_path,
+				ret = changed_cb(left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
 						ctx);
@@ -5532,8 +5529,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 					goto out;
 				advance_left = ADVANCE;
 			} else if (cmp > 0) {
-				ret = changed_cb(left_root, right_root,
-						left_path, right_path,
+				ret = changed_cb(left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
 						ctx);
@@ -5550,8 +5546,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 					result = BTRFS_COMPARE_TREE_CHANGED;
 				else
 					result = BTRFS_COMPARE_TREE_SAME;
-				ret = changed_cb(left_root, right_root,
-						 left_path, right_path,
+				ret = changed_cb(left_path, right_path,
 						 &left_key, result, ctx);
 				if (ret < 0)
 					goto out;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ca087ad5ac48..260d8464fac4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2811,9 +2811,7 @@ enum btrfs_compare_tree_result {
 	BTRFS_COMPARE_TREE_CHANGED,
 	BTRFS_COMPARE_TREE_SAME,
 };
-typedef int (*btrfs_changed_cb_t)(struct btrfs_root *left_root,
-				  struct btrfs_root *right_root,
-				  struct btrfs_path *left_path,
+typedef int (*btrfs_changed_cb_t)(struct btrfs_path *left_path,
 				  struct btrfs_path *right_path,
 				  struct btrfs_key *key,
 				  enum btrfs_compare_tree_result result,
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 85a9509a9cbd..d7a8a7aed657 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6169,9 +6169,7 @@ static int compare_refs(struct send_ctx *sctx, struct btrfs_path *path,
  * Updates compare related fields in sctx and simply forwards to the actual
  * changed_xxx functions.
  */
-static int changed_cb(struct btrfs_root *left_root,
-		      struct btrfs_root *right_root,
-		      struct btrfs_path *left_path,
+static int changed_cb(struct btrfs_path *left_path,
 		      struct btrfs_path *right_path,
 		      struct btrfs_key *key,
 		      enum btrfs_compare_tree_result result,
@@ -6253,8 +6251,8 @@ static int full_send_tree(struct send_ctx *sctx)
 		slot = path->slots[0];
 		btrfs_item_key_to_cpu(eb, &found_key, slot);
 
-		ret = changed_cb(send_root, NULL, path, NULL,
-				&found_key, BTRFS_COMPARE_TREE_NEW, sctx);
+		ret = changed_cb(path, NULL, &found_key,
+				 BTRFS_COMPARE_TREE_NEW, sctx);
 		if (ret < 0)
 			goto out;
 
-- 
2.7.4

