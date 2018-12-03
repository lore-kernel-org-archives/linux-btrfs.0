Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C492FC04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B13D20834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DgBpl8Ub"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B13D20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbeLCPZJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:25:09 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:43332 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPZJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:25:09 -0500
Received: by mail-yb1-f193.google.com with SMTP id x144so1262239ybg.10
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=nl6MLo/NHjX/vVb0yXW5grQ7bMmst7d2p+95T9TiGdo=;
        b=DgBpl8UbQoBHUM9FcGnPacNGamLAY0XoDNnQnc4aVPPJ3lMKcun+l4LU3uw3oeqKzq
         HOsyRLnMIvzErs74tDSo3IgMQYBcYEL7CUodoPDCQpa8tRkZcOuBxKS9NCq+RlPzck1c
         OadgvET4OOtmbmV5BqFEudRxbJe6moh66ZcLQzwe8+uy0+pvnHfczmoiUi747kDL+3Uj
         bQZpV93ZgFSoeXdGf1FCkX85ntfdYalSJriCjBApaDg7JUtJQX4DdRaTud42tuQf3TNo
         f79ortJpw1fGDgZsYhhEzgzkGnaARLDHSlSFUN8PmsG8WRpiSNPsfcyTq5xaR91HhpIU
         b6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=nl6MLo/NHjX/vVb0yXW5grQ7bMmst7d2p+95T9TiGdo=;
        b=Sz/dCRFT07kwPppaY7Lk8mH/HlBsLdW+e04XWLQocYDbKIPr4QxMpbgBFOiEIuZH4m
         gJM+RNKqY0lW2mRFW0k248ps8NhiHoA8bFoKszVOof9b37/7BqpkAiCF2yUvK93XIi0T
         S8wzfo1+7ZIeIdjNQrNK1EdbpCu9H8w6xBiRu9NdD8a9n7M3H8BdyW5JIjXeOZDm35xi
         9UaM31Kz6q9K8EjK6RSNs/JGBVOm9ZBUX+TRVjWg9k+Y1ZRMjZ/BCAxjJYtG1mtoQTrR
         1yukpaG7xd5VrioERbxBU7i/NU1Ak17GYG7M3YE7cIhlMWda6Gj7Dhqs/YKFvmjOSQ8c
         JKKQ==
X-Gm-Message-State: AA+aEWYJTpyQQyTTtjIN11tiGG1rpnpjQVNcTk3ppB7h5A98Bkk9W6jH
        qpzXiOyHZQZaPzM3qHb2Ufl8HguFc1s=
X-Google-Smtp-Source: AFSGD/UCMfzqk0rxKo6fpERW9ixWqZJec0l8kD19zWCH3Hxe+pFBgMw1b5ch6YE8+7hKGoXE+sOOhg==
X-Received: by 2002:a25:ac9d:: with SMTP id x29mr2028052ybi.85.1543850706776;
        Mon, 03 Dec 2018 07:25:06 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i2sm5436191ywc.59.2018.12.03.07.25.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:25:06 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 3/8] btrfs: don't use global rsv for chunk allocation
Date:   Mon,  3 Dec 2018 10:24:54 -0500
Message-Id: <20181203152459.21630-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
References: <20181203152459.21630-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The should_alloc_chunk code has math in it to decide if we're getting
short on space and if we should go ahead and pre-emptively allocate a
new chunk.  Previously when we did not have the delayed_refs_rsv, we had
to assume that the global block rsv was essentially used space and could
be allocated completely at any time, so we counted this space as "used"
when determining if we had enough slack space in our current space_info.
But on any slightly used file system (10gib or more) you can have a
global reserve of 512mib.  With our default chunk size being 1gib that
means we just assume half of the block group is used, which could result
in us allocating more metadata chunks than is actually required.

With the delayed refs rsv we can flush delayed refs as the space becomes
tight, and if we actually need more block groups then they will be
allocated based on space pressure.  We no longer require assuming the
global reserve is used space in our calculations.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 204b35434056..667b992d322d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4398,21 +4398,12 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
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

