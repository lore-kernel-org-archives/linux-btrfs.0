Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751336AbdGRMjM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 08:39:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9005FABB8
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 12:39:11 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Use explicit round_down macro in btrfs resize ioctl handler
Date: Tue, 18 Jul 2017 15:39:08 +0300
Message-Id: <1500381548-10168-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes, just make the code more self-explanatory.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78cf25f6..5101515b4a14 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1600,8 +1600,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		goto out_free;
 	}
 
-	new_size = div_u64(new_size, fs_info->sectorsize);
-	new_size *= fs_info->sectorsize;
+	new_size = round_down(new_size, fs_info->sectorsize);
 
 	btrfs_info_in_rcu(fs_info, "new size for %s is %llu",
 			  rcu_str_deref(device->name), new_size);
-- 
2.7.4

