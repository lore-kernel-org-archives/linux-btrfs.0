Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA261C43444
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 904D420883
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbfACIuK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:50:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:60098 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728617AbfACIuK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 03:50:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 68361AF8A
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 08:50:08 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/7] btrfs: Document logic in async_cow_submit
Date:   Thu,  3 Jan 2019 10:50:03 +0200
Message-Id: <20190103085005.32053-6-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190103085005.32053-1-nborisov@suse.com>
References: <20190103085005.32053-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add a comment explaining when ->inode could be null and why we always
perform the ->async_delalloc_pages modification.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1a7f790b68e8..41ad0d06b3d4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1165,6 +1165,12 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 	    5 * SZ_1M)
 		cond_wake_up_nomb(&fs_info->async_submit_wait);
 
+	/*
+	 * ->inode could be NULL if async_cow_start has failed to compress,
+	 * in which case we don't have anything to submit, yet we need to
+	 * adjust ->async_delalloc_pages always as its paired to the init
+	 * happening in cow_file_range_async
+	 */
 	if (async_cow->inode)
 		submit_compressed_extents(async_cow);
 }
-- 
2.17.1

