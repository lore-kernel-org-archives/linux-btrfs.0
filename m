Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956CFC6783B
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 507392084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544637968;
	bh=vyh7zZkqoMKsFhIxyiC5hZIJX1tpoKRbsxaB9WwNOFE=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ql48eZOnbSvekSiIPrLedVaoAte/vlmeiG1MKNJuTkkQHRC65ZW+2ZSjZvS/fjS21
	 PJ+LCSG7viZ4gxmgW69qRAfqo7f5/7x4+7me7hgETUhqQsgastQjGNxH9tGRkq+7Wu
	 LY1rCLnuI1ueKvYuv4QAdu9BfmiTQ4AKWivDP0RQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 507392084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbeLLSGH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:06:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728150AbeLLSGG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 13:06:06 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 750CD2086D
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544637965;
        bh=vyh7zZkqoMKsFhIxyiC5hZIJX1tpoKRbsxaB9WwNOFE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=P6vHgAbmd9tFf08QA612HgrNokIbifqotYksw92/QKDa9DQVcI+K4G1Tto/OvDLS2
         4JOKeW+UYmjqDfBrhfUu4rjg8BBtXF8d3jnXu430bNO0MxrhHLeH0hwehTiHgcVHTx
         iGx3LQDzqLP7wYSdSwuHBW18st4Rcg1JonB/yvqs=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] Btrfs: move duplicated nodatasum check into common reflink/dedupe helper
Date:   Wed, 12 Dec 2018 18:05:56 +0000
Message-Id: <20181212180559.15249-2-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181212180559.15249-1-fdmanana@kernel.org>
References: <20181212180559.15249-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Move the check that verifies if both inodes have checksums disabled or
both have them enabled, from the clone and deduplication functions into
the new common helper btrfs_remap_file_range_prep().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 321fb9bc149d..1e90d10b5638 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3245,11 +3245,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	int num_pages = PAGE_ALIGN(BTRFS_MAX_DEDUPE_LEN) >> PAGE_SHIFT;
 	u64 i, tail_len, chunk_count;
 
-	/* don't make the dst file partly checksummed */
-	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
-	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM))
-		return -EINVAL;
-
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
 	if (chunk_count == 0)
@@ -3869,11 +3864,6 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	 *   be either compressed or non-compressed.
 	 */
 
-	/* don't make the dst file partly checksummed */
-	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
-	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
-		return -EINVAL;
-
 	/*
 	 * VFS's generic_remap_file_range_prep() protects us from cloning the
 	 * eof block into the middle of a file, which would result in corruption
@@ -3933,6 +3923,13 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	else
 		btrfs_double_inode_lock(inode_in, inode_out);
 
+	/* don't make the dst file partly checksummed */
+	if ((BTRFS_I(inode_in)->flags & BTRFS_INODE_NODATASUM) !=
+	    (BTRFS_I(inode_out)->flags & BTRFS_INODE_NODATASUM)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Now that the inodes are locked, we need to start writeback ourselves
 	 * and can not rely on the writeback from the VFS's generic helper
-- 
2.11.0

