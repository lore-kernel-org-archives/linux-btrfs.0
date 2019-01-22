Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147E0C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 22:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5B8E21726
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 22:59:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKtSpdYQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfAVW7t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 17:59:49 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44690 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfAVW7s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 17:59:48 -0500
Received: by mail-ed1-f68.google.com with SMTP id y56so161092edd.11;
        Tue, 22 Jan 2019 14:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mOkvoFhfo2r6rTTBk2jy/ET4GloEdf/e5pS9eICehWE=;
        b=XKtSpdYQCUrsQqnK7iE2xKcr3HkPHHZ9ttkYYldmjM9v0SGSZRMq6tsQk0KeG01N4m
         zLZelw9Yb4xaLHHYl7eLcACGMuHVz3VsFLJ/6bVaaS7CHgnkdAb/G0+9dv6VUY6wwTwJ
         Q3PePFS24fL2dXGOwt4GAYaYTXEvuDTXIpvBh65ysklQ83/wZ2GPTpziTQ+O24ZgF7RA
         w/UM+fI34svukxRJqRHB6ui6hfcDrVtFugINz7ah6/3BIsasvkRJ89DObwpoXOrdCFzH
         4ksmXBJHtXQUHqvaKjJur8Mf20iUZ7kUB/rhqaql0I6KspiPPwlKcgketWeOh5awXEnj
         d2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mOkvoFhfo2r6rTTBk2jy/ET4GloEdf/e5pS9eICehWE=;
        b=kpFC3CU9VeM6ElMfOe0BXdbXM+GpCFr548MbuHa64wagcIO7FtMHStxP/TAPjKwOLO
         cNjdiypxrZ7Dw96tY4y366fx0Xmo6oELsnCiT9bRnn1MzItCKpZ+odcPthL9FoGyBpg7
         DCPsN4wUbOzISS2uWJuhv8b7xWqVq6oEUkp4c0IyE26q2pKGKZB6tFRjZAgVwdje+k4v
         GJoN3hF17p/c/Wp9PCPSijqMIj+MiMG8DTbCn7ln4uSL5e+tN5BKs6VmvaviuaY0yhu3
         e5MHWMA/eLGG7xKOH0j8qy9aPDt6zMYSztTVi9ADh4Y74H+kEk/dkzeasWc7ceTX7Vcv
         TaJQ==
X-Gm-Message-State: AJcUukdIZc/XI41lcFH+uMMpj5HEp/itQpL5P1wts0l8IDvi/hjHGYTf
        3neyVpoiiOxI/9tFwNLd7jo=
X-Google-Smtp-Source: ALg8bN7SS1SkmZuijhyBk+r7Sxq2NXTycyLMSbkY9GM8LY04mTWLporr3Gw1iBgHpYUZJ8sGIdfkSg==
X-Received: by 2002:a50:898f:: with SMTP id g15mr306602edg.257.1548197986827;
        Tue, 22 Jan 2019 14:59:46 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:220:e800:7c60:7501:32ce:4c88])
        by smtp.gmail.com with ESMTPSA id z39sm10102619edb.81.2019.01.22.14.59.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Jan 2019 14:59:46 -0800 (PST)
From:   Matthew Friday <lkmfriday@gmail.com>
To:     dsterba@suse.com
Cc:     lkmfriday@gmail.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [PATCH] btrfs: remove unused wariable 'num_pages'
Date:   Tue, 22 Jan 2019 22:59:43 +0000
Message-Id: <20190122225943.7976-1-lkmfriday@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Matthew Friday <lkmfriday@gmail.com>
---
 fs/btrfs/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9c8e1734429c..6243f734c0cd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3278,7 +3278,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 			     struct inode *dst, u64 dst_loff)
 {
 	int ret;
-	int num_pages = PAGE_ALIGN(BTRFS_MAX_DEDUPE_LEN) >> PAGE_SHIFT;
 	u64 i, tail_len, chunk_count;
 
 	/* don't make the dst file partly checksummed */
@@ -3291,8 +3290,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
-	if (chunk_count == 0)
-		num_pages = PAGE_ALIGN(tail_len) >> PAGE_SHIFT;
 
 	for (i = 0; i < chunk_count; i++) {
 		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
-- 
2.11.0

