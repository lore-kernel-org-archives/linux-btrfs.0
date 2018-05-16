Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57486 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752442AbeEPFo3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 01:44:29 -0400
From: Christoph Hellwig <hch@lst.de>
To: Souptick Joarder <jrdr.linux@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@lists.orangefs.org,
        ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mtd@lists.infradead.org, dri-devel@lists.freedesktop.org,
        lustre-devel@lists.lustre.org, linux-arm-kernel@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 04/14] mm: remove the unused device_private_entry_fault export
Date: Wed, 16 May 2018 07:43:38 +0200
Message-Id: <20180516054348.15950-5-hch@lst.de>
In-Reply-To: <20180516054348.15950-1-hch@lst.de>
References: <20180516054348.15950-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/memremap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index db4e1a373e5f..59ee3b604b39 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -65,7 +65,6 @@ int device_private_entry_fault(struct vm_area_struct *vma,
 	 */
 	return page->pgmap->page_fault(vma, addr, page, flags, pmdp);
 }
-EXPORT_SYMBOL(device_private_entry_fault);
 #endif /* CONFIG_DEVICE_PRIVATE */
 
 static void pgmap_radix_release(struct resource *res, unsigned long end_pgoff)
-- 
2.17.0

