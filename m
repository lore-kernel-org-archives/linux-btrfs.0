Return-Path: <SRS0=Rt3R=CX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2772C433E2
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Sep 2020 08:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 982F221741
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Sep 2020 08:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600070474;
	bh=+JJI8Mbb6DQkNcgZWhvgPCiaRm2Fneu9WAU2Fmz05JM=;
	h=From:To:Subject:Date:List-ID:From;
	b=gZMifsOkHsQqZjpn8f7t4kzH4aAzKqLuF2W8cuV14rAVFswhx2+NYL2ttyQ457FN4
	 4EocwqXxLEvn712LyV7L7C/iv2g8p7mj+kVXsuEx8etKvDyc3C9pM2cCJfqB008g87
	 80XVc7K+4MngarwkAuRKp4myvr8+uB2rmI2XJklA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgINIBN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 04:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgINIBI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Sep 2020 04:01:08 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1776221741
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2020 08:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600070467;
        bh=+JJI8Mbb6DQkNcgZWhvgPCiaRm2Fneu9WAU2Fmz05JM=;
        h=From:To:Subject:Date:From;
        b=yvQTAdqUIrwW/N8G7Okwo7hGDVx8yQ3ZESkxJTGkvv48+Igqi3oGU14jsinHVvau1
         J/4czq8VV9B2Q1b823WQFEyT5LAT9cwghqmniJqrAacKiSCBjat3oB8e8Sj+dnGRd0
         3N8hu2Jrgbp6zcmJxNqhxpIUzUbpY9VW6PkJ03Q4=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix wrong address when faulting in pages in the search ioctl
Date:   Mon, 14 Sep 2020 09:01:04 +0100
Message-Id: <78bf853ef63f2dbd62587bb02bb723fbaa77c198.1600070418.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When faulting in the pages for the user supplied buffer for the search
ioctl, we are passing only the base address of the buffer to the function
fault_in_pages_writeable(). This means that after the first iteration of
the while loop that searches for leaves, when we have a non-zero offset,
stored in 'sk_offset', we try to fault in a wrong page range.

So fix this by adding the offset in 'sk_offset' to the base address of the
user supplied buffer when calling fault_in_pages_writeable().

Several users have reported that the applications compsize and bees have
started to operate incorrectly since commit a48b73eca4ceb9 ("btrfs: fix
potential deadlock in the search ioctl") was added to stable trees, and
these applications make heavy use of the search ioctls. This fixes their
issues.

Link: https://lore.kernel.org/linux-btrfs/632b888d-a3c3-b085-cdf5-f9bb61017d92@lechevalier.se/
Link: https://github.com/kilobyte/compsize/issues/34
Tested-by: A L <mail@lechevalier.se>
Fixes: a48b73eca4ceb9 ("btrfs: fix potential deadlock in the search ioctl")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5f06aeb71823..b91444e810a5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2194,7 +2194,8 @@ static noinline int search_ioctl(struct inode *inode,
 	key.offset = sk->min_offset;
 
 	while (1) {
-		ret = fault_in_pages_writeable(ubuf, *buf_size - sk_offset);
+		ret = fault_in_pages_writeable(ubuf + sk_offset,
+					       *buf_size - sk_offset);
 		if (ret)
 			break;
 
-- 
2.26.2

