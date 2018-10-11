Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F60C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 395BB20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="PezPKDiO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 395BB20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbeJLDYW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:22 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40085 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbeJLDYW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id b4-v6so11332737qtc.7
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=xTZQcRzq0IzMsRcNbawv7mMyVU41r6nyXAFW5TJVAig=;
        b=PezPKDiOFOkTFR+xmFUjKxEKK3jL1aZoJKN9ps+QCnV1HxZfiJluJ/40fiWCw6H6US
         rTAzTfZtuFvkMW/JbH5+bPVCfkrmvGbx0GhGCfZlcIxAJocJ1U3UEylIFtVn41MEzukL
         80EZ5AeMhcLhtGmRybEB6rq6loXGxAVWJBnwoS4J9dOhb+ff9mELiFR3niWqWdhmX7VF
         pLBcQAdUtOkLbZUjiomNxgNEtt8KC8sqfKgTkEhyQP15rVnpaAjWygs1HnTd+fFbNEUl
         af0rwnAW5neMDZ3lb/BkND1D1v2nr4WdBVVCyLzKMumQscQ8dT4pJmWdGp1pUJkwfaEd
         agWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=xTZQcRzq0IzMsRcNbawv7mMyVU41r6nyXAFW5TJVAig=;
        b=l9P7QaOUwJItXjQr9YX8U64ThLKskzl+vzqQV8nxLV4EqWNvtPCGCMOo5qIY3lLYqa
         uxFLi5Q99KTAqA6nkrOJNwJRGMfTcxwPNJF8oplOrnjTLmcsN36sg6hAimrO0xYMq7Z3
         0Kb83RNdCPnRM9fu4Mwvbe4rFoTB0qtnYuQnCdw5p2W9roQiutraGoL5JSXGb1MjSKHQ
         mKuKJpEEx4s4Plrb9LYH7+N3p9cHSI+hLq5FAeAhVrj09TlM1Ta94BMDo+mPzSu03woK
         pKKVEoC8jOX1OUF6hDk/iOdrJSJOpoe8XVwgT+1ZPWSofbW4JRp6fkU3pj7euRsqJ5Je
         By4g==
X-Gm-Message-State: ABuFfohu0UBm/znhgzJ9g4n03oTfSPa5iwdJgKaOFqSto/8S0fFVFU5z
        8B1o56rrNQdNhotUO4liNYuyrg==
X-Google-Smtp-Source: ACcGV62FPEWgnCaiO5lWNXprm0bQAsoaIN3QxW0JDDsS8FWwakddKQ6V4vrqgpzZxXTHMlVaETqfhg==
X-Received: by 2002:ac8:34bc:: with SMTP id w57-v6mr3002914qtb.239.1539287735563;
        Thu, 11 Oct 2018 12:55:35 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id k1-v6sm14538356qte.76.2018.10.11.12.55.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:34 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 33/42] btrfs: fix insert_reserved error handling
Date:   Thu, 11 Oct 2018 15:54:22 -0400
Message-Id: <20181011195431.3441-34-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We were not handling the reserved byte accounting properly for data
references.  Metadata was fine, if it errored out the error paths would
free the bytes_reserved count and pin the extent, but it even missed one
of the error cases.  So instead move this handling up into
run_one_delayed_ref so we are sure that both cases are properly cleaned
up in case of a transaction abort.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7e66a6351aad..6174d1b7875b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2405,6 +2405,9 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 					   insert_reserved);
 	else
 		BUG();
+	if (ret && insert_reserved)
+		btrfs_pin_extent(trans->fs_info, node->bytenr,
+				 node->num_bytes, 1);
 	return ret;
 }
 
@@ -8257,21 +8260,14 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	}
 
 	path = btrfs_alloc_path();
-	if (!path) {
-		btrfs_free_and_pin_reserved_extent(fs_info,
-						   extent_key.objectid,
-						   fs_info->nodesize);
+	if (!path)
 		return -ENOMEM;
-	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      &extent_key, size);
 	if (ret) {
 		btrfs_free_path(path);
-		btrfs_free_and_pin_reserved_extent(fs_info,
-						   extent_key.objectid,
-						   fs_info->nodesize);
 		return ret;
 	}
 
-- 
2.14.3

