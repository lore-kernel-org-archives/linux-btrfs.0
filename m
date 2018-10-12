Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADF5C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1D4B2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="hjqGgyVx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1D4B2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbeJMDHb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:31 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43077 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbeJMDHb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id q41-v6so15042979qtq.10
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=M5rFuwWprh+KHg3eMVqEhuKS6R++ogrBjwetuDUUZ8A=;
        b=hjqGgyVxPZEGhBBgr6//k4jMJqu0HhwTTF/4cIsqVG+9oBK9WAbNYs8kmTp/HGdIKf
         FFzZuea+GTSrNLe0+8WArAFdaf8GSytE1zMHANNo9+7egRrIpvW9nVZiX8V7QGtehe2g
         zml9+r9o3oVVdEAiqd/2UDZeKg3HTr3fD2Amfagjy8zH2FBX3SQsZGGYYNtHWs6CUftU
         fiJEdup3xdYyPNhYHmfsBURmIhHtOBrN+TkfMO3EM7t9Zj8QIynY6qs0HkXjytFhxKoz
         Hg278X5gq2pggNHY/xFi7EmgN5xERP9Gak7qff5TyDu2B7DHtvJqhSr3qhsEcxowSVgG
         lMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=M5rFuwWprh+KHg3eMVqEhuKS6R++ogrBjwetuDUUZ8A=;
        b=YA3QQ+Io3ri8xp9PUyPLDoLKKeSSVZnKgUmnLwtLbm10dysh4r/ePfj+zGCtbV2ad6
         /Hp/f0JtrO50KTQYMhVtRPrqGO470kXTGvv4FnApe0AeWGSxl2oypn0BHSkV2SKzGyjp
         glg3foPKule0EgwTy1KKOzOelTgIikNBLVyAs8F7xS6Hn+T0PGAg2EzEj4tYzVSGVt45
         ketzEZrYUjQjjmRYMs65fnJuv8WrPM7/CM0dxwxgg1M8o2dbz6l596XG0eKyooh7J0IS
         c5WLVnZ+HyCyoVTYPNdMbrlGuxFZEqDHdOcF1FzgxwZT7ZDGvRHCq7hKO+Xpw0W+FhZi
         9/xQ==
X-Gm-Message-State: ABuFfogq1RG4wKTTygm6aesSxiEjcPuGrqQOkqra8wihBs5ISZeSC0nc
        meBZ3uD8LjO6iulNvhDSILcc3xxpwaU=
X-Google-Smtp-Source: ACcGV63qY60JYWwe0TPF71E+xjlz28IoRCFWz0Bk0q6sswtGdtdalfNCSBmjd70/23gBhwoe6WF+Ug==
X-Received: by 2002:ac8:6bc8:: with SMTP id b8-v6mr7086591qtt.213.1539372810311;
        Fri, 12 Oct 2018 12:33:30 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i26-v6sm1637167qta.34.2018.10.12.12.33.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:29 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 14/42] btrfs: reset max_extent_size properly
Date:   Fri, 12 Oct 2018 15:32:28 -0400
Message-Id: <20181012193256.13735-15-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we use up our block group before allocating a new one we'll easily
get a max_extent_size that's set really really low, which will result in
a lot of fragmentation.  We need to make sure we're resetting the
max_extent_size when we add a new chunk or add new space.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 640ec640b21c..2b1704331d21 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4573,6 +4573,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			goto out;
 	} else {
 		ret = 1;
+		space_info->max_extent_size = 0;
 	}
 
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
@@ -6671,6 +6672,7 @@ static int btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
 		space_info->bytes_readonly += num_bytes;
 	cache->reserved -= num_bytes;
 	space_info->bytes_reserved -= num_bytes;
+	space_info->max_extent_size = 0;
 
 	if (delalloc)
 		cache->delalloc_bytes -= num_bytes;
-- 
2.14.3

