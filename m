Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30552C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F076B2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="O9wDp53x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F076B2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbeJMDIi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:38 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41052 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeJMDIi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id l41-v6so15055644qtl.8
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=sV09l7dO3avmvRHRl1FabUbd/mHTvojy+8waApybFR4=;
        b=O9wDp53xXiGiI3+RRjMyNCCkLOpSTIYQJZRk7Bh93aO53bdpyA7ePzQfpU+4nhgDG7
         0vwMWoOMTjj2k6HBSQmES1cBEH5cJ55lBsTC4NVlc5eqQPMs6toz7lbQHQW5tgKEFzdh
         Ly+SnJYxaJDXxk+NAgGYyfL/trmWWTDl8xqheQ9iacg9BjFznG1KiPobCSLXbs0ZmecO
         mld5UHJfh91yrVUEiOSaTsneb+Ktd8aVeMO5jykoS2XnC+8lS7eJhcHuUrp9ErWrThb5
         TJHcud8/rl0nvbGIJxiI4BpfCN/jKWyi17ip1qsQoav+JY+MfXuPHByNK85jCw4z05Ry
         4Buw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=sV09l7dO3avmvRHRl1FabUbd/mHTvojy+8waApybFR4=;
        b=Agc3faOshTAis80ClufY6Xet4CxoiwSW9VAJ8rWa0ZNJoqyyAEP68gnAPRHpLRRwEx
         C1n00VhXigX3mkpcJPwEH6SxZ+yFqhGKROTZw2LATTXdmlSad9ahUOD+VJWvJh1d+xcv
         hYc7VHTT8CX7dS0C1yIzLzqLat+q3JqHKSj5MizjqKC4imyH6NRSdJ3L0HjDRo0KvX5L
         SZaONAaUdiPNtzndEqVAMUjq+5a9/IWepFszv60LAZAR7j8ZR8Aa05D4jKYusGdrbQN8
         B4MFn3Yixm8BsUUJ+R6kaJ4mivXEs6LSLsvfjwyCBym/LN19LzQlCiS5oJxlgtv1EDHO
         /1hg==
X-Gm-Message-State: ABuFfogG7M+IHj4dbG9E7EKjqVTHaMA8JFyGOH2UQc7+IOYZ/8xUR8mB
        1To/ADVYb1i7L4a6CJqOgZ7ByWLdXKs=
X-Google-Smtp-Source: ACcGV61T5EgiRiaJGKCAH17qJ+KPi4G70kaNp1UxKATWuQsk3oVKnY+VwKGiJjfszq4XSgUg8icSPA==
X-Received: by 2002:aed:34e1:: with SMTP id x88-v6mr7167409qtd.156.1539372876570;
        Fri, 12 Oct 2018 12:34:36 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m9-v6sm1699980qkl.32.2018.10.12.12.34.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:35 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 42/42] btrfs: don't run delayed_iputs in commit
Date:   Fri, 12 Oct 2018 15:32:56 -0400
Message-Id: <20181012193256.13735-43-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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

