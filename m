Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2631C04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 663DC20834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="rT9M2iYV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 663DC20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbeLCPZO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:25:14 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:34460 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPZO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:25:14 -0500
Received: by mail-yb1-f193.google.com with SMTP id a67-v6so5443152ybg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=AQZc8uTNq0x0auoD41dliv7VUABy1O4XFL1Cxv4lxB8=;
        b=rT9M2iYVIcub8bp0zwCc1s11ML7P32PT9zB5flY+3wznduMOseaU2wYK5wjAjm6U1t
         UZhrSA92XGM7z8BZB29QPwYjNZWFSRk2k4rEiISb5Cg0Aupp9HFgAvtYYGh4jOlMfTi1
         0ymYZW18uJGLXpvWDXV1aUAhZRjv7By4ST1DtrZohD6jcFK/HVZNZvYtProNWZy93lhy
         FzMNW0B6hZ0Ksh82fX/Zfh5rDyi5giGgahsMe4ClKzT6tdj0o/MHBDLz7xSgcYooWgZf
         fpSUSublPwBrQ+ruvjCtBeivrd3UsHV+wU0rPCcRopsMygGMvXZRbiwxP8JJjroehZsr
         fbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=AQZc8uTNq0x0auoD41dliv7VUABy1O4XFL1Cxv4lxB8=;
        b=TpUtPjYhQaVaJhrys3iY1BBQwi4r69khhnCRvxboLPJgU9s5CUrsuenXkP6iuqko6l
         NkomZjt0ax6E4MLlf1VWbmSrJLotMtN7cYLpwiweFd0xMPURfW/9GwJ11GYLq8yCLQWf
         BfNrfHiCrmKL2Y1fPCGALkzqApeM/m6dfvQzCNLwlGdjk6QYpNH+/YpLOC6hPswBNGGZ
         A0sMmwbpv7XByClD/4VDge5XhdHah8JDTAL7jZsh6pgsxJvHVRqasxGqfIp9pWz20aWP
         00v8N/R2DT6ilAKofrH3OueEG5L4gPLxA1MzyiPJhcdWYrLYwv74IXkvwskt5v15zqhf
         A8VQ==
X-Gm-Message-State: AA+aEWZtcrZxBk4pX4i/ZhRiR5HWRI9KV2WpuTkIoSYumEwnOa5f05SE
        etCogM5xNLxuGV6vleUDVE0truayiVU=
X-Google-Smtp-Source: AFSGD/XMTAfAXPoqGu4UkSWTrysIVXdgFh4w61cTqHtKKyZzUhmcT59lRmG1w/di2w/rWJM6rI+i0w==
X-Received: by 2002:a25:c107:: with SMTP id r7-v6mr12360426ybf.360.1543850711519;
        Mon, 03 Dec 2018 07:25:11 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id x132sm5793542ywx.27.2018.12.03.07.25.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:25:10 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 6/8] btrfs: loop in inode_rsv_refill
Date:   Mon,  3 Dec 2018 10:24:57 -0500
Message-Id: <20181203152459.21630-7-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
References: <20181203152459.21630-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With severe fragmentation we can end up with our inode rsv size being
huge during writeout, which would cause us to need to make very large
metadata reservations.  However we may not actually need that much once
writeout is complete.  So instead try to make our reservation, and if we
couldn't make it re-calculate our new reservation size and try again.
If our reservation size doesn't change between tries then we know we are
actually out of space and can error out.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 58 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0ee77a98f867..0e1a499035ac 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5787,6 +5787,21 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 	return ret;
 }
 
+static inline void __get_refill_bytes(struct btrfs_block_rsv *block_rsv,
+				      u64 *metadata_bytes, u64 *qgroup_bytes)
+{
+	*metadata_bytes = 0;
+	*qgroup_bytes = 0;
+
+	spin_lock(&block_rsv->lock);
+	if (block_rsv->reserved < block_rsv->size)
+		*metadata_bytes = block_rsv->size - block_rsv->reserved;
+	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
+		*qgroup_bytes = block_rsv->qgroup_rsv_size -
+			block_rsv->qgroup_rsv_reserved;
+	spin_unlock(&block_rsv->lock);
+}
+
 /**
  * btrfs_inode_rsv_refill - refill the inode block rsv.
  * @inode - the inode we are refilling.
@@ -5802,25 +5817,39 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 {
 	struct btrfs_root *root = inode->root;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
-	u64 num_bytes = 0;
+	u64 num_bytes = 0, last = 0;
 	u64 qgroup_num_bytes = 0;
 	int ret = -ENOSPC;
 
-	spin_lock(&block_rsv->lock);
-	if (block_rsv->reserved < block_rsv->size)
-		num_bytes = block_rsv->size - block_rsv->reserved;
-	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
-		qgroup_num_bytes = block_rsv->qgroup_rsv_size -
-				   block_rsv->qgroup_rsv_reserved;
-	spin_unlock(&block_rsv->lock);
-
+	__get_refill_bytes(block_rsv, &num_bytes, &qgroup_num_bytes);
 	if (num_bytes == 0)
 		return 0;
 
-	ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes, true);
-	if (ret)
-		return ret;
-	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
+	do {
+		ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes, true);
+		if (ret)
+			return ret;
+		ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
+		if (ret) {
+			btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
+			last = num_bytes;
+			/*
+			 * If we are fragmented we can end up with a lot of
+			 * outstanding extents which will make our size be much
+			 * larger than our reserved amount.  If we happen to
+			 * try to do a reservation here that may result in us
+			 * trying to do a pretty hefty reservation, which we may
+			 * not need once delalloc flushing happens.  If this is
+			 * the case try and do the reserve again.
+			 */
+			if (flush == BTRFS_RESERVE_FLUSH_ALL)
+				__get_refill_bytes(block_rsv, &num_bytes,
+						   &qgroup_num_bytes);
+			if (num_bytes == 0)
+				return 0;
+		}
+	} while (ret && last != num_bytes);
+
 	if (!ret) {
 		block_rsv_add_bytes(block_rsv, num_bytes, false);
 		trace_btrfs_space_reservation(root->fs_info, "delalloc",
@@ -5830,8 +5859,7 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 		spin_lock(&block_rsv->lock);
 		block_rsv->qgroup_rsv_reserved += qgroup_num_bytes;
 		spin_unlock(&block_rsv->lock);
-	} else
-		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
+	}
 	return ret;
 }
 
-- 
2.14.3

