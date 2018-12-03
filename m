Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA57C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F9720834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="LQps9DhS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71F9720834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbeLCPZR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:25:17 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:38209 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPZR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:25:17 -0500
Received: by mail-yb1-f193.google.com with SMTP id u103-v6so5421247ybi.5
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=8+WTPfeR/Ywf+hDHPXxxZw0aJZ/nn6DsF7zCWZH8hIs=;
        b=LQps9DhSZQQQQhddMrAblGBvszT2A4XHc8unMnRiu+WPw4nhAZlch2MUQ/NBTbwM18
         9X2L9l2rCZjEbMx7vRyV1rdtSYTID44WyOriuAf8QU8mdHeB7oTG0cwUhb7+AVexEj5r
         s4JpwVPNhoBFcgOCCNQ79RXZt0ay6z+r1V+8RkonwdoVsS3T5SM8gpQMb5tlbzys45N/
         7EcX//2pgR53EegXU9OwgtU3UjBEjKafjTnBFS+rEYxtkfBreITnHxittvggkYAFzHdB
         RT38kg098aZRYiujMSm0j+eA+x+CIBbIRfh/LGcsCSfM6UozgrP/Mz3wWbn1e9ZKFyci
         eh0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=8+WTPfeR/Ywf+hDHPXxxZw0aJZ/nn6DsF7zCWZH8hIs=;
        b=i9FAnOKbtIquSAC8YMAnMkeQxhXw4v6U1bnFZWWA/+RDfmoF6qKq9ruxJI4ynd/Vnw
         QiX14FdIxFF+PGObraLOcFGBS1KP4McN/vi4PiQ5TrT5bkuv7pLUWYNQyYkqUKET87eF
         wu5RprvZEhbwoM/UJFGGB0mvFsNq0lAR3YpoVUlzz7eMNUK9IwasQpbc3OuKFIriQ/iP
         RixZoX0qjD94fTwfSSLr7p9969uRV93r162vpF+C1Ttf0OHj+oWWV2DRYaa7QhS0n6d9
         K2RkZzREZT0kGKVCGmLwsez9Wivade4VaOKvg6ttJaT+NLA+8XqtFzHvmD2RM4pNvtU4
         61WQ==
X-Gm-Message-State: AA+aEWb/A2rY4KgPvYo0AoNOA4a/pERWZjvEI4oo7lKShEMT5gu3rfA3
        lu0rvHZiawAVcx2/3YB/YJw8L16X32A=
X-Google-Smtp-Source: AFSGD/VR68DPa7rTY7L5kmXa18Q/9FJ3j2U7yJPi/8hVKGiamHIajDZi9oAnLvVs0ovunFEMfks9pw==
X-Received: by 2002:a25:378d:: with SMTP id e135-v6mr15543121yba.94.1543850714892;
        Mon, 03 Dec 2018 07:25:14 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id r62sm4591016ywd.4.2018.12.03.07.25.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:25:14 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 8/8] btrfs: reserve extra space during evict()
Date:   Mon,  3 Dec 2018 10:24:59 -0500
Message-Id: <20181203152459.21630-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
References: <20181203152459.21630-1-josef@toxicpanda.com>
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
index 623a71d871d4..8ac7abe2ae9b 100644
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

