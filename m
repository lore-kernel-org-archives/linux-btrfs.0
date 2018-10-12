Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B131C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00E892087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="pgziAFro"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00E892087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbeJMDI0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37628 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeJMDI0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:26 -0400
Received: by mail-qt1-f193.google.com with SMTP id d14-v6so15065223qto.4
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=zZszbBJ2wYqnRaCO5pCUOw7tHC5U99aK2TNTpFeSZ9Q=;
        b=pgziAFro1R6lxCBjS1Sg+32a1iqvPlpMfohfHpMcD/QeZyBHeRlkbchDuWiG/Lu1qf
         5ln/VsTBAWxkupqwHpAIVJ77iSBz6rCIu+2swMUIMvujDzLWHebGZddfT77Rk5z3h1RC
         KdtH2mbKAkkH6mR/GWGAwHngU0XAJLN3XmCfBVE/RecotHZJhSVlxsVAbOsxHp+nfatK
         Od2Vm7ZuXVuRVTgxGyLGh0AwfpQgz0Ki/fHSKxfkIhIUV+1EKNWEEc4Lfaldj0o8dRqg
         ELNkrpyPocfxHPKLSEbPA7yRuYhvozWj8s3eeobZH41FYB7ebUOSKgMglaV4MpAFJ9vC
         0OXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=zZszbBJ2wYqnRaCO5pCUOw7tHC5U99aK2TNTpFeSZ9Q=;
        b=NQS+EAdDAmbHU4IQwTltSimnEEuFjQe8Layj6nGBxypmmK++Mr5mlsonWdSNJCaFu+
         sz3Ow2Ed74hy8ospm15Up2DGPyeIRx8X8ZPLpQPi1HJBh9nJr0CSRMrylUS9COBXupaA
         BRi9bf/FQaQLYZb6PLi1xteDrVmQ1mjbF2rWpP+ptee7RRURDPMzIpaI403uwFvqo+qV
         v6W9HOcI3YBO/cVx/AIVWefr2FyLEx2XnFAzQMDqR2WnVDUKwJNA+FZdLxTXibycWHbt
         gL5uX4Yn/GLGgN2w0KQijeJgP4DcXoleW1XWGS2YFH0QjNaRka7Eg7zLsk/Ivnhv4TjT
         Ocaw==
X-Gm-Message-State: ABuFfojRwkW4E3m7aLwR25fzvPa9oT7iymwQ7tsvr8BIKNObgofd285b
        LbuU5cw5cDU5ugJgB8+ztohQUHXIFrg=
X-Google-Smtp-Source: ACcGV62ZL4qM+jCuipY5MweN25SRh6oQtUR6BuMjB09/A0DiBfX0BwMPYNDmjM74ZFOoprgzS8d6nA==
X-Received: by 2002:ac8:7482:: with SMTP id v2-v6mr7147733qtq.251.1539372864452;
        Fri, 12 Oct 2018 12:34:24 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id e24-v6sm1476954qtc.78.2018.10.12.12.34.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:23 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 37/42] btrfs: wakeup cleaner thread when adding delayed iput
Date:   Fri, 12 Oct 2018 15:32:51 -0400
Message-Id: <20181012193256.13735-38-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The cleaner thread usually takes care of delayed iputs, with the
exception of the btrfs_end_transaction_throttle path.  The cleaner
thread only gets woken up every 30 seconds, so instead wake it up to do
it's work so that we can free up that space as quickly as possible.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2b257d14bd3d..0a1671fb03bf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3323,6 +3323,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	ASSERT(list_empty(&binode->delayed_iput));
 	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
 	spin_unlock(&fs_info->delayed_iput_lock);
+	wake_up_process(fs_info->cleaner_kthread);
 }
 
 void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
-- 
2.14.3

