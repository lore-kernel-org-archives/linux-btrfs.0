Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D11EC43444
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EDBF21479
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbfACIuJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:50:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:60076 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbfACIuJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 03:50:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2443AF70
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 08:50:07 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/7] btrfs: Use ihold instead of igrab in cow_file_range_async
Date:   Thu,  3 Jan 2019 10:50:01 +0200
Message-Id: <20190103085005.32053-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190103085005.32053-1-nborisov@suse.com>
References: <20190103085005.32053-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

ihold is supposed to be used when the caller already has a reference to
the inode. In the case of cow_file_range_async this invariants holds,
since the 3 call chains leading to this function all take a reference:

btrfs_writepage  <--- does igrab
 extent_write_full_page
  __extent_writepage
   writepage_delalloc
     btrfs_run_delalloc_range
      cow_file_range_async

extent_write_cache_pages <--- does igrab
 __extent_writepage (same callchain as above)

and

submit_compressed_extents <-- already called from async CoW submit path,
			      which would have done ihold.
 extent_write_locked_range
  __extent_writepage

No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 97ad494d0b3c..f023d2b5ef49 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1194,7 +1194,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		if (!async_cow)
 			return -ENOMEM;
-		async_cow->inode = igrab(inode);
+		ihold(inode);
+		async_cow->inode = inode;
 		async_cow->fs_info = fs_info;
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
-- 
2.17.1

