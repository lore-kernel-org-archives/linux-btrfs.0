Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A0FC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C42E42054F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfCLPUh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:20:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:41170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726255AbfCLPUh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 11:20:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 112AFB69F
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 15:20:36 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/7] btrfs: Remove fs_info from struct async_chunk
Date:   Tue, 12 Mar 2019 17:20:26 +0200
Message-Id: <20190312152030.31987-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190312152030.31987-1-nborisov@suse.com>
References: <20190312152030.31987-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The associated btrfs_work already contains a reference to the fs_info so
use that instead of passing it via async_chunk. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/inode.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index be3777d03c80..2a9d24bc8b53 100644
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
-	struct async_chunk *async_chunk;
+	struct async_chunk *async_chunk = container_of(work, struct async_chunk,
+						     work);
+	struct btrfs_fs_info *fs_info = btrfs_work_owner(work);
 	unsigned long nr_pages;
 
-	async_chunk = container_of(work, struct async_chunk, work);
-
-	fs_info = async_chunk->fs_info;
 	nr_pages = (async_chunk->end - async_chunk->start + PAGE_SIZE) >>
 		PAGE_SHIFT;
 
@@ -1252,7 +1249,6 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_chunk[i].inode = inode;
 		async_chunk[i].start = start;
 		async_chunk[i].end = cur_end;
-		async_chunk[i].fs_info = fs_info;
 		async_chunk[i].locked_page = locked_page;
 		async_chunk[i].write_flags = write_flags;
 		INIT_LIST_HEAD(&async_chunk[i].extents);
-- 
2.17.1

