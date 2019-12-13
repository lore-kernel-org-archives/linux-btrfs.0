Return-Path: <SRS0=17CA=2D=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8CCC4D2D1
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0486124784
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfLMT6P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 14:58:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:59056 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728988AbfLMT6O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Dec 2019 14:58:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AF0F6B2BF;
        Fri, 13 Dec 2019 19:58:12 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     hch@infradead.org, darrick.wong@oracle.com, fdmanana@kernel.org,
        nborisov@suse.com, dsterba@suse.cz, jthumshirn@suse.de,
        linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 8/8] btrfs: remove BTRFS_INODE_READDIO_NEED_LOCK
Date:   Fri, 13 Dec 2019 13:57:50 -0600
Message-Id: <20191213195750.32184-9-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191213195750.32184-1-rgoldwyn@suse.de>
References: <20191213195750.32184-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Since we now perform direct reads using i_rwsem, we can remove this
inode flag used to co-ordinate unlocked reads.

The truncate call takes i_rwsem. This means it is correctly synchronized
with concurrent direct reads.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jth@kernel.org>
---
 fs/btrfs/btrfs_inode.h | 18 ------------------
 fs/btrfs/inode.c       |  3 ---
 2 files changed, 21 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 4e12a477d32e..cd8f378ed8e7 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -27,7 +27,6 @@ enum {
 	BTRFS_INODE_NEEDS_FULL_SYNC,
 	BTRFS_INODE_COPY_EVERYTHING,
 	BTRFS_INODE_IN_DELALLOC_LIST,
-	BTRFS_INODE_READDIO_NEED_LOCK,
 	BTRFS_INODE_HAS_PROPS,
 	BTRFS_INODE_SNAPSHOT_FLUSH,
 };
@@ -317,23 +316,6 @@ struct btrfs_dio_private {
 			blk_status_t);
 };
 
-/*
- * Disable DIO read nolock optimization, so new dio readers will be forced
- * to grab i_mutex. It is used to avoid the endless truncate due to
- * nonlocked dio read.
- */
-static inline void btrfs_inode_block_unlocked_dio(struct btrfs_inode *inode)
-{
-	set_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
-	smp_mb();
-}
-
-static inline void btrfs_inode_resume_unlocked_dio(struct btrfs_inode *inode)
-{
-	smp_mb__before_atomic();
-	clear_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
-}
-
 /* Array of bytes with variable length, hexadecimal format 0x1234 */
 #define CSUM_FMT				"0x%*phN"
 #define CSUM_FMT_VALUE(size, bytes)		size, bytes
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 07220194ffb8..68adb7958ef4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5273,10 +5273,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 
 		truncate_setsize(inode, newsize);
 
-		/* Disable nonlocked read DIO to avoid the endless truncate */
-		btrfs_inode_block_unlocked_dio(BTRFS_I(inode));
 		inode_dio_wait(inode);
-		btrfs_inode_resume_unlocked_dio(BTRFS_I(inode));
 
 		ret = btrfs_truncate(inode, newsize == oldsize);
 		if (ret && inode->i_nlink) {
-- 
2.16.4

