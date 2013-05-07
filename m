Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:22614 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab3EGR2F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 13:28:05 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp4) (RZmta 31.27 OK)
	with ESMTP id 601f81p479KFeT for <linux-btrfs@vger.kernel.org>;
	Tue, 7 May 2013 19:28:03 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: don't allow device replace on RAID5/RAID6
Date: Tue,  7 May 2013 19:28:03 +0200
Message-Id: <1367947683-11693-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is not yet supported and causes crashes. One sad user reported
that it destroyed his filesystem.

One failure is in __btrfs_map_block+0xc1f calling kmalloc(0).

0x5f21f is in __btrfs_map_block (fs/btrfs/volumes.c:4923).
4918                            num_stripes = map->num_stripes;
4919                            max_errors = nr_parity_stripes(map);
4920
4921                            raid_map = kmalloc(sizeof(u64) * num_stripes,
4922                                               GFP_NOFS);
4923                            if (!raid_map) {
4924                                    ret = -ENOMEM;
4925                                    goto out;
4926                            }
4927

There might be more issues. Until this is really tested, don't allow
users to start the procedure on RAID5/RAID6 filesystems.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/dev-replace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 7ba7b39..65241f3 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -313,6 +313,11 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	struct btrfs_device *tgt_device = NULL;
 	struct btrfs_device *src_device = NULL;
 
+	if (btrfs_fs_incompat(fs_info, RAID56)) {
+		pr_warn("btrfs: dev_replace cannot yet handle RAID5/RAID6\n");
+		return -EINVAL;
+	}
+
 	switch (args->start.cont_reading_from_srcdev_mode) {
 	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS:
 	case BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID:
-- 
1.8.2.2

