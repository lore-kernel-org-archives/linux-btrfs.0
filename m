Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B45CC43612
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E733920883
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbfACIuK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:50:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:60070 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728829AbfACIuJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 03:50:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9230AAF6C
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 08:50:07 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/7] btrfs: Remove isize local variable in compress_file_range
Date:   Thu,  3 Jan 2019 10:50:00 +0200
Message-Id: <20190103085005.32053-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190103085005.32053-1-nborisov@suse.com>
References: <20190103085005.32053-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It's used only once so just inline the call to i_size_read. 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 43baca50fba5..97ad494d0b3c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -453,7 +453,6 @@ static noinline void compress_file_range(struct inode *inode,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 blocksize = fs_info->sectorsize;
 	u64 actual_end;
-	u64 isize = i_size_read(inode);
 	int ret = 0;
 	struct page **pages = NULL;
 	unsigned long nr_pages;
@@ -467,7 +466,7 @@ static noinline void compress_file_range(struct inode *inode,
 	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
 			SZ_16K);
 
-	actual_end = min_t(u64, isize, end + 1);
+	actual_end = min_t(u64, i_size_read(inode), end + 1);
 again:
 	will_compress = 0;
 	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
-- 
2.17.1

