Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AA5C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 11:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 242A42084F
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 11:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfBUL5V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 06:57:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:48480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbfBUL5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 06:57:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69279B181
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2019 11:57:20 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 3/6] btrfs: Make compress_file_range take only struct async_chunk
Date:   Thu, 21 Feb 2019 13:57:14 +0200
Message-Id: <20190221115717.5128-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190221115717.5128-1-nborisov@suse.com>
References: <20190221115717.5128-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All context this function needs is held within struct async_chunk.
Currently we not only pass the struct but also every individual member.
This is redundant, simplify it by only passing struct async_chunk and
leaving it to compress_file_range to extract the values it requires.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d61dd538d2b4..d566e15f8c58 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -449,14 +449,14 @@ static inline void inode_should_defrag(struct btrfs_inode *inode,
  * are written in the same order that the flusher thread sent them
  * down.
  */
-static noinline void compress_file_range(struct inode *inode,
-					struct page *locked_page,
-					u64 start, u64 end,
-					struct async_chunk *async_cow,
-					int *num_added)
+static noinline void compress_file_range(struct async_chunk *async_cow,
+					 int *num_added)
 {
+	struct inode *inode = async_cow->inode;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 blocksize = fs_info->sectorsize;
+	u64 start = async_cow->start;
+	u64 end = async_cow->end;
 	u64 actual_end;
 	int ret = 0;
 	struct page **pages = NULL;
@@ -675,9 +675,9 @@ static noinline void compress_file_range(struct inode *inode,
 	 * to our extent and set things up for the async work queue to run
 	 * cow_file_range to do the normal delalloc dance.
 	 */
-	if (page_offset(locked_page) >= start &&
-	    page_offset(locked_page) <= end)
-		__set_page_dirty_nobuffers(locked_page);
+	if (page_offset(async_cow->locked_page) >= start &&
+	    page_offset(async_cow->locked_page) <= end)
+		__set_page_dirty_nobuffers(async_cow->locked_page);
 		/* unlocked later on in the async handlers */
 
 	if (redirty)
@@ -1141,9 +1141,7 @@ static noinline void async_cow_start(struct btrfs_work *work)
 	int num_added = 0;
 	async_cow = container_of(work, struct async_chunk, work);
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
-			    async_cow->start, async_cow->end, async_cow,
-			    &num_added);
+	compress_file_range(async_cow, &num_added);
 	if (num_added == 0) {
 		btrfs_add_delayed_iput(async_cow->inode);
 		async_cow->inode = NULL;
-- 
2.17.1

