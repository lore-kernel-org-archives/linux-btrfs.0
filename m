Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab3G3Rm1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 13:42:27 -0400
Date: Tue, 30 Jul 2013 13:42:17 -0400
From: Dave Jones <davej@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Fix leak in __btrfs_map_block error path
Message-ID: <20130730174217.GA892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we bail out when the stripe alloc fails, we need to undo the
earlier allocation of raid_map.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78b8717..6a0f52f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4671,6 +4671,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	}
 	bbio = kzalloc(btrfs_bio_size(num_alloc_stripes), GFP_NOFS);
 	if (!bbio) {
+		kfree(raid_map);
 		ret = -ENOMEM;
 		goto out;
 	}
