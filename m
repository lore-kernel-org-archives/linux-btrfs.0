Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01F1C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 964EF20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="SuiUPlfB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 964EF20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbeJLDXw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:52 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39994 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDXw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:52 -0400
Received: by mail-qt1-f196.google.com with SMTP id b4-v6so11330708qtc.7
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=3KmYan+SJv1KntXTmAyylbTgpGl4Ql82kSHN+uqa4Eo=;
        b=SuiUPlfBWbGFt4P0yJzdOZU5PF3l7QQY7g5KVTlK48wEC87hV3TCaRgtJxT2qexOaL
         WfJyp64v+8AbiKt9e2gt5g53PC34mrGSI69Rw1CWTf03348iJ/noDp7xtONdJ/vmG56L
         4pGtL/G/3Xt+KEWJGNdDt41jF36BkP2wrgxdAZhSjnjWcwOydIHCqFsqwlXLCvO8de3T
         jZdNM5b+D8K/+LVCC7ceG6sR6YTCYk9gVzGn5LeC0zaQlIXH/ELuZzJI7xl3LN0kfrcM
         5WwyZ9IyMcg/lzAhvI/64Aj7Qna4dFEqosrJle7Srdrm3gpVqJXvceP6baxyx+sIop/z
         S+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=3KmYan+SJv1KntXTmAyylbTgpGl4Ql82kSHN+uqa4Eo=;
        b=evDoZGIte39qCNhsqpxeddONzJ1OZYyRLxZJFRyz/QB53mxiwTwxvqTdvk9BILrmyE
         /exIjxuK5mXM1Sxq1U3NIKtZujxKyqMhr2GwdawPI7ABKtH3/JkAbjugxeUkzREIJEMN
         JLQjeBplKLUol4SWZAV3R7db/bogtUnxFkN+bS9urblKMkUqRnYFXTHUtUMYHXSTG3TA
         1Z9RAS4YdzP0GBJwkYbFElBC8q8pMXQWH2Vw3vZQpJFNbUXaz/oNoeA60GS32dp8mrb5
         RcUqII6gddAEsxfGH/hClgWjRIWQESoQA6Zn9UNqUZ7FtXUIGaMU2dGnliAtc7YRR6RI
         C2nA==
X-Gm-Message-State: ABuFfoh4L5KC9sknIyBg+Ws3vDY2H9kG7bpIMcOqOygRUrTdVmK2Q/Uj
        9Bh+qNzd8MLYGWcF1AEYDIM0j0t3+9Q=
X-Google-Smtp-Source: ACcGV62ImT7Lg7cDkc+mZUrQtw6HI+fbI5/2eQ/m49UMgoemMi2xl4odauJsxFU1dnPNM0KdX8z84g==
X-Received: by 2002:ac8:427:: with SMTP id v39-v6mr2954080qtg.59.1539287706266;
        Thu, 11 Oct 2018 12:55:06 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m54-v6sm11452976qtb.97.2018.10.11.12.55.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:05 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 17/42] btrfs: run delayed iputs before committing
Date:   Thu, 11 Oct 2018 15:54:06 -0400
Message-Id: <20181011195431.3441-18-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 3aba96442472..6e7bc3197737 100644
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

