Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200EFC6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D943220835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ODOJisoE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D943220835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbeJLDYR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:17 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]:45805 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:16 -0400
Received: by mail-qk1-f180.google.com with SMTP id m8-v6so6267878qka.12
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=U3FEzmZTOlWuf95OZRDugO+ySzVMXr2hm7FmI8EAbWE=;
        b=ODOJisoEVAukyhSlaltYmP12vd7QIeNsbIKOtSPRhVrMKnTQ8g4frDrdd/zsu9H3Dr
         C8rY0TkU5Q11VWACjb1FnF7Ge/XTufszZUNAOPyD8FX8gK7LME2KlP7tGS9LmRQyXl4u
         fcYS9E7rWk2BKOrU5IDXoNSSAjckKkFvC+9OG+eBAGzjnZS66Zrjl2txh3AhLP60S4Fk
         ioSX1rquuT14Ruc2mKiZjOZNKXkX6CI+BU6RFzgvZ1uZ/Oz+YDS9VihkXSiF0A2/Qacm
         7siQYC7ymYsIfu9L5+IPwpitZ4xg61mZVwv2ynQuD9Yi8+Q9HhTyvS+B1Cq1QN38xXD5
         9eQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=U3FEzmZTOlWuf95OZRDugO+ySzVMXr2hm7FmI8EAbWE=;
        b=CUDZarfrQ0Llvx/k3PRFC+iT0lSk4ZCQ7oAUtessDV40qGN7og6O1vYpQF/tNgREvK
         9bm8YJPoJEeZTq8+wXRkV00fzN1vDiLLndLJi90fSy5tNksZyBmkwOras5vzQ5chEutt
         2CtKK+kMIGbOKqa0xsvQSDcKC/acxIFJeVfSRAx0s5TUOXKsGE3bHuk63yUBYkR91hXn
         nuBHOPPJwhMJk0Qq0211vT9SR8n8vsiDTW0Kw82qe/jfsy8J94efR40nJQcK6kNeMMPw
         4hOy6eWABlnfa1pas4m7Aehqv5KR9wJdtw4uwtNgF8yXxpef9YWztGGpXXuTwhHaTp6v
         9GUw==
X-Gm-Message-State: ABuFfogZe0X7BsO2KSJbNtxSrLNNisPPkjgqubX6fkcupD1epjiJ/36u
        m44MKenB6BUGlutAZb56z3DHGqW4qaI=
X-Google-Smtp-Source: ACcGV60eR2h08A3V4ohEg336J0XGBYu6QU0e0t7M7s/86WS7HraQz7F4Q0pVMkICsHdnPBxreuHIRQ==
X-Received: by 2002:a37:9dd5:: with SMTP id g204-v6mr2965236qke.41.1539287730187;
        Thu, 11 Oct 2018 12:55:30 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id x34-v6sm14373573qth.86.2018.10.11.12.55.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:29 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 30/42] btrfs: just delete pending bgs if we are aborted
Date:   Thu, 11 Oct 2018 15:54:19 -0400
Message-Id: <20181011195431.3441-31-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 6fa7d19bcbb1..7e66a6351aad 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10363,9 +10363,15 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
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

