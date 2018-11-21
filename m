Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8765DC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AE5F214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="G/Nph4tg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AE5F214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbeKVFi7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:38:59 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40091 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFi7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:38:59 -0500
Received: by mail-yb1-f195.google.com with SMTP id g9-v6so2635213ybh.7
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=buaPteFeVuIpD8HDkTwU+lZ4EhwxY+ANt8BGHXpmHmw=;
        b=G/Nph4tggca3zCWPik/PqDxA12sQTRqntGxluksrIIhqmvuiYQ5z8jam66JZfwLgCl
         oP/Dgn6jZvkgqxyeBozMW9XwF/Fw0RiwqJZgB86nUqOTq3AKozfCqRNBChh24Nsfwuv6
         aGWmiu9DZunM35hEQKVqktZbgPMN4WUfsjrP1sSW1Q4NvUzSgsAfwx+8n1PFiFLep9fe
         xA+7R8xodk8lybBBE0iSAAaFO1bhHn0b6zGMRjmLkYQOozMFTKCG8vXvtXUdSRDKo0TE
         WjQP49EIMNKJYbdcNnJTbZmbUadHeBo5dsIDjaVyD96/qAzoEdnSOIBETI85EhzBWru6
         kKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=buaPteFeVuIpD8HDkTwU+lZ4EhwxY+ANt8BGHXpmHmw=;
        b=layztpmgD08uPKYqBZpWfpkdGcszQulXxvAVfGnddFSPkqpoJVhG6maoZil+JVTENG
         vzMezZ+XVDpiKUZZX6x6mLUam7clBeWuHaWRdrkfVckQlkKnGhHD18i+PLjq65XdO5rf
         6OvXtaBFld9MjxfBhCEuSqm1gbtdw4gAQp+aG8Wd8WOJiA86+cEN6HWNaG0qpZWgWRKB
         uJf9f5MiY9EYZ0glkntnolYTMolqocRUNf2aUBsrU6gDQ0ouUpyjEZMPVEOSrq9ZSb9L
         gB1z+SfwVVfdfnTwMucudCdVSvVgLyVtr7SujW1Dw0XYTasgyLmSW6dC0e6AqHaT151c
         xkxw==
X-Gm-Message-State: AA+aEWaJ3mC3vmrjBxI6adwJbkGUEmppgdfY3IDZzcSkRFT/78yr4esq
        dXtsNOYHprKzsYLT64CJX4Qh53c4g1Q=
X-Google-Smtp-Source: AFSGD/U5FMf3rqiTjmBJUy44zLFKTWhvr99MNGNXu8gZ3sjHX4sFsWMHGAPq/106E5tEFjCizf0low==
X-Received: by 2002:a25:ba04:: with SMTP id t4-v6mr7847872ybg.251.1542827006592;
        Wed, 21 Nov 2018 11:03:26 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id k206sm1592652ywa.16.2018.11.21.11.03.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:03:25 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 6/8] btrfs: loop in inode_rsv_refill
Date:   Wed, 21 Nov 2018 14:03:11 -0500
Message-Id: <20181121190313.24575-7-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190313.24575-1-josef@toxicpanda.com>
References: <20181121190313.24575-1-josef@toxicpanda.com>
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
index 983d086fa768..0e9ba77e5316 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5776,6 +5776,21 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
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
@@ -5791,25 +5806,37 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
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
 		block_rsv_add_bytes(block_rsv, num_bytes, false);
 		trace_btrfs_space_reservation(root->fs_info, "delalloc",
@@ -5819,8 +5846,7 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
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

