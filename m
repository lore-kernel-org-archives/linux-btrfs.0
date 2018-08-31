Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44187 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbeIACq2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 22:46:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id ba4-v6so6051092plb.11
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 15:36:54 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v5 6/6] Btrfs: support swap files
Date: Fri, 31 Aug 2018 15:36:41 -0700
Message-Id: <c95fac987d706e7369e794b37f7122575f5417a0.1535754957.git.osandov@fb.com>
In-Reply-To: <cover.1535754957.git.osandov@fb.com>
References: <cover.1535754957.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Implement the swap file a_ops on Btrfs. Activation needs to make sure
that the file can be used as a swap file, which currently means it must
be fully allocated as nocow with no compression on one device. It also
sets up the swap extents directly with add_swap_extent(), so export it.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 232 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 232 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9357a19d2bff..c0409e632768 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -27,6 +27,7 @@
 #include <linux/uio.h>
 #include <linux/magic.h>
 #include <linux/iversion.h>
+#include <linux/swap.h>
 #include <asm/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -10437,6 +10438,235 @@ void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 	}
 }
 
+struct btrfs_swap_info {
+	u64 start;
+	u64 block_start;
+	u64 block_len;
+	u64 lowest_ppage;
+	u64 highest_ppage;
+	unsigned long nr_pages;
+	int nr_extents;
+};
+
+static int btrfs_add_swap_extent(struct swap_info_struct *sis,
+				 struct btrfs_swap_info *bsi)
+{
+	unsigned long nr_pages;
+	u64 first_ppage, first_ppage_reported, next_ppage;
+	int ret;
+
+	first_ppage = ALIGN(bsi->block_start, PAGE_SIZE) >> PAGE_SHIFT;
+	next_ppage = ALIGN_DOWN(bsi->block_start + bsi->block_len,
+				PAGE_SIZE) >> PAGE_SHIFT;
+
+	if (first_ppage >= next_ppage)
+		return 0;
+	nr_pages = next_ppage - first_ppage;
+
+	first_ppage_reported = first_ppage;
+	if (bsi->start == 0)
+		first_ppage_reported++;
+	if (bsi->lowest_ppage > first_ppage_reported)
+		bsi->lowest_ppage = first_ppage_reported;
+	if (bsi->highest_ppage < (next_ppage - 1))
+		bsi->highest_ppage = next_ppage - 1;
+
+	ret = add_swap_extent(sis, bsi->nr_pages, nr_pages, first_ppage);
+	if (ret < 0)
+		return ret;
+	bsi->nr_extents += ret;
+	bsi->nr_pages += nr_pages;
+	return 0;
+}
+
+static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
+			       sector_t *span)
+{
+	struct inode *inode = file_inode(file);
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct extent_state *cached_state = NULL;
+	struct extent_map *em = NULL;
+	struct btrfs_device *device = NULL;
+	struct btrfs_swap_info bsi = {
+		.lowest_ppage = (sector_t)-1ULL,
+	};
+	int ret = 0;
+	u64 isize = inode->i_size;
+	u64 start;
+
+	/*
+	 * If the swap file was just created, make sure delalloc is done. If the
+	 * file changes again after this, the user is doing something stupid and
+	 * we don't really care.
+	 */
+	ret = btrfs_wait_ordered_range(inode, 0, (u64)-1);
+	if (ret)
+		return ret;
+
+	/*
+	 * The inode is locked, so these flags won't change after we check them.
+	 */
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS) {
+		btrfs_err(fs_info, "swapfile must not be compressed");
+		return -EINVAL;
+	}
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW)) {
+		btrfs_err(fs_info, "swapfile must not be copy-on-write");
+		return -EINVAL;
+	}
+
+	/*
+	 * Balance or device remove/replace/resize can move stuff around from
+	 * under us. The EXCL_OP flag makes sure they aren't running/won't run
+	 * concurrently while we are mapping the swap extents, and the fs_info
+	 * nr_swapfiles counter prevents them from running while the swap file
+	 * is active and moving the extents. Note that this also prevents a
+	 * concurrent device add which isn't actually necessary, but it's not
+	 * really worth the trouble to allow it.
+	 */
+	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
+		return -EBUSY;
+	atomic_inc(&fs_info->nr_swapfiles);
+	/*
+	 * Snapshots can create extents which require COW even if NODATACOW is
+	 * set. We use this counter to prevent snapshots. We must increment it
+	 * before walking the extents because we don't want a concurrent
+	 * snapshot to run after we've already checked the extents.
+	 */
+	atomic_inc(&BTRFS_I(inode)->root->nr_swapfiles);
+
+	lock_extent_bits(io_tree, 0, isize - 1, &cached_state);
+	start = 0;
+	while (start < isize) {
+		u64 end, logical_block_start, physical_block_start;
+		u64 len = isize - start;
+
+		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, len, 0);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out;
+		}
+		end = extent_map_end(em);
+
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			btrfs_err(fs_info, "swapfile must not have holes");
+			ret = -EINVAL;
+			goto out;
+		}
+		if (em->block_start == EXTENT_MAP_INLINE) {
+			/*
+			 * It's unlikely we'll ever actually find ourselves
+			 * here, as a file small enough to fit inline won't be
+			 * big enough to store more than the swap header, but in
+			 * case something changes in the future, let's catch it
+			 * here rather than later.
+			 */
+			btrfs_err(fs_info, "swapfile must not be inline");
+			ret = -EINVAL;
+			goto out;
+		}
+		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
+			btrfs_err(fs_info, "swapfile must not be compressed");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		logical_block_start = em->block_start + (start - em->start);
+		len = min(len, em->len - (start - em->start));
+		free_extent_map(em);
+		em = NULL;
+
+		ret = can_nocow_extent(inode, start, &len, NULL, NULL, NULL);
+		if (ret < 0) {
+			goto out;
+		} else if (ret) {
+			ret = 0;
+		} else {
+			btrfs_err(fs_info, "swapfile must not be copy-on-write");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		em = btrfs_get_chunk_map(fs_info, logical_block_start, len);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out;
+		}
+
+		if (em->map_lookup->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+			btrfs_err(fs_info, "swapfile must have single data profile");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (device == NULL) {
+			device = em->map_lookup->stripes[0].dev;
+		} else if (device != em->map_lookup->stripes[0].dev) {
+			btrfs_err(fs_info, "swapfile must be on one device");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		physical_block_start = (em->map_lookup->stripes[0].physical +
+					(logical_block_start - em->start));
+		len = min(len, em->len - (logical_block_start - em->start));
+		free_extent_map(em);
+		em = NULL;
+
+		if (bsi.block_len &&
+		    bsi.block_start + bsi.block_len == physical_block_start) {
+			bsi.block_len += len;
+		} else {
+			if (bsi.block_len) {
+				ret = btrfs_add_swap_extent(sis, &bsi);
+				if (ret)
+					goto out;
+			}
+			bsi.start = start;
+			bsi.block_start = physical_block_start;
+			bsi.block_len = len;
+		}
+
+		start = end;
+	}
+
+	if (bsi.block_len)
+		ret = btrfs_add_swap_extent(sis, &bsi);
+
+out:
+	if (!IS_ERR_OR_NULL(em))
+		free_extent_map(em);
+
+	unlock_extent_cached(io_tree, 0, isize - 1, &cached_state);
+
+	if (ret) {
+		atomic_dec(&BTRFS_I(inode)->root->nr_swapfiles);
+		atomic_dec(&fs_info->nr_swapfiles);
+	}
+
+	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
+
+	if (ret)
+		return ret;
+
+	if (device)
+		sis->bdev = device->bdev;
+	*span = bsi.highest_ppage - bsi.lowest_ppage + 1;
+	sis->max = bsi.nr_pages;
+	sis->pages = bsi.nr_pages - 1;
+	sis->highest_bit = bsi.nr_pages - 1;
+	return bsi.nr_extents;
+}
+
+static void btrfs_swap_deactivate(struct file *file)
+{
+	struct inode *inode = file_inode(file);
+
+	atomic_dec(&BTRFS_I(inode)->root->nr_swapfiles);
+	atomic_dec(&BTRFS_I(inode)->root->fs_info->nr_swapfiles);
+}
+
 static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.lookup		= btrfs_lookup,
@@ -10514,6 +10744,8 @@ static const struct address_space_operations btrfs_aops = {
 	.releasepage	= btrfs_releasepage,
 	.set_page_dirty	= btrfs_set_page_dirty,
 	.error_remove_page = generic_error_remove_page,
+	.swap_activate	= btrfs_swap_activate,
+	.swap_deactivate = btrfs_swap_deactivate,
 };
 
 static const struct address_space_operations btrfs_symlink_aops = {
-- 
2.18.0
