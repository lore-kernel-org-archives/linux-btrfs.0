Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63974C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E27215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ec/MB5Li"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25E27215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbeI1Rmd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:33 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39356 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1Rmd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:33 -0400
Received: by mail-qt1-f193.google.com with SMTP id c25-v6so6145762qtp.6
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=cvSqJmOxERWLztXjenJ/CRRumlDa3ZymappVew1ga8M=;
        b=ec/MB5LieKBlAkYByyUs5658fGHiSbkKfgPaAHg8WFpxWJaRiD0yL9lkBYvSQboL3D
         Ga0YFNkRoUfrSIUPpHJY0xHi3hROGeNIhmmLu7pLYwr0+kJPp3Mii4XM+CT5e9ChzVYH
         UNjlmy9WfOsfoTa1+0Qobx37D0Y8KjGj/Ueb2ORuvrGUGIRPbwislzRtUgJRa7tokLiL
         Qc0EaMTWC4gCLXMfQKpMd8pmbtNqYlqnNskOm/es96JLjHKHRHwqch4OFwTvUlSqSq1M
         48Tx+M9TD9dyA2GqhVXYxy4O2DnhTv+S8n0FJ74lKdEcMRco7fx6jdZiFfQmN2zQSUfo
         pa/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=cvSqJmOxERWLztXjenJ/CRRumlDa3ZymappVew1ga8M=;
        b=g7shYies4juhESjhwwfpH6gePLGjARQyLhiL3fvYLOzhIr+I5OVSU63YT74Wu+hKPW
         wnltsvAIozijmNo1nfBYM/UaTfPaW7fd/j+4IbvNn44tGr1I7vhxP7nsgSgHXpCenJpz
         KKRN9AZzZUh5tR/yMZg2Bd2iUbeMQU4hnkA/aQ7CiPx3p2geR7hjWmtz0clL4GqVrH9+
         dAPeU7Y7LC+H4dga6Z8cOxF6xyHXFLmJISQokb62BdIhTJoVp3Y3HeRffHwZv4TRUY2m
         8xjX9kxNn4rSrcLgC67bzxZ0/EpJx/HFEk1O1mxQt0HodsEAs0bC3lQ7JLhNgxEuGdDG
         Ob4g==
X-Gm-Message-State: ABuFfogRMz+3hraUS4nAIU5+4Die+9tLWApb5vlHnXj5kyfvm5w0UpRb
        +F0uPpCF3zW+w3zkmIK683uxQA==
X-Google-Smtp-Source: ACcGV62JjHZrhVYccC1dlnHJZoORWOcC9mo0MLxwClYOW5qlikf1Y7odyzkYH/8uwcZ42lzvL9Dinw==
X-Received: by 2002:a05:6214:1091:: with SMTP id o17mr4520661qvr.193.1538133555085;
        Fri, 28 Sep 2018 04:19:15 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 14-v6sm47319qke.3.2018.09.28.04.19.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:14 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 27/42] btrfs: make btrfs_destroy_delayed_refs use btrfs_delete_ref_head
Date:   Fri, 28 Sep 2018 07:18:06 -0400
Message-Id: <20180928111821.24376-28-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Instead of open coding this stuff use the helper instead.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 121ab180a78a..fe1f229320ef 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4232,12 +4232,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		if (head->must_insert_reserved)
 			pin_bytes = true;
 		btrfs_free_delayed_extent_op(head->extent_op);
-		delayed_refs->num_heads--;
-		if (head->processing == 0)
-			delayed_refs->num_heads_ready--;
-		atomic_dec(&delayed_refs->num_entries);
-		rb_erase(&head->href_node, &delayed_refs->href_root);
-		RB_CLEAR_NODE(&head->href_node);
+		btrfs_delete_ref_head(delayed_refs, head);
 		spin_unlock(&head->lock);
 		spin_unlock(&delayed_refs->lock);
 		mutex_unlock(&head->mutex);
-- 
2.14.3

