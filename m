Return-Path: <SRS0=iRg2=DB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E66C2D0E2
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AEAC23741
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgIXQj6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:39:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:36378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728566AbgIXQj5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Sep 2020 12:39:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32425ABD1;
        Thu, 24 Sep 2020 16:39:56 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        johannes.thumshirn@wdc.com, dsterba@suse.com,
        darrick.wong@oracle.com, josef@toxicpanda.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 07/14] btrfs: Move FS error state bit early during write
Date:   Thu, 24 Sep 2020 11:39:14 -0500
Message-Id: <20200924163922.2547-8-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200924163922.2547-1-rgoldwyn@suse.de>
References: <20200924163922.2547-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

fs_info->fs_state is a filesystem bit check as opposed to inode
and can be performed before we begin with write checks. This eliminates
inode lock/unlock in case the error bit is set.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4c40a2742aab..f7e96754d4c9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1981,6 +1981,14 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	size_t count;
 	loff_t oldsize;
 
+	/*
+	 * If BTRFS flips readonly due to some impossible error,
+	 * although we have opened a file as writable, we have
+	 * to stop this write operation to ensure FS consistency.
+	 */
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
+		return -EROFS;
+
 	if (!(iocb->ki_flags & IOCB_DIRECT) &&
 	    (iocb->ki_flags & IOCB_NOWAIT))
 		return -EOPNOTSUPP;
@@ -2030,18 +2038,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 		goto out;
 	}
 
-	/*
-	 * If BTRFS flips readonly due to some impossible error
-	 * (fs_info->fs_state now has BTRFS_SUPER_FLAG_ERROR),
-	 * although we have opened a file as writable, we have
-	 * to stop this write operation to ensure FS consistency.
-	 */
-	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
-		inode_unlock(inode);
-		err = -EROFS;
-		goto out;
-	}
-
 	/*
 	 * We reserve space for updating the inode when we reserve space for the
 	 * extent we are going to write, so we will enospc out there.  We don't
-- 
2.26.2

