Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68772C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35D212084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35D212084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbeLEM3O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:29:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:48544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727787AbeLEM3N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:29:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DFD53AEB9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:29:11 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 10/10] btrfs: dax mmap write
Date:   Wed,  5 Dec 2018 06:28:35 -0600
Message-Id: <20181205122835.19290-11-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Create a page size extent and copy the contents of the original
extent into the new one, and present to user space as the page
to write.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/dax.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index 6d68d39cc5da..4634917877f3 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -231,6 +231,45 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
 		sector >>= 9;
 		ret = copy_user_dax(em->bdev, dax_dev, sector, PAGE_SIZE, vmf->cow_page, vaddr);
 		goto out;
+	} else if (vmf->flags & FAULT_FLAG_WRITE) {
+		pfn_t pfn;
+		struct extent_map *orig = em;
+		void *daddr;
+		sector_t dstart;
+		size_t maplen;
+		struct extent_changeset *data_reserved = NULL;
+		struct extent_state *cached_state = NULL;
+
+		ret = btrfs_delalloc_reserve_space(inode, &data_reserved, pos, PAGE_SIZE);
+		if (ret < 0)
+			return ret;
+		refcount_inc(&orig->refs);
+		lock_extent_bits(&BTRFS_I(inode)->io_tree, pos, pos + PAGE_SIZE, &cached_state);
+		/* Create an extent of page size */
+		ret = btrfs_get_extent_map_write(&em, NULL, inode, pos,
+				PAGE_SIZE);
+		if (ret < 0) {
+			free_extent_map(orig);
+			btrfs_delalloc_release_space(inode, data_reserved, pos,
+					PAGE_SIZE, true);
+			goto out;
+		}
+
+		dax_dev = fs_dax_get_by_bdev(em->bdev);
+		/* Calculate start address of destination extent */
+		dstart = (get_start_sect(em->bdev) << 9) + em->block_start;
+		maplen = dax_direct_access(dax_dev, PHYS_PFN(dstart),
+				1, &daddr, &pfn);
+
+		/* Copy the original contents into new destination */
+		copy_extent_page(orig, daddr, pos);
+		btrfs_update_ordered_extent(inode, pos, PAGE_SIZE, true);
+		dax_insert_entry(&xas, mapping, vmf, entry, pfn, 0, false);
+		ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
+		free_extent_map(orig);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, pos, pos + PAGE_SIZE, &cached_state);
+		extent_changeset_free(data_reserved);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, false);
 	} else {
         	sector_t sector;
 		if (em->block_start == EXTENT_MAP_HOLE) {
-- 
2.16.4

