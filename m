Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDECDC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 11:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A066E208A3
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 11:08:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="chMvCaVQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A066E208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbeKPVUl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 16:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbeKPVUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 16:20:41 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47426206BA
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 11:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542366528;
        bh=Mk+diofMuEs8mERF8fOAVmmC0GHDyeAWU/Iq9kPtuDA=;
        h=From:To:Subject:Date:From;
        b=chMvCaVQ4m037NfYF8uwmeaxTeu3d2KnL/TIbLGBDrsv8OPfn2Tt2TEHUt+z+03eQ
         UGqAIanveAjTS6y7wuJaodDI5adz9pHLvVw7QSyfGOJk+kkbrBKOO4tnZoi0/+mUfy
         qvhi1QbFsY/Ly7D+dD16oAuNLQWDggKCpzvQ7TYY=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: bring back key search optimization to btrfs_search_old_slot()
Date:   Fri, 16 Nov 2018 11:08:45 +0000
Message-Id: <20181116110845.28561-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Commit d7396f07358a ("Btrfs: optimize key searches in btrfs_search_slot"),
dated from August 2013, introduced an optimization to search for keys in a
node/leaf to both btrfs_search_slot() and btrfs_search_old_slot(). For the
later, it ended up being reverted in commit d4b4087c43cc ("Btrfs: do a
full search everytime in btrfs_search_old_slot"), from September 2013,
because the content of extent buffers were often inconsistent during
replay. It turned out that the reason why they were often inconsistent was
because the extent buffer replay stopped being done atomically, and got
broken after commit c8cc63416537 ("Btrfs: stop using GFP_ATOMIC for the
tree mod log allocations"), introduced in July 2013. The extent buffer
replay issue was then found and fixed by commit 5de865eebb83 ("Btrfs: fix
tree mod logging"), dated from December 2013.

So bring back the optimization to btrfs_search_old_slot() as skipping it
and its comment about disabling it confusing. After all, if unwinding
extent buffers resulted in some inconsistency, the normal searches (binary
searches) would also not always work.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 089b46c4d97f..cf5487a79c96 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2966,7 +2966,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 	int level;
 	int lowest_unlock = 1;
 	u8 lowest_level = 0;
-	int prev_cmp = -1;
+	int prev_cmp;
 
 	lowest_level = p->lowest_level;
 	WARN_ON(p->nodes[0] != NULL);
@@ -2977,6 +2977,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 	}
 
 again:
+	prev_cmp = -1;
 	b = get_old_root(root, time_seq);
 	level = btrfs_header_level(b);
 	p->locks[level] = BTRFS_READ_LOCK;
@@ -2994,11 +2995,6 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 		 */
 		btrfs_unlock_up_safe(p, level + 1);
 
-		/*
-		 * Since we can unwind ebs we want to do a real search every
-		 * time.
-		 */
-		prev_cmp = -1;
 		ret = key_search(b, key, level, &prev_cmp, &slot);
 
 		if (level != 0) {
-- 
2.11.0

