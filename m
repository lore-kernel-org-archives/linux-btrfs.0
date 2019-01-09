Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D2EC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 14:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F325D206BA
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 14:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731706AbfAIOnH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 09:43:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:35392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731729AbfAIOnG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Jan 2019 09:43:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1A7C1AD3C
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Jan 2019 14:43:05 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Handle ENOMEM gracefully in cow_file_range_async
Date:   Wed,  9 Jan 2019 16:43:03 +0200
Message-Id: <20190109144303.31847-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we run out of memory during delalloc filling in compress case btrfs
is going to BUG_ON. This is unnecessary since the higher levels code
(btrfs_run_delalloc_range and its callers) gracefully handle error
condtions and error out the page being submittede. Let's be a model
kernel citizen and no panic the machine due to ENOMEM and instead fail
the IO.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cde51ace68b5..b4b2d7f8a98b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1197,7 +1197,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 			 1, 0, NULL);
 	while (start < end) {
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
-		BUG_ON(!async_cow); /* -ENOMEM */
+		if (!async_cow)
+			return -ENOMEM;
 		/*
 		 * igrab is called higher up in the call chain, take only the
 		 * lightweight reference for the callback lifetime
-- 
2.17.1

