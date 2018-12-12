Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E19AC6783B
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E07672084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544637970;
	bh=d06/89y5d99CukwbzncxYpqWa036dmzZ/Ho8m0ct/EQ=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BgtAZjGEEZ6o8zaS93v73nYaQrDB7XRoJpRr/i6LcTp1xT0WfS2GnkP9jj47Z3CUC
	 NlUrv2YlpBFlxdFqUe6ibOTUVCJrr1ys8UMsv1Z/9KWDmFp5U+S8ealnB7DAVevG/v
	 jMyu2DVJbuz0NfIuhb+hRjoggLLxZOoLgQPt6Vqs=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E07672084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbeLLSGJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbeLLSGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 13:06:07 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5559D20879
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 18:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544637966;
        bh=d06/89y5d99CukwbzncxYpqWa036dmzZ/Ho8m0ct/EQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=t55EqDK4Htt/9nEqTqcCg9JYs+mwoxTIYNCUBTrHbcXtQpP08z0FiKVZPwGiJZEYf
         nNRPRsDSGRbR2kqlICtPLTJ3hWJ3OVSEQ/01sO6KURTZry5yEQtjX9KwtknvgEBCBe
         eM7rnN0BIO60dRzFBRCMODKq+BcYGWGb3UtHp0lg=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] Btrfs: use cross mount point check for cloning and deduplication
Date:   Wed, 12 Dec 2018 18:05:57 +0000
Message-Id: <20181212180559.15249-3-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181212180559.15249-1-fdmanana@kernel.org>
References: <20181212180559.15249-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

There is no reason why this check was performed for clone operations but
not for deduplication operations, after all deduplication is a special
case of cloning. So make the check happen for deduplication as well.

This check used to be done and got removed by accident in commit
2b3909f8a7fe9 ("btrfs: use new dedupe data function pointer").

Fixes: 2b3909f8a7fe9 ("btrfs: use new dedupe data function pointer").
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1e90d10b5638..ffe940ceb80a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3912,12 +3912,12 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
 		if (btrfs_root_readonly(root_out))
 			return -EROFS;
-
-		if (file_in->f_path.mnt != file_out->f_path.mnt ||
-		    inode_in->i_sb != inode_out->i_sb)
-			return -EXDEV;
 	}
 
+	if (file_in->f_path.mnt != file_out->f_path.mnt ||
+	    inode_in->i_sb != inode_out->i_sb)
+		return -EXDEV;
+
 	if (same_inode)
 		inode_lock(inode_in);
 	else
-- 
2.11.0

