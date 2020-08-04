Return-Path: <SRS0=HNUC=BO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60539C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Aug 2020 17:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389D8206DA
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Aug 2020 17:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="fUMvdGfW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bZ5j0fbX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgHDRz0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Aug 2020 13:55:26 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:49295 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgHDRzY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Aug 2020 13:55:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 87E8F533;
        Tue,  4 Aug 2020 13:55:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 04 Aug 2020 13:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=8wi2qg8OUUJ9CFrQsCG+pHE0Gs
        W5iWYwty/LhGT0rfQ=; b=fUMvdGfWv60nwsxaojIOWOzMilgEJODwTOLDSwRnz/
        lrOk+PQQAIzOoDctPIbnN9wGYOXjht9yxZf5uoMO1ccCZTSGVCKkiZ+OlggWQvpQ
        Jjo8UapHeABs1iHNy4rmgaI0gO1aQKQibLeZv977cN90zyzov0Q0i56dVJ9jOP1c
        OCo1jAeNxGZzrykzE785yEZHBLp0G2DAs21qjzB6sLHDTFJNPDJpNB6VPUw9Zqz8
        w79HpXjva56RFiF0UUtP3ZnSa2aODl2CVUBzIzkPh/oePGqPDWGTwuMPHdmlKBNe
        FrtRqgiqNimDBhGgcGTmHUp5XBfdHEVKZ1fKg9ZkkKcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8wi2qg8OUUJ9CFrQs
        CG+pHE0GsW5iWYwty/LhGT0rfQ=; b=bZ5j0fbXsDBNycfFdkhVAWV9IN9X+/OWk
        3rwzTT0V81Yqb6X8A2IoXb4lCO4kg6s/dCTf/GN2fGdxBfSnDQ5vrAvRef04f7bi
        EGmH0bcEzjXw3W9jllBYOf2lQEtUrvWyCUsfBz+HF710Ryq08YSKYx3khqm/1KRE
        NIsBukhI01O1A2F1m76D6DNfK5fG9FfuYChtYu/R0g68jSpvJR8h7DDcHwpN/PzP
        kCSWNACVyY7WW+MVzgm+1t/o40UxdFV4KYApxD01rLvcILeschpBqcG4P/bQ+lVy
        qbWMKvxZXysVpVoPBqRwiSedzrd+pDmtEBt5SdyOz9wH9BzfmVTvQ==
X-ME-Sender: <xms:CaEpX-tonLtNZkUe1jGsuYLvu7uD2uqsQxLbWGwD0ZvxSS73FVXkRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeigdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepudeitd
    elueeijeefleffveelieefgfejjeeigeekudduteefkefffeethfdvjeevnecukfhppedu
    ieefrdduudegrddufedvrdefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:CaEpXzfqdTIQ71a0A7AXsLbV78ja6Vo9gEYdt9hXN9-rVZ_wp7dECw>
    <xmx:CaEpX5x7tgB-Hf5ddAwqLTfuL7Fq2Uu2cntdGlnsGo7BjB5Y52tqaQ>
    <xmx:CaEpX5M1dMH4o8YMVY_ZIX91hAo_AgLQQ9wnM8UI-osl2UkaPJHbRw>
    <xmx:CqEpXwLiXpkbYWIQJ6-oQJPKBzjqdrnD8TCvtzvWJRyD1OlWnHmO_A>
Received: from localhost (unknown [163.114.132.3])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FEEC328005A;
        Tue,  4 Aug 2020 13:55:21 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Boris Burkov <boris@bur.io>
Subject: [PATCH RFC] btrfs: change commit txn to end txn in subvol_setflags ioctl
Date:   Tue,  4 Aug 2020 10:55:16 -0700
Message-Id: <20200804175516.2511704-1-boris@bur.io>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently, btrfs_ioctl_subvol_setflags forces a btrfs_commit_transaction
while holding subvol_sem. As a result, we have seen workloads where
calling `btrfs property set -ts <subvol> ro false` hangs waiting for a
legitimately slow commit. This gets even worse if the workload tries to
set flags on multiple subvolumes and the ioctls pile up on subvol_sem.

Change the commit to a btrfs_end_transaction so that the ioctl can
return in a timely fashion and piggy back on a later commit.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/ioctl.c       | 2 +-
 fs/btrfs/transaction.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bd3511c5ca81..3ae484768ce7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1985,7 +1985,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_reset;
 	}
 
-	ret = btrfs_commit_transaction(trans);
+	ret = btrfs_end_transaction(trans);
 
 out_reset:
 	if (ret)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 20c6ac1a5de7..1dc44209c2ae 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -47,7 +47,7 @@
  * | Will wait for previous running transaction to completely finish if there
  * | is one
  * |
- * | Then one of the following happes:
+ * | Then one of the following happens:
  * | - Wait for all other trans handle holders to release.
  * |   The btrfs_commit_transaction() caller will do the commit work.
  * | - Wait for current transaction to be committed by others.
@@ -60,7 +60,7 @@
  * |
  * | To next stage:
  * |  Caller is chosen to commit transaction N, and all other trans handle
- * |  haven been released.
+ * |  have been released.
  * V
  * Transaction N [[TRANS_STATE_COMMIT_DOING]]
  * |
-- 
2.24.1

