Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78501C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D9852064E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="b3KCe1EW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D9852064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbeJLDYA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:00 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45007 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:00 -0400
Received: by mail-qt1-f196.google.com with SMTP id c56-v6so11328583qtd.11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z3nhKV1wBqQcfXnDoMHMl2GEjOrb6h1HQ06C9nkbnUE=;
        b=b3KCe1EWRzyLQiTGj7FwJp9/DIi+ZZnKj+VPNGL4dTvrM0LbRmtKyc9e3t0y0TI+6R
         mL5aScEgl32muQoVRaBzEjP/Gjb9GMO1QsIVC+ozW6zXSHExbiVjiJTXE20oKbjvTaaR
         uegv2Ey+g7pcnT/MbUv7T3gRP2uLVZtz0EM6+6WU0IdACv91NHcw43yCzW1SmyuAcRQa
         yyP65SRKaU6m3Pc2/SLORMsWO74B6ugxf9IRkOZfO63Kq4qdfdcw7SkZeXExM4GbGYTw
         qiOu8CZh/o6+PZmrYu4e5VZtVsTKneu0S4k6olgQZbAR2HPFZaudHRl6Tto8+3EcbbPJ
         tS/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z3nhKV1wBqQcfXnDoMHMl2GEjOrb6h1HQ06C9nkbnUE=;
        b=G3YE+MVAA6P6Jv4sTlK5XS2xW2u+TDRzFKgPN8bPWskFEY4UwsaufX3bpRZgNcbykA
         FBBefS0YFRVvUlIxdTMycRtlHZpdg4mamyfE4C8FGMvDZ8VBD3tdiT8jzHUbvAOS326D
         4XfAjZg/pIK93QGqsypAFPBcYVNTFZLpEtoLguMD02USA5+8d8s1qkVufRxyFwg+0Kse
         2RY2YKOj0fD1eoyfCT+/mpwZWvXHW30QAxL+2Xa+zmoWvdy5wGW4Rp72Y6Tan7iYVUIE
         H/Vq53UAxZoQ+Zzahn6tHyso4egAL7L8dLRhUFt+rZbee/Jts/DBadUiZV4pJ0Ex5CKf
         Tp5g==
X-Gm-Message-State: ABuFfojBl1T9LSiRp/tOTq8DxkhSV47hDrsg0sSPMvnchfOdfeSCgjOj
        jXfCICnvi+hx9Mibc7ktXADbXw==
X-Google-Smtp-Source: ACcGV61Y2Ax0IdCm3cEj9kXmdLWejTxQnenuNLNo3O1VZ/yMJedBP4sFh6rozmgtOJo5I3d4FVD+mw==
X-Received: by 2002:a0c:ae04:: with SMTP id y4-v6mr2970287qvc.233.1539287713800;
        Thu, 11 Oct 2018 12:55:13 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m13-v6sm8907378qtm.20.2018.10.11.12.55.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:12 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 21/42] btrfs: reset max_extent_size on clear in a bitmap
Date:   Thu, 11 Oct 2018 15:54:10 -0400
Message-Id: <20181011195431.3441-22-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

We need to clear the max_extent_size when we clear bits from a bitmap
since it could have been from the range that contains the
max_extent_size.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/free-space-cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2e96ee7da3ec..d2a863a2ee24 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1687,6 +1687,8 @@ static inline void __bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 	bitmap_clear(info->bitmap, start, count);
 
 	info->bytes -= bytes;
+	if (info->max_extent_size > ctl->unit)
+		info->max_extent_size = 0;
 }
 
 static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
-- 
2.14.3

