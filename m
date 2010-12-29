From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] btrfs: Require CAP_SYS_ADMIN for filesystem rebalance
Date: Wed, 29 Dec 2010 14:55:03 +0000
Message-ID: <1293634503.2928.132.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org, 608185@bugs.debian.org,
	Aron Xu <happyaron.xu@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Filesystem rebalancing (BTRFS_IOC_BALANCE) affects the entire
filesystem and may run uninterruptibly for a long time.  This does not
seem to be something that an unprivileged user should be able to do.

Reported-by: Aron Xu <happyaron.xu@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cc04dc1..2313e8b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -22,6 +22,7 @@
 #include <linux/blkdev.h>
 #include <linux/random.h>
 #include <linux/iocontext.h>
+#include <linux/capability.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
@@ -1905,6 +1906,9 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	mutex_lock(&dev_root->fs_info->volume_mutex);
 	dev_root = dev_root->fs_info->dev_root;
 
-- 
1.7.2.3


