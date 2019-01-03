Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4CCC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3382020883
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbfACIuR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:50:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:60084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729124AbfACIuJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 03:50:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 28C7DAF84
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 08:50:08 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/7] btrfs: Remove WARN_ON in btrfs_alloc_delalloc_work
Date:   Thu,  3 Jan 2019 10:50:02 +0200
Message-Id: <20190103085005.32053-5-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190103085005.32053-1-nborisov@suse.com>
References: <20190103085005.32053-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It can never trigger since before calling alloc_delalloc_work we have
called igrab in start_delalloc_inodes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f023d2b5ef49..1a7f790b68e8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9943,7 +9943,6 @@ static struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode
 	init_completion(&work->completion);
 	INIT_LIST_HEAD(&work->list);
 	work->inode = inode;
-	WARN_ON_ONCE(!inode);
 	btrfs_init_work(&work->work, btrfs_flush_delalloc_helper,
 			btrfs_run_delalloc_work, NULL, NULL);
 
-- 
2.17.1

