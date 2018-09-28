Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEBCC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AC19215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="dL0MrWJA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AC19215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbeI1Rm7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:59 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37326 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbeI1Rm7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:59 -0400
Received: by mail-qk1-f195.google.com with SMTP id c13-v6so3571414qkm.4
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=am1ak1Lg8slURG/v1F1bdWqQUehd7FnCdJ9TMX1sZm0=;
        b=dL0MrWJAoyRdcRMr/CFVu3GZAnY1JF54EeD8nh6VuiQYQta3wkIKspgynxc8aqYO5q
         39lMmcOjMN0w8b64QaEnenT9TATol8PDC2eZdRWt1LZd8Ms9uOoaqrILqi+loSlpC7a2
         L9aXY17bXE97uHZJ524vPYNc/RdP4OT2HQR4EWpJpcBq60uNFYuDfvvsH5Ec/kdjYzSy
         3AnuXMvnV6jJpHKqKfzIfohQPWnjHam7POOV/Fs5k2OhxsUZU33vDHL0IH2ZgO2EMSZc
         NymFWDUGOhGSwCoFE9yf+lK2XGB6PHllv0mR9zRApMyuZHsJOKOfg8aYHFHoSmKJnYAe
         th7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=am1ak1Lg8slURG/v1F1bdWqQUehd7FnCdJ9TMX1sZm0=;
        b=iU0lJLsk7csIZmNZ36I3ebjMTahvgaZ4KBR6KReq31Vc4PkYQHoYFWeVrKVHlJSb14
         urlqZF3ciuDSPdhHQp9cIc9+kguKhSi8pLFvXV5Mu4wUcW4PtWylHPt9Iug8wwtGzl78
         m8KwM8WJ63/h82/5Ilahon14Miv3YCYh1D5puHKWkSPib4SYI3pKyhERY1zBgB8PBCGj
         oCSqnWk7IC5Cujmp1qaRx8Fbi0/SPhofVul1he9nUDf6ouVMZqwNPZzSK2yc/yMvG9sN
         7RqJrP2uRaTd58v9ruQSnUSkFPj8zuEIC3aV7R4OXo/o6ubhGMffaWIwojH23f+JwSXF
         MNFA==
X-Gm-Message-State: ABuFfogx9qrYPzW9heao1Q7oBJvaoFUsTSBHU7cofKjym/hgezNAq7T9
        S1ZftC0qddk7d7s02/lzixmpiA==
X-Google-Smtp-Source: ACcGV62tLufoddP1P+jaP3Syn3Ofdpo7wTmhNeeFFHp7RvNMPQQAleKXc13keb9Cxue5H2ikto+mFg==
X-Received: by 2002:a37:5c81:: with SMTP id q123-v6mr11212405qkb.8.1538133580737;
        Fri, 28 Sep 2018 04:19:40 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c85-v6sm2439672qke.89.2018.09.28.04.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:39 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 41/42] btrfs: reserve extra space during evict()
Date:   Fri, 28 Sep 2018 07:18:20 -0400
Message-Id: <20180928111821.24376-42-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

