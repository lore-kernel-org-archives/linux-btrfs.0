Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751819AbdLAJTw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 04:19:52 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 31449AD30
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Dec 2017 09:19:51 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/5] btrfs: Remove dead code
Date: Fri,  1 Dec 2017 11:19:40 +0200
Message-Id: <1512119984-12708-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1512119984-12708-1-git-send-email-nborisov@suse.com>
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

trans was statically assigned to NULL and this never changed over the course of
btrfs_get_extent. So remove any code which checks whether trans != NULL and
just hardcode the fact trans is always NULL. This fixes CID#112806

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 57785eadb95c..92d140b06271 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6943,7 +6943,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	struct extent_map *em = NULL;
 	struct extent_map_tree *em_tree = &inode->extent_tree;
 	struct extent_io_tree *io_tree = &inode->io_tree;
-	struct btrfs_trans_handle *trans = NULL;
 	const bool new_inline = !page || create;
 
 	read_lock(&em_tree->lock);
@@ -6984,8 +6983,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		path->reada = READA_FORWARD;
 	}
 
-	ret = btrfs_lookup_file_extent(trans, root, path,
-				       objectid, start, trans != NULL);
+	ret = btrfs_lookup_file_extent(NULL, root, path, objectid, start, 0);
 	if (ret < 0) {
 		err = ret;
 		goto out;
@@ -7181,11 +7179,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	trace_btrfs_get_extent(root, inode, em);
 
 	btrfs_free_path(path);
-	if (trans) {
-		ret = btrfs_end_transaction(trans);
-		if (!err)
-			err = ret;
-	}
 	if (err) {
 		free_extent_map(em);
 		return ERR_PTR(err);
-- 
2.7.4

