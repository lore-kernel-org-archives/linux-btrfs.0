Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C077EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88C4E214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DhJrG7RS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88C4E214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbeKVFiy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:38:54 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46658 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFiy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:38:54 -0500
Received: by mail-yw1-f68.google.com with SMTP id t13so2659198ywe.13
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=hcI+0XW5aWg125geSsnhm5i+1RsuZKsRTwalaa5gUb8=;
        b=DhJrG7RSQwgP3Kq4QRKhFbMH3JZkuU7rQZPZkXTwVko06W/Rsg+zqYzS3GRL77OqPW
         VInpxlmVP+XHJkPrxnsMGLqVxa2K/0u67YjvyEbIRGtIaNkmrcz5eC6k457V4uwzHnXV
         Dlkw2zS+auEx/o5/hPjr5I4w+Q1NGizzwkQr4d7EYP49BcdPAlvGiXXmiJo8SXv/AQNY
         xGZwA6BuN8OMQswoe6lGkk3YGfTKporLiZfNOydBkSoy0oaGR1NRuancSjVwN8qahuO7
         0YdZoKXXrRmOxPC/8VomWceLC5/siCQ9Ymorbq7VMVgIVfV3hB1QTZ+tZ3mf1YXtCc2L
         z4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=hcI+0XW5aWg125geSsnhm5i+1RsuZKsRTwalaa5gUb8=;
        b=ghamJHh/UB2Dh2uzeKFSc6R6oDF1Cv8kCyJTKu0MT9cICE+RS5PjbpzWcDlyBdKDwl
         RdWUOOQpZB9p9WMvdx5XM67QbmDfal9FDw13Ri4C0bLaqyR05BRENMZgYLzeqcCmN9SO
         TSaDRoWpvh6iwByoeWyPc5xQj7ygXa4+XObv/XY2XcduKEACvejvVG3+HeBNB2HQLKZ7
         ZHktyvJJJhCSO/TL+K0CXpbGtDfRbwLwFonI7Fvr7q6BolaJKn2hLRISrQamDSLAXuII
         YpIoxeKEqK3pyS0JBebf4sAsLm00kf6Wh8hDqxzqTA2pFm/RBZDVcYyfYkoMzp5zQvyr
         3yYQ==
X-Gm-Message-State: AGRZ1gIKx32RPX0RiR6K1dSJrVqoyfQRUdal3jq1Zk0YIxHIOFUyfmVQ
        oSZv92ER4yDoTFKQTOfSM/FdehUeRHY=
X-Google-Smtp-Source: AJdET5egDObRuQm5P8AGd3X2kmDP01y2a5+OE8JhXJAScroGnU7fS0DG1x2FHSrcOQxB0Kff5RlLjQ==
X-Received: by 2002:a0d:ff82:: with SMTP id p124-v6mr7710148ywf.336.1542827001484;
        Wed, 21 Nov 2018 11:03:21 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id j134sm995926ywb.91.2018.11.21.11.03.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:03:20 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 3/8] btrfs: don't use global rsv for chunk allocation
Date:   Wed, 21 Nov 2018 14:03:08 -0500
Message-Id: <20181121190313.24575-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190313.24575-1-josef@toxicpanda.com>
References: <20181121190313.24575-1-josef@toxicpanda.com>
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
index 7a30fbc05e5e..a91b3183dcae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4388,21 +4388,12 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
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

