Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFBDC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E40A215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="kB5k4RIV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E40A215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbeI1RmF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45309 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1RmF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id l2-v6so6092598qtr.12
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=471cQ/dE/uVCNlSocUpXaqoy8Ktro672PmaGzD5v8vY=;
        b=kB5k4RIVewxdSRXEl8RLr6OZZ4YF8a/ksuTYinBDE1tn90vOiybY8dMPDgDcL9WGSi
         hJ6VNclRPggaiaTIeArSaFUvrBhr+nK3lH7SHFoytj6NM23azETBWJI2Sv4zqEDMROOS
         UgTCi7lLLckNZOmHFf0Xkr5fWm3QUB+zy7t6E2Qev3C6SPNBRRocd5APFlauCvpem1fo
         Rt0Ws21TX/tTfAPT3mXKH99aD9fYd0Ovbrch31FTtHureSamO+3/xVV2iHNBS8KiIj1z
         xBUTtj/O5ZpSyQD4BzCJlYblV3mLiLgUD/kiXK5sw/jWpFn0Ia2Ds/DDTdN3N+6wJXMS
         H+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=471cQ/dE/uVCNlSocUpXaqoy8Ktro672PmaGzD5v8vY=;
        b=Qyz5YXnYBrjCtf83nDosVw1qfse/m9TAlPBapPc33Zfm4XnAiv8dPoEYRABIDwQytA
         EWA4geVt4tBQejoKpzb4nN2QiKlI4SzAt6bopy34nttElE9KcW81uppEcH+m0i5vqY7n
         93feMEfoa/cYhZUKFgsi9OOoltyg5/dvoKr0RpIHLDGsYxgcD08QvfWXtay7SVsf3KaJ
         hcycbT4xAe29mrgx5IWkewFbtaZwpJlx3tbWu0uSlZNXFRM6x/EX7pops2pyQsz4O5wI
         iVxsATWR8TOCUSJHnc/Y1iPFCyE/9V6tpLOZRogPYLG04+PMPJsLlazagBup6r6PWk5V
         naag==
X-Gm-Message-State: ABuFfojnf6AW+41Dx642G80fGKajTotcNOG8EhXWYIEoabUut0j+GmNN
        GaJ1YUr3ZOkWfa576AuuG10Wo5iIz+U=
X-Google-Smtp-Source: ACcGV61cf6Z2RoC6JNOddQOikl3iAaGiCJnFN6ueghNTLjYCzwqCRSs1WJSXHPnycanWKlzuIsxSIA==
X-Received: by 2002:aed:3384:: with SMTP id v4-v6mr11926048qtd.267.1538133527773;
        Fri, 28 Sep 2018 04:18:47 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id h58-v6sm3132728qtk.60.2018.09.28.04.18.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:46 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 12/42] btrfs: don't use global rsv for chunk allocation
Date:   Fri, 28 Sep 2018 07:17:51 -0400
Message-Id: <20180928111821.24376-13-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We've done this forever because of the voodoo around knowing how much
space we have.  However we have better ways of doing this now, and on
normal file systems we'll easily have a global reserve of 512MiB, and
since metadata chunks are usually 1GiB that means we'll allocate
metadata chunks more readily.  Instead use the actual used amount when
determining if we need to allocate a chunk or not.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c9913c59686b..c0f6110419b2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4374,21 +4374,12 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
 static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
 			      struct btrfs_space_info *sinfo, int force)
 {
-	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	u64 bytes_used = btrfs_space_info_used(sinfo, false);
 	u64 thresh;
 
 	if (force == CHUNK_ALLOC_FORCE)
 		return 1;
 
-	/*
-	 * We need to take into account the global rsv because for all intents
-	 * and purposes it's used space.  Don't worry about locking the
-	 * global_rsv, it doesn't change except when the transaction commits.
-	 */
-	if (sinfo->flags & BTRFS_BLOCK_GROUP_METADATA)
-		bytes_used += calc_global_rsv_need_space(global_rsv);
-
 	/*
 	 * in limited mode, we want to have some free space up to
 	 * about 1% of the FS size.
-- 
2.14.3

