Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3B9C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AB2C2084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AB2C2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbeLEM3F (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:29:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:48506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727778AbeLEM3F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:29:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4CA7AAEB9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:29:03 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 06/10] btrfs: dax write support
Date:   Wed,  5 Dec 2018 06:28:31 -0600
Message-Id: <20181205122835.19290-7-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This is a combination of direct and buffered I/O. Similarties
with direct I/O is that it needs to allocate space before
writing. Similarities with buffered is when the data is not
page-aligned, it needs to copy parts of the previous extents. In
order to accomplish that, keep a references of the first and last
extent (if required) and then perform allocations. If the "pos"
or "end" is not aligned, copy the data from first and last extent
respectively.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h |   1 +
 fs/btrfs/dax.c   | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/file.c  |   4 +-
 3 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a0d296b0d826..d91ff283a966 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3693,6 +3693,7 @@ int btree_readahead_hook(struct extent_buffer *eb, int err);
 #ifdef CONFIG_FS_DAX
 /* dax.c */
 ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
+ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from);
 #endif /* CONFIG_FS_DAX */
 
 static inline int is_fstree(u64 rootid)
diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index 5a297674adec..4000259a426c 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -2,6 +2,7 @@
 #include <linux/uio.h>
 #include "ctree.h"
 #include "btrfs_inode.h"
+#include "extent_io.h"
 
 static ssize_t em_dax_rw(struct inode *inode, struct extent_map *em, u64 pos,
 		u64 len, struct iov_iter *iter)
@@ -71,3 +72,123 @@ ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
         return done ? done : ret;
 }
 
+static int copy_extent_page(struct extent_map *em, void *daddr, u64 pos)
+{
+        struct dax_device *dax_dev;
+	void *saddr;
+	sector_t start;
+	size_t len;
+
+	if (em->block_start == EXTENT_MAP_HOLE) {
+		memset(daddr, 0, PAGE_SIZE);
+	} else {
+		dax_dev = fs_dax_get_by_bdev(em->bdev);
+		start = (get_start_sect(em->bdev) << 9) + (em->block_start + (pos - em->start));
+		len = dax_direct_access(dax_dev, PHYS_PFN(start), 1, &saddr, NULL);
+		memcpy(daddr, saddr, PAGE_SIZE);
+	}
+	free_extent_map(em);
+
+	return 0;
+}
+
+
+ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	ssize_t ret, done = 0, count = iov_iter_count(from);
+        struct inode *inode = file_inode(iocb->ki_filp);
+	u64 pos = iocb->ki_pos;
+	u64 start = round_down(pos, PAGE_SIZE);
+	u64 end = round_up(pos + count, PAGE_SIZE);
+	struct extent_state *cached_state = NULL;
+	struct extent_changeset *data_reserved = NULL;
+	struct extent_map *first = NULL, *last = NULL;
+
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, start, end - start);
+	if (ret < 0)
+		return ret;
+
+	/* Grab a reference of the first extent to copy data */
+	if (start < pos) {
+		first = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, end - start, 0);
+		if (IS_ERR(first)) {
+			ret = PTR_ERR(first);
+			goto out2;
+		}
+	}
+
+	/* Grab a reference of the last extent to copy data */
+	if (pos + count < end) {
+		last = btrfs_get_extent(BTRFS_I(inode), NULL, 0, end - PAGE_SIZE, PAGE_SIZE, 0);
+		if (IS_ERR(last)) {
+			ret = PTR_ERR(last);
+			goto out2;
+		}
+	}
+
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, end, &cached_state);
+	while (done < count) {
+		struct extent_map *em;
+		struct dax_device *dax_dev;
+		int offset = pos & (PAGE_SIZE - 1);
+		u64 estart = round_down(pos, PAGE_SIZE);
+		u64 elen = end - estart;
+		size_t len = count - done;
+		sector_t dstart;
+		void *daddr;
+		ssize_t maplen;
+
+		/* Read the current extent */
+                em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, estart, elen, 0);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out;
+		}
+
+		/* Get a new extent */
+		ret = btrfs_get_extent_map_write(&em, NULL, inode, estart, elen);
+		if (ret < 0)
+			goto out;
+
+		dax_dev = fs_dax_get_by_bdev(em->bdev);
+		/* Calculate start address start of destination extent */
+		dstart = (get_start_sect(em->bdev) << 9) + em->block_start;
+		maplen = dax_direct_access(dax_dev, PHYS_PFN(dstart),
+				PHYS_PFN(em->len), &daddr, NULL);
+
+		/* Copy front of extent page */
+		if (offset)
+			ret = copy_extent_page(first, daddr, estart);
+
+		/* Copy end of extent page */
+		if ((pos + len > estart + PAGE_SIZE) && (pos + len < em->start + em->len))
+			ret = copy_extent_page(last, daddr + em->len - PAGE_SIZE, em->start + em->len - PAGE_SIZE);
+
+		/* Copy the data from the iter */
+		maplen = PFN_PHYS(maplen);
+		maplen -= offset;
+		ret = dax_copy_from_iter(dax_dev, dstart, daddr + offset, maplen, from);
+		if (ret < 0)
+			goto out;
+		pos += ret;
+		done += ret;
+	}
+out:
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, end, &cached_state);
+	if (done) {
+		btrfs_update_ordered_extent(inode, start,
+				end - start, true);
+		iocb->ki_pos += done;
+		if (iocb->ki_pos > i_size_read(inode))
+			i_size_write(inode, iocb->ki_pos);
+	}
+
+	btrfs_delalloc_release_extents(BTRFS_I(inode), count, false);
+out2:
+	if (count - done > 0)
+		btrfs_delalloc_release_space(inode, data_reserved, pos,
+				count - done, true);
+	extent_changeset_free(data_reserved);
+        return done ? done : ret;
+
+}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ef6ed93f44d1..29a3b12e6660 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1964,7 +1964,9 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	if (sync)
 		atomic_inc(&BTRFS_I(inode)->sync_writers);
 
-	if (iocb->ki_flags & IOCB_DIRECT) {
+	if (IS_DAX(inode)) {
+		num_written = btrfs_file_dax_write(iocb, from);
+	} else if (iocb->ki_flags & IOCB_DIRECT) {
 		num_written = __btrfs_direct_write(iocb, from);
 	} else {
 		num_written = btrfs_buffered_write(iocb, from);
-- 
2.16.4

