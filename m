Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57784 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753243AbdHUMlI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 08:41:08 -0400
Subject: [PATCH 3/5] btrfs: Use common error handling code in
 btrfs_update_root()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
Message-ID: <287b99e6-6562-ea64-e763-6a6808fee12a@users.sourceforge.net>
Date: Mon, 21 Aug 2017 14:40:28 +0200
MIME-Version: 1.0
In-Reply-To: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 21 Aug 2017 13:10:15 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/btrfs/root-tree.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 5b488af6f25e..bc497ba9d9d1 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -145,10 +145,8 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		return -ENOMEM;
 
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
-	if (ret < 0) {
-		btrfs_abort_transaction(trans, ret);
-		goto out;
-	}
+	if (ret < 0)
+		goto abort_transaction;
 
 	if (ret != 0) {
 		btrfs_print_leaf(path->nodes[0]);
@@ -171,23 +169,17 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		btrfs_release_path(path);
 		ret = btrfs_search_slot(trans, root, key, path,
 				-1, 1);
-		if (ret < 0) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret < 0)
+			goto abort_transaction;
 
 		ret = btrfs_del_item(trans, root, path);
-		if (ret < 0) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret < 0)
+			goto abort_transaction;
 		btrfs_release_path(path);
 		ret = btrfs_insert_empty_item(trans, root, path,
 				key, sizeof(*item));
-		if (ret < 0) {
-			btrfs_abort_transaction(trans, ret);
-			goto out;
-		}
+		if (ret < 0)
+			goto abort_transaction;
 		l = path->nodes[0];
 		slot = path->slots[0];
 		ptr = btrfs_item_ptr_offset(l, slot);
@@ -204,6 +196,9 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 out:
 	btrfs_free_path(path);
 	return ret;
+abort_transaction:
+	btrfs_abort_transaction(trans, ret);
+	goto out;
 }
 
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-- 
2.14.0

