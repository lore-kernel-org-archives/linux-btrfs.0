Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3EEC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E4C3215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="xyh5YsQd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E4C3215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbeI1RmA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:00 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:42022 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1Rl7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:41:59 -0400
Received: by mail-qt1-f178.google.com with SMTP id z8-v6so6114830qto.9
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=yYx+AcpbxeLRdPqDImtMM4yf4Rg6f5T1yjgQiHsfUlY=;
        b=xyh5YsQd1dY496OnahxCJ7gwUX3hHNiNBHNW9p5RSC9F/NzgUB1S3jN1kyBY+1Par3
         jiKQ/L5LaLdF1jdbMlY13eeJIpcu4S8o3UQnpv5PzXVEzIGGxdBnqP74EzzOIz081gUP
         p48XLCB032UGouf07coDJkC0A1eJ4ckAEFABgBr/NbF+0ZCn9otUdl1ESi+0EZr4plEs
         sOlX5n/hwaag6d8qmOLpScNRbsaIYhAqCW20JZ0FpxB5iGuWEIwGcQtnG7PB/NdAe6xG
         O18txdxley0ywn/7HgA/eujEpq3L8Wm+gipN1gOCM5lhyDtoL/Ut8TobcpVNJ1SPcStO
         +SfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=yYx+AcpbxeLRdPqDImtMM4yf4Rg6f5T1yjgQiHsfUlY=;
        b=JhG5OOd4/P7uWHjoJER7bJVh+k3fqHxQRX46MmcV1RKlWoLFsr3SM2jSYC6TVLQg95
         Cf+ym53vhsvVS0Sem0MsXpLKJPsPIY52Uki61wjqlTYAOomFlIN6IEe3QV/NJKGRLTUs
         PFwjMuTnZCogHe4zrc5E1AhvQMy0QSLSBMLSFHG/OPP72P1amwz2IW6RMHd3LC8gx8Eq
         RbUYUvGAMx7aZ9CyN/RQpT+WbjJzt08g8r4LKMVZvJ+TAxA7KIsZevM2pBJ0G8Bt4hUZ
         WfS6CbsBMfLwP0G3YSTxgwWSEFBfyGJfXLm9xmsq1J2bL1B0864XlM13jma/IJ40+owd
         qIFQ==
X-Gm-Message-State: ABuFfojYwh/RXS6jkM2bDhZbOs53vS10EjosoQT/yPQQc4gjulNKXsb8
        L80XP2YyD5pufjlYOxJs77QoNabjfnA=
X-Google-Smtp-Source: ACcGV63URrSCe0p12sWYeHvFkdYX48zvn9fdIiis94hC+ELl7QHnekpLMn+eFED0naOYiXjiJ8ffHA==
X-Received: by 2002:aed:32e4:: with SMTP id z91-v6mr9050397qtd.106.1538133522147;
        Fri, 28 Sep 2018 04:18:42 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f184-v6sm2610770qkc.23.2018.09.28.04.18.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:41 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 09/42] btrfs: release metadata before running delayed refs
Date:   Fri, 28 Sep 2018 07:17:48 -0400
Message-Id: <20180928111821.24376-10-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We want to release the unused reservation we have since it refills the
delayed refs reserve, which will make everything go smoother when
running the delayed refs if we're short on our reservation.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 117e0c4a914a..a0f19ca0bd6c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1922,6 +1922,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		return ret;
 	}
 
+	btrfs_trans_release_metadata(trans);
+	trans->block_rsv = NULL;
+
 	/* make a pass through all the delayed refs we have so far
 	 * any runnings procs may add more while we are here
 	 */
@@ -1931,9 +1934,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		return ret;
 	}
 
-	btrfs_trans_release_metadata(trans);
-	trans->block_rsv = NULL;
-
 	cur_trans = trans->transaction;
 
 	/*
-- 
2.14.3

