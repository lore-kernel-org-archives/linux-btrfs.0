Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10191C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA5D5214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="EqPxyamX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA5D5214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732165AbeKVFl3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:41:29 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46439 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFl3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:41:29 -0500
Received: by mail-yb1-f195.google.com with SMTP id i17-v6so2627726ybp.13
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=JdbY4jZtPIPda37F1AntqT6ZzucRQu0I7FkAGpehVsk=;
        b=EqPxyamXCEYpua7E8JurGtYst4ELgAK5nxglIsPtSfkUP2inw/iEBJ/mt/kXFMFK5F
         OtYgwXaXfgOpMwiFgDQUUxXreTdnoKxH6m+UENIn6rExFfJAoY5Q/YMB2nE07f06uwor
         mLRW5WFJuoLzTU5pzr2PFS0wuKwmi0x9RhWYaKf5hVkQ7eVn8+WfztWCxYFKL9lZqtJl
         T5ITblnNU7AFiN3qikfdrvW06rs51IyipjHWRBa27qZxQTbfGhxCyHL5lVZdS5OKPcRS
         NqQLrmG3076wB0TKQDx1vvoFOBikS4Z7PpxO0mlG6KVnNOtyji/oRPsNngIGUoLoQGsi
         cHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=JdbY4jZtPIPda37F1AntqT6ZzucRQu0I7FkAGpehVsk=;
        b=HLDOrAxSAEoT3PX8CoDjGOxTYSLQ9UcvHBuTrAqNyUegk+/KAzpwvq/5oYkpUJRo8K
         2iPowj1m1+Hb6Xf2aUHzy687FSPR5QZSR23rSfL/HUdtowqMzBLyq5uhI64DEGpP4sTU
         tqc691F8CZs+MVZeUAHj4TEsW8AmSPkkCzI4sXh9L3p7bdD3DrmBVXsRfs3iJrP7fFBh
         S8c5LcRdhCS9x30QRhMq6TOHzzDG2f/zqsiVljJPihamocksTkbjKx41LeGZre7hVtXw
         HO0wf9lgeiXyU0Vzh6exYENpmhryAtlgGmCS3Km4rBR2WVBEYQVLo2/NcDatU8obpw5x
         Jgvg==
X-Gm-Message-State: AA+aEWYh9fnRk+g357OllqcGJDugB0YsQRllWTsjh1uFQpn55JdJAcV6
        jT2q0GxPHXnYz2wNWcJc6PnB/8ybBjY=
X-Google-Smtp-Source: AFSGD/Vp/qFIVGpI+4/KGPYnbCzklNDALmedrUAgtMycbFKEm7cbAW3d6B9hy9m85UhkQ4FmwZ3CWg==
X-Received: by 2002:a5b:708:: with SMTP id g8-v6mr7593807ybq.331.1542827156373;
        Wed, 21 Nov 2018 11:05:56 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l35sm13351690ywh.48.2018.11.21.11.05.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:05:55 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 5/7] btrfs: just delete pending bgs if we are aborted
Date:   Wed, 21 Nov 2018 14:05:43 -0500
Message-Id: <20181121190545.24798-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190545.24798-1-josef@toxicpanda.com>
References: <20181121190545.24798-1-josef@toxicpanda.com>
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
index b9b829c8825c..90423b6749b7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10500,11 +10500,17 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_item item;
 	struct btrfs_key key;
-	int ret = 0;
+	int ret;
 
 	if (!trans->can_flush_pending_bgs)
 		return;
 
+	/*
+	 * If we aborted the transaction with pending bg's we need to just
+	 * cleanup the list and carry on.
+	 */
+	ret = trans->aborted;
+
 	while (!list_empty(&trans->new_bgs)) {
 		block_group = list_first_entry(&trans->new_bgs,
 					       struct btrfs_block_group_cache,
-- 
2.14.3

