Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41210 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750777AbdFONIe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 09:08:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E19F2ACBF
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 13:08:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: use GFP_KERNEL in btrfs_calc_avail_data_space
Date: Thu, 15 Jun 2017 15:07:25 +0200
Message-Id: <20170615130725.466-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't hold any locks here. Inidirectly called from statfs.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4f1cdd5058f1..6f2e68b36362 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1927,7 +1927,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	}
 
 	devices_info = kmalloc_array(nr_devices, sizeof(*devices_info),
-			       GFP_NOFS);
+			       GFP_KERNEL);
 	if (!devices_info)
 		return -ENOMEM;
 
-- 
2.13.0

