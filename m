Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A6AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 13:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D6C20657
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552309862;
	bh=wvdSP9RtFbLCHFyDn0i7adsaEc3vRLpBSquMbgn1ZFI=;
	h=From:To:Subject:Date:List-ID:From;
	b=omWQNOQJkOtrPVM1pNqTYPF+HDFjwMOTESgs5gLKvN3vQvioSH9m/lOaV59BUh2v3
	 nDMn/U+wGFSSMOM765WYT+aKh85m9tZ3kRbyzDFP7TUS2B7+p+fQ+9GEVwt+GPR8Ro
	 p+u4J8DtTk7hO/vpP7KeoAr9kldweaOPiTJEm4Lw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfCKNLB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfCKNLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 09:11:00 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E311020657
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2019 13:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552309860;
        bh=wvdSP9RtFbLCHFyDn0i7adsaEc3vRLpBSquMbgn1ZFI=;
        h=From:To:Subject:Date:From;
        b=H0LgoiLpXKvJNwTvwRVeemlYLLYbY49TFPA8RuQe0uG7mSRdXczWvYnSy/1XkmDVe
         Z4huc0RuofFIMG5riQPc52SIgK7gm0LRakcOfOA7DS/du6DgWK0BC5jM72+r0ySUA1
         ipDlKpdDtZwlCR0V0WPJ1EGIOjUBtY3plEDZZxUM=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove no longer used 'sync' member from transaction handle
Date:   Mon, 11 Mar 2019 13:10:56 +0000
Message-Id: <20190311131056.2365-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Commit db2462a6ad3d ("btrfs: don't run delayed refs in the end transaction
logic") removed its last use, so now it does absolutely nothing, therefore
remove it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 6 ------
 fs/btrfs/file.c        | 1 -
 fs/btrfs/transaction.h | 1 -
 3 files changed, 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 994f0cc41799..bda83087271f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2910,12 +2910,6 @@ static void delayed_ref_async_start(struct btrfs_work *work)
 		goto done;
 	}
 
-	/*
-	 * trans->sync means that when we call end_transaction, we won't
-	 * wait on delayed refs
-	 */
-	trans->sync = true;
-
 	/* Don't bother flushing if we got into a different transaction */
 	if (trans->transid > async->transid)
 		goto end;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 34fe8a58b0e9..94c1c86fd18a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2165,7 +2165,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		inode_unlock(inode);
 		goto out;
 	}
-	trans->sync = true;
 
 	ret = btrfs_log_dentry_safe(trans, dentry, start, end, &ctx);
 	if (ret < 0) {
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index f1ba78949d1b..b34678e7968e 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -120,7 +120,6 @@ struct btrfs_trans_handle {
 	bool allocating_chunk;
 	bool can_flush_pending_bgs;
 	bool reloc_reserved;
-	bool sync;
 	bool dirty;
 	struct btrfs_root *root;
 	struct btrfs_fs_info *fs_info;
-- 
2.11.0

