Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6D2C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF33620835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="s5BhkSD6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF33620835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbeJLDXv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:51 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33573 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDXu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:50 -0400
Received: by mail-qk1-f194.google.com with SMTP id 84-v6so6291283qkf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=8rOVak+zFvn8kwTuxufp2i+ZKKWKap8qoVBHOiPi4Bk=;
        b=s5BhkSD6WGrnQiDBtmyJMtJvSfCMAhn4mm9BGU1mrqTNpOtDIZ+PXUHk8ffz6yZP23
         xQ+IVXWXMuVWGQtCIn8I1rlJcsRpKv8PYu44eOoLangLx7p04V0ivWVKmqIvkXpBHQQh
         01xVvu26tH+nt/cDKMlbcVccU4GWiuOsoyim1j2qnDYKmKPeEMhw++6IkfVI0zPkV/CZ
         MVxDLODVXDzKwdGAfwGFFwSk8R+EQrwviXBqbIupmEyirZ+IMgpEhOZCZMP7tCx5aBv+
         QkhOauAxbxhFqFraWPCb4Fb2qZVwCXL1wLv1Mgy6Pdn3LxJiVE9Xk5oX1avtHG1nB72N
         u9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=8rOVak+zFvn8kwTuxufp2i+ZKKWKap8qoVBHOiPi4Bk=;
        b=NOH1u9SnqM9rOSbNaF+bABYYW6mlocr65cC5HLOzDcjcvgjXFCZMANqNTFHeZ3FZLc
         zpwl0cff2TrFnndo7XBoocL49JUneFWVyl6Ts0gRUQABIuYrQS/k668zPvx9TbPlTae5
         EG/XY+ndW2xHeXbH17U12KVS5FeIrdT6FA1qvwgkOjxcBvQ6u7Lzn5nvr9RfN4Zp+lQf
         GO3gEuffLuN/WgNI6Bwyzcwmk3pHI+VHazSqYJrlgpVy6CZQG1BkqN+Zg/oi/hYAiGSt
         rZO3r7H4B9Kd7t67hGR8wykDYCASKsE9DActtJWG/AlJF2QgKgBUAVOqC0PAaYfJdW6I
         xv2g==
X-Gm-Message-State: ABuFfoioIMZTxOabv34Q9m6IUwy9mTCMPETZMmUGuRclnPaNz/yGJlaZ
        OxdeWT34JcKHQjPozfiBfr9Nh/jX5Ao=
X-Google-Smtp-Source: ACcGV60GXkUmiDG6H2a0fstKUlY+6ZRiPDEtCuchuoZhvX03q4SoYrmXYtt22B5ag+G2Mhsm64qa1g==
X-Received: by 2002:a37:650b:: with SMTP id z11-v6mr2835444qkb.221.1539287704335;
        Thu, 11 Oct 2018 12:55:04 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m71-v6sm13169793qke.71.2018.10.11.12.55.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:03 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 16/42] btrfs: loop in inode_rsv_refill
Date:   Thu, 11 Oct 2018 15:54:05 -0400
Message-Id: <20181011195431.3441-17-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 7a53f6a29ebc..3aba96442472 100644
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

