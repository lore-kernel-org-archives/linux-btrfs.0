Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDACC71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 637222087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="NCgWsohd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 637222087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbeJMDII (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:08 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38790 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbeJMDII (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:08 -0400
Received: by mail-qt1-f193.google.com with SMTP id l9-v6so15069500qtf.5
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=2v3HNp+SiUuKkJAWzeR46bMWpcvQbLX2jWxeWYdX+Ok=;
        b=NCgWsohdYsXKratC8htSWExXwEtFINv2XfjX2Qu1N+u1XPgQ5T84AzWbkyvxfz5LhV
         LSyRjrWZXBwl3iuJfFofjI8+/Gz6ivTxbTBrK/B69L6tkjAdADmD2whIv+sHutOArFLh
         oemeg525qzuczeB8o6fU/fQwLXvONTqTYUHStE3R/9dr3zwpreVsa6UIFeJPbvsEKL5X
         QHhTkRZzxaPzPLeyCZrFkq1tSZu577iFxMjPPD618IUQ9GFlzCJfHClLZjOSE3jS8Fkg
         baWg++BzAquN7LxFauImwAvEAYIXh5q796zMGtyRGEFkzCfY2iVgC9GmgeqttzvDd7j9
         +Odw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=2v3HNp+SiUuKkJAWzeR46bMWpcvQbLX2jWxeWYdX+Ok=;
        b=Ddg290kNPZAlfrtasx9gTDRu26hHQt3InTjB4e6ie+KtfUfjI305UoUFEJC0mxb/Mo
         gn0OiIDtvrfluiZgtOwp3wdkteY3qkbACodzHLkaBUNGTirVatrGT/UumPKBvlu6xNfV
         QiL7iVN/j2p398ZNdYxuAprQh4PMPaoBIIZh2xtW/TvoqNMCCsmVU2HZAXHs7PH6tpKD
         aLXDCXwTmGOgP1PL+hcRSBvi+yGhW5GqT932NvtXVF013nXGBmNbAB4pDQ3wnka/EaEY
         3pVtEyMnRBIk1aEVawUBEnoDbfusqGRdgcNWWFlHlDwpWEuQ/LqskzSU/X9IFnWuzZZj
         Vexg==
X-Gm-Message-State: ABuFfoj+VkZ9iXfavgbdtafoyqs9TmC27zLjSl8t0LJ6l6elBL+DJ2iq
        hhmD0WW/0gN/VsBOVrUxSshZPDDqlSs=
X-Google-Smtp-Source: ACcGV62If6XmjTofKNOvwcwwt2UF3ZpFXdNl7G1XCwoYCObJdIhc0VrzZLDYQqsm3tpYQm7qm/7UDA==
X-Received: by 2002:aed:2647:: with SMTP id z65-v6mr7020018qtc.301.1539372846646;
        Fri, 12 Oct 2018 12:34:06 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id n67-v6sm1803906qkh.66.2018.10.12.12.34.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:05 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 30/42] btrfs: just delete pending bgs if we are aborted
Date:   Fri, 12 Oct 2018 15:32:44 -0400
Message-Id: <20181012193256.13735-31-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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
index 14495c030301..933cba06c9fb 100644
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

