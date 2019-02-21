Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C94C00319
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 11:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 921302084F
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 11:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfBUL5V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 06:57:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:48474 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727550AbfBUL5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 06:57:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36E90B17E
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2019 11:57:20 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 2/6] btrfs: Remove fs_info from struct async_chunk
Date:   Thu, 21 Feb 2019 13:57:13 +0200
Message-Id: <20190221115717.5128-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190221115717.5128-1-nborisov@suse.com>
References: <20190221115717.5128-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The associated btrfs_work already contains a reference to the fs_info so
use that instead of passing it via async_chunk. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0f82ea348164..d61dd538d2b4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -368,7 +368,6 @@ struct async_extent {
 
 struct async_chunk {
 	struct inode *inode;
-	struct btrfs_fs_info *fs_info;
 	struct page *locked_page;
 	u64 start;
 	u64 end;
@@ -1156,13 +1155,11 @@ static noinline void async_cow_start(struct btrfs_work *work)
  */
 static noinline void async_cow_submit(struct btrfs_work *work)
 {
-	struct btrfs_fs_info *fs_info;
-	struct async_chunk *async_cow;
+	struct async_chunk *async_cow = container_of(work, struct async_chunk,
+						     work);
+	struct btrfs_fs_info *fs_info = btrfs_work_owner(work);
 	unsigned long nr_pages;
 
-	async_cow = container_of(work, struct async_chunk, work);
-
-	fs_info = async_cow->fs_info;
 	nr_pages = (async_cow->end - async_cow->start + PAGE_SIZE) >>
 		PAGE_SHIFT;
 
@@ -1249,7 +1246,6 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow[i].inode = inode;
 		async_cow[i].start = start;
 		async_cow[i].end = cur_end;
-		async_cow[i].fs_info = fs_info;
 		async_cow[i].locked_page = locked_page;
 		async_cow[i].write_flags = write_flags;
 		INIT_LIST_HEAD(&async_cow[i].extents);
-- 
2.17.1

