Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22A3C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83B41215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="NV4v21Y2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83B41215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbeI1Rmb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39354 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1Rmb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id c25-v6so6145707qtp.6
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=X+PT81/Zp3zcYtUcLLi8M0fbP5w87s6IcVZs1kVoVUA=;
        b=NV4v21Y2b3kHq4kkKPvlC/HvRP7dcCk5/lM4olHWJqicPfAvk4YlW5W+vwEExSSn+U
         9Klw3yT2SpKHOPvpq7eOsZUbrcVFTg78Q67bskkB25pijXy745SrlYGnQgyz1dVds6fc
         q2ICyVysqVjA5GGnwH8+ZFEaDbh3mbSG7HdWOzHoaQhIOqgHNwnbokDSy1v/njASGI6e
         EkDnHMZiRqHym76IdGbzBd+qfF9lMEzK2LgbmpbmyEZuZPULvyjkPAL+ketPWEy5wS9x
         rZM33NI9CqQhc3WSRY/pZQvofpUHefymIrpvTcgq/mj0JNnEieIgr58LGTMBqrOjJDLO
         Pv1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=X+PT81/Zp3zcYtUcLLi8M0fbP5w87s6IcVZs1kVoVUA=;
        b=SCgKSMzaKpTc50OhjdN5ugYp14GQ01+TqDo2Owstb5QtI6ipoWG6JmxL5NUaEKLSEm
         838eOHQZEQGgejlqGQSuyUbHOggVBGHS/mlTdvnIVz7iEQ1k2AIvb3IGnAqhRvUy6Jq8
         dFNicOChIfIH2exNuz15Vlf22kEqqJgrqvRyRqO2/Vnyf8cMIdvlFg5Un8bDlwdjk7Du
         qkrNeya3olqh4d6XwbsPt+xfqIpYySTkxvQ+ZYgpW+RUftFi8fWo/wWI9Mx7GK1K4189
         Y+mtuRiqLKWdbrLqOoBHM5raINpLsBRRQiOtVEEoaEtkYrnZVwDpQSH4yRE7dDra8X97
         bKUA==
X-Gm-Message-State: ABuFfojIaKmHGd6Hw878xfsazBFFkr6AecIl2fjYN/riGLqTtceppIaX
        lwYZXPKbVmoiR1bI8AYP8o1UeKH8bZM=
X-Google-Smtp-Source: ACcGV619t5wDGk18XGmTPD80PIF5VY5Br8iF9/rHCYFPTwct07QOPYzTrYr+c5w8+PyUsnIjpIhmCA==
X-Received: by 2002:ac8:1793:: with SMTP id o19-v6mr11941511qtj.98.1538133553176;
        Fri, 28 Sep 2018 04:19:13 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id e29-v6sm3092790qte.47.2018.09.28.04.19.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:12 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 26/42] btrfs: make btrfs_destroy_delayed_refs use btrfs_delayed_ref_lock
Date:   Fri, 28 Sep 2018 07:18:05 -0400
Message-Id: <20180928111821.24376-27-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have this open coded in btrfs_destroy_delayed_refs, use the helper
instead.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 39bd158466cd..121ab180a78a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4214,16 +4214,9 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 		head = rb_entry(node, struct btrfs_delayed_ref_head,
 				href_node);
-		if (!mutex_trylock(&head->mutex)) {
-			refcount_inc(&head->refs);
-			spin_unlock(&delayed_refs->lock);
-
-			mutex_lock(&head->mutex);
-			mutex_unlock(&head->mutex);
-			btrfs_put_delayed_ref_head(head);
-			spin_lock(&delayed_refs->lock);
+		if (btrfs_delayed_ref_lock(delayed_refs, head))
 			continue;
-		}
+
 		spin_lock(&head->lock);
 		while ((n = rb_first(&head->ref_tree)) != NULL) {
 			ref = rb_entry(n, struct btrfs_delayed_ref_node,
-- 
2.14.3

