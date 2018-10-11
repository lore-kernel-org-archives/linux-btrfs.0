Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC19C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 358E020835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="JIc2h/TK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 358E020835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbeJLDYh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:37 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41095 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbeJLDYh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:37 -0400
Received: by mail-qt1-f196.google.com with SMTP id l41-v6so11345248qtl.8
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=am1ak1Lg8slURG/v1F1bdWqQUehd7FnCdJ9TMX1sZm0=;
        b=JIc2h/TK/UQ2UZ8nJ39ub+qXfDm7HiabmkcL7kG08mCd8vs4VcWZMi7sfEyfQc8ppZ
         3MZdK1ySpjiZ34cUFRLIU2w+0vgeVOjDVfA3p2Os7XDxQYVbVMxQDB6naInJL6cNc2Ga
         Jj7SdboMYkKvGScL+kfgw8dpF2JDzpyUTJW6oLojR80TV88JwwSTCmg/Lc/X2X7VxZIy
         wbQkle3tRs6jawyYYm7Mquynm22E1gt5iLMjP5sZmgkNE3FtiGNdg3dAH1lNxQSJx0KF
         DEIKCkHZmx68+DWv1RZFQxvZTjPL3RoWm+D2nO4tDP16WXXBPd6Gt2USCFCKOxO0aW+4
         KcUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=am1ak1Lg8slURG/v1F1bdWqQUehd7FnCdJ9TMX1sZm0=;
        b=GCgamZK+u0xmr/ZBENNu2vjDbuBl5mx8xYLSTuRaSvqWepAERyDwK5KNgum99vRr+I
         KBPdgwi7OkJeOZfSTYAck5iWxukCvqa4oyKd0rZhof5pZpItkf4cjzFBYgDAfUjQRDuK
         U3Sx+kQFW3+39t0OgwiRiwuzbyK6FuZrVDTX6mop41zfeAzVUraJUzmcya6Tunv27hTY
         GPff5Wq63debwunKBo5DoqdsctnuQqEPhakuaSk6BVr/weVQcA2OTivy0zanTruT7AG7
         v5/qYKRh9DUQP39fYYQzqTLEDn38Aj1IrxLyHHhwY9RihYs5Ik5RS/1JgHv7jPLj6Mml
         q7Ug==
X-Gm-Message-State: ABuFfoj26TinDDd33ZYGjiWeUNPExBpt4MVsWY3t6sJ+lR0E6dcguyg/
        W6S1R1ZIUqjnqHQyMPEukKGe1vLEziM=
X-Google-Smtp-Source: ACcGV62A+JeSEnl62DvKN5+9Y+unzc6stDHh/GwB8J0I2L6eVF//ENDFm0e8YIBozuuPac2ErzQCuw==
X-Received: by 2002:ac8:2595:: with SMTP id e21-v6mr3007216qte.233.1539287750466;
        Thu, 11 Oct 2018 12:55:50 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a13-v6sm15930322qkg.94.2018.10.11.12.55.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:49 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 41/42] btrfs: reserve extra space during evict()
Date:   Thu, 11 Oct 2018 15:54:30 -0400
Message-Id: <20181011195431.3441-42-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

