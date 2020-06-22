Return-Path: <SRS0=j8o/=AD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489E0C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jun 2020 16:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281B220656
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jun 2020 16:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbgFVQUa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 12:20:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:46084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgFVQU3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jun 2020 12:20:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 581A4C241;
        Mon, 22 Jun 2020 16:20:28 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 2/8] btrfs: Move FS error state bit early during write
Date:   Mon, 22 Jun 2020 11:20:11 -0500
Message-Id: <20200622162017.21773-3-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200622162017.21773-1-rgoldwyn@suse.de>
References: <20200622162017.21773-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

We don't need the inode locked to check for the error bit. Move the
check early.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 01377a7d1d13..9ec30ccbd67a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1932,6 +1932,15 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	size_t count;
 	loff_t oldsize;
 
+	/*
+	 * If BTRFS flips readonly due to some impossible error
+	 * (fs_info->fs_state now has BTRFS_SUPER_FLAG_ERROR),
+	 * although we have opened a file as writable, we have
+	 * to stop this write operation to ensure FS consistency.
+	 */
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
+		return -EROFS;
+
 	if (!(iocb->ki_flags & IOCB_DIRECT) &&
 	    (iocb->ki_flags & IOCB_NOWAIT))
 		return -EOPNOTSUPP;
@@ -1971,18 +1980,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
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
2.25.0

