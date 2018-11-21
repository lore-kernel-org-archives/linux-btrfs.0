Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D476C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16ECF206BB
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="fMoeA7Z4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16ECF206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388702AbeKVFpx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:45:53 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45916 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728508AbeKVFpv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:45:51 -0500
Received: by mail-yw1-f67.google.com with SMTP id d190so2673928ywd.12
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=U00qdcgjBsAx+U7o9QiXdKu8jPdvEDb3FfF0Zgxi5kQ=;
        b=fMoeA7Z4RpVkF1WUwa6UYL38q0LSE6CpGOVs89u8LenB4WQI031/jR1maLkccZhrM3
         eDG/aRcVunfwoFBSdSGxZxuv+rgeEinkJj+NZTf/8t6XW8wXDvae8myIrnu8JU8HYVPe
         5Hy4d4NNNCLxrB4XHDlssTjPCPQsJ66fnQRhWHWlmcLn/Yma8/J1tX9Rq8oEvwZLtMg6
         G9Fl2TQw0vAJixWHFE1BZJdIqNLQnvHAVtIfigPwwP0EGVY7nFUo5umXY4gVtxmcFePf
         a1RYTiucYHnM81cVpBxmeU24Qn/B1lp6u2IQV2xedxC/o4wm9pu52PFrsC6+rjDxJWmg
         K2Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=U00qdcgjBsAx+U7o9QiXdKu8jPdvEDb3FfF0Zgxi5kQ=;
        b=XxSY2yfZpwY24/ZCvtc0t5bVe9m0o/ELEb+TB9wYH8ch/fOoD2g59arv1Y1A4BrAC5
         c9k0st30bwNJpQwGv40+SDGLy/ZwCzhFYBBIzSH9rbT5hfPU3r1wuOghfTCugO38nTzF
         eYjTAa1TiOhNzYxewL6bPUQ1olvE8bgDyhHQgBg1eqtiSDRW45/lpnvj8IX08QNgAe3p
         BAlcMTgyZda8j4KP/z69phmyPxvh1QM5fpQaItK0jTV1xbpV+y3+YO/YE5UOhpcKfGVx
         SkR/k+yqG5muj36GQQlQaEW120vj48rFmReuiVFHy0paDep2ckuIO9yhInJqGXd5V+HY
         WZxQ==
X-Gm-Message-State: AGRZ1gJghrC6HbM+o0IL52f8Y2xrAK/xQ1PjDy58xMXC9cf9wJ+DpOBQ
        BoACkiqh2nsDFU6/UkMEMjoOPw==
X-Google-Smtp-Source: AJdET5ezAUeCnGWNGVtVj3LLMWPL8QkRol7YnJxwDEM1d/ZKS3Bz6rtlox59JXZLAEVbTaHjQ60Ydg==
X-Received: by 2002:a81:1417:: with SMTP id 23-v6mr7733249ywu.201.1542827418275;
        Wed, 21 Nov 2018 11:10:18 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l35sm13367370ywh.48.2018.11.21.11.10.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:10:17 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: only run delayed refs if we're committing
Date:   Wed, 21 Nov 2018 14:10:16 -0500
Message-Id: <20181121191016.25224-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I noticed in a giant dbench run that we spent a lot of time on lock
contention while running transaction commit.  This is because dbench
results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
they all run the delayed refs first thing, so they all contend with
each other.  This leads to seconds of 0 throughput.  Change this to only
run the delayed refs if we're the ones committing the transaction.  This
makes the latency go away and we get no more lock contention.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3c1be9db897c..41cc96cc59a3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1918,15 +1918,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	/* make a pass through all the delayed refs we have so far
-	 * any runnings procs may add more while we are here
-	 */
-	ret = btrfs_run_delayed_refs(trans, 0);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
-	}
-
 	cur_trans = trans->transaction;
 
 	/*
@@ -1938,12 +1929,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	btrfs_create_pending_block_groups(trans);
 
-	ret = btrfs_run_delayed_refs(trans, 0);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
-	}
-
 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
 		int run_it = 0;
 
@@ -2014,6 +1999,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		spin_unlock(&fs_info->trans_lock);
 	}
 
+	/*
+	 * We are now the only one in the commit area, we can run delayed refs
+	 * without hitting a bunch of lock contention from a lot of people
+	 * trying to commit the transaction at once.
+	 */
+	ret = btrfs_run_delayed_refs(trans, 0);
+	if (ret)
+		goto cleanup_transaction;
+
 	extwriter_counter_dec(cur_trans, trans->type);
 
 	ret = btrfs_start_delalloc_flush(fs_info);
-- 
2.14.3

