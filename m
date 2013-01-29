Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:36019 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3A2GFR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:05:17 -0500
Received: by mail-ob0-f201.google.com with SMTP id un3so14874obb.4
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 22:05:17 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH] Btrfs: move fs/btrfs/ioctl.h to include/uapi/linux/btrfs.h
Date: Mon, 28 Jan 2013 22:04:50 -0800
Message-Id: <1359439490-4012-2-git-send-email-filbranden@google.com>
In-Reply-To: <1359439490-4012-1-git-send-email-filbranden@google.com>
References: <1359439490-4012-1-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The header file will then be installed under /usr/include/linux so that
userspace applications can refer to Btrfs ioctls by name and use the same
structs used internally in the kernel.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 fs/btrfs/backref.h                             | 2 +-
 fs/btrfs/ctree.h                               | 2 +-
 fs/btrfs/file.c                                | 2 +-
 fs/btrfs/inode.c                               | 2 +-
 fs/btrfs/ioctl.c                               | 2 +-
 fs/btrfs/qgroup.c                              | 2 +-
 fs/btrfs/super.c                               | 2 +-
 fs/btrfs/volumes.h                             | 2 +-
 include/linux/btrfs.h                          | 6 ++++++
 include/uapi/linux/Kbuild                      | 1 +
 fs/btrfs/ioctl.h => include/uapi/linux/btrfs.h | 7 ++++---
 11 files changed, 19 insertions(+), 11 deletions(-)
 create mode 100644 include/linux/btrfs.h
 rename fs/btrfs/ioctl.h => include/uapi/linux/btrfs.h (99%)

diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index d61feca7..310a7f6 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -19,7 +19,7 @@
 #ifndef __BTRFS_BACKREF__
 #define __BTRFS_BACKREF__
 
-#include "ioctl.h"
+#include <linux/btrfs.h>
 #include "ulist.h"
 #include "extent_io.h"
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 547b7b0..53ffd31 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -31,10 +31,10 @@
 #include <trace/events/btrfs.h>
 #include <asm/kmap_types.h>
 #include <linux/pagemap.h>
+#include <linux/btrfs.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
-#include "ioctl.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 841cfe3..2cdf85c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -30,11 +30,11 @@
 #include <linux/statfs.h>
 #include <linux/compat.h>
 #include <linux/slab.h>
+#include <linux/btrfs.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
 #include "btrfs_inode.h"
-#include "ioctl.h"
 #include "print-tree.h"
 #include "tree-log.h"
 #include "locking.h"
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ca7ace7..fa98870 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -39,12 +39,12 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/mount.h>
+#include <linux/btrfs.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
 #include "btrfs_inode.h"
-#include "ioctl.h"
 #include "print-tree.h"
 #include "ordered-data.h"
 #include "xattr.h"
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index afbf3ac..3f7a080 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -42,12 +42,12 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/uuid.h>
+#include <linux/btrfs.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
 #include "btrfs_inode.h"
-#include "ioctl.h"
 #include "print-tree.h"
 #include "volumes.h"
 #include "locking.h"
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a5c8562..a0d6368 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -23,13 +23,13 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/btrfs.h>
 
 #include "ctree.h"
 #include "transaction.h"
 #include "disk-io.h"
 #include "locking.h"
 #include "ulist.h"
-#include "ioctl.h"
 #include "backref.h"
 
 /* TODO XXX FIXME
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d8982e9..231177b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -41,13 +41,13 @@
 #include <linux/slab.h>
 #include <linux/cleancache.h>
 #include <linux/ratelimit.h>
+#include <linux/btrfs.h>
 #include "compat.h"
 #include "delayed-inode.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
 #include "btrfs_inode.h"
-#include "ioctl.h"
 #include "print-tree.h"
 #include "xattr.h"
 #include "volumes.h"
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d3c3939..12bb841 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -21,8 +21,8 @@
 
 #include <linux/bio.h>
 #include <linux/sort.h>
+#include <linux/btrfs.h>
 #include "async-thread.h"
-#include "ioctl.h"
 
 #define BTRFS_STRIPE_LEN	(64 * 1024)
 
diff --git a/include/linux/btrfs.h b/include/linux/btrfs.h
new file mode 100644
index 0000000..22d7991
--- /dev/null
+++ b/include/linux/btrfs.h
@@ -0,0 +1,6 @@
+#ifndef _LINUX_BTRFS_H
+#define _LINUX_BTRFS_H
+
+#include <uapi/linux/btrfs.h>
+
+#endif /* _LINUX_BTRFS_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 19e765f..896ee12 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -68,6 +68,7 @@ header-y += blkpg.h
 header-y += blktrace_api.h
 header-y += bpqether.h
 header-y += bsg.h
+header-y += btrfs.h
 header-y += can.h
 header-y += capability.h
 header-y += capi.h
diff --git a/fs/btrfs/ioctl.h b/include/uapi/linux/btrfs.h
similarity index 99%
rename from fs/btrfs/ioctl.h
rename to include/uapi/linux/btrfs.h
index dabca9c..cffbb58 100644
--- a/fs/btrfs/ioctl.h
+++ b/include/uapi/linux/btrfs.h
@@ -16,8 +16,9 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __IOCTL_
-#define __IOCTL_
+#ifndef _UAPI_LINUX_BTRFS_H
+#define _UAPI_LINUX_BTRFS_H
+#include <linux/types.h>
 #include <linux/ioctl.h>
 
 #define BTRFS_IOCTL_MAGIC 0x94
@@ -499,4 +500,4 @@ struct btrfs_ioctl_send_args {
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
 
-#endif
+#endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.7.11.7

