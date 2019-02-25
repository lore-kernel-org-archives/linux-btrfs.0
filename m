Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256F5C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 19:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE3252084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 19:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfBYTH4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 14:07:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:39130 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbfBYTH4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 14:07:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6DDD4AF7A
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 19:07:55 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 1/3] btrfs: Initialize btrfs_io_ctl instead of memsetting it
Date:   Mon, 25 Feb 2019 13:07:42 -0600
Message-Id: <20190225190744.21664-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

io_ctl_init() memsets it to zero anyways. However, I presume the
memset was added to avoid the WARN_ON in io_ctl_init().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/free-space-cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 74aa552f4793..c813378ebf08 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3544,13 +3544,12 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
 	int ret;
-	struct btrfs_io_ctl io_ctl;
+	struct btrfs_io_ctl io_ctl = {0};
 	bool release_metadata = true;
 
 	if (!btrfs_test_opt(fs_info, INODE_MAP_CACHE))
 		return 0;
 
-	memset(&io_ctl, 0, sizeof(io_ctl));
 	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl, trans);
 	if (!ret) {
 		/*
-- 
2.16.4

