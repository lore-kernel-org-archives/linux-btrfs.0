Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADE0C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 09:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D72CF2085A
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 09:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="e5uhNqWS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfCYJQs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 05:16:48 -0400
Received: from mail.synology.com ([211.23.38.101]:50896 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730076AbfCYJQs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 05:16:48 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2019 05:16:47 EDT
Received: from localhost.localdomain (unknown [10.17.32.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 705B2B25263B;
        Mon, 25 Mar 2019 17:06:53 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1553504813; bh=ZlcAF87ymAwlg6JfFbSlvp8aiP3h4y5rPpnrSPCUH18=;
        h=From:To:Cc:Subject:Date;
        b=e5uhNqWSRTKCFjolfs0t05NpscfrRJNnrpCCQLHASH5CBVWFLUHWQiN/VM1otEOZe
         tj9M4rdXlC0FOAcgaI7sQZCylMUXOemP5kTvsh3b+P1KXB7o05NJf0xzqQtlNdEtB0
         jR8sJepd4BbU3JNQchMsgJ2XUZoK7fZ2aT4myP7c=
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: improve unnecessary free space inode update when space_cache=v1 has never been used
Date:   Mon, 25 Mar 2019 17:06:38 +0800
Message-Id: <1553504798-8116-1-git-send-email-robbieko@synology.com>
X-Mailer: git-send-email 1.9.1
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

When we have never used space_cache=v1, we don't need to update
the free space inode, and try to free up the space occupied by the
free space inode.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/extent-tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1d49694..d3bba07 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3403,6 +3403,13 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 
 	if (trans->aborted)
 		return 0;
+
+	if (btrfs_super_cache_generation(fs_info->super_copy) == (u64)-1 &&
+		!btrfs_test_opt(fs_info, SPACE_CACHE)) {
+		dcs = BTRFS_DC_WRITTEN;
+		goto out;
+	}
+
 again:
 	inode = lookup_free_space_inode(fs_info, block_group, path);
 	if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
-- 
1.9.1

