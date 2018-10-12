Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAFBC71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16C9D2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="skXY3pP1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16C9D2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbeJMDHS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45044 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbeJMDHR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:17 -0400
Received: by mail-qt1-f196.google.com with SMTP id c56-v6so15043461qtd.11
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=yYx+AcpbxeLRdPqDImtMM4yf4Rg6f5T1yjgQiHsfUlY=;
        b=skXY3pP1DrFOdaOO5OkC1wUb6KrG+WXjvnuvCO5zH0wiq/Pm2fTcI5P/OuJe8q999n
         kgqdbaj6P90mIcNIATAKMWRq4XrEKdwkvI9/9XWX7dTIbG6N/TVQ2Gbtsr3hQH28EWjJ
         lrBrc6luGk5TlR1lYLELvN+YXWQGStEFB++OR96TO3seFEHcbGT7iGfBdRMpco4t3cDb
         6YSYPO+NoIHUkeJe1vYspE6o6OkdhY/3hV5c/IBPJl78e90RAPBFDnKLRyLKN8uG1wjq
         WUqeHcz1B6Gb8neY1JYzM3mK/0xMprhaizF35lAFsePqvcHCpcGN/x/qzDUF6oNeCkj+
         vMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=yYx+AcpbxeLRdPqDImtMM4yf4Rg6f5T1yjgQiHsfUlY=;
        b=qtZza7fbL9oCpeDMv/A31ekUBy9vv7u/J6NTfgW1N0JC+u+N02kJWBN+lfRByVFQXd
         ySPrqRizyQycN+7HyPEpNkRGCMWb5GPZuvxytgO6U3xP54KXrjIDTphVHsi0trTMh1XV
         9dEK7uRAFMurDJ9X+HE2A4PeRYBoRAuEQM+IfGgqIYmHfByNOwupdJUo2EmODuLIQlho
         zS6dLuZfsQAXfTdoiFJoZlS/sCZVAc0qmM7Rg9Bxl/u6NoAJL8uf9aeXeJ6w68XDLcMD
         q3AR1UWGeSIX10FKm56WXBWBsnc73Owpyw7Lkda4WAGbmVjBlfbtf8r3MH9eNurq2jnS
         WTIA==
X-Gm-Message-State: ABuFfohGxkjaB9+8bjpTXSJ5RnLPm6zm1XmQkZu2V6HA0lBdUrz2c/N/
        cdagFeBYcVoXrlPP5L8z0YXbJ1aJ6Mk=
X-Google-Smtp-Source: ACcGV61+GUrPwZKPZ4dJ2PIzFj5ghXqJ9+NZoPRw9qtncUl4fv1V4OnL6quyl+BQ7p1JUG2FP/Nfsw==
X-Received: by 2002:a0c:d97a:: with SMTP id t55mr7109584qvj.208.1539372796675;
        Fri, 12 Oct 2018 12:33:16 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id g2-v6sm1065682qkf.91.2018.10.12.12.33.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:15 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 09/42] btrfs: release metadata before running delayed refs
Date:   Fri, 12 Oct 2018 15:32:23 -0400
Message-Id: <20181012193256.13735-10-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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

