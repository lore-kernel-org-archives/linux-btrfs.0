Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40436C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04C2F20672
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:17:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04C2F20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437089AbeKWC5B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 21:57:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:57936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436801AbeKWC5B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 21:57:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2A20AD12
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 16:16:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A069BDA829; Thu, 22 Nov 2018 17:16:44 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: replace async_cow::root with fs_info
Date:   Thu, 22 Nov 2018 17:16:44 +0100
Message-Id: <fd6d887df4b22a7522ae3fa4dc0a2c6db88ff27b.1542902890.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542902890.git.dsterba@suse.com>
References: <cover.1542902890.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The async_cow::root is used to propagate fs_info to async_cow_submit.
We can't use inode to reach it because it could become NULL after
write without compression in async_cow_start.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a88122b89f50..26b8bec7c2dc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -358,7 +358,7 @@ struct async_extent {
 
 struct async_cow {
 	struct inode *inode;
-	struct btrfs_root *root;
+	struct btrfs_fs_info *fs_info;
 	struct page *locked_page;
 	u64 start;
 	u64 end;
@@ -1144,13 +1144,11 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 {
 	struct btrfs_fs_info *fs_info;
 	struct async_cow *async_cow;
-	struct btrfs_root *root;
 	unsigned long nr_pages;
 
 	async_cow = container_of(work, struct async_cow, work);
 
-	root = async_cow->root;
-	fs_info = root->fs_info;
+	fs_info = async_cow->fs_info;
 	nr_pages = (async_cow->end - async_cow->start + PAGE_SIZE) >>
 		PAGE_SHIFT;
 
@@ -1179,7 +1177,6 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct async_cow *async_cow;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	unsigned long nr_pages;
 	u64 cur_end;
 
@@ -1189,7 +1186,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		BUG_ON(!async_cow); /* -ENOMEM */
 		async_cow->inode = igrab(inode);
-		async_cow->root = root;
+		async_cow->fs_info = fs_info;
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 		async_cow->write_flags = write_flags;
-- 
2.19.1

