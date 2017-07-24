Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34072 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753667AbdGXSAi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 14:00:38 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DFDF9AB43
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 18:00:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: remove trivial wrapper btrfs_force_ra
Date: Mon, 24 Jul 2017 19:59:09 +0200
Message-Id: <a24216d4a1bf994ab9281755309f0ad01344f983.1500919093.git.dsterba@suse.com>
In-Reply-To: <cover.1500919093.git.dsterba@suse.com>
References: <cover.1500919093.git.dsterba@suse.com>
In-Reply-To: <cover.1500919093.git.dsterba@suse.com>
References: <cover.1500919093.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's a simple call page_cache_sync_readahead, same arguments in the same
order.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 8 --------
 fs/btrfs/ioctl.c | 4 ++--
 fs/btrfs/send.c  | 2 +-
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 128b7435e071..f81d1faf5307 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3135,14 +3135,6 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *orig_start, u64 *orig_block_len,
 			      u64 *ram_bytes);
 
-/* This forces readahead on a given range of bytes in an inode */
-static inline void btrfs_force_ra(struct address_space *mapping,
-				  struct file_ra_state *ra, struct file *file,
-				  pgoff_t offset, unsigned long req_size)
-{
-	page_cache_sync_readahead(mapping, ra, file, offset, req_size);
-}
-
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f321e3b32737..8f91369ddf92 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1395,8 +1395,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 		if (i + cluster > ra_index) {
 			ra_index = max(i, ra_index);
-			btrfs_force_ra(inode->i_mapping, ra, file, ra_index,
-				       cluster);
+			page_cache_sync_readahead(inode->i_mapping, ra,
+						file, ra_index, cluster);
 			ra_index += cluster;
 		}
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b082210df9c8..59fb1ed6ca20 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4733,7 +4733,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 	/* initial readahead */
 	memset(&sctx->ra, 0, sizeof(struct file_ra_state));
 	file_ra_state_init(&sctx->ra, inode->i_mapping);
-	btrfs_force_ra(inode->i_mapping, &sctx->ra, NULL, index,
+	page_cache_sync_readahead(inode->i_mapping, &sctx->ra, NULL, index,
 		       last_index - index + 1);
 
 	while (index <= last_index) {
-- 
2.13.0

