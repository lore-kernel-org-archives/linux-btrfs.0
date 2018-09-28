Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393BEC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE77C215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="dz16+1LR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE77C215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbeI1RmZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39344 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1RmZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id c25-v6so6145483qtp.6
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=N+dz60mOwxy8LSi9HFgdT6MWdMfa3FlIMDFMCSuxx48=;
        b=dz16+1LRQ95OLS0zid0fsAbDlQMCGJF0df2In3q2MRQrzMvVNgfv/aIiklVBotuGd/
         9FcZ8C1RcTHGe7uSnrtICKiEysx0DnODrzJn3ZqMZAqp3uEDTgrnPPDFQ4o58lA4MEY3
         r7hmvR+yH0nZYAvF6jbxiexJl1BgeMDIm7Y3hcC08cxEQ/JD21YNO5b02uqvYTQDY2j1
         2CZ03c3DIacrSXy++rUagl3Hm9Y49Ir0NV7vFGDeA7jEY9i2t0qpqvVjD97apGBq1YyC
         1jTNX1hKqQicg8wxZ6fOkgstnXQvbB8cfKNoR1E83Rk9uPfHypW6cld0YjsgEfPXObzQ
         zSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=N+dz60mOwxy8LSi9HFgdT6MWdMfa3FlIMDFMCSuxx48=;
        b=Munzt0Wk4liraDO+HyvTk58mmRhxAUkNcdBFAARAsdCmg5ynYs76HaR7OxwIU24PUB
         nCcVsk7+n/wnRKpbaKSP1gpe5hsumnzdUchsnWlDFVGNDj5J57H++4OaznfV4xfrgq3K
         19/GF9iAqeWIXOoHZB+HjdipiInQf/5cBwt4XPyRpSZUqYzV9hATmSJjMxBQdw8dIbN3
         v8By6+zI2bLR5WFd4MZLj/58idO8Vs2jC8Gi/O4ztHs+L/On+DHdFGTuf71GPlnx7ISF
         mLUDowIueJVNG5/3+tXyXGHFSURTnqfu3BqFVtIjtGz7NwUKjV0xlH60Tv/JdGh2Z7uI
         anQA==
X-Gm-Message-State: ABuFfoipre5UMOf7oEmNRa2BpDcbYEocQccBUGiax9uPDaSxTg94YzoA
        SmmU6DU8gvSbyrrEh4oEDtmDcQ==
X-Google-Smtp-Source: ACcGV60cfb/HzJMDQzIup8J0AYvBYsux+r1rZvs5tI3ir9kV6ojZvSKSTygRS5QN7JdJZjA2Q5ItIQ==
X-Received: by 2002:a0c:b9a9:: with SMTP id v41-v6mr11398673qvf.63.1538133547845;
        Fri, 28 Sep 2018 04:19:07 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t28-v6sm3185174qki.41.2018.09.28.04.19.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:06 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 23/42] btrfs: make sure we create all new bgs
Date:   Fri, 28 Sep 2018 07:18:02 -0400
Message-Id: <20180928111821.24376-24-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Allocating new chunks modifies both the extent and chunk tree, which can
trigger new chunk allocations.  So instead of doing list_for_each_safe,
just do while (!list_empty()) so we make sure we don't exit with other
pending bg's still on our list.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 40503438ef6c..01bfb02101c1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10357,7 +10357,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_block_group_cache *block_group, *tmp;
+	struct btrfs_block_group_cache *block_group;
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_item item;
 	struct btrfs_key key;
@@ -10365,7 +10365,10 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 	bool can_flush_pending_bgs = trans->can_flush_pending_bgs;
 
 	trans->can_flush_pending_bgs = false;
-	list_for_each_entry_safe(block_group, tmp, &trans->new_bgs, bg_list) {
+	while (!list_empty(&trans->new_bgs)) {
+		block_group = list_first_entry(&trans->new_bgs,
+					       struct btrfs_block_group_cache,
+					       bg_list);
 		if (ret)
 			goto next;
 
-- 
2.14.3

