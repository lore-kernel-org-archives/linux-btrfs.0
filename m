Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36891 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaIHMlK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 08:41:10 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so1762030pad.14
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Sep 2014 05:41:10 -0700 (PDT)
Received: from localhost ([1.202.252.122])
        by mx.google.com with ESMTPSA id xj9sm9451667pab.40.2014.09.08.05.41.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 08 Sep 2014 05:41:09 -0700 (PDT)
From: roy.qing.li@gmail.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove the wrong comments
Date: Mon,  8 Sep 2014 20:41:09 +0800
Message-Id: <1410180069-25507-1-git-send-email-roy.qing.li@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Li RongQing <roy.qing.li@gmail.com> 

This comments became wrong after c3c532[bdi: add helper function for
doing init and register of a bdi for a file system], so remove them.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
---
 fs/btrfs/disk-io.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d0ed9e6..ce8b8b6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1703,10 +1703,6 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 	return ret;
 }
 
-/*
- * If this fails, caller must call bdi_destroy() to get rid of the
- * bdi again.
- */
 static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
 {
 	int err;
-- 
1.7.10.4

