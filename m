Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F31C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C440206BB
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="eehgDoqG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C440206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbeKVFpA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:45:00 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39164 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730026AbeKVFo7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:44:59 -0500
Received: by mail-yb1-f195.google.com with SMTP id w17-v6so2641858ybl.6
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Hrc6yDqnzsTpE+Nk+dV4bO+PSKpX5EQ8RMs+u1JoiUc=;
        b=eehgDoqGpD/9rimYrqvlzXRUvTD5fkn68i8MpsaWjA6dkeeRjy+kDgK26kFknJai7Y
         7m9pEy1QkInVv/FQEte94jp0v+mHLwieqDxuHfW8qefzHw15jtHvG16pqCo+qoljT40W
         2qrgY4fxju0CQiny0ercckpQsmnTn0dGynsICJUfPhc/kp2wthCJ/gi6mvkMTEq2asgH
         W5z1AmXuuTZLqWFlf6NhikQqwVsRoDFUKsw9+VV9ZBMkUdnFxpSzNMWsZC9J2PzETe10
         0DCTzRSpjJn4QwGWlo5ieBUTOQAiijKqPpz687nA/ZxNnikY0GFCYEA+waxq5eox8ZiP
         WuIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Hrc6yDqnzsTpE+Nk+dV4bO+PSKpX5EQ8RMs+u1JoiUc=;
        b=ccHpRmp6rcnWqyvuNkUlrZVlNrlfA3YT62n3tE62gqpzgQO/cY4OWvI4egCCe5epAM
         oShmroN84QGgsNesJaHIGphytKaNbRzLU/EKgG5I97pzTqpcX2wvnMeH+B/i1uesUpdD
         HhniAm+Dyy1aC3HJ/RvZWWqeKpAnjzNFNiRsRw9jgn/XjA+WQIFirGeFFuHY3WQTz5ku
         ycYl6iJK9IcyGiCFQUnVLwEJ7D4Am1OGgByEAIlTzotr6uQB8Piiy2MCuSP4KMC/mnid
         KjYcuExZN7WRxWkbof+viY3KSMx4T+62yvjbuxBBeD7i95A+YpTJ3/BhWChoQycx06Zj
         tD/g==
X-Gm-Message-State: AGRZ1gLXLQhoLGGn4FFNdWpTqpQxspFTiNWNqvkhJuN1lt4xfjaiAYmq
        CN/ITf9kY6wrVst5gLvB6fqSD378sXI=
X-Google-Smtp-Source: AFSGD/WBQxCjN69UAh9EyJGPDz3bAs29ctQQjyOXS+i+vb/TcnA6aLMDtnOJR08vqZ6T2GqV/Eg3WA==
X-Received: by 2002:a25:3c81:: with SMTP id j123-v6mr7621946yba.250.1542827365805;
        Wed, 21 Nov 2018 11:09:25 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id b144sm13350452ywa.33.2018.11.21.11.09.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:09:25 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/3] btrfs: run delayed iputs before committing
Date:   Wed, 21 Nov 2018 14:09:20 -0500
Message-Id: <20181121190922.25038-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190922.25038-1-josef@toxicpanda.com>
References: <20181121190922.25038-1-josef@toxicpanda.com>
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
index 90423b6749b7..3a90dc1d6b31 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4833,6 +4833,15 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
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
 		return PTR_ERR(trans);
-- 
2.14.3

