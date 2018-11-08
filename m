Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8337ECDE4D
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 13:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEA442081D
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 13:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bAEPNX4w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEA442081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbeKHWxW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 17:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbeKHWxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 17:53:21 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5E72081D
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 13:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541683073;
        bh=0IAbTFrzNcBowsACnxs46/xvL3HnKCfhntJMtaqjGtE=;
        h=From:To:Subject:Date:From;
        b=bAEPNX4w2Zsn3Ks+pO1S+HUy3KaDxJW7YO2nPQOskRIC86/xysKkhHaCEJMaMuP9e
         ASpP6Iqeyadso73OhUsJ8vrGhCtLv5EL+kZSwIzVvbSSVAC6pNiRBFx6uQm1yXENnE
         dtCx7NES3tNvk6wvry+cho3sy11Zbj0bZtlXbz9Y=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not set log for full commit when creating non-data block groups
Date:   Thu,  8 Nov 2018 13:17:50 +0000
Message-Id: <20181108131750.27833-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When creating a block group we don't need to set the log for full commit
if the new block group is not used for data. Logged items can only point
to logical addresses of data block groups (through file extent items) so
there is no need to for the next fsync to fallback to a transaction commit
if the new block group is for metadata.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 577878324799..588fbd1606fb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10112,7 +10112,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 	struct btrfs_block_group_cache *cache;
 	int ret;
 
-	btrfs_set_log_full_commit(fs_info, trans);
+	if (type & BTRFS_BLOCK_GROUP_DATA)
+		btrfs_set_log_full_commit(fs_info, trans);
 
 	cache = btrfs_create_block_group_cache(fs_info, chunk_offset, size);
 	if (!cache)
-- 
2.11.0

