Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A9EC6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C215E20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="FOsqJNvn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C215E20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbeJLDXn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39388 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDXn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:43 -0400
Received: by mail-qt1-f193.google.com with SMTP id e22-v6so11363360qto.6
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=471cQ/dE/uVCNlSocUpXaqoy8Ktro672PmaGzD5v8vY=;
        b=FOsqJNvn24sHi7ORMBYzLsqvT0UMaMgxkwncGisB5ylg42sVq3CPXOdD8h4Nv5J6aC
         WUGoacLstDVilw9VYvMQQ2fNX/JyiE6r9rOgj6pffVsuji5A4Y+eSXtTn51vhMp+kWCD
         fwVlVzri1ChZqUkA0gTvubsDm1WjuFMu2NSrh1sTyynN9wr1Cji8AfSus0rh3kJba439
         CaeAL9glo5wAui179bakEJeHzhTGPy6HKjN0ZjYorVoC80W0la+BXoT1UNe+7bNshDy9
         lMY/o2zVM480FNqstZ5niK6hTEPb0hzyayRZ/dRljcZbF7qrfswPtF7zOGXHKADhrgU1
         a8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=471cQ/dE/uVCNlSocUpXaqoy8Ktro672PmaGzD5v8vY=;
        b=EFkL5Tb2xTH3PdnHgMmcEtem8Y/bTZznqIZTWJ03Pl32Zvca9oUBXSAfhqHZ1ieL57
         yh7EdTVn6DSnY9yr6jcatzDkNeimOgdOgVNGPl+h1gGSIw7IbayALdpEqj24D5tqYEK4
         91P/jdqFaEaitFzsZwtvDeCZvv6L9ShhWFpPplM1vhEOeNxHEe6ilEzPooV+wykhhR1y
         23b9CE5DwxRZI16RdBd28wkn8VqzJakKUy0g2B8FnXrKnInSK6iTU9e8YEoK9mO8IRXF
         49fv9SNGQlmMiTauyrq14LVIndgqaaMQ5v+H2Fc954rCSw5J0JVVN9o8K0q6B0rLkc8j
         m5cQ==
X-Gm-Message-State: ABuFfojS2gUChf0crA41rFV+33HHSNrCSX2GjTonD3Zb6ZfXX98+q/lz
        Di4p/kQ8JRhB8CeXQlrMA6Z6dd7O4MI=
X-Google-Smtp-Source: ACcGV60Zm6Jl1x0WWY5OLNWRyq2004hannA5ykBEPV0fwG+FqxRZN+dAKpejc0t2Q0uc35T2xvG0sA==
X-Received: by 2002:a0c:f744:: with SMTP id e4-v6mr2962445qvo.197.1539287696772;
        Thu, 11 Oct 2018 12:54:56 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y35-v6sm15817398qtc.49.2018.10.11.12.54.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:55 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 12/42] btrfs: don't use global rsv for chunk allocation
Date:   Thu, 11 Oct 2018 15:54:01 -0400
Message-Id: <20181011195431.3441-13-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

