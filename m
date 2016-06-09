Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48006 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbcFIQxS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 12:53:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D7C77202A1
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jun 2016 16:53:16 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id A5ADC20295
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jun 2016 16:53:15 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: be more precise on errors when getting an inode from disk
Date: Thu,  9 Jun 2016 17:53:10 +0100
Message-Id: <1465491191-28102-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When we attempt to read an inode from disk, we end up always returning an
-ESTALE error to the caller regardless of the actual failure reason, which
can be an out of memory problem (when allocating a path), some error found
when reading from the fs/subvolume btree (like a genuine IO error) or the
inode does not exists. So lets start returning the real error code to the
callers so that they don't treat all -ESTALE errors as meaning that the
inode does not exists (such as during orphan cleanup). This will also be
needed for a subsequent patch in the same series dealing with a special
fsync case.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e5558d9..1ae0fc8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3419,10 +3419,10 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		found_key.offset = 0;
 		inode = btrfs_iget(root->fs_info->sb, &found_key, root, NULL);
 		ret = PTR_ERR_OR_ZERO(inode);
-		if (ret && ret != -ESTALE)
+		if (ret && ret != -ENOENT)
 			goto out;
 
-		if (ret == -ESTALE && root == root->fs_info->tree_root) {
+		if (ret == -ENOENT && root == root->fs_info->tree_root) {
 			struct btrfs_root *dead_root;
 			struct btrfs_fs_info *fs_info = root->fs_info;
 			int is_dead_root = 0;
@@ -3458,7 +3458,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * Inode is already gone but the orphan item is still there,
 		 * kill the orphan item.
 		 */
-		if (ret == -ESTALE) {
+		if (ret == -ENOENT) {
 			trans = btrfs_start_transaction(root, 1);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
@@ -3617,7 +3617,7 @@ static noinline int acls_after_inode_item(struct extent_buffer *leaf,
 /*
  * read an inode from the btree into the in-memory inode
  */
-static void btrfs_read_locked_inode(struct inode *inode)
+static int btrfs_read_locked_inode(struct inode *inode)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -3636,14 +3636,19 @@ static void btrfs_read_locked_inode(struct inode *inode)
 		filled = true;
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		ret = -ENOMEM;
 		goto make_bad;
+	}
 
 	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
 
 	ret = btrfs_lookup_inode(NULL, root, path, &location, 0);
-	if (ret)
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
 		goto make_bad;
+	}
 
 	leaf = path->nodes[0];
 
@@ -3796,11 +3801,12 @@ cache_acl:
 	}
 
 	btrfs_update_iflags(inode);
-	return;
+	return 0;
 
 make_bad:
 	btrfs_free_path(path);
 	make_bad_inode(inode);
+	return ret;
 }
 
 /*
@@ -5585,7 +5591,9 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 		return ERR_PTR(-ENOMEM);
 
 	if (inode->i_state & I_NEW) {
-		btrfs_read_locked_inode(inode);
+		int ret;
+
+		ret = btrfs_read_locked_inode(inode);
 		if (!is_bad_inode(inode)) {
 			inode_tree_add(inode);
 			unlock_new_inode(inode);
@@ -5594,7 +5602,8 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 		} else {
 			unlock_new_inode(inode);
 			iput(inode);
-			inode = ERR_PTR(-ESTALE);
+			ASSERT(ret < 0);
+			inode = ERR_PTR(ret < 0 ? ret : -ESTALE);
 		}
 	}
 
-- 
2.7.0.rc3

