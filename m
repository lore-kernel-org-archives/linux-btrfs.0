Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CE4C67839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 822A22084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544637969;
	bh=FQCjLrSiqOBJNDFQv1mBKvsGCfJ1gRrdof+CVS3sWcc=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=b+m/degoY+4o3o3LZDrdWpEYPnCxcDjUc3kNsg9v7wEEMiY6ZUOV4/Rl4Rn7/i2YL
	 pbF40Vw3qImthVZc6R2u2hwzIpeMToGw9+YUS90a3w6vdEQRCW90Q5kPc+4wiEDw8I
	 glSklJswiNcXaDfS5mFrm2P6SdZcorKXLaYrR6xA=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 822A22084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbeLLSGJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbeLLSGI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 13:06:08 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 353FC2084E
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 18:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544637967;
        bh=FQCjLrSiqOBJNDFQv1mBKvsGCfJ1gRrdof+CVS3sWcc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aOFeOaBjA2DXAKkhrrEdghhq79z/QY6E/2BJxpYldP3DljfkEVa6BtPg0JiJKI/s8
         aHbC3BDidlCfOnihIsG3udrEPw2CkWNhOFyw3YVd4Cu5/29TGNyiCPIR2HpZrVAfRp
         x+ASn3xksh7019J96BKQJs+We1sNj1mTjBkiUroQ=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] Btrfs: check if destination root is read-only for deduplication
Date:   Wed, 12 Dec 2018 18:05:58 +0000
Message-Id: <20181212180559.15249-4-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181212180559.15249-1-fdmanana@kernel.org>
References: <20181212180559.15249-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Checking if the destination root is read-only was being performed only for
clone operations. Make deduplication check it as well, as it does not make
sense to not do it, even if it is an operation that does not change the
file contents (such as defrag for example, which checks first if the root
is read-only).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ffe940ceb80a..4e9efc93340e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3907,12 +3907,8 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	u64 wb_len;
 	int ret;
 
-	if (!(remap_flags & REMAP_FILE_DEDUP)) {
-		struct btrfs_root *root_out = BTRFS_I(inode_out)->root;
-
-		if (btrfs_root_readonly(root_out))
-			return -EROFS;
-	}
+	if (btrfs_root_readonly(BTRFS_I(inode_out)->root))
+		return -EROFS;
 
 	if (file_in->f_path.mnt != file_out->f_path.mnt ||
 	    inode_in->i_sb != inode_out->i_sb)
-- 
2.11.0

