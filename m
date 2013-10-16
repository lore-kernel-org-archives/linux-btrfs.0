Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761134Ab3JPTKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 15:10:47 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9GJAlVH032562
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 15:10:47 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r9GJAiSE026570
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 15:10:46 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: remove fs/btrfs/compat.h
Date: Wed, 16 Oct 2013 12:10:34 -0700
Message-Id: <1381950634-20490-4-git-send-email-zab@redhat.com>
In-Reply-To: <1381950634-20490-1-git-send-email-zab@redhat.com>
References: <1381950634-20490-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs/btrfs/compat.h only contained trivial macro wrappers of drop_nlink()
and inc_nlink().  This doesn't belong in mainline.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/compat.h      | 7 -------
 fs/btrfs/compression.c | 1 -
 fs/btrfs/dev-replace.c | 1 -
 fs/btrfs/disk-io.c     | 1 -
 fs/btrfs/export.c      | 1 -
 fs/btrfs/extent-tree.c | 1 -
 fs/btrfs/extent_io.c   | 1 -
 fs/btrfs/file.c        | 1 -
 fs/btrfs/inode.c       | 5 ++---
 fs/btrfs/ioctl.c       | 1 -
 fs/btrfs/raid56.c      | 1 -
 fs/btrfs/super.c       | 1 -
 fs/btrfs/tree-log.c    | 9 ++++-----
 fs/btrfs/volumes.c     | 1 -
 14 files changed, 6 insertions(+), 26 deletions(-)
 delete mode 100644 fs/btrfs/compat.h

diff --git a/fs/btrfs/compat.h b/fs/btrfs/compat.h
deleted file mode 100644
index 7c4503e..0000000
--- a/fs/btrfs/compat.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _COMPAT_H_
-#define _COMPAT_H_
-
-#define btrfs_drop_nlink(inode) drop_nlink(inode)
-#define btrfs_inc_nlink(inode)	inc_nlink(inode)
-
-#endif /* _COMPAT_H_ */
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 6aad98c..df019c7 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -32,7 +32,6 @@
 #include <linux/writeback.h>
 #include <linux/bit_spinlock.h>
 #include <linux/slab.h>
-#include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index d3ee6e7..ccfbf8b 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -26,7 +26,6 @@
 #include <linux/kthread.h>
 #include <linux/math64.h>
 #include <asm/div64.h>
-#include "compat.h"
 #include "ctree.h"
 #include "extent_map.h"
 #include "disk-io.h"
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 419968e..1c60ac7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -33,7 +33,6 @@
 #include <linux/uuid.h>
 #include <linux/semaphore.h>
 #include <asm/unaligned.h>
-#include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 4b86916..41422a3 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -5,7 +5,6 @@
 #include "btrfs_inode.h"
 #include "print-tree.h"
 #include "export.h"
-#include "compat.h"
 
 #define BTRFS_FID_SIZE_NON_CONNECTABLE (offsetof(struct btrfs_fid, \
 						 parent_objectid) / 4)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9be5e35..a32b523 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/percpu_counter.h>
-#include "compat.h"
 #include "hash.h"
 #include "ctree.h"
 #include "disk-io.h"
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 46a4022..c7a5089 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -13,7 +13,6 @@
 #include <linux/cleancache.h>
 #include "extent_io.h"
 #include "extent_map.h"
-#include "compat.h"
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "volumes.h"
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d12107e..98b8a81 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -39,7 +39,6 @@
 #include "print-tree.h"
 #include "tree-log.h"
 #include "locking.h"
-#include "compat.h"
 #include "volumes.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d468246..3afe2a6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -43,7 +43,6 @@
 #include <linux/btrfs.h>
 #include <linux/blkdev.h>
 #include <linux/posix_acl_xattr.h>
-#include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -3645,7 +3644,7 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	int ret;
 	ret = __btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
 	if (!ret) {
-		btrfs_drop_nlink(inode);
+		drop_nlink(inode);
 		ret = btrfs_update_inode(trans, root, inode);
 	}
 	return ret;
@@ -5738,7 +5737,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		goto fail;
 	}
 
-	btrfs_inc_nlink(inode);
+	inc_nlink(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = CURRENT_TIME;
 	ihold(inode);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 98d4ffe..81cf9d8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -44,7 +44,6 @@
 #include <linux/uuid.h>
 #include <linux/btrfs.h>
 #include <linux/uaccess.h>
-#include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d0ecfbd..24ac218 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -33,7 +33,6 @@
 #include <linux/raid/xor.h>
 #include <linux/vmalloc.h>
 #include <asm/div64.h>
-#include "compat.h"
 #include "ctree.h"
 #include "extent_map.h"
 #include "disk-io.h"
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2bdaafd..6e20a17 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -42,7 +42,6 @@
 #include <linux/cleancache.h>
 #include <linux/ratelimit.h>
 #include <linux/btrfs.h>
-#include "compat.h"
 #include "delayed-inode.h"
 #include "ctree.h"
 #include "disk-io.h"
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 849b729..540cd57 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -26,7 +26,6 @@
 #include "locking.h"
 #include "print-tree.h"
 #include "backref.h"
-#include "compat.h"
 #include "tree-log.h"
 #include "hash.h"
 
@@ -936,7 +935,7 @@ again:
 					    parent_objectid,
 					    victim_name,
 					    victim_name_len)) {
-				btrfs_inc_nlink(inode);
+				inc_nlink(inode);
 				btrfs_release_path(path);
 
 				ret = btrfs_unlink_inode(trans, root, dir,
@@ -1006,7 +1005,7 @@ again:
 				victim_parent = read_one_inode(root,
 							       parent_objectid);
 				if (victim_parent) {
-					btrfs_inc_nlink(inode);
+					inc_nlink(inode);
 					btrfs_release_path(path);
 
 					ret = btrfs_unlink_inode(trans, root,
@@ -1480,7 +1479,7 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 		if (!inode->i_nlink)
 			set_nlink(inode, 1);
 		else
-			btrfs_inc_nlink(inode);
+			inc_nlink(inode);
 		ret = btrfs_update_inode(trans, root, inode);
 	} else if (ret == -EEXIST) {
 		ret = 0;
@@ -1841,7 +1840,7 @@ again:
 				goto out;
 			}
 
-			btrfs_inc_nlink(inode);
+			inc_nlink(inode);
 			ret = btrfs_unlink_inode(trans, root, dir, inode,
 						 name, name_len);
 			if (!ret)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fe0f2ef..6624ae7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -28,7 +28,6 @@
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
 #include <asm/div64.h>
-#include "compat.h"
 #include "ctree.h"
 #include "extent_map.h"
 #include "disk-io.h"
-- 
1.7.11.7

