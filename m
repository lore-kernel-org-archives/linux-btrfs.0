Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A5DC04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E294B214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Qkpr8BD8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E294B214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbeKVFey (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:34:54 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:46932 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731406AbeKVFey (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:34:54 -0500
Received: by mail-yb1-f196.google.com with SMTP id i17-v6so2619270ybp.13
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 10:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sIdIZc1l6sbHZydB4J7nWNiolZK5nlGKOxC60n5ngnE=;
        b=Qkpr8BD8uqPav+1oWTiODt9xgzx2ryVX3axdBDqr8MaSJR5Wflvyma80pnLF9wLT1B
         Pljr6LL3Zo20NgEiYxexbeczPrUcyjRMDxbiQH8yr82KLY0JnKLM15rLX/zNP36HBART
         JzvDiv2a7O++XgCNOGgk+Mdc6zH/S78bHiO+TTe2qOKCM1cKHqnKx7Cn8VPduaPKYLUi
         Nqz5dE2MBRgNewRrmgqSTGQRqdh72YyRSMixu+FdqJ4PDxKMk+5iZg3+ks40dfWt1T7W
         Bm/hZgANnl+LwiAWdNWJI3EhATudTeslQCHKYJzVGaFKfc/YYEiXsPDQkelLoPNIrR6t
         bJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sIdIZc1l6sbHZydB4J7nWNiolZK5nlGKOxC60n5ngnE=;
        b=kIxi9x5eY0UjpJk8ZJNgTHNwZBboSi+DIWrKrqINd+dJUEC+sZ+95qcRKQQF/3dwya
         NmGdjUX3MjtX0kHC8RGAC3sQ+bwuvQbtUiHoAvMjlQIdeigGsRobvahXIRVJtO2hEJq8
         oR5IrmCn9xzOCr8CxIfb0a5cp+Cq8Nr1cR/ZDv0lJ+XOoEFJPUlW/QPiWFpooo1J0EZ5
         a/XuOcqwaXIJ7WE2040697mLtg1ALztcWo8vwLF6x2Xw2gilReOvQi3/7I59NmXdvbao
         LVvWnO3Xjr/Ik1Uh1QxsxDns3hoeDMH87whCqP1/YPDI/0XTM3WeTqS/5hMoueEcLZFs
         n2/A==
X-Gm-Message-State: AA+aEWY1z/zaLU5a+2GIhyc9tSnbdaOTrpUceMZt1VeHRg59x9cMikyB
        5kekcPRURBK+WGgF1F6h7TglMXnGCpw=
X-Google-Smtp-Source: AFSGD/UUdNcBOBMNbUBdXfQf4t0cY4JBHxHFmzYqAIKu9xi/PAub62+Cg/A2ziO/fst5vA4AMZQ8AQ==
X-Received: by 2002:a25:8507:: with SMTP id w7-v6mr7725608ybk.390.1542826762434;
        Wed, 21 Nov 2018 10:59:22 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id d85sm2414638ywd.22.2018.11.21.10.59.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 10:59:21 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 4/6] btrfs: only track ref_heads in delayed_ref_updates
Date:   Wed, 21 Nov 2018 13:59:10 -0500
Message-Id: <20181121185912.24288-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121185912.24288-1-josef@toxicpanda.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

We use this number to figure out how many delayed refs to run, but
__btrfs_run_delayed_refs really only checks every time we need a new
delayed ref head, so we always run at least one ref head completely no
matter what the number of items on it.  Fix the accounting to only be
adjusted when we add/remove a ref head.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index b3e4c9fcb664..48725fa757a3 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -251,8 +251,6 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
 	atomic_dec(&delayed_refs->num_entries);
-	if (trans->delayed_ref_updates)
-		trans->delayed_ref_updates--;
 }
 
 static bool merge_ref(struct btrfs_trans_handle *trans,
@@ -467,7 +465,6 @@ static int insert_delayed_ref(struct btrfs_trans_handle *trans,
 	if (ref->action == BTRFS_ADD_DELAYED_REF)
 		list_add_tail(&ref->add_list, &href->ref_add_list);
 	atomic_inc(&root->num_entries);
-	trans->delayed_ref_updates++;
 	spin_unlock(&href->lock);
 	return ret;
 }
-- 
2.14.3

