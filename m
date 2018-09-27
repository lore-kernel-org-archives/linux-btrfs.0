Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DB9C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C1B621708
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="DKAdIqgW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C1B621708
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbeI1AiD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:38:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41282 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbeI1Aht (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:37:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id z3-v6so2533998pgv.8
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 11:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QXDWG45gpDSq3zL/smt5myzX38kSpgMjDpiwlbpqRuI=;
        b=DKAdIqgWFG6SV0CBA48SgC4NQm7T4RakGJNIi/cetz/XZKnId153u8LkBYwxYqp4u8
         cHzVwJky2CYsfRKhf7yOwYXK+mSQ5ZG1tV47GXjBCQY0GF3NCVqpuUMIQWYWaNPUWv4v
         dobATjU+N7oG54oV8uYDHrvaCZSbwfonog20qdLsh5lrUJorX9gbsqDKVcJRfFGuZrFs
         nNn8hyTDIlc58ngWFyhToWNnsVy0TdArYIfVVkp/6tbzocwO5tk00ItQsJxR5mmOORDf
         uJNDkSyER33vGL1iT6YNpB8qfG3lGYQGcHbbj9VgXMTo3/pL1Ewg5JQH+JMVkET0Y6fN
         DAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QXDWG45gpDSq3zL/smt5myzX38kSpgMjDpiwlbpqRuI=;
        b=jhBugfr5i16eXQ2ACA32wmpaZ6FsSJE0rZqZ+g0PC5WbhOPUIMArbcIzHjo7930Bmu
         j3d330FUNaSPIYOlCvUIQJRwejQFst/iT7AMqTJbPydqQPaWIaJRAOEgvMkm0ULmV4fj
         /Crs9rhpB2KV4OVvVKEr2KWsKvwu5aWvp+pxDkmHEq+GWNrveS4NTBnbEHLVkgBeRzsV
         UsZnBoXx0xqY8c5VQ59Na8WESnYuM246Q3c1UCBh1diINViKbRuQRr0c9wG/ovk34526
         1ORwUQ+VqP+0fiYUZqFt04z/1TnuTAS13JxNs4iRr89MaC0B5/hJVfDoeWpGBFv1gMyN
         vvxg==
X-Gm-Message-State: ABuFfojOVqqUGZMNzOjbvplkGIrJV1b8H5lsvMwa2RzXtSQlNfVffkiu
        gc26Orsh6jFs5w8zq6VS/ocOx+aPAgY=
X-Google-Smtp-Source: ACcGV60yZ2h3lhm1qoylwDz/2vvBySB8SIcwjxHsKffJDAbHTMu/P79T+B9meiGgkJV+6aeJXuZvsQ==
X-Received: by 2002:a63:4c16:: with SMTP id z22-v6mr11763860pga.312.1538072297770;
        Thu, 27 Sep 2018 11:18:17 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::5:3e64])
        by smtp.gmail.com with ESMTPSA id p19-v6sm4086614pgh.60.2018.09.27.11.18.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 11:18:17 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v9 6/6] Btrfs: support swap files
Date:   Thu, 27 Sep 2018 11:17:38 -0700
Message-Id: <08c9e240cc1de1e861c0e3781b7405a8c3f0a120.1538072009.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1538072009.git.osandov@fb.com>
References: <cover.1538072009.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Btrfs has not allowed swap files since commit 35054394c4b3 ("Btrfs: stop
providing a bmap operation to avoid swapfile corruptions"). However, now
that the proper restrictions are in place, Btrfs can support swap files
through the swap file a_ops, similar to iomap in commit 67482129cdab
("iomap: add a swapfile activation function").

For Btrfs, activation needs to make sure that the file can be used as a
swap file, which currently means that it must be fully allocated as
nocow with no compression on one device. It must also do the proper
tracking so that ioctls will not interfere with the swap file.
Deactivation clears this tracking.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 338 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 338 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3ea5339603cf..8f8b7079e1ba 100644
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
@@ -10488,6 +10489,341 @@ void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 	}
 }
 
+#ifdef CONFIG_SWAP
+/*
+ * Add an entry indicating a block group or device which is pinned by a
+ * swapfile. Returns 0 on success, 1 if there is already an entry for it, or a
+ * negative errno on failure.
+ */
+static int btrfs_add_swapfile_pin(struct inode *inode, void *ptr,
+				  bool is_block_group)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_swapfile_pin *sp, *entry;
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+
+	sp = kmalloc(sizeof(*sp), GFP_NOFS);
+	if (!sp)
+		return -ENOMEM;
+	sp->ptr = ptr;
+	sp->inode = inode;
+	sp->is_block_group = is_block_group;
+
+	spin_lock(&fs_info->swapfile_pins_lock);
+	p = &fs_info->swapfile_pins.rb_node;
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct btrfs_swapfile_pin, node);
+		if (sp->ptr < entry->ptr ||
+		    (sp->ptr == entry->ptr && sp->inode < entry->inode)) {
+			p = &(*p)->rb_left;
+		} else if (sp->ptr > entry->ptr ||
+			   (sp->ptr == entry->ptr && sp->inode > entry->inode)) {
+			p = &(*p)->rb_right;
+		} else {
+			spin_unlock(&fs_info->swapfile_pins_lock);
+			kfree(sp);
+			return 1;
+		}
+	}
+	rb_link_node(&sp->node, parent, p);
+	rb_insert_color(&sp->node, &fs_info->swapfile_pins);
+	spin_unlock(&fs_info->swapfile_pins_lock);
+	return 0;
+}
+
+/* Free all of the entries pinned by this swapfile. */
+static void btrfs_free_swapfile_pins(struct inode *inode)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_swapfile_pin *sp;
+	struct rb_node *node, *next;
+
+	spin_lock(&fs_info->swapfile_pins_lock);
+	node = rb_first(&fs_info->swapfile_pins);
+	while (node) {
+		next = rb_next(node);
+		sp = rb_entry(node, struct btrfs_swapfile_pin, node);
+		if (sp->inode == inode) {
+			rb_erase(&sp->node, &fs_info->swapfile_pins);
+			if (sp->is_block_group)
+				btrfs_put_block_group(sp->ptr);
+			kfree(sp);
+		}
+		node = next;
+	}
+	spin_unlock(&fs_info->swapfile_pins_lock);
+}
+
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
+static void btrfs_swap_deactivate(struct file *file)
+{
+	struct inode *inode = file_inode(file);
+
+	btrfs_free_swapfile_pins(inode);
+	atomic_dec(&BTRFS_I(inode)->root->nr_swapfiles);
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
+		btrfs_warn(fs_info, "swapfile must not be compressed");
+		return -EINVAL;
+	}
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW)) {
+		btrfs_warn(fs_info, "swapfile must not be copy-on-write");
+		return -EINVAL;
+	}
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
+		btrfs_warn(fs_info, "swapfile must not be checksummed");
+		return -EINVAL;
+	}
+
+	/*
+	 * Balance or device remove/replace/resize can move stuff around from
+	 * under us. The EXCL_OP flag makes sure they aren't running/won't run
+	 * concurrently while we are mapping the swap extents, and
+	 * fs_info->swapfile_pins prevents them from running while the swap file
+	 * is active and moving the extents. Note that this also prevents a
+	 * concurrent device add which isn't actually necessary, but it's not
+	 * really worth the trouble to allow it.
+	 */
+	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
+		btrfs_warn(fs_info,
+	   "cannot activate swapfile while exclusive operation is running");
+		return -EBUSY;
+	}
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
+		u64 logical_block_start, physical_block_start;
+		struct btrfs_block_group_cache *bg;
+		u64 len = isize - start;
+
+		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, len, 0);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out;
+		}
+
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			btrfs_warn(fs_info, "swapfile must not have holes");
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
+			btrfs_warn(fs_info, "swapfile must not be inline");
+			ret = -EINVAL;
+			goto out;
+		}
+		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
+			btrfs_warn(fs_info, "swapfile must not be compressed");
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
+			btrfs_warn(fs_info,
+				   "swapfile must not be copy-on-write");
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
+			btrfs_warn(fs_info,
+				   "swapfile must have single data profile");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (device == NULL) {
+			device = em->map_lookup->stripes[0].dev;
+			ret = btrfs_add_swapfile_pin(inode, device, false);
+			if (ret == 1)
+				ret = 0;
+			else if (ret)
+				goto out;
+		} else if (device != em->map_lookup->stripes[0].dev) {
+			btrfs_warn(fs_info, "swapfile must be on one device");
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
+		bg = btrfs_lookup_block_group(fs_info, logical_block_start);
+		if (!bg) {
+			btrfs_warn(fs_info,
+			   "could not find block group containing swapfile");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ret = btrfs_add_swapfile_pin(inode, bg, true);
+		if (ret) {
+			btrfs_put_block_group(bg);
+			if (ret == 1)
+				ret = 0;
+			else
+				goto out;
+		}
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
+		start += len;
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
+	if (ret)
+		btrfs_swap_deactivate(file);
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
+#else
+static void btrfs_swap_deactivate(struct file *file)
+{
+}
+
+static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
+			       sector_t *span)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.lookup		= btrfs_lookup,
@@ -10565,6 +10901,8 @@ static const struct address_space_operations btrfs_aops = {
 	.releasepage	= btrfs_releasepage,
 	.set_page_dirty	= btrfs_set_page_dirty,
 	.error_remove_page = generic_error_remove_page,
+	.swap_activate	= btrfs_swap_activate,
+	.swap_deactivate = btrfs_swap_deactivate,
 };
 
 static const struct address_space_operations btrfs_symlink_aops = {
-- 
2.19.0

