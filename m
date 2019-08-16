Return-Path: <SRS0=CxMI=WM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1E6C3A59C
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Aug 2019 15:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6BC42086C
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Aug 2019 15:06:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="p8yPIzA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfHPPGK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 11:06:10 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:47002 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbfHPPGJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Aug 2019 11:06:09 -0400
Received: by mail-qk1-f195.google.com with SMTP id p13so4912457qkg.13
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2019 08:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0IMczAdyKPY6kC8Rg3PSJuec5mHORT8BHCxnswZAnl0=;
        b=p8yPIzA6Ke9vzLucu/qtyZjhH7oYBkTS108sJtPUJt3ZxGSL0sZVZQNDqq1wRuqPqi
         n7W+wm+g01zYq5dWLRp5UMrZ+LkQY0LDPkKliteK49B7T4TZuuS35dybGsKRzJhMZOHT
         YGqgvNztSkZaixeN1immoH+xdCPoh5b5jdTZhiG+8aYVmuu31KXlx597C88Ku5P/+iYD
         zRbgn/CR1/5dLR6Z6EUgCF/sFAS19LU3Btcukn4ejBTirwJ9g5ft56M3CBn5HRj4jg7Y
         IvRjS71ayxi2De33u7tl8odDIy6l4zYckyAffrT6x8PSGCdmQ7wgVulTcyrDnrNCNeu5
         zHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0IMczAdyKPY6kC8Rg3PSJuec5mHORT8BHCxnswZAnl0=;
        b=n3yyapWvIJcE8Emn5K9Tn6ztMvmkZ6uCztLxlSllS71vTO3e/hPKcbkVAAPFThLHGW
         +u3dHaNdGVWy57NQOB+OQrDbi0Tv4arNihsHipM9xBYJPAcwKmW6p87QD6u9lA+jNEpb
         OcndwLIZIFGbYG2XbDd1VpUUYkMtXdQdCIjX2SGWt1DLnzD4Rfxy+LfOkBzNfIJWqvUM
         urmBv8Wc4f1xBHLbw1VFC2bV2YNMUZWp/sKR2SONtcuENdGVrQezUdvCVy200vTIG4Sn
         Fxcqil+eJx0T0m3Wa5Z0BPRe8skXAwK1LUtNdjw+b4hotthXh9/gETHAKi3SzWTpXkDH
         86dg==
X-Gm-Message-State: APjAAAWhzYLECZmI5neYOEpl5D+DATFKAmzxciAM+26wXpb1VJ8Wa4WK
        AjJaUCaZzVb7L86/FxfDiC/RUOVa3T23Dg==
X-Google-Smtp-Source: APXvYqz+koUqpf7ggZn27sRBpOXBNiccFnPQdmgkIdUTq0PrcspdGDAkMrkWd0y+5m8zNGRFf0GVgA==
X-Received: by 2002:a05:620a:1411:: with SMTP id d17mr9114095qkj.81.1565967968408;
        Fri, 16 Aug 2019 08:06:08 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f7sm2951735qtj.16.2019.08.16.08.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 08:06:07 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 3/3] btrfs: global reserve fallback should use metadata_size
Date:   Fri, 16 Aug 2019 11:06:00 -0400
Message-Id: <20190816150600.9188-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816150600.9188-1-josef@toxicpanda.com>
References: <20190816150600.9188-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We only use the global reserve fallback for truncates, so use
calc_metadata_size instead of calc_insert_metadata_size.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f21416d68c2c..cc1a3000a344 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -636,7 +636,7 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 	if (IS_ERR(trans))
 		return trans;
 
-	num_bytes = btrfs_calc_insert_metadata_size(fs_info, num_items);
+	num_bytes = btrfs_calc_metadata_size(fs_info, num_items);
 	ret = btrfs_cond_migrate_bytes(fs_info, &fs_info->trans_block_rsv,
 				       num_bytes, min_factor);
 	if (ret) {
-- 
2.21.0

