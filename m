Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AA0C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7CF520835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="mHB99gDs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7CF520835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbeJLDXh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:37 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:36338 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDXh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:37 -0400
Received: by mail-qk1-f173.google.com with SMTP id a85-v6so6278228qkg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=yYx+AcpbxeLRdPqDImtMM4yf4Rg6f5T1yjgQiHsfUlY=;
        b=mHB99gDsbhUNvWIWPjLY0Pw9l6iUNxJU3AewQx7C1hrIXha7BzwTI1UmJ9WSZyCa6K
         Q/bAgCCzpzbawiqE4aMpZR6WeppSsNoiHDBBb32akCRhvbwz+5mjcKEyoSHHLgrHzAgp
         Vsnu/rCxgkyZPEK8Jfvp+yz2QQviTLF0hguGIlhy/MDZgPNDHNZkHzuto2YOu8hJPtz6
         kqdocH1F3eqmYyJ9PKHEqFPPSXJmQKccMdJu2xKJ2t/Umb47OGYmwC2WCJZMu0vh/4bR
         Iq2VUuI28IaHWEWU0QoCQZr7SwWTMqZ899rUUTL2uUg8DYykOvsHwJBMiYndhLN3F4sr
         PBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=yYx+AcpbxeLRdPqDImtMM4yf4Rg6f5T1yjgQiHsfUlY=;
        b=hRxMqUjv8tavWnLZuPFcnJohK8KaJliIzrcYBciGsiUJQcL7PNX+je6owydOMQZ/sO
         gwSCIG0cROL81O1fz690p7mqCl/r88Z4QVmkiNmDlQzBgCPUanBpoUpP/8nVvUG6QQq5
         Mpa4paGYHgnYn7jOiMEj+bF47tSLU/3bPRQKNeg+JfxJF7DAHnAQNyvplTYQaEAOSvin
         nl1Xzf07MIEakPMPDvegvw00YwlprJ3w/1b81EilTemWvCtAVTYlrjzRWu9HFCHw5g3Q
         s4fu27eqYnLVbAeCLAjtT71KwIPo9dwEbK1HH4Ir9qt349o8M2Eb8YZpIPjWK3CYsj58
         rXIw==
X-Gm-Message-State: ABuFfohxW4ZKCqumCwMEUobGbIKi9duZMiNUHkOOQyYZ59kMovn2N5eb
        sK8e0iJ4lTKGj8mGAJSJ1DXu0Q==
X-Google-Smtp-Source: ACcGV618jFIlWNGFek61r+IP5wdDyVEjkoU3zDPeUpBf5/BueOMHuFT1L9ffvM+A2e84bm9zaeIXKA==
X-Received: by 2002:a37:f8c:: with SMTP id 12-v6mr2994137qkp.224.1539287690821;
        Thu, 11 Oct 2018 12:54:50 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id g4-v6sm6762627qkb.64.2018.10.11.12.54.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:49 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 09/42] btrfs: release metadata before running delayed refs
Date:   Thu, 11 Oct 2018 15:53:58 -0400
Message-Id: <20181011195431.3441-10-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

