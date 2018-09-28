Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D38C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5651215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ZsCcd1DB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5651215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbeI1Rmi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:38 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:46783 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbeI1Rmi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:38 -0400
Received: by mail-qk1-f179.google.com with SMTP id q12-v6so3531722qkl.13
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=FaedjnvqEPjhcquf2LaidURx/buWzJK+i4n0WtJhwI8=;
        b=ZsCcd1DBGRmB+4KwglFPY+NQCZgUE7cxMH7Ld0M5QX6NNhCZQvpjLILZ/46rVoYu+R
         2zOcZwYHeqPt3KBfvEOrWiP28aZGesSyrzw6hz8gygEgJVD/27p8jZo0/IQuvdzvRTwj
         OTjXD+kqo9WE7sOt7NM1OlAxsGf0U83SrSeBI9rf7wE6OyBL37HOUEZQ1phAPgFtQkLm
         JmVN3hLMxOD0pxXcuhknpX1IZQVHSieWqGriMA3cPN2z3aRVY79YUA80FqMZH7SerYGe
         2ERDe+2OlS2gEaiHj53dzHpTc5bk8gtaznafzW0XwxsLYrdE3b2H8L3mJJb0Huy5NR+0
         im/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=FaedjnvqEPjhcquf2LaidURx/buWzJK+i4n0WtJhwI8=;
        b=QNDBE5miF3Yug1X2I78io2dFMP0hZVzQsaX9fqajKc5YPHrnWXlyj1YQNw7sBdKSES
         dgrUKTgL04xUNHLOZO2MWxXMxprXxp2v+tZq9x8AyOT0uKmOrGNU6TUIiFEvj4Y0czUR
         uAay3L0aMDMIEwLPTrh3OmPhs25W6ajlUrd53Si5jBzOFqcwSL9cKfXp2utI8kITdLp0
         PtUgSQeV0pdQm3cfcAxWLktL2j2SK2EgWjzxQkQqoqB07KxFyA8djQ5uxQDGF7ZfhEUP
         4GWf9rjlz+VqE86iF+L31uNOS4PHvHnHliWIOp6n0bSwO/ee2Mmvwr/73EtWSZkZegGL
         j0sw==
X-Gm-Message-State: ABuFfojGMgtWHXV642MxWoGBEbjmjEU1GbmOIcpuqy/4kYHB9MJayzwJ
        JhN4vjcu/UmU75oEP2b2PtKbMw==
X-Google-Smtp-Source: ACcGV63q/xlzTEA9gO+cpKCoWp7aVuCzPQFdYBnXnljRcQcwAc5MGBxReIu5LFxsPK4OLpN0lkVpYA==
X-Received: by 2002:a37:6388:: with SMTP id x130-v6mr4700039qkb.118.1538133560776;
        Fri, 28 Sep 2018 04:19:20 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a11-v6sm2748774qte.13.2018.09.28.04.19.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:19 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 30/42] btrfs: just delete pending bgs if we are aborted
Date:   Fri, 28 Sep 2018 07:18:09 -0400
Message-Id: <20180928111821.24376-31-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We still need to do all of the accounting cleanup for pending block
groups if we abort.  So set the ret to trans->aborted so if we aborted
the cleanup happens and everybody is happy.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 91e45cb14d45..ac282eb535a8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10359,9 +10359,15 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_item item;
 	struct btrfs_key key;
-	int ret = 0;
+	int ret;
 	bool can_flush_pending_bgs = trans->can_flush_pending_bgs;
 
+	/*
+	 * If we aborted the transaction with pending bg's we need to just
+	 * cleanup the list and carry on.
+	 */
+	ret = trans->aborted;
+
 	trans->can_flush_pending_bgs = false;
 	while (!list_empty(&trans->new_bgs)) {
 		block_group = list_first_entry(&trans->new_bgs,
-- 
2.14.3

