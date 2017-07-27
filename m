Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751719AbdG0IRE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 04:17:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 492E2ADDC
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 08:17:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs-progs: Use already defined BTRFS_BLOCK_GROUP_PROFILE_MASK
Date: Thu, 27 Jul 2017 11:16:59 +0300
Message-Id: <1501143420-28062-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of opencoding it. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 volumes.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/volumes.c b/volumes.c
index b350e259dded..e60dc0e0dd93 100644
--- a/volumes.c
+++ b/volumes.c
@@ -869,10 +869,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		return -ENOSPC;
 	}
 
-	if (type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-		    BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
-		    BTRFS_BLOCK_GROUP_RAID10 |
-		    BTRFS_BLOCK_GROUP_DUP)) {
+	if (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
 		if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 			calc_size = SZ_8M;
 			max_chunk_size = calc_size * 2;
-- 
2.7.4

