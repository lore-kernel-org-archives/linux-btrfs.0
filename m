Return-Path: <SRS0=myd1=DV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFBCC433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Oct 2020 14:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BC5222227
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Oct 2020 14:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgJNOz5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 10:55:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:38696 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728799AbgJNOz5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Oct 2020 10:55:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 80C7FAD18;
        Wed, 14 Oct 2020 14:55:56 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs: Use round_down while calculating start position in btrfs_dirty_pages()
Date:   Wed, 14 Oct 2020 09:55:44 -0500
Message-Id: <20201014145545.10878-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

round_down looks prettier than the bit mask operations.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0ff659455b1e..6e52e2360d8e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -514,7 +514,7 @@ int btrfs_dirty_pages(struct btrfs_inode *inode, struct page **pages,
 	loff_t isize = i_size_read(&inode->vfs_inode);
 	unsigned int extra_bits = 0;
 
-	start_pos = pos & ~((u64) fs_info->sectorsize - 1);
+	start_pos = round_down(pos, fs_info->sectorsize);
 	num_bytes = round_up(write_bytes + pos - start_pos,
 			     fs_info->sectorsize);
 
-- 
2.26.2

