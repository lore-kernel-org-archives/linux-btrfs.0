Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1667C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61A52215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="cdBc5Q6K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61A52215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbeI1RmW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:22 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38147 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1RmW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:22 -0400
Received: by mail-qt1-f195.google.com with SMTP id z13-v6so6144075qts.5
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z3nhKV1wBqQcfXnDoMHMl2GEjOrb6h1HQ06C9nkbnUE=;
        b=cdBc5Q6KuuD06XXPh1mFzp5TW+/7H4ANit7XsOnhww4nFYTdj+Ei5lZdLzH0WjxRIk
         zFVyx2lwsl8ES7NVUje/y51OeDxW5XsNNwpvkW5l4A2sW4xZkQuNH8sYxL+Lo1aeqoqd
         Nq6JAVv2WqD6L+ciesSDtCFrbvxrb+K5mU8eaoP8ALeFe7IKuXAJl8zrLL61vi8gu2cI
         V3dtJnO8kXeYH8eEb6JPH6CJm7tHhRUNDy64Se86iq7ibK85dhctjYUWi5/nHMNNCsYV
         EBOwPKd6zw2PHqSsyd6lGlfi2lSCL5ny0uR3xXSsqP95EvEkpLemsyF6kapmNs7I0Rw+
         rffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z3nhKV1wBqQcfXnDoMHMl2GEjOrb6h1HQ06C9nkbnUE=;
        b=RLPc6S59EGFuOP0t2LjTOM0VELcIJHQoGcLU3mweTdIgNrh5INNm7s4768sBFphAIm
         loNdW2GZcrNwSLtxHr/vNhYeu6sAs52eZC9PYAtdDtp52nGvcqEG92w7foRT7G26IY/E
         0xIFxGRCeYZSk9F0ySnDXBIPmrbJTnasAWidpahdgjjDjoMK+w3zXM1PeAX7wIoTekV5
         +my0ZtgtZJ/M5NzyJdDhAjPJ3TRXmE2NwzN8Uz7QMrmiVF4mmhDQJPQg+p7gkX81v15J
         bGYkL5LM/3xUimEGhca8bTjfO8ZVDkMB2hmxAs0/AaOhvFlZrbULUZAVw7Ocypyrooif
         D6tw==
X-Gm-Message-State: ABuFfoj75hqE4yu9cRbPZkdxJj457NGxEHsMVmgEcGaFEQ6TDnq934sh
        mdamYhQL4qyf6BgWTNAGdKkv/Q==
X-Google-Smtp-Source: ACcGV60AGalAUmVNdqHGKkBexmdl+jSkQFtfKLVDVFggfWZXhFIw2g3Wt8TNzWD7ug2UmJPOienNyg==
X-Received: by 2002:ac8:6b13:: with SMTP id w19-v6mr12239761qts.317.1538133544259;
        Fri, 28 Sep 2018 04:19:04 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f10-v6sm2388374qtq.52.2018.09.28.04.19.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:03 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 21/42] btrfs: reset max_extent_size on clear in a bitmap
Date:   Fri, 28 Sep 2018 07:18:00 -0400
Message-Id: <20180928111821.24376-22-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

