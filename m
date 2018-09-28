Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5266C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4FFF215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DYvsiw7W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4FFF215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbeI1RmP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:15 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34735 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1RmP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:15 -0400
Received: by mail-qt1-f195.google.com with SMTP id x23-v6so6181483qtr.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=plAorLc8fDr39W0E6gJzb3bU7gor3NEIbpaym2AY9dc=;
        b=DYvsiw7WBddLcuzMn6MM151tKY2mru/yxknTU8OaWobGouaAXjjCK3n6A+aHFp2FMG
         Qfkq+vwF+05GYdRimHfl/uH3WXkRYinAML95RnZ5Ur4PHoDGAzVkCwHEjf6hjKRd/WHI
         3qxrFvFjwJG7LYZ4FCsyjFgg5XQrmSaF5T/UKuB6DcyvGHSIxNRPJxq351gTm5PzpzgD
         6brXg21iPyvoTy1LblKb95CHPHdKmeNl1ivIIFRqNmfRhObT1wQCaq5rF/8iMAHVK4wT
         4OjQw8s4mTwjvJTP/wwa0DGmoNMb+Ddsi22eGvtEbnIOhc6+DD0UoghOGgHwFETF7Beu
         FJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=plAorLc8fDr39W0E6gJzb3bU7gor3NEIbpaym2AY9dc=;
        b=WJpYOrLRiSoKCIH/yFBvlCu0ady3vhuDliea67C/ovpMsG35eVLN0RCNO/cO1aqmGl
         SnhUv7rZvofmf6LoaHAhPA9Pf6r09o0FaAjzbv8FFaRnqf0v1/onbcQ/eRO9TCaAEhWg
         X7IriQJDjtsl7729qlEUmn8RBrL2R2LeHqm/anDXhyI7m6DVAXgXiBIP5Oy9eUb1LJCE
         bD/pMzCJE9LWjr9+d9xbHQW5YO4ItRWk49YZvPFabfs3L+QscjICUhgc99FZ4MCEm4ld
         eILguPEtrOEl+XlxhZcglPBraQHdGHpDiwOVEaY22W4MH9TUSREv7wXekTRT7Qb5Qqf7
         Y1Zg==
X-Gm-Message-State: ABuFfohF/6kyEU8d60ft3ncnxFkoUMEOq9tPi4kNGeJokb+d4hcgiqDm
        qMM7XyqduzX3Z/G72ADvpT+y5A==
X-Google-Smtp-Source: ACcGV62+kUT27Z6X+Nt3vQU2cl4vsUa3MTyB2JRq4F0qUKtKluq9tso8wH1Ytt+0JyO1ReDaezQqYg==
X-Received: by 2002:aed:3b97:: with SMTP id r23-v6mr11857892qte.77.1538133536928;
        Fri, 28 Sep 2018 04:18:56 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m6-v6sm242906qta.50.2018.09.28.04.18.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:56 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 17/42] btrfs: run delayed iputs before committing
Date:   Fri, 28 Sep 2018 07:17:56 -0400
Message-Id: <20180928111821.24376-18-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Delayed iputs means we can have final iputs of deleted inodes in the
queue, which could potentially generate a lot of pinned space that could
be free'd.  So before we decide to commit the transaction for ENOPSC
reasons, run the delayed iputs so that any potential space is free'd up.
If there is and we freed enough we can then commit the transaction and
potentially be able to make our reservation.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 461b8076928b..eb64b28196b8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4823,6 +4823,15 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	if (!bytes)
 		return 0;
 
+	/*
+	 * If we have pending delayed iputs then we could free up a bunch of
+	 * pinned space, so make sure we run the iputs before we do our pinned
+	 * bytes check below.
+	 */
+	mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
+	btrfs_run_delayed_iputs(fs_info);
+	mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
+
 	trans = btrfs_join_transaction(fs_info->extent_root);
 	if (IS_ERR(trans))
 		return -ENOSPC;
-- 
2.14.3

