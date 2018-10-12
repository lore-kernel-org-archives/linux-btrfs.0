Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7B9C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D2542087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="gx2Y6kcs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D2542087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbeJMDIg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:36 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40393 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeJMDIg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:36 -0400
Received: by mail-qk1-f196.google.com with SMTP id a13-v6so8346440qkc.7
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=am1ak1Lg8slURG/v1F1bdWqQUehd7FnCdJ9TMX1sZm0=;
        b=gx2Y6kcsHJ+pVpuknpzs13ZOWqkQbNRz+KAaoZl8n3q+UzN/rHyRhKtq0IO7OjBne6
         V7q3syiIcAa9tgVMjstbIg0FCNQtBKviOLFYQEzEQGNvIvs16izxvgJnomNe4ojOrjlN
         CUALc8UpoY1IErNEeXzNWZAkhq3n3Wt91utwkY9ymsfjx6/SdDOvsYtXnBDg2m3rCMTw
         qT7cZhUBpIQd6uYPeiG/4cjqQm/co3CD4ObOjLYimwC8h6Xf6DSZWgD75sQWQKDuWTll
         P3sRT+kVflYhroI0NBZAvBHfn4YZpw9/OL7acSWKHxpsHS72vSeg3lgzQ9yQx1NUO66M
         B+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=am1ak1Lg8slURG/v1F1bdWqQUehd7FnCdJ9TMX1sZm0=;
        b=q/3uC0Z7E3NDDPPkTKJ6AqQRsc4EKdrDSmYk8daHRHTnt/R93JEacCxs5zaBylYk7w
         x9GZd8XIYXSKU+3tnZiTdNSuB/9pLMVK0bvJ5f7VOFBwmw54HTeFJ7V5qJbBmEXOm3jM
         mm8beMJH2imvfIKToKZ5bWkLrRsfVyC3ZltDHurkPqtd2qgRxBfoCA+0O5FjrCAV106U
         dnyMypi4jG+wO4qoZoplcoGiYHus+LY6jdDjeWeXGKh/Q/J/I3POf0ppwWFvbgbAagQN
         Rxwd8HiZLf/o2exNmrO1ZplnMyzRXF+ddyWPYNLAagUpnWq7h7nawIO/YFGnMeTPdNyf
         KFmw==
X-Gm-Message-State: ABuFfoiCI/jNS43ai1xblbeuiGSdjnxiVy5/iYENELXq03SMTvoK1HPG
        xX1454gMKmB2u/1hBdYEp89DT1BHKtM=
X-Google-Smtp-Source: ACcGV62E9oZnMwI/UFpvFRmBjIBrxiA7O5m8cWTA0JkKrnsEV1r2UhaePEPKAr9nka+DbBmDhj8Cuw==
X-Received: by 2002:a37:ad11:: with SMTP id f17-v6mr6877028qkm.329.1539372874778;
        Fri, 12 Oct 2018 12:34:34 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i27-v6sm1805641qti.57.2018.10.12.12.34.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:33 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 41/42] btrfs: reserve extra space during evict()
Date:   Fri, 12 Oct 2018 15:32:55 -0400
Message-Id: <20181012193256.13735-42-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We could generate a lot of delayed refs in evict but never have any left
over space from our block rsv to make up for that fact.  So reserve some
extra space and give it to the transaction so it can be used to refill
the delayed refs rsv every loop through the truncate path.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dbcca915e681..9f7da5e3c741 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5343,13 +5343,15 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	u64 delayed_refs_extra = btrfs_calc_trans_metadata_size(fs_info, 1);
 	int failures = 0;
 
 	for (;;) {
 		struct btrfs_trans_handle *trans;
 		int ret;
 
-		ret = btrfs_block_rsv_refill(root, rsv, rsv->size,
+		ret = btrfs_block_rsv_refill(root, rsv,
+					     rsv->size + delayed_refs_extra,
 					     BTRFS_RESERVE_FLUSH_LIMIT);
 
 		if (ret && ++failures > 2) {
@@ -5358,9 +5360,28 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 			return ERR_PTR(-ENOSPC);
 		}
 
+		/*
+		 * Evict can generate a large amount of delayed refs without
+		 * having a way to add space back since we exhaust our temporary
+		 * block rsv.  We aren't allowed to do FLUSH_ALL in this case
+		 * because we could deadlock with so many things in the flushing
+		 * code, so we have to try and hold some extra space to
+		 * compensate for our delayed ref generation.  If we can't get
+		 * that space then we need see if we can steal our minimum from
+		 * the global reserve.  We will be ratelimited by the amount of
+		 * space we have for the delayed refs rsv, so we'll end up
+		 * committing and trying again.
+		 */
 		trans = btrfs_join_transaction(root);
-		if (IS_ERR(trans) || !ret)
+		if (IS_ERR(trans) || !ret) {
+			if (!IS_ERR(trans)) {
+				trans->block_rsv = &fs_info->trans_block_rsv;
+				trans->bytes_reserved = delayed_refs_extra;
+				btrfs_block_rsv_migrate(rsv, trans->block_rsv,
+							delayed_refs_extra, 1);
+			}
 			return trans;
+		}
 
 		/*
 		 * Try to steal from the global reserve if there is space for
-- 
2.14.3

