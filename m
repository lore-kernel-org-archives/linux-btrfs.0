Return-Path: <SRS0=tFs+=D4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233D9C561F8
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Oct 2020 06:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC2421D43
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Oct 2020 06:28:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bSIrpmzO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436577AbgJUG22 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Oct 2020 02:28:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:45042 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440865AbgJUG20 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Oct 2020 02:28:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603261704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxipyaoC8soMha9pnnrNqX9B72Ucj/YKwiAwl9hQfcM=;
        b=bSIrpmzOGLUBJ3DXd7C9bJpKCr+gAehGiZd4Z8VwBl9JAkoFiC/23roACBYCnEf0wuyF0z
        m/9H7AI8HJPIyfoOulRc3JbV4i0Z2r6AO+Lejxio+F6yWJihx2kBua9L5zfTcYXLPeCBR1
        4VPliAmVVH1x+BM/QAyKg6fFKPAKICQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C213BAC1D
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2020 06:28:24 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 65/68] btrfs: inode: require page alignement for direct io
Date:   Wed, 21 Oct 2020 14:25:51 +0800
Message-Id: <20201021062554.68132-66-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201021062554.68132-1-wqu@suse.com>
References: <20201021062554.68132-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For incoming subpage support, we still can only submit full page write,
thus the requirement for direct IO alignment should still be page size,
not sector size.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0da6c91db0bc..625950258c87 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7894,7 +7894,7 @@ static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
 {
 	int seg;
 	int i;
-	unsigned int blocksize_mask = fs_info->sectorsize - 1;
+	unsigned int blocksize_mask = PAGE_SIZE - 1;
 	ssize_t retval = -EINVAL;
 
 	if (offset & blocksize_mask)
-- 
2.28.0

