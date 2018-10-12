Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFB5C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83C32087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="NKttTl5l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B83C32087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbeJMDHq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34329 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbeJMDHh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id o17-v6so15081949qtr.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=vHabzEqM4andqo36SRSVv9D6V894NYsX3WbIWx+RRlM=;
        b=NKttTl5l4WQbbj+Wy9FAfdXXirZUyutam7wnpsBICTZdfDVCpMCQ5/4PWQeQ8gpW16
         gbj28GiscKxeF9OJLb/+yT3W4Uh01F6jcHa5K64LEhtiUV35HEermkQAZ7qCdh/C4Orm
         TsySBzGQRln4DPJ2HIb4K1UXsTArvqYRfdiSi0IlDAO6lkLUvao8Q48uQysr/gWGgMIn
         riMOOP44Vz1EbUw+lgcXvpFn8TPFCK21jCQ3o/2BQiLLwDlwY1yEJNFkF9fkitf96BNP
         QhuP0HRB3O88I2AF3b/HGu+G9qDEOVoIdr0OnHd6ayBN4e0DPhfDFkT7Ku+JErlQfHif
         UnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=vHabzEqM4andqo36SRSVv9D6V894NYsX3WbIWx+RRlM=;
        b=YdNJpoxp5MJ5xer66vPHTm6D+OrSlhnpwUklE7d/WqX6cj6Rvv1ZCsLmAlf1zEjJ3w
         m03EkYuJrSHnN+KjfE6gSyiuEDSqUUrvBzeYOuXbZl+lIBFVYvIDc5sOiEl9CIk90IAi
         jAgGT+hhL4IQALLoao9XNBLMSJJvSRFqTm7+PwGyQ/ETdFNuoxS4Ncl8qAHHxm+KQ78J
         GK+xpQASry88qqoKt7r/OJYb9Gm0e7K4OkfN6whNvONRpr0J+t3fnoTdzAGfZtNEMSwY
         q0bZl7UG8UepcEQbnAUV5HP0a5+ZGttkwJ6ouZBOdrB4Nr8arU+9zGWIieYyHPW703Jp
         UtRw==
X-Gm-Message-State: ABuFfohuloQIO2xYJwul2VRAUAgQzFUHz/+gYGrc3ZkLY9zdBdFhcJCQ
        7jBf3eiF5bhZy0K1ZKyFOhKxdLkS7aw=
X-Google-Smtp-Source: ACcGV61YkOSjfdg94+24oMvmZoDR6to2HAaIU1vZl9DU0RC8Eyc8/pGWhIFznVYnJX/SPdqG8q/c8w==
X-Received: by 2002:ac8:2278:: with SMTP id p53-v6mr7136442qtp.200.1539372815530;
        Fri, 12 Oct 2018 12:33:35 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id z46-v6sm1589896qth.87.2018.10.12.12.33.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:34 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 16/42] btrfs: loop in inode_rsv_refill
Date:   Fri, 12 Oct 2018 15:32:30 -0400
Message-Id: <20181012193256.13735-17-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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
 fs/btrfs/extent-tree.c | 56 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 19449ee93693..3757ca42b8e0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5766,6 +5766,21 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
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
@@ -5781,25 +5796,37 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
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
+		}
+	} while (ret && last != num_bytes);
+
 	if (!ret) {
 		block_rsv_add_bytes(block_rsv, num_bytes, 0);
 		trace_btrfs_space_reservation(root->fs_info, "delalloc",
@@ -5809,8 +5836,7 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
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

