Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77C2C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD7A8214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="pnm3x3FP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD7A8214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbeKVFlb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:41:31 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38768 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFlb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:41:31 -0500
Received: by mail-yw1-f66.google.com with SMTP id i20so2677947ywc.5
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=DTDAD38vSYBkub9gfA4jndGSFn3T+R5a7UQKxBBUTEY=;
        b=pnm3x3FPGZ/7XQNGpCh4H6P78YO1XJ0ZW5XB0DZ1JzDp3GLFQhuxEORhS6BGXacr5Y
         G9eZSHhKVgCkYkk+YK8YLj/nYn0iBy/VRc+CX8LcRmVA8aUc1uHkH3R2boP9u+6LOazX
         9d/Rv2c9mXdBihSZ9hFU4SvpF23UDAYCaC/jqRwlxQ4Z9XYKoaDOkXcJNyKFynkmPCId
         lfiCebhMgSAcUpTzWFevFVIo8Mb33QeSAdoKtaHf/4YMf8xSHWOe+6UVabFsbpb+Dm3f
         Z8ephzGZLgdWpXx9TrmSJMsODSj0LpCH7x5EnkZhZluRuqQR5wTSqsJWU2aw0l8hix7K
         8deQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=DTDAD38vSYBkub9gfA4jndGSFn3T+R5a7UQKxBBUTEY=;
        b=kOC0PxDFYpehW7hDT46smrfE3CUtFLclbJDWKAjRNUnM/R02gI1/jeR+WslPt13L93
         xF0CMzeqlQG822Ah1yPxTPJmtxW3hsNa7jD8uhZQ3GzbErFfMiysmIVm1BazzDxaGabD
         ZZF9+Q7S1R/XnpLGTJmbsNNvQ29B8eoztrx7O+uRdpI4FPJmDI6KAki3BDakv6WHOLM3
         eJELLAJfHC1EAkQAl/0tLrJiqJuvLKMFoN2zIDm0dPkSpykSjKzfsHRaWtZ0bCzS8xXO
         f55vBRK8N1JmbKkIPghy3XdkmZxiyJaJgb3LzN4zzu440KXaflt4CCQ9FlE/w9ArN0Ys
         hKMg==
X-Gm-Message-State: AGRZ1gIDp23nHUkQUpodlzkpsNOUf+0e3myVnGP3+ESZp7d2fBe8hxFG
        Qk3FvtpCNekf6UVrkEmCUrKT6Du7Cds=
X-Google-Smtp-Source: AJdET5dkOdFj1CILR0ehTJbWQp8vneHfUz5cudnP3iUKl9L2PiVS6BM7vZpkwI4QThJeoJ/vYgENAA==
X-Received: by 2002:a81:3358:: with SMTP id z85mr7788872ywz.398.1542827158041;
        Wed, 21 Nov 2018 11:05:58 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id k206sm1602455ywa.16.2018.11.21.11.05.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:05:57 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 6/7] btrfs: cleanup pending bgs on transaction abort
Date:   Wed, 21 Nov 2018 14:05:44 -0500
Message-Id: <20181121190545.24798-7-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190545.24798-1-josef@toxicpanda.com>
References: <20181121190545.24798-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We may abort the transaction during a commit and not have a chance to
run the pending bgs stuff, which will leave block groups on our list and
cause us accounting issues and leaked memory.  Fix this by running the
pending bgs when we cleanup a transaction.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 826a15a07fce..3c1be9db897c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2269,6 +2269,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_scrub_continue(fs_info);
 cleanup_transaction:
 	btrfs_trans_release_metadata(trans);
+	/* This cleans up the pending block groups list properly. */
+	if (!trans->aborted)
+		trans->aborted = ret;
+	btrfs_create_pending_block_groups(trans);
 	btrfs_trans_release_chunk_metadata(trans);
 	trans->block_rsv = NULL;
 	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
-- 
2.14.3

