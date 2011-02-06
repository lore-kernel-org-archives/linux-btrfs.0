From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs - Fix memory leak in btrfs_init_new_device()
Date: Sun, 6 Feb 2011 21:58:21 +0200
Message-ID: <20110206195821.GA14978@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Memory allocated by calling kstrdup() should be freed.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d158530..9649cdd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1601,6 +1601,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 	ret = find_next_devid(root, &device->devid);
 	if (ret) {
+		kfree(device->name);
 		kfree(device);
 		goto error;
 	}
-- 
1.7.2.3

