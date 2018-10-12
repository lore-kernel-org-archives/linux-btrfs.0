Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF34C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 252FA2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="hhQw7Se9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 252FA2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbeJMDHl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39777 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbeJMDHj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:39 -0400
Received: by mail-qt1-f195.google.com with SMTP id e22-v6so15072445qto.6
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=2w+WsPjL8r93Nw50uJe/lUsSq3OzjnbW2tYS17GINdo=;
        b=hhQw7Se96f1p4VOc1r9EdzOg4KBxP4LHpXyoYWaLT7lSJwmED/rJAynkWaE294Aegj
         lITxhCN4MNX8n+uZjBJUMDHgUwb1l9D3lib/awxO4ZJl/yWbo4NrbinjrCWX2GtD36zz
         p9BYyscRhUxVIXoJagyocQl+aD/OtzpUtIDGEifnoxX1cSy3OxS/V3xCWW3+DqV0r/HD
         RgUqtkPJZiFju+8ZqZBq8NOdGB2R9httDoFtgKu0235nO4xcBFKBdn7rWiYpKkpbwGkV
         OuQ8ibYQbXfdXAI0bJlPPAP3ppOMTe4g6Id28O57lKBl0IDTatMdL4Lpw3BBa7EeZHXF
         LR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=2w+WsPjL8r93Nw50uJe/lUsSq3OzjnbW2tYS17GINdo=;
        b=rIHW/DXvHPYtD1T5qB2Q5HVSOiDs82w1AJ3vOXNJy49BmJWEeoDtDzCAkJLIt65vmz
         Urq3ZlCdNoD80LxUKapownTe6p8/dIPEhkr+/MI/Ij0R4jVK4nC2iPIsL0Ik+OkbP8ui
         XyVQZaYJvCNSPIbfTA0tWYC1zfTKt1s6Sq51+vMSmNnoz5R4BB3Bxm0s+ICvf80DTrsN
         ptzw6To8NMmPSyNJchq+xq7wm3sl+AaEdLScKfhusUMCISz0v4YZ0tba1XozNmuwyseA
         OSU+K/9lkj2gQSLOmTPSFgxhslzm5gh3N1E/SXbHUOTfmYbaslvIigscednJyQZEB0YD
         7T9w==
X-Gm-Message-State: ABuFfoi2VSLmah3ilBpstXvWj2N77pz4R0LwcHlaY7ucJ+jwE+ATlakA
        J5TF2G/x5MowVNnu1HAIMG5OPLeyv9U=
X-Google-Smtp-Source: ACcGV62BOG5DUNHqLMvqHS1gYB3bdjO52svtVrMu8I+36bBLSw3F2zlkL6EEm15lhzwrgrsqiHscbA==
X-Received: by 2002:ac8:46da:: with SMTP id h26-v6mr7124015qto.369.1539372818368;
        Fri, 12 Oct 2018 12:33:38 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w17-v6sm1602437qth.47.2018.10.12.12.33.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:37 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 17/42] btrfs: run delayed iputs before committing
Date:   Fri, 12 Oct 2018 15:32:31 -0400
Message-Id: <20181012193256.13735-18-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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
index 3757ca42b8e0..ef852d1911d1 100644
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
 		return PTR_ERR(trans);
-- 
2.14.3

