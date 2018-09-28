Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCE4C004D1
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644BA215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="mpH4vl1e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 644BA215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbeI1RmN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:13 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46823 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1RmM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:12 -0400
Received: by mail-qt1-f193.google.com with SMTP id h22-v6so6089287qtr.13
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=KEzZC/iUqIPWQQpjLKXekOjt3SWza9+3dFW42ZSpeyc=;
        b=mpH4vl1e1qsnvjKyFGYH9j8MemRFrNotOWn+pPNkJ0rOFBCRldF9oSy1Q9FrudfUzZ
         WVdlALbx3O3cU6fzVPK80L3gewph8OE6gZqIn3gN8Z23PEUu/JPSb5l08b5WR5IPlOqf
         uubaBRyvT3BvBiObMNcLN/nwXSwa3vF9GPnfeEEHKEkA8P22VwIxEjhZkREOy6HPLgF/
         VZnuAW/Rbal09bUBBKyXwEk6es4yVbgjBMdyerrPbniWHGgGmNqUtJFkNpfZrn2vRsuH
         x9r1DI2x9FF8thxFH5P8WnWBa3/5uz9c4rhhhpliOMGLfvFDve28KAFjGACnLrFy9/AW
         BFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=KEzZC/iUqIPWQQpjLKXekOjt3SWza9+3dFW42ZSpeyc=;
        b=CsmrMGuZHynVwH1CzbXEpet4idShDyfLnapQGT1RE+8uj2b8R+FD/klQFfEoqo7JfR
         ZGVHCKGYUjCxfrOm8YQghbYs3qG3La1hMotTp7S/eUhCB6eB4Po8I2q3Yp1C34m15OuT
         JPtSpdvliSjlzgt86Sl0Z2X+O/eOmURLedsbICr9UYN1nyrdkEguzCEafAwtBwsWpJty
         vWN88VI/9+PAgppoNmUXvXSVCa4dSfUv0EFgiEdZSct+pGVEhNawVFEGEhQCImCy4N6b
         qb850wwB8depEKafwzxgq1P2qhpLUOHVGX5ZqphMX8AjDDllWitZLPo1dG5WtV12aRhT
         k0Ag==
X-Gm-Message-State: ABuFfoh/4uDPDanT1IOdJYjWZFOXNhgAJeI3RQTOj8IetgR+V3LrFj4k
        xCVdTiBqoW6bPwQ/A89L910hu2iqIG8=
X-Google-Smtp-Source: ACcGV61WDEQ8CD6Ygx1jwzatkVT1/F2+h3Hin7G8t7VZVFulCNUFbbcRU3C3NLldI9w5/EowYkaT5g==
X-Received: by 2002:ac8:1770:: with SMTP id u45-v6mr369521qtk.285.1538133535166;
        Fri, 28 Sep 2018 04:18:55 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y143-v6sm2650665qky.95.2018.09.28.04.18.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:54 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 16/42] btrfs: loop in inode_rsv_refill
Date:   Fri, 28 Sep 2018 07:17:55 -0400
Message-Id: <20180928111821.24376-17-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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
 fs/btrfs/extent-tree.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7a53f6a29ebc..461b8076928b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5781,10 +5781,11 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 {
 	struct btrfs_root *root = inode->root;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
-	u64 num_bytes = 0;
+	u64 num_bytes = 0, last = 0;
 	u64 qgroup_num_bytes = 0;
 	int ret = -ENOSPC;
 
+again:
 	spin_lock(&block_rsv->lock);
 	if (block_rsv->reserved < block_rsv->size)
 		num_bytes = block_rsv->size - block_rsv->reserved;
@@ -5796,6 +5797,13 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 	if (num_bytes == 0)
 		return 0;
 
+	/*
+	 * If our reservation size hasn't changed since the last time we tried
+	 * to make an allocation we can just bail.
+	 */
+	if (last && last == num_bytes)
+		return -ENOSPC;
+
 	ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes, true);
 	if (ret)
 		return ret;
@@ -5809,8 +5817,22 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 		spin_lock(&block_rsv->lock);
 		block_rsv->qgroup_rsv_reserved += qgroup_num_bytes;
 		spin_unlock(&block_rsv->lock);
-	} else
+	} else {
 		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
+
+		/*
+		 * If we are fragmented we can end up with a lot of outstanding
+		 * extents which will make our size be much larger than our
+		 * reserved amount.  If we happen to try to do a reservation
+		 * here that may result in us trying to do a pretty hefty
+		 * reservation, which we may not need once delalloc flushing
+		 * happens.  If this is the case try and do the reserve again.
+		 */
+		if (flush == BTRFS_RESERVE_FLUSH_ALL) {
+			last = num_bytes;
+			goto again;
+		}
+	}
 	return ret;
 }
 
-- 
2.14.3

