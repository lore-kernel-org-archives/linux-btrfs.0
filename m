Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CABC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1E0215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="JnIsHloa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA1E0215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbeI1RnA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:43:00 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43667 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbeI1RnA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:43:00 -0400
Received: by mail-qt1-f194.google.com with SMTP id q41-v6so1331531qtq.10
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=sV09l7dO3avmvRHRl1FabUbd/mHTvojy+8waApybFR4=;
        b=JnIsHloaL5IVXTRWMo8NpVnqf60amNdc8hSjSwEEHS75ri0QIkp+rkyqexWBAe/RfJ
         kvSVLN/Zrl36FSoxpy1K3SqIzzuWwqyAeRvvb6hLFrPKbFrl7zob9iSNuzkSZkEX+z4X
         GSfuCbs579Q1z5qtq8dhKrHy2YFOBXKDphYH9238aTKboF5qdGwCnBvJnOJuGYPwTsWt
         5JudYLeujPloD+12ysWqnC/NKqLsm5+YQKLt2dA5W6MyoBYk0prDI10AUYb5X5vL7neU
         vkITs0jJH3M/Ki/5zoYaz9DYLDPrT42P27MLWsnchOX6IGNBih6mzNfgD1pTNzYAzerF
         RC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=sV09l7dO3avmvRHRl1FabUbd/mHTvojy+8waApybFR4=;
        b=pSOJFCVXVkCrS3+OmVQ7LP3t8VumLPPms8PEerz0b9zkcXUR6s17B7SgOL22/NQ9a6
         kivUs4pOM0OV3aMeu82TgTjvIdciypwjhyFUMJevtv2jVdwFvq+nPPgmQkpTWw2fQ0fz
         tFuJat3JxaVjboV70GFDhXdhAv2r9AcDqtDaCuf+suBD6KLAAWkDruqrWLUvuxzPwE7s
         d2hFHM0aJX00oJgfXk3r+MFzbu+kDJid84Rtn3GWH+dNRHCe9nsMWikCB8C+IqigRgO5
         eORqJy2xQBZ6YcIJuVm5K6jGmm/IVmWQg91NzrC9+sFYC5MRt+lDY2vkkb46cnyIQILY
         HoDw==
X-Gm-Message-State: ABuFfojDQB6wdCps3jTosxwpv65eDjJhBqi9efGKtit74oY5i1iqMk3W
        JRa7MPAcyULVvf6UcIbXGtO6WnSVVas=
X-Google-Smtp-Source: ACcGV61uS6FjiEU0OB+t1/dqEqENK7Jrfm2U+6hY+wq6XzolYGZ78qWgUo3R25EKZV4V0xGYMYuGPA==
X-Received: by 2002:ad4:404a:: with SMTP id r10-v6mr11556258qvp.246.1538133582592;
        Fri, 28 Sep 2018 04:19:42 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id v18-v6sm3180056qtj.94.2018.09.28.04.19.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:41 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 42/42] btrfs: don't run delayed_iputs in commit
Date:   Fri, 28 Sep 2018 07:18:21 -0400
Message-Id: <20180928111821.24376-43-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

