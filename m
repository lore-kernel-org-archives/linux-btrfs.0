Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4660C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B81B214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="jtn15Uxt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B81B214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732050AbeKVFjD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:39:03 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33358 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFjC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:39:02 -0500
Received: by mail-yb1-f193.google.com with SMTP id i78-v6so2649917ybg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=yu2JCWkP7NYdrcPQZD2JAvRccQo2pQnedGA9JoGG3ao=;
        b=jtn15UxtHkJpj3Vt36CUpr0boxQRTEiE7HMcpfj5g1lS3S/0n3gz7rYbM5h6hwCBg5
         O2uv010D+NBNf1vzIpPBndLjqtHJASjoZCiUWeEJWM+1Hr1eICpJyIqVnFeEZ7lsmUax
         BHGu0SCTD6jbPwDtWcnCt2BoUySHBUNmd9ko0YvLJRpKJjHULlXIEo1e+J1cnu46L8K/
         LhEWTdArAwciP7ghDxROkN9CrMIppowtPIO53FO8Pk9ug1MDHe3jNo0sbyLO/evk7DxN
         /IvcZKLGCrXMD6r2GsRYhCsi6Ma8VoqBAggvA0UwmmpLkbq7Ks5XXAOrcHnIfRJBg3VQ
         7lrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=yu2JCWkP7NYdrcPQZD2JAvRccQo2pQnedGA9JoGG3ao=;
        b=tYnBa06YGk8Cp2zHQMHobikGiSMpQONFv9HSnjd5+qIICeZGAv+b7WVYtk4nowNgKU
         7bcn08uWL8lQG0S0E3rpgAkSO7iqUjtGqnSEpAXGSdNpzEGtXYoNGGIuDMVgLYd8ydM6
         Lu55+/IBx1PgUZAfbcZGCacTTe+YFM16QbmcxGDbiy4xsM+wy8jo5WAupMux2Rn6gVOz
         8vZvSxvz7F7IQ4+e59Cxl9crcMk1MI1hhYGv/I7J6xZnRvmH5WlPl9aK/Y2BbCdTg3UC
         MfpXZdBURD/Eo/p3R4uj9hHqlJM9Cde5spAnipq98rGzS9ZJ2AGJqeVsbpU5uAUGqJo4
         VGqA==
X-Gm-Message-State: AA+aEWaVzzgbGL3MwAZo05qXkT/lXTKxmzHN+quP/9Wa+VArIvU7Izc/
        Yai6Q6Zq45xYIPYDiKXBHLtPi8VKSFQ=
X-Google-Smtp-Source: AFSGD/XpVDyidW4KcZ/d8uEebRzPSk9xuU0qPsHm5joeYs+qd1B8L93VfmmWdGClvZyYZCKkk8Ps0A==
X-Received: by 2002:a25:2317:: with SMTP id j23-v6mr1153922ybj.457.1542827009992;
        Wed, 21 Nov 2018 11:03:29 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t141-v6sm7631345ywc.8.2018.11.21.11.03.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:03:29 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 8/8] btrfs: reserve extra space during evict()
Date:   Wed, 21 Nov 2018 14:03:13 -0500
Message-Id: <20181121190313.24575-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190313.24575-1-josef@toxicpanda.com>
References: <20181121190313.24575-1-josef@toxicpanda.com>
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
index cae30f6c095f..3da9ac463344 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5258,13 +5258,15 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
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
@@ -5273,9 +5275,28 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
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

