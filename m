Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEC4C65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE032084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544637972;
	bh=/eV4vNdpA1M8JpfHuF+GdnV3IlulhXuasGHP5F5mwug=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=dc8+/YZkjm3UaFJJKJ9pqcJUsC7GMkxScsumKNX4mG7zhwy/5sYByN8Wr20IqHOM1
	 BvjZepRnyIvOndlt6LLRdZWxcKeA6GuTHYW3oSn62Eq0nD9B6zzn+IUNbFLcvqueyh
	 zVO5uT85V03CyE870rDH4un+XpDy1eb5PxYlJ8NA=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BE032084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbeLLSGL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbeLLSGJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 13:06:09 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A162086D
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 18:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544637968;
        bh=/eV4vNdpA1M8JpfHuF+GdnV3IlulhXuasGHP5F5mwug=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Sv42FqJleB8C2udcSlp8NoiCF9nimfciMtnpLAb8KAy3JVXGxcYHBPT+4xKaYxyoB
         PTq6I32aldcHPEGgjTzNK5XS780VDPes78wCxNzKrO2WFEU+z5U5uthEmWIVUWOkBY
         3iijjFkrhqYVquC8Y3RGHe4gWNF5yfFmNfsDBnm4=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] Btrfs: remove no longer needed range length checks for deduplication
Date:   Wed, 12 Dec 2018 18:05:59 +0000
Message-Id: <20181212180559.15249-5-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181212180559.15249-1-fdmanana@kernel.org>
References: <20181212180559.15249-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Comparing the content of the pages in the range to deduplicate is now done
by the generic helper generic_remap_file_range_prep(), which takes care of
ensuring we do not compare/deduplicate undefined data beyond a file's eof
(range from eof to the next block boundary). So remove these checks which
are now redundant.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4e9efc93340e..3a27efa2b955 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3206,31 +3206,16 @@ static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
 	inode_lock_nested(inode2, I_MUTEX_CHILD);
 }
 
-static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
+static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 len,
 				   struct inode *dst, u64 dst_loff)
 {
-	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
 	int ret;
-	u64 len = olen;
-
-	if (loff + len == src->i_size)
-		len = ALIGN(src->i_size, bs) - loff;
-	/*
-	 * For same inode case we don't want our length pushed out past i_size
-	 * as comparing that data range makes no sense.
-	 *
-	 * This effectively means we require aligned extents for the single
-	 * inode case, whereas the other cases allow an unaligned length so long
-	 * as it ends at i_size.
-	 */
-	if (dst == src && len != olen)
-		return -EINVAL;
 
 	/*
 	 * Lock destination range to serialize with concurrent readpages().
 	 */
 	lock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
-	ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
+	ret = btrfs_clone(src, dst, loff, len, len, dst_loff, 1);
 	unlock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
 
 	return ret;
-- 
2.11.0

