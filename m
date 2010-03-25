From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 15/16] BTRFS ioctl.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:45 +0100
Message-ID: <1269537767-7553-15-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
	Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <josef@redhat.com>, Sage Weil <sage@newdream.net>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: linux-doc@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
List-ID: <linux-btrfs.vger.kernel.org>

fs/btrfs/ioctl.c: ctree.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
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
1.7.0.3.296.g9776a

