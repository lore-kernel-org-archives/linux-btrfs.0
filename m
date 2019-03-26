Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CA0C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A126A20823
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732666AbfCZTDg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:03:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:37008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732504AbfCZTDe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:03:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4BBC0AF79;
        Tue, 26 Mar 2019 19:03:33 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 08/15] dax: add dax_iomap_cow to copy a mmap page before writing
Date:   Tue, 26 Mar 2019 14:02:54 -0500
Message-Id: <20190326190301.32365-9-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190326190301.32365-1-rgoldwyn@suse.de>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

dax_iomap_cow copies a page before presenting for mmap.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index e254535dd830..21ee3df6f02c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1269,6 +1269,33 @@ static bool dax_fault_is_synchronous(unsigned long flags,
 		&& (iomap->flags & IOMAP_F_DIRTY);
 }
 
+static int dax_iomap_cow(struct iomap *iomap, loff_t pos, pfn_t *pfn)
+{
+	void *daddr;
+	pgoff_t pgoff;
+	long rc;
+	int id;
+	sector_t sector;
+
+	pos = round_down(pos, PAGE_SIZE);
+
+	sector = round_down(iomap->addr + iomap->offset - pos, PAGE_SIZE) >> 9;
+	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
+	if (rc)
+		return rc;
+
+	id = dax_read_lock();
+	rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &daddr, pfn);
+	if (rc < 0)
+		goto out;
+
+	dax_to_dax_copy(iomap, pos, daddr, PAGE_SIZE);
+
+out:
+	dax_read_unlock(id);
+	return rc;
+}
+
 static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			       int *iomap_errp, const struct iomap_ops *ops)
 {
@@ -1372,7 +1399,11 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
+
+		if (iomap.flags & IOMAP_F_COW)
+			error = dax_iomap_cow(&iomap, pos, &pfn);
+		else
+			error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
 		if (error < 0)
 			goto error_finish_iomap;
 
-- 
2.16.4

