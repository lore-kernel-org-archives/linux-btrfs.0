Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836FEC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE2E214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:03:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="z0ynNR5Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BE2E214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731991AbeKVFiu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:38:50 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38546 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFiu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:38:50 -0500
Received: by mail-yw1-f67.google.com with SMTP id i20so2674384ywc.5
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=MesUQs5u+SrETuFsSQYzz/T/gOSJTHUwBA8nUlPdLvM=;
        b=z0ynNR5ZZOKRecLlXBBYCGuz4NKaY41uAvfB/K3MaomEE2fCXowH0JQ7EYAISbZXO4
         QQ9oNwxdddSJNn5g5Dl4yop9GKJy/OL97zzOrqU4V3/mCMQyyA4X6fJdN1LvOGxuIA5y
         elzKBudE+Z8zkKPA8xeYRE9pqJYym8FHgVK0NqUM0mnxLWI1bUKbasmh8cdBRg4TExir
         x/JzCRDSdJ4JTU9HSrbarp8IFY12+CZ0wkrbXWPBJLo8bfM5mWx83mGwaPUkany0iHI/
         6/cCMVq/DC7sfWUsvatjipBLTl6JqypsLuPVoAPLUD+s0knYctUdgHw58Cp/hgUgD/bp
         +G9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=MesUQs5u+SrETuFsSQYzz/T/gOSJTHUwBA8nUlPdLvM=;
        b=ZWtBX8tcbptDP+l3JSfDDl3C+w+VBds+Fo0VmTA9KtRe9HY39EOUsGejdMYFg5hv+c
         e8HiVOyo1zZiIQbdIPrNGAAOCLEdUb0zq+jY0jTVmYlmcR7tglolB+65C9astJ6gW5jl
         i4S655YWeeY8SgmGEYSGMfKH70Ri3C6XzBVSHblHZI7lQzNbXZUTp6zajX4tyusM0lGv
         9OiGRz083EHhV/ACWo9k0/aJ/OKv7k7Aa2cyRSrhk321brfBs5jV7cfGe7oI1pXWOHVL
         EDL+6E2gcQxJyI5amAh5T6zicl/CKKJyz7FlXeNPRcu6doA8XTmChQuBN4KjexOgPtN7
         j5yw==
X-Gm-Message-State: AGRZ1gKJl9MreraoyM/qv3fZB7EJyPh6FJHpLpb31cN8Uc1SzlBWeCIe
        oGF+NZhb4VDgm/A0atg6BpsjZ8IVnmc=
X-Google-Smtp-Source: AJdET5foPP6ifynTJVwPnaPLxYk/XqzpGCNJDj7Gjt2wSQWiAfJPiJBBMOI3UsDOdaMTZNe8CexOTg==
X-Received: by 2002:a81:1417:: with SMTP id 23-v6mr7698979ywu.201.1542826997950;
        Wed, 21 Nov 2018 11:03:17 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i8-v6sm8916838ywa.106.2018.11.21.11.03.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:03:17 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/8] btrfs: check if free bgs for commit
Date:   Wed, 21 Nov 2018 14:03:06 -0500
Message-Id: <20181121190313.24575-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190313.24575-1-josef@toxicpanda.com>
References: <20181121190313.24575-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

may_commit_transaction will skip committing the transaction if we don't
have enough pinned space or if we're trying to find space for a SYSTEM
chunk.  However if we have pending free block groups in this transaction
we still want to commit as we may be able to allocate a chunk to make
our reservation.  So instead of just returning ENOSPC, check if we have
free block groups pending, and if so commit the transaction to allow us
to use that free space.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8af68b13fa27..0dca250dc02e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4843,10 +4843,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	if (!bytes)
 		return 0;
 
-	/* See if there is enough pinned space to make this reservation */
-	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
+	trans = btrfs_join_transaction(fs_info->extent_root);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	/*
+	 * See if there is enough pinned space to make this reservation, or if
+	 * we have bg's that are going to be freed, allowing us to possibly do a
+	 * chunk allocation the next loop through.
+	 */
+	if (test_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags) ||
+	    __percpu_counter_compare(&space_info->total_bytes_pinned, bytes,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
 		goto commit;
 
 	/*
@@ -4854,7 +4862,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	 * this reservation.
 	 */
 	if (space_info != delayed_rsv->space_info)
-		return -ENOSPC;
+		goto enospc;
 
 	spin_lock(&delayed_rsv->lock);
 	reclaim_bytes += delayed_rsv->reserved;
@@ -4868,17 +4876,14 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	bytes -= reclaim_bytes;
 
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
-		return -ENOSPC;
-	}
-
+				     bytes,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0)
+		goto enospc;
 commit:
-	trans = btrfs_join_transaction(fs_info->extent_root);
-	if (IS_ERR(trans))
-		return -ENOSPC;
-
 	return btrfs_commit_transaction(trans);
+enospc:
+	btrfs_end_transaction(trans);
+	return -ENOSPC;
 }
 
 /*
-- 
2.14.3

