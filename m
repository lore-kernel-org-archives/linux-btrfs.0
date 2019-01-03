Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC24C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F0F520883
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfACIuJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:50:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:60064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728617AbfACIuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 03:50:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4ED72AF57
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 08:50:07 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/7] btrfs: Remove inode argument from async_cow_submit
Date:   Thu,  3 Jan 2019 10:49:59 +0200
Message-Id: <20190103085005.32053-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190103085005.32053-1-nborisov@suse.com>
References: <20190103085005.32053-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We already pass the async_cow struct that holds a reference to the
inode. Exploit this fact and remove the extra inode argument. No
functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 38c0f385a617..43baca50fba5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -714,9 +714,9 @@ static void free_async_extent_pages(struct async_extent *async_extent)
  * queued.  We walk all the async extents created by compress_file_range
  * and send them down to the disk.
  */
-static noinline void submit_compressed_extents(struct inode *inode,
-					      struct async_cow *async_cow)
+static noinline void submit_compressed_extents(struct async_cow *async_cow)
 {
+	struct inode *inode = async_cow->inode;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct async_extent *async_extent;
 	u64 alloc_hint = 0;
@@ -1167,7 +1167,7 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 		cond_wake_up_nomb(&fs_info->async_submit_wait);
 
 	if (async_cow->inode)
-		submit_compressed_extents(async_cow->inode, async_cow);
+		submit_compressed_extents(async_cow);
 }
 
 static noinline void async_cow_free(struct btrfs_work *work)
-- 
2.17.1

