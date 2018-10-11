Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A63C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3898A20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="QJHkhUxT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3898A20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbeJLDYm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:42 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46916 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbeJLDYi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:38 -0400
Received: by mail-qt1-f195.google.com with SMTP id d8-v6so11327661qtk.13
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=sV09l7dO3avmvRHRl1FabUbd/mHTvojy+8waApybFR4=;
        b=QJHkhUxTtQCT3P7+4G825BxRv6Zb3O/MQjoykCcyuMzzTi+g5a8tHxkMMMgD6mwKmo
         AU9hRRofkamjx9oF0knlek5kojdexn2Cxr28/nW1FprCl2bdtdPApZP63BAE4U9CmF6y
         tvHO+Fu+UC1zzxI67l+1MRor0PgRxAzZSt6+CKTYKwoDcsJG2aSvIEQssu2Btxxx23yD
         2qJAvU5hOc8JBmkZu/Yv/JFjphZwVmNYeKJ6gLeK3AqRe7nhD2Kd2dmaLPNCUozn5Cq1
         lEnUlLtDFOpFf+TAMjLzOVboaifZpg9pCYedqzdqzlrqWk3cnj5TVy8WXg+3AYfYSZ9g
         z3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=sV09l7dO3avmvRHRl1FabUbd/mHTvojy+8waApybFR4=;
        b=bR4mFcg98sWFOkISII78DeoZeB8yLPW0hNIaGRqkvsRAc39vJ17y3CHMEOqmzrhryw
         1+gxmOCU/+0ufLd2KODeaDMrxS2q/jHLHQO5Th7juJKSX5lsdhdD5FojrKyC5BwUbEeL
         5kqQRt8CzcdQM3ol3epiS7gYGOIoQ6AgH26XScKyFTIFjpuQ4zgXgSAq+NUQ0Vj+ECYv
         Zr+a1lZzzUhh+7EkNCwUhW3l96gGkDyvfON6L9+v+AA78vtg0VgzwOMtfaOUmf7j82RF
         ILxA8G3E3jjqGTLBRJik13o+6pMI1pGYAiXYmuHmVONYvqvZnKDE65N1k1qDximRR3yw
         aTpg==
X-Gm-Message-State: ABuFfoiRl7ZrbRlVASY2CCNdx5QwupuDl9Unh3xK6qh4fygmciHco/Yy
        kZtThyxOJr0Ur4xp/hvhe4J66S30jD8=
X-Google-Smtp-Source: ACcGV60N5A174vlAs4DYMdFjDp6joNWacNStxT1y6RKC4qNax2Ctpyj18gmcFwvdxZZk3px1WyM7Og==
X-Received: by 2002:a0c:c346:: with SMTP id j6mr3104905qvi.48.1539287752336;
        Thu, 11 Oct 2018 12:55:52 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i27-v6sm17965684qti.57.2018.10.11.12.55.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:51 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 42/42] btrfs: don't run delayed_iputs in commit
Date:   Thu, 11 Oct 2018 15:54:31 -0400
Message-Id: <20181011195431.3441-43-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This could result in a really bad case where we do something like

evict
  evict_refill_and_join
    btrfs_commit_transaction
      btrfs_run_delayed_iputs
        evict
          evict_refill_and_join
            btrfs_commit_transaction
... forever

We have plenty of other places where we run delayed iputs that are much
safer, let those do the work.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9168efaca37e..c91dc36fccae 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2265,15 +2265,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 
-	/*
-	 * If fs has been frozen, we can not handle delayed iputs, otherwise
-	 * it'll result in deadlock about SB_FREEZE_FS.
-	 */
-	if (current != fs_info->transaction_kthread &&
-	    current != fs_info->cleaner_kthread &&
-	    !test_bit(BTRFS_FS_FROZEN, &fs_info->flags))
-		btrfs_run_delayed_iputs(fs_info);
-
 	return ret;
 
 scrub_continue:
-- 
2.14.3

