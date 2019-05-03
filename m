Return-Path: <SRS0=HUwI=TD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98164C43219
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 May 2019 15:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C89D2087F
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 May 2019 15:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="w1Fao1LL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfECPSM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 May 2019 11:18:12 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45180 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfECPSM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2019 11:18:12 -0400
Received: by mail-qk1-f196.google.com with SMTP id d5so3824614qko.12
        for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2019 08:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=lEAH3mW4TvfGnfj5Ey+wLtqeQ8FYBpo4lGJOvOOkR2o=;
        b=w1Fao1LLmSUfIsyOTyUt1pqOLINSIWVJo3fwje9RIGah1MOdHRuwKX2IS1YdcSK70z
         MuKsyaM3IJz9Vn3SrdePlOGPP0CvG8eQOdj0Mm+UzAn8ct5wgCllGGgX9+vxQC5BB8Kb
         658MDpBqI9v1tzFVCc74JZEkue5Bf7cJwstUE0vMNpaUv5HLOFfbxTfkAoTmcpUZ0qJ6
         NFwZkOPsURpnwNjHj3VZVN2P2V9WfLL3cwFIWwig/ehfmtWeV3zzIywqIaB3sXO8TWoQ
         2RDH5arKwpBVVhHqNuPW/NtbKKM9wp71QZj5CA4BNdJn/mDVvdTyES9T1bcJuFLzlWe9
         /rnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=lEAH3mW4TvfGnfj5Ey+wLtqeQ8FYBpo4lGJOvOOkR2o=;
        b=M7zQ0M7LgmuyE4c7bclDUgY27Mm5R6YQOiYv7NS3vSsXBclqMClJUlHfqcSsknVEbQ
         UefLIX+aynFyou445pCxi9php+5VbdeSNvDj1mbkDC/lgwkQPijCtI8rya2gPdIcN6wV
         qzKNvc6/6U6m/LA29zWwQYJSlZKsbFKJw1+E4qSdwG529immRNOx4/7FSqvYS+WeC0G/
         tT9oi9f+B2u3VRl+NDRw0mHRBZplMFrhYjB4Zzm7PWV1mR1R/XxEBNRmUiLnNgPvM4H7
         yd4K7QWlSgRNjyMGdPcawXR/qAEd/yiQOk92Z7zsG5sf439lQFrBeyfAbkghRoKlDSnT
         6pZw==
X-Gm-Message-State: APjAAAXRwXi9/5MQR7BdegbTYfV4LR4NKypXkpUTrvRZQtRm/UdpBjDH
        PBAexLuCHWP3FpxR5qNC3lIjjgLerN9UJlNS
X-Google-Smtp-Source: APXvYqw+K5jYKc1tjr0g0AK0K809yUo6F5e3xUgqG3WltBvAI9vtnr5ls8K09n99HsS6QMW+xGPzKw==
X-Received: by 2002:a05:620a:15a1:: with SMTP id f1mr3055679qkk.160.1556896209286;
        Fri, 03 May 2019 08:10:09 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::e8c5])
        by smtp.gmail.com with ESMTPSA id d127sm1173789qkf.8.2019.05.03.08.10.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 08:10:08 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH] btrfs: don't double unlock on error in btrfs_punch_hole
Date:   Fri,  3 May 2019 11:10:06 -0400
Message-Id: <20190503151007.75525-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.13.5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we have an error writing out a delalloc range in
btrfs_punch_hole_lock_range we'll unlock the inode and then goto
out_only_mutex, where we will again unlock the inode.  This is bad,
don't do this.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/file.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7f7833149cb7..d23ea0b388e0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2554,10 +2554,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	ret = btrfs_punch_hole_lock_range(inode, lockstart, lockend,
 					  &cached_state);
-	if (ret) {
-		inode_unlock(inode);
+	if (ret)
 		goto out_only_mutex;
-	}
 
 	path = btrfs_alloc_path();
 	if (!path) {
-- 
2.13.5

