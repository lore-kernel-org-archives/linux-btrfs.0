Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18A0C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 875C020835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="z0M0JogW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 875C020835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbeJLDXe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:34 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37727 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDXd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:33 -0400
Received: by mail-qt1-f195.google.com with SMTP id d14-v6so11350539qto.4
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Ayf4FJ5WuWBTP9J+ecILAGKV0NvK3Tj5jK4kHqTh68A=;
        b=z0M0JogW4LDmVUjaioPW0Eug1EDQdPaj4T1bR90j07KOEo4C10jyloe7BnvQrTvoGk
         RFTFqF2OBN7FK2h+5TXNEu0HhYJ5SsCP6ZHy4/qTbW4x8+SeON89xE6QmjW52OWDEUBV
         bIXv6VF21u9zUSbB+oEWDcHozDUBkkMv+l2XukhlK0Ka2lJcH00mzvFIz+bFi3+dtagT
         8tmVUIk/+dzVyVblIH2nMGQuH1hHNKYjyv5X7+QpHrQgN/ukJpLM6zim7Thx6P4y83W8
         OVplL8KpsNyBJzZrJRvEe0G9idWniyJkhC/aJ1m5tcCvIiwqnm50rFKwbY2pPUcsWOcS
         S3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Ayf4FJ5WuWBTP9J+ecILAGKV0NvK3Tj5jK4kHqTh68A=;
        b=iuxFUGsN1rRxCnCqMPlxN3bOKekVDSSatnE3WW70Ekk2FXFVxsnXGTnUtZ53rM19fn
         KKz+nVU2Rod2tsyPXvXF7SZh3wo+9mChqSiM2TbNfa0f7J4JgeCPG2AoTDO/+qFZekzC
         hVFpwyuZoOcfTA4k4JUGvCgf3YfnYB+9IL1jeJ//pmPSe931FyxBJUtFKw6zGeG2bQyq
         vG1Eobb72vslSZ7GkayPxBTCUdCMIlbaaCtizDp45BJ1c9EJOQdQvTtD1JI+iMHWad09
         DpCpwCcF4vKG7L0F0kHN/1FGWRfLUYjPanOsCt0vp/FT555vAYmwyCfVJ7IVaekv/7Re
         0Tiw==
X-Gm-Message-State: ABuFfoiXKpwnbGENxM+LTaMvnf/stiHZ0K0gbZP9dzt5mV7UBAqKUAne
        VVlSMKMWwbGEa+x6nuCBnu1boyxBPPs=
X-Google-Smtp-Source: ACcGV63k0hVlLoBroDgPx0xT0BuJeRBOsoDI4BMCn7KPs5w8ENogV3qLlssI65x61ESqEfdYmjPs9Q==
X-Received: by 2002:a0c:facc:: with SMTP id p12mr3120157qvo.103.1539287687125;
        Thu, 11 Oct 2018 12:54:47 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a13-v6sm15928303qkg.94.2018.10.11.12.54.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:46 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 07/42] btrfs: check if free bgs for commit
Date:   Thu, 11 Oct 2018 15:53:56 -0400
Message-Id: <20181011195431.3441-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

may_commit_transaction will skip committing the transaction if we don't
have enough pinned space or if we're trying to find space for a SYSTEM
chunk.  However if we have pending free block groups in this transaction
we still want to commit as we may be able to allocate a chunk to make
our reservation.  So instead of just returning ENOSPC, check if we have
free block groups pending, and if so commit the transaction to allow us
to use that free space.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1213f573eea2..da73b3e5bc39 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4830,10 +4830,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	if (!bytes)
 		return 0;
 
-	/* See if there is enough pinned space to make this reservation */
-	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
+	trans = btrfs_join_transaction(fs_info->extent_root);
+	if (IS_ERR(trans))
+		return -ENOSPC;
+
+	/*
+	 * See if there is enough pinned space to make this reservation, or if
+	 * we have bg's that are going to be freed, allowing us to possibly do a
+	 * chunk allocation the next loop through.
+	 */
+	if (test_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags) ||
+	    __percpu_counter_compare(&space_info->total_bytes_pinned, bytes,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
 		goto commit;
 
 	/*
@@ -4841,7 +4849,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	 * this reservation.
 	 */
 	if (space_info != delayed_rsv->space_info)
-		return -ENOSPC;
+		goto enospc;
 
 	spin_lock(&delayed_rsv->lock);
 	reclaim_bytes += delayed_rsv->reserved;
@@ -4855,17 +4863,14 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	bytes -= reclaim_bytes;
 
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
-		return -ENOSPC;
-	}
-
+				     bytes,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0)
+		goto enospc;
 commit:
-	trans = btrfs_join_transaction(fs_info->extent_root);
-	if (IS_ERR(trans))
-		return -ENOSPC;
-
 	return btrfs_commit_transaction(trans);
+enospc:
+	btrfs_end_transaction(trans);
+	return -ENOSPC;
 }
 
 /*
-- 
2.14.3

