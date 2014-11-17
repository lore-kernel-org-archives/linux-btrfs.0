Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49016 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaKQKh2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 05:37:28 -0500
Received: by mail-pd0-f169.google.com with SMTP id fp1so3628222pdb.14
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 02:37:27 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        <linux-fsdevel@vger.kernel.org>, Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 6/6] btrfs: enable swap file support
Date: Mon, 17 Nov 2014 02:36:59 -0800
Message-Id: <168a953b14d11e551d9d1a79f4c1ae3a87c2e1a3.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
References: <cover.1416219974.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Implement the swap file a_ops on btrfs. Activation simply checks for a usable
swap file: it must be fully allocated (no holes), support direct I/O (so no
compressed or inline extents) and should be nocow (I'm not sure about that last
one).

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/inode.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0e84316..c7cce4e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9442,6 +9442,75 @@ out_inode:
 
 }
 
+static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
+			       sector_t *span)
+{
+	struct inode *inode = file_inode(file);
+	struct btrfs_inode *ip = BTRFS_I(inode);
+	int ret = 0;
+	u64 isize = inode->i_size;
+	struct extent_state *cached_state = NULL;
+	struct extent_map *em;
+	u64 start, len;
+
+	if (ip->flags & BTRFS_INODE_COMPRESS) {
+		/* Can't do direct I/O on a compressed file. */
+		pr_err("BTRFS: swapfile is compressed");
+		return -EINVAL;
+	}
+	if (!(ip->flags & BTRFS_INODE_NODATACOW)) {
+		/* The swap file can't be copy-on-write. */
+		pr_err("BTRFS: swapfile is copy-on-write");
+		return -EINVAL;
+	}
+
+	lock_extent_bits(&ip->io_tree, 0, isize - 1, 0, &cached_state);
+
+	/*
+	 * All of the extents must be allocated and support direct I/O. Inline
+	 * extents and compressed extents fall back to buffered I/O, so those
+	 * are no good.
+	 */
+	start = 0;
+	while (start < isize) {
+		len = isize - start;
+		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out;
+		}
+
+		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags) ||
+		    em->block_start == EXTENT_MAP_HOLE) {
+			pr_err("BTRFS: swapfile has holes");
+			ret = -EINVAL;
+			goto out;
+		}
+		if (em->block_start == EXTENT_MAP_INLINE) {
+			pr_err("BTRFS: swapfile is inline");
+			ret = -EINVAL;
+			goto out;
+		}
+		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
+			pr_err("BTRFS: swapfile is compresed");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		start = extent_map_end(em);
+		free_extent_map(em);
+	}
+
+out:
+	unlock_extent_cached(&ip->io_tree, 0, isize - 1, &cached_state,
+			     GFP_NOFS);
+	return ret;
+}
+
+static void btrfs_swap_deactivate(struct file *file)
+{
+}
+
 static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.lookup		= btrfs_lookup,
@@ -9519,6 +9588,8 @@ static const struct address_space_operations btrfs_aops = {
 	.releasepage	= btrfs_releasepage,
 	.set_page_dirty	= btrfs_set_page_dirty,
 	.error_remove_page = generic_error_remove_page,
+	.swap_activate	= btrfs_swap_activate,
+	.swap_deactivate = btrfs_swap_deactivate,
 };
 
 static const struct address_space_operations btrfs_symlink_aops = {
-- 
2.1.3

