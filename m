Return-Path: <SRS0=tFs+=D4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3058EC4363A
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Oct 2020 06:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCF7421D43
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Oct 2020 06:28:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KVwr1NAo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436731AbgJUG2W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Oct 2020 02:28:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:44956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440865AbgJUG2W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Oct 2020 02:28:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603261701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OItWooDGL4k0RSoRQgCHLgFdXZYa1ij6bZkR/Pdmuyg=;
        b=KVwr1NAowp4osaQJ3JulkYW9sNktGJ4yUtU8oluR70usSdz9r634TJC+d+lREnoGVsEGvP
        DKHBdN0KOm17pBFrmpw8r8/h1ow7lRtN2OWPUVCJzu2mtgOA2jFYi5cYWX5WrfVuDu5uwD
        b+9axRIYT8coY0Ajag1PgHY//xKstJM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1DA70ACC5
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2020 06:28:21 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 63/68] btrfs: file: make btrfs_fallocate() to use PAGE_SIZE as blocksize
Date:   Wed, 21 Oct 2020 14:25:49 +0800
Message-Id: <20201021062554.68132-64-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201021062554.68132-1-wqu@suse.com>
References: <20201021062554.68132-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In theory, we can still allow subpage sector size to be utilized in such
case, but since btrfs_truncate_block() now operates in page unit, we
should also change btrfs_fallocate() to honor PAGE_SIZE as blocksize.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6e342c466fdf..f7122f71b791 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3244,7 +3244,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	u64 locked_end;
 	u64 actual_end = 0;
 	struct extent_map *em;
-	int blocksize = btrfs_inode_sectorsize(inode);
+	int blocksize = PAGE_SIZE;
 	int ret;
 
 	alloc_start = round_down(offset, blocksize);
@@ -3401,7 +3401,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 		if (!ret)
 			ret = btrfs_prealloc_file_range(inode, mode,
 					range->start,
-					range->len, i_blocksize(inode),
+					range->len, blocksize,
 					offset + len, &alloc_hint);
 		else
 			btrfs_free_reserved_data_space(BTRFS_I(inode),
-- 
2.28.0

