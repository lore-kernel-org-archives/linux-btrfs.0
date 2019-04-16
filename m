Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32894C282DA
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ACFE206B6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfDPQmS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:42:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:36198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726816AbfDPQmR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 12:42:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4B09FAF1B;
        Tue, 16 Apr 2019 16:42:15 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com,
        willy@infradead.org, hch@lst.de, darrick.wong@oracle.com,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 04/18] dax: Introduce IOMAP_DAX_COW to CoW edges during writes
Date:   Tue, 16 Apr 2019 11:41:40 -0500
Message-Id: <20190416164154.30390-5-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

The IOMAP_DAX_COW is a iomap type which performs copy of
edges of data while performing a write if start/end are
not page aligned. The source address is expected in
iomap->inline_data.

dax_copy_edges() is a helper functions performs a copy from
one part of the device to another for data not page aligned.
If iomap->inline_data is NULL, it memset's the area to zero.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c              | 41 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/iomap.h |  1 +
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index ca0671d55aa6..4b4ac51fbd16 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1083,6 +1083,40 @@ int __dax_zero_page_range(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
 
+/*
+ * dax_copy_edges - Copies the part of the pages not included in
+ * 		    the write, but required for CoW because
+ * 		    offset/offset+length are not page aligned.
+ */
+static void dax_copy_edges(struct inode *inode, loff_t pos, loff_t length,
+			   struct iomap *iomap, void *daddr)
+{
+	unsigned offset = pos & (PAGE_SIZE - 1);
+	loff_t end = pos + length;
+	loff_t pg_end = round_up(end, PAGE_SIZE);
+	void *saddr = iomap->inline_data;
+	/*
+	 * Copy the first part of the page
+	 * Note: we pass offset as length
+	 */
+	if (offset) {
+		if (saddr)
+			memcpy(daddr, saddr, offset);
+		else
+			memset(daddr, 0, offset);
+	}
+
+	/* Copy the last part of the range */
+	if (end < pg_end) {
+		if (saddr)
+			memcpy(daddr + offset + length,
+			       saddr + offset + length,	pg_end - end);
+		else
+			memset(daddr + offset + length, 0,
+					pg_end - end);
+	}
+}
+
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
@@ -1104,9 +1138,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			return iov_iter_zero(min(length, end - pos), iter);
 	}
 
-	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
+	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED
+			 && iomap->type != IOMAP_DAX_COW))
 		return -EIO;
 
+
 	/*
 	 * Write can allocate block for an area which has a hole page mapped
 	 * into page tables. We have to tear down these mappings so that data
@@ -1143,6 +1179,9 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			break;
 		}
 
+		if (iomap->type == IOMAP_DAX_COW)
+			dax_copy_edges(inode, pos, length, iomap, kaddr);
+
 		map_len = PFN_PHYS(map_len);
 		kaddr += offset;
 		map_len -= offset;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 0fefb5455bda..6e885c5a38a3 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -25,6 +25,7 @@ struct vm_fault;
 #define IOMAP_MAPPED	0x03	/* blocks allocated at @addr */
 #define IOMAP_UNWRITTEN	0x04	/* blocks allocated at @addr in unwritten state */
 #define IOMAP_INLINE	0x05	/* data inline in the inode */
+#define IOMAP_DAX_COW	0x06	/* Copy data pointed by inline_data before write*/
 
 /*
  * Flags for all iomap mappings:
-- 
2.16.4

