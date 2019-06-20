Return-Path: <SRS0=S96U=UT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB27EC43613
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Jun 2019 19:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 965B8206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Jun 2019 19:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="N9zFkasr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFTTiN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Jun 2019 15:38:13 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45467 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfFTTiN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jun 2019 15:38:13 -0400
Received: by mail-yb1-f195.google.com with SMTP id v104so1653614ybi.12
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2019 12:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=fFzDvXAtGxvS0IHdyqRzNx63Dt9a4FHHLIgOsAPOSUQ=;
        b=N9zFkasrLqyya01ja1zLuoKhVHYTssPQCJYlVbbPb2rcy9snhDUudOkj2FHzYvQJay
         b7dCwc7T6JAA8IKGKvaiHC0cvpdbceN64mslsWmFG52sl03PxcF5wpaw12N0yWLijhXh
         HXpp2N7KNABJAoZTsmlyYH1dFs/Pckkz+YEjQKzaDriHyQ49VORrBNqdjjIUAECMEAkZ
         yIXF3qd+FfcXXHdnLJt/dfd6CO6DD02tKonAVgSqCx3Z2YEvtdcskz8QeHYIHl9d8wg2
         0M31E96z3NogYVnWxiBKgRwDT2iChxnjtpWfB7dLnQkbPrLRDmmnhUgA7y3LTif8ywfp
         zyOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=fFzDvXAtGxvS0IHdyqRzNx63Dt9a4FHHLIgOsAPOSUQ=;
        b=o5ZZLiKH56jFY5/cUIq+hbNmpPKd3r2pmuxDXatm1WF9IVLSnNYC2oqe8/HG+ZMfwF
         JaAKJ4BibEBUm+Pzv33Vj7GAbKiMuYr6gvOSyQEfnApqsY51vsErIvJDWAF6v2JqsZy9
         qg+8FRzLxr6TQsE7iwtuOhC+/MJG5sdZ8rFACgUAsk7iPzKMZhzbB8PNiZdSdFvuCzTL
         gO5rV9whaKpSC1VGjnsHGJ1yG0b4gyvLNOhM9XZPUFD1SaGjYah6MlIjs/Rdt2C82Xjh
         g6AAlvZWYuuKMibY47lW7N1fwDGoTrosTJvFpKtcbJdNew2222vbucj7HwW3C7tdwtaC
         morg==
X-Gm-Message-State: APjAAAXJNlVHNdKJux+Dsav2kgiPoP/JgLixiXch+U4BKSDMH90oMbzd
        q1cdFvWlmKxhZEAbm+qqLpee5GMfRcEaBA==
X-Google-Smtp-Source: APXvYqyOnyNHcw+Afz6Hh/XvVlsdHTSehFubOHwBcXvokR98SyduCYoqEqr8jN7RpZzDRNq8c8WZZA==
X-Received: by 2002:a25:43:: with SMTP id 64mr66090677yba.115.1561059491589;
        Thu, 20 Jun 2019 12:38:11 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 199sm108076ywr.101.2019.06.20.12.38.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Jun 2019 12:38:11 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 01/25] btrfs: move btrfs_add_free_space out of a header file
Date:   Thu, 20 Jun 2019 15:37:43 -0400
Message-Id: <20190620193807.29311-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190620193807.29311-1-josef@toxicpanda.com>
References: <20190620193807.29311-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is prep work for moving block_group_cache around.  Having this in
the header file makes the header file include need to be in a certain
order, which is awkward, so just move it into free-space-cache.c and
then we can re-arrange later.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/free-space-cache.c |  8 ++++++++
 fs/btrfs/free-space-cache.h | 10 ++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 062be9dde4c6..92cb06dd94d3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2376,6 +2376,14 @@ int __btrfs_add_free_space(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+			 u64 bytenr, u64 size)
+{
+	return __btrfs_add_free_space(block_group->fs_info,
+				      block_group->free_space_ctl,
+				      bytenr, size);
+}
+
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			    u64 offset, u64 bytes)
 {
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 8760acb55ffd..2205a4113ef3 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -73,14 +73,8 @@ void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group);
 int __btrfs_add_free_space(struct btrfs_fs_info *fs_info,
 			   struct btrfs_free_space_ctl *ctl,
 			   u64 bytenr, u64 size);
-static inline int
-btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
-		     u64 bytenr, u64 size)
-{
-	return __btrfs_add_free_space(block_group->fs_info,
-				      block_group->free_space_ctl,
-				      bytenr, size);
-}
+int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+			 u64 bytenr, u64 size);
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			    u64 bytenr, u64 size);
 void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl);
-- 
2.14.3

