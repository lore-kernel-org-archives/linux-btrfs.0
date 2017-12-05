Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53275 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751852AbdLELx3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 06:53:29 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1DB20AE1A
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 11:53:28 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove dead code btrfs_get_extent
Date: Tue,  5 Dec 2017 13:53:25 +0200
Message-Id: <1512474805-30223-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20171204134521.GV3553@twin.jikos.cz>
References: <20171204134521.GV3553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

trans was statically assigned to NULL and this never changes over the course of
btrfs_get_extent. This was added in commit a52d9a8033c4 ("Btrfs: Extent based
page cache code.  This uses an rbtree of extents and tests instead of buffer
heads.") and wasn't used even then, which indicates it was never intended to be
merged. So remove any code which checks whether trans != NULL and
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

