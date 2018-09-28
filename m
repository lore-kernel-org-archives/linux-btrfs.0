Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01010C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4A28215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="G+jIjuh1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4A28215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbeI1Rmv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:51 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39397 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbeI1Rmv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:51 -0400
Received: by mail-qt1-f194.google.com with SMTP id c25-v6so6146541qtp.6
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ANeznX0lp5d9NlWDDlAsdKM+75WpkJ49Ux0qD1evMCM=;
        b=G+jIjuh1F0ReR+rc4SULRsAqiSLqm/f5loGvH9R+Y6G7i/xM/rAzVgrH0bRr5+Ca+K
         frX2RNhco+1YL4e6D5WkXfb3WWvckAXvIn3VpS7ttsAYPEGpFHUuGz8dgzRpN/zzm6ce
         UmE5V6GeUt9m2C5DBCrVVvS33Dk7W61AYV/BUaPVMG5hHwI3SubpyMinKnGAjgPSodGE
         gNVXbOvPV9V1XjTXiOJ0W8LlSamjEuE0xGH0OKk8+ppLuL7SLtPdpCI2L4iEOushS8Ix
         fdroiFe68ZTJXdinO9QPrVpU55Y86e4bmirSCoosfW22Z8k/5b/EpCObuVK3sDre5op4
         8deQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ANeznX0lp5d9NlWDDlAsdKM+75WpkJ49Ux0qD1evMCM=;
        b=qAwJwE2tq9NGu/IcGJ/BRjMMrRuaAWim440IeZ+UR7aMBhsSxPIER5af39vOB3N3jh
         33UkrPFEk5jaM80cdLcUIcE7t1WgqVvQOBGJyQU9FQjJjzFsMXQXpD+F192lpybqGzQf
         5DtJdQoEXUSwhsghPYzFV1BM7QrX39BIQaEdgLV3XEygLNhogVnS9n/+cLPOtf44uRLs
         m6rn8mw6bLc3vtvP/mXG3JjN0ziZjapxmPBkNugTkr/Ny8BEml7xZPZrqXN9e2Dp3TAX
         hOgqK9vkNgXNL8WplMc6Yw0cKrdBy+Ew3Jb8/hkRRJHmE+nNS2fi2xAHbpfNj8be8GLv
         snjg==
X-Gm-Message-State: ABuFfohLfbLGRUru+w+XSAJPm0d7qQCClngQQbdg7tNnkHoS6+5uYc/b
        V+/MtODm74Z1glFHur6pFeQ4DN8WQ9U=
X-Google-Smtp-Source: ACcGV63e+BL5BVKUaRLcviAjn+IjSpdlbYM9vZj/h4Pvbe1yFUsDXZPtVxEPNSKzTNk5WZMzfdH8Zg==
X-Received: by 2002:a05:6214:46:: with SMTP id c6mr3092417qvr.128.1538133573576;
        Fri, 28 Sep 2018 04:19:33 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c47-v6sm2958505qtd.70.2018.09.28.04.19.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:32 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 37/42] btrfs: wakeup cleaner thread when adding delayed iput
Date:   Fri, 28 Sep 2018 07:18:16 -0400
Message-Id: <20180928111821.24376-38-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The cleaner thread usually takes care of delayed iputs, with the
exception of the btrfs_end_transaction_throttle path.  The cleaner
thread only gets woken up every 30 seconds, so instead wake it up to do
it's work so that we can free up that space as quickly as possible.

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

