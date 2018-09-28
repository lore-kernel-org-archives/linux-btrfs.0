Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC289C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD238215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="sPHp7jUk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD238215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbeI1Rm1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:27 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44513 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1Rm1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:27 -0400
Received: by mail-qk1-f193.google.com with SMTP id g184-v6so3538159qkc.11
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=JFxGVw1HrusCY3GFgaJkHeYCW8OyW70/VljEmT/1Dxg=;
        b=sPHp7jUkzCEtCaZ7TZa7nJAet+wGxKfK1z05Y5h1YbKKNkBMZ3/GK8hysREi9l+K0D
         HRx7R2PlFziw+uQconyApQK5bELe7bh2xiIMnZSs+zt1K4Q8K9bADbgcSp/DxKQilPwZ
         kJKmb9t8u3LMxvKkkuIsPQr1zR9PgACPki2HfLGrBE/6t0lwgDYAONqPY5jYwK26f/Vc
         1QbFS24IM8gxOqDDXPMJP3TwBUypBPzA9EHRO5lVcmYblwczgFrC8yoqG6Zns7wUhGvj
         ND4ajw2GkanK3QxrSHYK/heYrR8D0zMRohZYzn/KzqgKSyGXhFzRls1nXL+P3+WtNFgm
         Am0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=JFxGVw1HrusCY3GFgaJkHeYCW8OyW70/VljEmT/1Dxg=;
        b=gDSbPTro20rCT+SPkx15OuknftfLPYpCOaqh/CwhQ+6cyN45T2jqfUFJlowoJ1Cdl6
         dqlwEdfnGFIRDGiG6h5SDHH5S840z+s45Vr6Jq3nxBfWxYIoGcCJSpwXG5PpRqEHV1cD
         ptFh+79wM70KYzNKKIMkzwJsSftSSKXluqe1u1JlOgnHXe5JLmqnuDcCQQMD5nWXSBUa
         TcW3Da9T3LsGkgCN4KbzUce4CZrZMaqB7AUwtMLRxWRawBW7Mc1sDNC2LMCJVUSNrHdk
         lIFVvuaRlSX433PJqVqs5vi8YQgi4h7EHjMPvi32e2yboQsPuLN+5YOfRVG1IZdNzlJU
         nclw==
X-Gm-Message-State: ABuFfoh/LIuH4svZ94ypCxpIEOdvkoaP4y0A23qBz0/OxGIEn1fL9lAM
        h8TkipIpEv1RghWKZrWmsUtgCDqc58w=
X-Google-Smtp-Source: ACcGV61fpQPr+ZCr17Vf2ioB5cRs5iudMVRVSC7oDvWvJ0MfP8WK/0nR7X76X+I7yIsCnCOS5/vCnQ==
X-Received: by 2002:a37:f53:: with SMTP id z80-v6mr10666503qkg.278.1538133549566;
        Fri, 28 Sep 2018 04:19:09 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id v12-v6sm2700178qtg.82.2018.09.28.04.19.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:08 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 24/42] btrfs: assert on non-empty delayed iputs
Date:   Fri, 28 Sep 2018 07:18:03 -0400
Message-Id: <20180928111821.24376-25-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I ran into an issue where there was some reference being held on an
inode that I couldn't track.  This assert wasn't triggered, but it at
least rules out we're doing something stupid.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 377ad9c1cb17..39bd158466cd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3979,6 +3979,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
 
+	ASSERT(list_empty(&fs_info->delayed_iputs));
 	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
 
 	btrfs_free_qgroup_config(fs_info);
-- 
2.14.3

