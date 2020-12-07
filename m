Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131D7C433FE
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E61235DD
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgLGN7l (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgLGN7g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2020 08:59:36 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B943C0613D0
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Dec 2020 05:58:36 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id w79so1461027qkb.5
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2020 05:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yQW5HdN7qO3+mPtg3gOgxaceIpJN+421WcNEAltwLCs=;
        b=dmDcNrAM6eijtIxXmQJPlIvZcreX8SgJ3US2c2/BvZ15LdyM2GZhoGyx67OKFud1Jc
         3safcTJCXe/OZSTPxmSptvT84AtZIHQ1rKNxahFlih5OfGFEsm9baf9OtqtnXrQHtxDQ
         vDY3vjo5Zan6LFugL6Pe/bF/7A0PnEWqUtWjXqE9MX/6iCRAUjWsp/3/8IRzGzmFJsz2
         eN5tLojXV2SmMco13T4YQQZQL7zNNZpLxGwXGBVpaWlqp9m8hFyM6sDpq4qZwEpVNE1Y
         O1tNcDPvjGtkOaLdpr3CsjYiNqiUUda34yYUuCewYveBgTIrnqvGu3eVytGcenbNdTEB
         gbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yQW5HdN7qO3+mPtg3gOgxaceIpJN+421WcNEAltwLCs=;
        b=jg/uRFo88gpfgEqS7S33LXG/0vrA9HhbLes3tKc4AAUc4NRUl/aCYt70a3cHKch0eT
         HMOee9nyGgN1xLI0TGvwYzLI3jXtlWtHFKUR3b/SpXKtVS8+YG7HDtVWaiutVOtj5TeW
         BzApTPeiu1bCEVXl+w815YDuvOyCt59G6WOUbUobQtPWT1bG5ptN7gdUd/3kAw9+iy0d
         4yBfRWPKP0OYSI1bop0hUk1r7/7+d/E9No1/f7c1Vp4+qqD27dYpitwfeP2wa35HT1YN
         4eUtHxy5kEdVJst1emW6pM3uTyx8BimiYMImrMUpODW2s0dWaN2WSpcu7KnnhaY1tcxw
         yFfg==
X-Gm-Message-State: AOAM533fLJJTb5pItSKv4UZHgKdgKJ3+kj5+thma9xZ47o9xrmcSvSom
        yrLRQ+MPKA4Dploy4cIXR1o6C7PQ0n7lqeyW
X-Google-Smtp-Source: ABdhPJz2TYj/Tp5WU7R0w0Kg2+dsUCsCxkWek6bQrrYZ8aVUfI1Q0ecOz4OsWt+CV5TsUVSQaRMVMQ==
X-Received: by 2002:a05:620a:40d6:: with SMTP id g22mr24441818qko.232.1607349514994;
        Mon, 07 Dec 2020 05:58:34 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id v28sm11610951qkj.103.2020.12.07.05.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 05:58:34 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 25/52] btrfs: handle record_root_in_trans failure in btrfs_record_root_in_trans
Date:   Mon,  7 Dec 2020 08:57:17 -0500
Message-Id: <33f8d3602329758f97b85efc4b705daf115f4922.1607349282.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1607349281.git.josef@toxicpanda.com>
References: <cover.1607349281.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

record_root_in_trans can fail currently, handle this failure properly.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index db676d99b098..087d919de9fb 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -480,6 +480,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	int ret;
 
 	if (!test_bit(BTRFS_ROOT_SHAREABLE, &root->state))
 		return 0;
@@ -494,10 +495,10 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 		return 0;
 
 	mutex_lock(&fs_info->reloc_mutex);
-	record_root_in_trans(trans, root, 0);
+	ret = record_root_in_trans(trans, root, 0);
 	mutex_unlock(&fs_info->reloc_mutex);
 
-	return 0;
+	return ret;
 }
 
 static inline int is_transaction_blocked(struct btrfs_transaction *trans)
-- 
2.26.2

