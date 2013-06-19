Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50941 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3FSOTX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Jun 2013 10:19:23 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 35E007C068E
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2013 08:19:23 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id UlqF2pFkZqXI3YBf (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2013 08:19:22 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: check for actual acls rather than just xattrs when caching no acl
Date: Wed, 19 Jun 2013 10:19:20 -0400
Message-ID: <1371651560-4827-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have an optimization that will go ahead and cache no acls on an inode if
there are no xattrs on the inode.  This saves us a lookup later to check the
acls for writes or any other access.  The problem is I use selinux so I always
have an xattr on inodes, so make this test a little smarter and check for the
actual acl hash on the key and if it isn't there then we still get to cache no
acl which makes everybody who uses selinux a little happier.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ecf8b5b..7b9144c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -41,6 +41,7 @@
 #include <linux/mount.h>
 #include <linux/btrfs.h>
 #include <linux/blkdev.h>
+#include <linux/posix_acl_xattr.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -56,6 +57,7 @@
 #include "free-space-cache.h"
 #include "inode-map.h"
 #include "backref.h"
+#include "hash.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -3300,8 +3302,17 @@ static noinline int acls_after_inode_item(struct extent_buffer *leaf,
 {
 	u32 nritems = btrfs_header_nritems(leaf);
 	struct btrfs_key found_key;
+	static u64 xattr_access = 0;
+	static u64 xattr_default = 0;
 	int scanned = 0;
 
+	if (!xattr_access) {
+		xattr_access = btrfs_name_hash(POSIX_ACL_XATTR_ACCESS,
+					strlen(POSIX_ACL_XATTR_ACCESS));
+		xattr_default = btrfs_name_hash(POSIX_ACL_XATTR_DEFAULT,
+					strlen(POSIX_ACL_XATTR_DEFAULT));
+	}
+
 	slot++;
 	while (slot < nritems) {
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
@@ -3311,8 +3322,11 @@ static noinline int acls_after_inode_item(struct extent_buffer *leaf,
 			return 0;
 
 		/* we found an xattr, assume we've got an acl */
-		if (found_key.type == BTRFS_XATTR_ITEM_KEY)
-			return 1;
+		if (found_key.type == BTRFS_XATTR_ITEM_KEY) {
+			if (found_key.offset == xattr_access ||
+			    found_key.offset == xattr_default)
+				return 1;
+		}
 
 		/*
 		 * we found a key greater than an xattr key, there can't
-- 
1.7.7.6

