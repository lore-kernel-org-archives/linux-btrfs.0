Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33393 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbcCTHLi (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Sun, 20 Mar 2016 03:11:38 -0400
From: Flex Liu <fliu@novell.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        Petr Tesarik <ptesarik@suse.com>, Flex Liu <fliu@suse.com>
Subject: [PATCH 1/1] Btrfs: Code Cleanup
Date: Sun, 20 Mar 2016 15:11:11 +0800
Message-Id: <1458457871-25512-1-git-send-email-fliu@novell.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Flex Liu <fliu@suse.com>

In fs/btrfs/volumes.c:2328

        if (seeding_dev) {
                sb->s_flags &= ~MS_RDONLY;
                ret = btrfs_prepare_sprout(root);
                BUG_ON(ret); /* -ENOMEM */
        }

the error code would be return from:

        fs_devs = kzalloc(sizeof(*fs_devs), GFP_NOFS);
        if (!fs_devs)
                return ERR_PTR(-ENOMEM);

Insufficient memory in btrfs would let the kernel panic, it suboptimal.
instead, we should return the error code in btrfs_init_new_device to
btrfs_ioctl.

Hello kernel list.
This is my first patch for kernel, so if I missed some of the guidelines,
please be patient :) I hope everything is explained in the commit message.

Signed-off-by: Flex Liu <fliu@suse.com>
---
 fs/btrfs/volumes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 366b335..5c16f04 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2325,7 +2325,10 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
 		ret = btrfs_prepare_sprout(root);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
+			goto error_trans;
+		}
 	}
 
 	device->fs_devices = root->fs_info->fs_devices;
-- 
2.1.4

