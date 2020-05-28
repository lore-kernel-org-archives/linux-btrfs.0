Return-Path: <SRS0=T3D7=7K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7276C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 08:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C7FA20776
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 08:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgE1IFR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 May 2020 04:05:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:54614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgE1IFQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 May 2020 04:05:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2030AABE2;
        Thu, 28 May 2020 08:05:18 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Don't balance btree inode pages from buffered write path
Date:   Thu, 28 May 2020 11:05:13 +0300
Message-Id: <20200528080513.22914-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The call to btrfs_btree_balance_dirty has been there since the early
days of BTRFS, when the btree was directly modified from the write path,
hence dirtied btree inode pages. With the implementation of
b888db2bd7b6 ("Btrfs: Add delayed allocation to the extent based page tree code")
13 years ago the btree is no longer modified from the write path, hence
there is no point in calling this function. Just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fde125616687..6a76aea7bcb3 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1784,8 +1784,6 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		cond_resched();
 
 		balance_dirty_pages_ratelimited(inode->i_mapping);
-		if (dirty_pages < (fs_info->nodesize >> PAGE_SHIFT) + 1)
-			btrfs_btree_balance_dirty(fs_info);
 
 		pos += copied;
 		num_written += copied;
-- 
2.17.1

