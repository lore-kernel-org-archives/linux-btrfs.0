Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB66C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3E5220835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="JpFhFPSb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3E5220835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbeJLDYK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:10 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:43337 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:09 -0400
Received: by mail-qt1-f173.google.com with SMTP id q41-v6so11336205qtq.10
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=X+PT81/Zp3zcYtUcLLi8M0fbP5w87s6IcVZs1kVoVUA=;
        b=JpFhFPSbLvkIgXUEZk5rcRryuq6R7zg44GGSlm0d3AafpFaqZ3HfNtb+GJ7HdNrp04
         fhfznbSEXItaJK47iFYL3cD5MtAfmkrsN9jl91O8w1flkOOR6JYwihXBrSd0kEXwjW+S
         pg3wqUB03YtPbw6ntjL5Ozp0vBlqsw+0dI1rnDg17tSSGq8GlNV/un2YHDZ+XeLaV7TN
         jVLPCzk9cr4bDm3HCayhfN0wU+5W140bBOkaAlXC8Hd+SfYt6630vJCS7xtefrcuU/bF
         qO3YZIQDJyAlWgeZf8c1vbS8Kt08fGqz021UapLJ5ZlglmZlns+qFYdJbbRqx/l8IFbz
         Mogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=X+PT81/Zp3zcYtUcLLi8M0fbP5w87s6IcVZs1kVoVUA=;
        b=IdcmLCBCGNv+yJits2XsiZcwjbt5N3af16eZuXzyat39Jzx3bItfooam39cfkzCzp+
         eoD9RPMMOCFYihTtaBOJSqA89H5grLrgJkJFpAYbUGcYbx5xRe+Jf+UNmXr2wYuNTjT3
         QiDSVhMaSF2Aemgk8qLyvccnu+s0fO4WOPucXl3GXCberl3tP71yJsY6YZVkPFmRPKn8
         FSptDt+YUjObABog6nYVQ+HzXU0wUL0sJkDc2OlKug4lckT2CIwvcYKyJkZrwx9thTz/
         2aVzkDJ5PialYdRKhspYFZwZnFCacou4H7Lnaj4NmZ44RKVCSX+VRoC+Zl3LnSugY//q
         TbiQ==
X-Gm-Message-State: ABuFfoiQgAMHISKYJfwIDkd0dKYE7PwBNQ85PG64yAcAI109TBJBZK9o
        tdni3zl/wu7fzDD7pYmbXcdBWg==
X-Google-Smtp-Source: ACcGV62Ki5yRZA3PI3vpbkwmuZvVUCIXcXZ0rfDHsGXfTlU9WyXCmApMIwuLKrxRo8B5SFquXEznJw==
X-Received: by 2002:ac8:ec3:: with SMTP id w3-v6mr3024168qti.138.1539287723036;
        Thu, 11 Oct 2018 12:55:23 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id e2-v6sm10869159qkm.55.2018.10.11.12.55.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:22 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 26/42] btrfs: make btrfs_destroy_delayed_refs use btrfs_delayed_ref_lock
Date:   Thu, 11 Oct 2018 15:54:15 -0400
Message-Id: <20181011195431.3441-27-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

