Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60185 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2FVSNE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 14:13:04 -0400
Received: by wgbdr13 with SMTP id dr13so2058818wgb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 11:13:02 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH] Btrfs: do not return EINVAL instead of ENOMEM from open_ctree()
Date: Fri, 22 Jun 2012 21:13:01 +0300
Message-Id: <1340388781-20791-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When bailing from open_ctree() err is returned, not ret.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1890b1..f06db81 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2244,7 +2244,7 @@ int open_ctree(struct super_block *sb,
 	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
 	if (ret) {
-		ret = -ENOMEM;
+		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
 
-- 
1.7.9.1

