Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37740 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbcGMNTt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 09:19:49 -0400
Received: by mail-wm0-f42.google.com with SMTP id i5so68917770wmg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jul 2016 06:19:35 -0700 (PDT)
From: Nikolay Borisov <kernel@kyup.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <kernel@kyup.com>
Subject: [PATCH 1/2] btrfs: Ratelimit an info message
Date: Wed, 13 Jul 2016 16:19:14 +0300
Message-Id: <1468415955-30804-1-git-send-email-kernel@kyup.com>
In-Reply-To: <20160713121526.GJ10595@twin.jikos.cz>
References: <20160713121526.GJ10595@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recently during a crash it became apparent that this particular
message can be printed so many times that it causes the softlockup
detector to trigger. Fix it by ratelimiting it
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 62a81ee13a5f..6b58d0620e2f 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -250,7 +250,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 						offset + root->sectorsize - 1,
 						EXTENT_NODATASUM);
 				} else {
-					btrfs_info(BTRFS_I(inode)->root->fs_info,
+					btrfs_info_rl(BTRFS_I(inode)->root->fs_info,
 						   "no csum found for inode %llu start %llu",
 					       btrfs_ino(inode), offset);
 				}
-- 
2.5.0

