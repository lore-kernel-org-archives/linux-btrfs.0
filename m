Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54227 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932227AbeCLQwd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 12:52:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 83BCAADE5
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Mar 2018 16:52:32 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Use sizeof directly instead of a constant variable
Date: Mon, 12 Mar 2018 18:52:28 +0200
Message-Id: <1520873548-26667-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel would like to have all stack VLA usage removed[1].
Unfortunately using an integer constant variable as the size of an
array is still considered a VLA. Instead let's use directly sizeof(var)
which removes the VLA usage. Use the occasion to remove csum_size
altogether and use sizeof() also for the size passed to memcmp

[1]: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3809d6d66f6a..6247162e334a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -403,8 +403,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 
 	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
 		u32 crc = ~(u32)0;
-		const int csum_size = sizeof(crc);
-		char result[csum_size];
+		char result[sizeof(crc)];
 
 		/*
 		 * The super_block structure does not span the whole
@@ -415,7 +414,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
 		btrfs_csum_final(crc, result);
 
-		if (memcmp(raw_disk_sb, result, csum_size))
+		if (memcmp(raw_disk_sb, result, sizeof(crc)))
 			ret = 1;
 	}
 
-- 
2.7.4

