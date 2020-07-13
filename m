Return-Path: <SRS0=tdFO=AY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CEFC433DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Jul 2020 01:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FFDC206B6
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 Jul 2020 01:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgGMBDf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 12 Jul 2020 21:03:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:53920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgGMBDf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Jul 2020 21:03:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0F7F0AC20;
        Mon, 13 Jul 2020 01:03:35 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v3 1/4] btrfs: relocation: allow signal to cancel balance
Date:   Mon, 13 Jul 2020 09:03:19 +0800
Message-Id: <20200713010322.18507-2-wqu@suse.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200713010322.18507-1-wqu@suse.com>
References: <20200713010322.18507-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although btrfs balance can be canceled with "btrfs balance cancel"
command, it's still almost muscle memory to press Ctrl-C to cancel a
long running btrfs balance.

So allow btrfs balance to check signal to determine if it should exit.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/relocation.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 523d2e5fab8f..2b869fb2e62c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2656,7 +2656,8 @@ int setup_extent_mapping(struct inode *inode, u64 start, u64 end,
  */
 int btrfs_should_cancel_balance(struct btrfs_fs_info *fs_info)
 {
-	return atomic_read(&fs_info->balance_cancel_req);
+	return atomic_read(&fs_info->balance_cancel_req) ||
+		fatal_signal_pending(current);
 }
 ALLOW_ERROR_INJECTION(btrfs_should_cancel_balance, TRUE);
 
-- 
2.27.0

