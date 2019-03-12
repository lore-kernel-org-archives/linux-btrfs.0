Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F52FC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD0A2054F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfCLPUr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:20:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:41182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726600AbfCLPUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 11:20:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B3EAFB69B
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 15:20:36 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/7] btrfs: Replace clear_extent_bit with unlock_extent
Date:   Tue, 12 Mar 2019 17:20:28 +0200
Message-Id: <20190312152030.31987-6-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190312152030.31987-1-nborisov@suse.com>
References: <20190312152030.31987-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index df008aa195b4..0123f7067c8a 100644
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

