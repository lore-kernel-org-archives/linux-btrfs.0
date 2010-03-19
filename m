From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 1/2] Btrfs: remove duplicated #include
Date: Fri, 19 Mar 2010 23:13:17 +0800
Message-ID: <1269011597-5736-1-git-send-email-weiyi.huang@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Remove duplicated #include('s) in
  fs/btrfs/ioctl.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 fs/btrfs/ioctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2845c6c..5c9f8b3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -48,7 +48,6 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "locking.h"
-#include "ctree.h"
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
-- 
1.6.1.3

