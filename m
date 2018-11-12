Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E333AC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 10:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2A29223C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 10:24:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xjkGbrO9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2A29223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbeKLURI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbeKLURI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 15:17:08 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44AAE223C8
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 10:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542018272;
        bh=cSRQ6trroBt0WR/tFq4T9ce/gIJNWKIS51yCUzQuuX0=;
        h=From:To:Subject:Date:From;
        b=xjkGbrO933Nzm6n1CvnFuwWpkhV5SlAPU9WOO+/kR49xI9o7v+jHpV5yD2YjswN0q
         xxjQpeTs0YebdXgMjYD0xR9E95/lxVXzbK6EBvDHX8tCGowWSP1L4dcfu+JHJtEZ5D
         yy9Bbae/33dRISoWHyA/zm6BXH+6KmjtFTBR4XCU=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove no longer used io_err from btrfs_log_ctx
Date:   Mon, 12 Nov 2018 10:24:30 +0000
Message-Id: <20181112102430.16096-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The io_err field of struct btrfs_log_ctx is no longer used after the
recent simplification of the fast fsync path, where we now wait for
ordered extents to complete before logging the inode. We did this in
commit b5e6c3e170b7 ("btrfs: always wait on ordered extents at fsync
time") and commit a2120a473a80 ("btrfs: clean up the left over
logged_list usage") removed its last use.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c     | 19 -------------------
 fs/btrfs/tree-log.h |  2 --
 2 files changed, 21 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6483757f0c09..65b3bcda99e2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2157,25 +2157,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	inode_unlock(inode);
 
-	/*
-	 * If any of the ordered extents had an error, just return it to user
-	 * space, so that the application knows some writes didn't succeed and
-	 * can take proper action (retry for e.g.). Blindly committing the
-	 * transaction in this case, would fool userspace that everything was
-	 * successful. And we also want to make sure our log doesn't contain
-	 * file extent items pointing to extents that weren't fully written to -
-	 * just like in the non fast fsync path, where we check for the ordered
-	 * operation's error flag before writing to the log tree and return -EIO
-	 * if any of them had this flag set (btrfs_wait_ordered_range) -
-	 * therefore we need to check for errors in the ordered operations,
-	 * which are indicated by ctx.io_err.
-	 */
-	if (ctx.io_err) {
-		btrfs_end_transaction(trans);
-		ret = ctx.io_err;
-		goto out;
-	}
-
 	if (ret != BTRFS_NO_LOG_SYNC) {
 		if (!ret) {
 			ret = btrfs_sync_log(trans, root, &ctx);
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 7ab9bb88a639..a1e14ee26c54 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -15,7 +15,6 @@
 struct btrfs_log_ctx {
 	int log_ret;
 	int log_transid;
-	int io_err;
 	bool log_new_dentries;
 	struct inode *inode;
 	struct list_head list;
@@ -26,7 +25,6 @@ static inline void btrfs_init_log_ctx(struct btrfs_log_ctx *ctx,
 {
 	ctx->log_ret = 0;
 	ctx->log_transid = 0;
-	ctx->io_err = 0;
 	ctx->log_new_dentries = false;
 	ctx->inode = inode;
 	INIT_LIST_HEAD(&ctx->list);
-- 
2.11.0

