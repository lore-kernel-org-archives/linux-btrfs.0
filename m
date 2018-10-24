Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F445C004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 09:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9BE92075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 09:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VaKRAGpa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9BE92075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbeJXRk3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 13:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbeJXRk3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 13:40:29 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF6882075D;
        Wed, 24 Oct 2018 09:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540372390;
        bh=pn4qgeCNd6VY/KALZAeG21tVrd53JOv8n/h/Kr+S82E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaKRAGpay0udOa8JniNHJcT7C45XbTW7kALE/gVf58/hVpxnzXi86RjlMYjh2o8VQ
         QtUJyyccf+Fh1KKqMyUi00BT/YIF888kzrADex0j264LBPdJMJiTbc5Vttc7qRWQFA
         UFHqtb/fH0nwEbehDQBPxyqcJe5PsFQDwKLDhTNE=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     josef@toxicpanda.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v4] Btrfs: fix deadlock on tree root leaf when finding free extent
Date:   Wed, 24 Oct 2018 10:13:03 +0100
Message-Id: <20181024091303.20324-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181022090946.1150-1-fdmanana@kernel.org>
References: <20181022090946.1150-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When we are writing out a free space cache, during the transaction commit
phase, we can end up in a deadlock which results in a stack trace like the
following:

 schedule+0x28/0x80
 btrfs_tree_read_lock+0x8e/0x120 [btrfs]
 ? finish_wait+0x80/0x80
 btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
 btrfs_search_slot+0xf6/0x9f0 [btrfs]
 ? evict_refill_and_join+0xd0/0xd0 [btrfs]
 ? inode_insert5+0x119/0x190
 btrfs_lookup_inode+0x3a/0xc0 [btrfs]
 ? kmem_cache_alloc+0x166/0x1d0
 btrfs_iget+0x113/0x690 [btrfs]
 __lookup_free_space_inode+0xd8/0x150 [btrfs]
 lookup_free_space_inode+0x5b/0xb0 [btrfs]
 load_free_space_cache+0x7c/0x170 [btrfs]
 ? cache_block_group+0x72/0x3b0 [btrfs]
 cache_block_group+0x1b3/0x3b0 [btrfs]
 ? finish_wait+0x80/0x80
 find_free_extent+0x799/0x1010 [btrfs]
 btrfs_reserve_extent+0x9b/0x180 [btrfs]
 btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
 __btrfs_cow_block+0x11d/0x500 [btrfs]
 btrfs_cow_block+0xdc/0x180 [btrfs]
 btrfs_search_slot+0x3bd/0x9f0 [btrfs]
 btrfs_lookup_inode+0x3a/0xc0 [btrfs]
 ? kmem_cache_alloc+0x166/0x1d0
 btrfs_update_inode_item+0x46/0x100 [btrfs]
 cache_save_setup+0xe4/0x3a0 [btrfs]
 btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
 btrfs_commit_transaction+0xcb/0x8b0 [btrfs]

At cache_save_setup() we need to update the inode item of a block group's
cache which is located in the tree root (fs_info->tree_root), which means
that it may result in COWing a leaf from that tree. If that happens we
need to find a free metadata extent and while looking for one, if we find
a block group which was not cached yet we attempt to load its cache by
calling cache_block_group(). However this function will try to load the
inode of the free space cache, which requires finding the matching inode
item in the tree root - if that inode item is located in the same leaf as
the inode item of the space cache we are updating at cache_save_setup(),
we end up in a deadlock, since we try to obtain a read lock on the same
extent buffer that we previously write locked.

So fix this by using the tree root's commit root when searching for a
block group's free space cache inode item when we are attempting to load
a free space cache. This is safe since block groups once loaded stay in
memory forever, as well as their caches, so after they are first loaded
we will never need to read their inode items again. For new block groups,
once they are created they get their ->cached field set to
BTRFS_CACHE_FINISHED meaning we will not need to read their inode item.

Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Made the solution more generic, since the problem could happen in any
    path COWing an extent buffer from the root tree.

    Applies on top of a previous patch titled:

     "Btrfs: fix deadlock when writing out free space caches"

V3: Made it more simple by avoiding the atomic from V2 and pass the root
    to find_free_extent().

V4: Changed the whole approach so that we lookup for free space cache inode
    items using the commit root instead.
    The previous approach was causing some transactions to be aborted with
    -ENOSPC during umount because sometimes we were skipping cache loading
    of all metadata block groups.

 fs/btrfs/ctree.h            |  3 +++
 fs/btrfs/free-space-cache.c | 22 +++++++++++++++++++++-
 fs/btrfs/inode.c            | 32 ++++++++++++++++++++++----------
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2cddfe7806a4..2b34b2a05ad6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3177,6 +3177,9 @@ void btrfs_destroy_inode(struct inode *inode);
 int btrfs_drop_inode(struct inode *inode);
 int __init btrfs_init_cachep(void);
 void __cold btrfs_destroy_cachep(void);
+struct inode *btrfs_iget_path(struct super_block *s, struct btrfs_key *location,
+			      struct btrfs_root *root, int *new,
+			      struct btrfs_path *path);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 65b79500e09f..7265f35324f6 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -68,7 +68,8 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	btrfs_disk_key_to_cpu(&location, &disk_key);
 	btrfs_release_path(path);
 
-	inode = btrfs_iget(fs_info->sb, &location, root, NULL);
+	inode = btrfs_iget_path(fs_info->sb, &location, root, NULL, path);
+	btrfs_release_path(path);
 	if (IS_ERR(inode))
 		return inode;
 
@@ -830,6 +831,25 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
 
+	/*
+	 * We must pass a path with search_commit_root set to btrfs_iget in
+	 * order to avoid a deadlock when allocating extents for the tree root.
+	 *
+	 * When we are COWing an extent buffer from the tree root, when looking
+	 * for a free extent, at extent-tree.c:find_free_extent(), we can find
+	 * block group without its free space cache loaded. When we find one
+	 * we must load its space cache which requires reading its free space
+	 * cache's inode item from the root tree. If this inode item is located
+	 * in the same leaf that we started COWing before, then we end up in
+	 * deadlock on the extent buffer (trying to read lock it when we
+	 * previously write locked it).
+	 *
+	 * It's safe to read the inode item using the commit root because
+	 * block groups, once loaded, stay in memory forever (until they are
+	 * removed) as well as their space caches once loaded. New block groups
+	 * once created get their ->cached field set to BTRFS_CACHE_FINISHED so
+	 * we will never try to read their inode item while the fs is mounted.
+	 */
 	inode = lookup_free_space_inode(fs_info, block_group, path);
 	if (IS_ERR(inode)) {
 		btrfs_free_path(path);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d6b61b1facdd..64ea749c1ba4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3568,10 +3568,11 @@ static noinline int acls_after_inode_item(struct extent_buffer *leaf,
 /*
  * read an inode from the btree into the in-memory inode
  */
-static int btrfs_read_locked_inode(struct inode *inode)
+static int btrfs_read_locked_inode(struct inode *inode,
+				   struct btrfs_path *in_path)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_path *path;
+	struct btrfs_path *path = in_path;
 	struct extent_buffer *leaf;
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -3587,15 +3588,18 @@ static int btrfs_read_locked_inode(struct inode *inode)
 	if (!ret)
 		filled = true;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		path = btrfs_alloc_path();
+		if (!path)
+			return -ENOMEM;
+	}
 
 	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
 
 	ret = btrfs_lookup_inode(NULL, root, path, &location, 0);
 	if (ret) {
-		btrfs_free_path(path);
+		if (path != in_path)
+			btrfs_free_path(path);
 		return ret;
 	}
 
@@ -3720,7 +3724,8 @@ static int btrfs_read_locked_inode(struct inode *inode)
 				  btrfs_ino(BTRFS_I(inode)),
 				  root->root_key.objectid, ret);
 	}
-	btrfs_free_path(path);
+	if (path != in_path)
+		btrfs_free_path(path);
 
 	if (!maybe_acls)
 		cache_no_acl(inode);
@@ -5662,8 +5667,9 @@ static struct inode *btrfs_iget_locked(struct super_block *s,
 /* Get an inode object given its location and corresponding root.
  * Returns in *is_new if the inode was read from disk
  */
-struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
-			 struct btrfs_root *root, int *new)
+struct inode *btrfs_iget_path(struct super_block *s, struct btrfs_key *location,
+			      struct btrfs_root *root, int *new,
+			      struct btrfs_path *path)
 {
 	struct inode *inode;
 
@@ -5674,7 +5680,7 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 	if (inode->i_state & I_NEW) {
 		int ret;
 
-		ret = btrfs_read_locked_inode(inode);
+		ret = btrfs_read_locked_inode(inode, path);
 		if (!ret) {
 			inode_tree_add(inode);
 			unlock_new_inode(inode);
@@ -5696,6 +5702,12 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 	return inode;
 }
 
+struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
+			 struct btrfs_root *root, int *new)
+{
+	return btrfs_iget_path(s, location, root, new, NULL);
+}
+
 static struct inode *new_simple_dir(struct super_block *s,
 				    struct btrfs_key *key,
 				    struct btrfs_root *root)
-- 
2.11.0

