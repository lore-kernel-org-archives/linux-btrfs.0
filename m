Return-Path: <SRS0=DXmw=ZV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF19CC432C3
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Nov 2019 09:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF75B21774
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Nov 2019 09:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfK2JiK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Nov 2019 04:38:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:46974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbfK2JiK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Nov 2019 04:38:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 88EF8ACA5;
        Fri, 29 Nov 2019 09:38:09 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Simplify len alignment calculation
Date:   Fri, 29 Nov 2019 11:38:07 +0200
Message-Id: <20191129093807.525-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Use ALIGN() directly rather than achieving the same thing in a roundabout way.
No semantic changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delalloc-space.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 4cdac4d834f5..c08e905b0424 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -142,8 +142,7 @@ int btrfs_check_data_free_space(struct inode *inode,
 	int ret;

 	/* align the range */
-	len = round_up(start + len, fs_info->sectorsize) -
-	      round_down(start, fs_info->sectorsize);
+	len = ALIGN(len, fs_info->sectorsize);
 	start = round_down(start, fs_info->sectorsize);

 	ret = btrfs_alloc_data_chunk_ondemand(BTRFS_I(inode), len);
--
2.17.1

