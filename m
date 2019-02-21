Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C23C00319
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 11:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 763B42084F
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 11:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfBUL5X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 06:57:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:48486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727645AbfBUL5W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 06:57:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB90BB182
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2019 11:57:20 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 4/6] btrfs: Replace clear_extent_bit with unlock_extent
Date:   Thu, 21 Feb 2019 13:57:15 +0200
Message-Id: <20190221115717.5128-5-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190221115717.5128-1-nborisov@suse.com>
References: <20190221115717.5128-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d566e15f8c58..c857f3c2bfc4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1204,8 +1204,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	int i;
 	bool should_compress;
 
-	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
-			 1, 0, NULL);
+	unlock_extent(&BTRFS_I(inode)->io_tree, start, end);
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
 	    !btrfs_test_opt(fs_info, FORCE_COMPRESS)) {
-- 
2.17.1

