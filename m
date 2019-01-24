Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D865BC282C5
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 14:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A0CC2184B
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 14:31:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="xmdzh4F/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfAXObs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:31:48 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40081 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbfAXObq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 09:31:46 -0500
Received: by mail-qt1-f193.google.com with SMTP id k12so6699280qtf.7
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2019 06:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=tbOY02J6JXBGaov9lGo0MEoRv50vZchl0Df7Zt6b3rE=;
        b=xmdzh4F/+JU3nUrQDgckrDuICsLb16TeyJVnC7OKD1AD5EzyqDcPvF3URljMf4EFRy
         rcNPC3g/ptlMSQX8TN0PjnEYoprMCvyteG4Y5j68dPfiOZb6+n5wilanyZ+/RIVGLq7/
         gdi2nUTqcJ8L2aakxA/adYl54MrBKR0GvIV79XX5hdiSy3DBDvZOa1gQFOUECCtmIMZx
         Kt87OT+5ZqLU42Y6EgomV6V5zq3wrQrgOGVhlme4uGEq6dciRlzgOKuDkSttdwR4S4AQ
         rpDdsiqVHYU7wAy7FnQGu99+VuE9vf/7X00wCYXsIyCA/f/8kZcn30seSj29IpPLO/pH
         X90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=tbOY02J6JXBGaov9lGo0MEoRv50vZchl0Df7Zt6b3rE=;
        b=kmuvh1RQXpnfrKnY5tqoAUKwN5TLD/Bqrzuo4BaD24Ed+5GrblFtObZKR5j0IDGX9R
         scJvvMpxXBr+Q5QU8VRggHgLU1i5k+SHvA0vpwi78nV2LBNwJ2NTleGOZeN5j9d/Gsq/
         C3iYrKXygwowICx5+5aj/CZ4/WBci236J0svBEkNepbT7qCYAi+tY0btqFVmHFFmF4NW
         DGpfeYbTOA7gP0sQTiZ/gPS0w53+4zFRn8gqivQURFUZoSuaGcGrFYbf6wxVoPxsOkOT
         l03G5jFqQSufRsaaTK/N6O72WvdiWn+wVtNX6IL+op4chNexmT0e/q3Mz80KyLBHyHgt
         S06g==
X-Gm-Message-State: AJcUuke5Se7X9BRxBxeWotUi0xE+YhZQmAqfbaG1dudKU36qZxJmc3K1
        ZpLDW7AzMRmzjowMozC81VlhhxI1ZaY=
X-Google-Smtp-Source: ALg8bN5vxz5Hq2Y2oqJi4ml3lSjg8+uBEDwlasZOE6g0bnWsPrVDxKpobRiFIOFFkG8+60zsDKBI+g==
X-Received: by 2002:a0c:9961:: with SMTP id i30mr6173853qvd.229.1548340305294;
        Thu, 24 Jan 2019 06:31:45 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id b134sm55911714qkg.78.2019.01.24.06.31.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 06:31:44 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH] btrfs: don't end the transaction for delayed refs in throttle
Date:   Thu, 24 Jan 2019 09:31:43 -0500
Message-Id: <20190124143143.8838-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Previously callers to btrfs_end_transaction_throttle() would commit the
transaction if there wasn't enough delayed refs space.  This happens in
relocation, and if the fs is relatively empty we'll run out of delayed
refs space basically immediately, so we'll just be stuck in this loop of
committing the transaction over and over again.

This code existed because we didn't have a good feedback mechanism for
running delayed refs, but with the delayed refs rsv we do now.  Delete
this throttling code and let the btrfs_start_transaction() in relocation
deal with putting pressure on the delayed refs infrastructure.  With
this patch we no longer take 5 minutes to balance a metadata only fs.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 22b0dacae003..ef98b3cd30db 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -851,14 +851,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_chunk_metadata(trans);
 
-	if (lock && should_end_transaction(trans) &&
-	    READ_ONCE(cur_trans->state) == TRANS_STATE_RUNNING) {
-		spin_lock(&info->trans_lock);
-		if (cur_trans->state == TRANS_STATE_RUNNING)
-			cur_trans->state = TRANS_STATE_BLOCKED;
-		spin_unlock(&info->trans_lock);
-	}
-
 	if (lock && READ_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
 		if (throttle)
 			return btrfs_commit_transaction(trans);
-- 
2.14.3

