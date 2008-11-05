From: "yanhai zhu" <zhu.yanhai@gmail.com>
Subject: [PATCH] Add a missing return pointer check
Date: Wed, 5 Nov 2008 12:53:50 +0800
Message-ID: <977a2be20811042053r563ed791hfea4f3500eb1e714@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
  This patch adds a missing kzalloc()'s return pointer check in
add_missing_dev().

Thanks,
Zhu Yanhai
---
 fs/btrfs/volumes.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cbb9bb3..1b7ee1f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2259,6 +2259,8 @@ static struct btrfs_device
*add_missing_dev(struct btrfs_root *root,
       struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;

       device = kzalloc(sizeof(*device), GFP_NOFS);
+       if (!device)
+               return NULL;
       list_add(&device->dev_list,
                &fs_devices->devices);
       list_add(&device->dev_alloc_list,
--
1.5.2.5
