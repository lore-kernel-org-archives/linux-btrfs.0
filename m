Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36083 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751575AbdF0HCc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 03:02:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3B05DABB8
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 07:02:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Use explicit round_down call rather than open-coding it
Date: Tue, 27 Jun 2017 10:02:25 +0300
Message-Id: <1498546946-6853-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1498546946-6853-1-git-send-email-nborisov@suse.com>
References: <1498546946-6853-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9f4426014490..07cfcc507ba6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4752,7 +4752,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	     btrfs_cmp_device_info, NULL);
 
 	/* round down to number of usable stripes */
-	ndevs -= ndevs % devs_increment;
+	ndevs = round_down(ndevs, devs_increment);
 
 	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
 		ret = -ENOSPC;
-- 
2.7.4

