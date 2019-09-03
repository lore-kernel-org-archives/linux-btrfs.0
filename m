Return-Path: <SRS0=cRuQ=W6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26225C3A5A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 16:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EABE92339D
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 16:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567528539;
	bh=e02ufRmgAN86RUGECAi/L5SoLpjKjenqfajH47AsiOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VPoCo4fXrC1ChmRL1EKlE7t21UtPYBnPC0MuZwACWkFdUO1iPfCRRGS0nW4yKrU24
	 pl9MUREEs0ovFWN0ByRrQNvGIIRgthPHToFs8g5YmMUesiqCw/ZQm1nFqT3yZo+wXo
	 LZlSkty2jzzYtVxAgIDqCXXi1iftklLH3IPTk+1o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfICQf3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbfICQ1q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9480238C7;
        Tue,  3 Sep 2019 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528065;
        bh=e02ufRmgAN86RUGECAi/L5SoLpjKjenqfajH47AsiOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTkOK3a+DFHhCE38xgIWU7YwUQOGljKsx1Ao3xuA4L8Z18gBP+jwu+UtEZUOREqr1
         sykhh0hhBHxk4m4hKsoxbmq2x4Dg3BZ5pp3JZpNLTQm6oVru9eGzk7SRJj/mQC5WQE
         mDqHkD4NXw01Q/Y7HfV8IAnFbt0uVj+Q+mSpvtCQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 080/167] btrfs: init csum_list before possible free
Date:   Tue,  3 Sep 2019 12:23:52 -0400
Message-Id: <20190903162519.7136-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Dan Robertson <dan@dlrobertson.com>

[ Upstream commit e49be14b8d80e23bb7c53d78c21717a474ade76b ]

The scrub_ctx csum_list member must be initialized before scrub_free_ctx
is called. If the csum_list is not initialized beforehand, the
list_empty call in scrub_free_csums will result in a null deref if the
allocation fails in the for loop.

Fixes: a2de733c78fa ("btrfs: scrub")
CC: stable@vger.kernel.org # 3.0+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Dan Robertson <dan@dlrobertson.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a08a4d6f540f9..916c397704679 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -592,6 +592,7 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
 	sctx->pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx->curr = -1;
 	sctx->fs_info = fs_info;
+	INIT_LIST_HEAD(&sctx->csum_list);
 	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
 
@@ -616,7 +617,6 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
 	atomic_set(&sctx->workers_pending, 0);
 	atomic_set(&sctx->cancel_req, 0);
 	sctx->csum_size = btrfs_super_csum_size(fs_info->super_copy);
-	INIT_LIST_HEAD(&sctx->csum_list);
 
 	spin_lock_init(&sctx->list_lock);
 	spin_lock_init(&sctx->stat_lock);
-- 
2.20.1

