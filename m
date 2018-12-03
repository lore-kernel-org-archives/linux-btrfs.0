Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5367EC07E85
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BB7320834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="BsrqaSo7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BB7320834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbeLCPU7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:20:59 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:41816 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbeLCPU7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:20:59 -0500
Received: by mail-yw1-f65.google.com with SMTP id f65so5516073ywc.8
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=hHtcDYnXOhWCyKFQ33WPBhLZWr2Xg4OGIItW/Kobk30=;
        b=BsrqaSo7pVGGHf+2VXC00+hwJMuZwugOxF0OriBvRjn2GsJBTmlnshotCn1k3oUQyd
         aMfFCbHSco/93E2tRkH781QsX5dFKiWp137SzLGvO0zauMGUPbSWDBQQ2we7WOqdqzpB
         HjcCNGuUR8QmEfHhRivchLWySKchbFY2uIQXv28Z4w0DeuHcVVAnbkdgEgAYYE8PM/rV
         C9FKT7uHwZIUWQEz2HQNpRiXVTL1Ak4US6Q4vd4imFquGzSDNvxu+KXDIsgveLsaZh8r
         HSeToMFCJeZ2il9b0DQGWZOtW3AVokuvx6OzJSlzPyPEnTe1kTzNweB8qvdGd55daXj0
         aAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=hHtcDYnXOhWCyKFQ33WPBhLZWr2Xg4OGIItW/Kobk30=;
        b=i6BwEcElZJl3wRtFs0+sx2LDHYWQ2oGdCsZbHXmJutlMVyY/o0mGvNXzfw4mFRMahQ
         M8XyixIjWMkJUS5MZfiPFrmlrcJkYmA1mdc5+k8JGd7HmaoByQKWQtkEf4G5Hva3qrD2
         y8+pn8khIDP24N7XpPcZ4ZbZ0hAd3Uz6/TXMzB+L6c1P0T2teYMOuLomgXnb1CaP8HzM
         /80lScePG0g7N7/0gdJc6uiSXQRQkhvFVqTJqc3+3kliFLE1AedpWhoCFLLvmMRPc3M4
         I+a4XVE9xVR8e5gD0c8u/9tpGoZ8x6L0MvSPtp3cxVSBi1Khhpher7yZ1swYSSpq2dUt
         nVQA==
X-Gm-Message-State: AA+aEWZuTQRB7xfSjKpXJnLvnMsGorBHCPrp4t2mBRjk1ItziIZ6NkmI
        Ia3DTovFfaZCF072/Kon61LaikDdvjg=
X-Google-Smtp-Source: AFSGD/W1hlx8TUeYPw0fheObuJRja+w4tHfwYtrQQ+m8NOtfwstgv0bp0ouIrs7CTphrRZRiqcMB8Q==
X-Received: by 2002:a81:b65d:: with SMTP id h29mr15609321ywk.429.1543850457285;
        Mon, 03 Dec 2018 07:20:57 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id p201sm5792670ywe.45.2018.12.03.07.20.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:56 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 09/10] btrfs: don't run delayed refs in the end transaction logic
Date:   Mon,  3 Dec 2018 10:20:37 -0500
Message-Id: <20181203152038.21388-10-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Over the years we have built up a lot of infrastructure to keep delayed
refs in check, mostly by running them at btrfs_end_transaction() time.
We have a lot of different maths we do to figure out how much, if we
should do it inline or async, etc.  This existed because we had no
feedback mechanism to force the flushing of delayed refs when they
became a problem.  However with the enospc flushing infrastructure in
place for flushing delayed refs when they put too much pressure on the
enospc system we have this problem solved.  Rip out all of this code as
it is no longer needed.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2d8401bf8df9..01f39401619a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -798,22 +798,12 @@ static int should_end_transaction(struct btrfs_trans_handle *trans)
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	int updates;
-	int err;
 
 	smp_mb();
 	if (cur_trans->state >= TRANS_STATE_BLOCKED ||
 	    cur_trans->delayed_refs.flushing)
 		return 1;
 
-	updates = trans->delayed_ref_updates;
-	trans->delayed_ref_updates = 0;
-	if (updates) {
-		err = btrfs_run_delayed_refs(trans, updates * 2);
-		if (err) /* Error code will also eval true */
-			return err;
-	}
-
 	return should_end_transaction(trans);
 }
 
@@ -843,11 +833,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *info = trans->fs_info;
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	u64 transid = trans->transid;
-	unsigned long cur = trans->delayed_ref_updates;
 	int lock = (trans->type != TRANS_JOIN_NOLOCK);
 	int err = 0;
-	int must_run_delayed_refs = 0;
 
 	if (refcount_read(&trans->use_count) > 1) {
 		refcount_dec(&trans->use_count);
@@ -858,27 +845,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
-
-	trans->delayed_ref_updates = 0;
-	if (!trans->sync) {
-		must_run_delayed_refs =
-			btrfs_should_throttle_delayed_refs(trans);
-		cur = max_t(unsigned long, cur, 32);
-
-		/*
-		 * don't make the caller wait if they are from a NOLOCK
-		 * or ATTACH transaction, it will deadlock with commit
-		 */
-		if (must_run_delayed_refs == 1 &&
-		    (trans->type & (__TRANS_JOIN_NOLOCK | __TRANS_ATTACH)))
-			must_run_delayed_refs = 2;
-	}
-
-	btrfs_trans_release_metadata(trans);
-	trans->block_rsv = NULL;
-
 	if (!list_empty(&trans->new_bgs))
 		btrfs_create_pending_block_groups(trans);
 
@@ -923,10 +889,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	}
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
-	if (must_run_delayed_refs) {
-		btrfs_async_run_delayed_refs(info, cur, transid,
-					     must_run_delayed_refs == 1);
-	}
 	return err;
 }
 
-- 
2.14.3

