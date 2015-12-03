Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbbLCQxt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:53:49 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1CD76ADD6
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 16:53:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: use GFP_KERNEL for xattr and acl allocations
Date: Thu,  3 Dec 2015 17:51:58 +0100
Message-Id: <39a27ec1004e886f1d949bdb8f2616896d02c5c2.1449160585.git.dsterba@suse.com>
In-Reply-To: <cover.1449160585.git.dsterba@suse.com>
References: <cover.1449160585.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't have to use GFP_NOFS in context of ACL or XATTR actions, not
possible to loop through the allocator and it's safe to fail with
ENOMEM.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/acl.c   | 4 ++--
 fs/btrfs/xattr.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 9a0124a95851..dbbb8ed53a51 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -48,7 +48,7 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 
 	size = __btrfs_getxattr(inode, name, "", 0);
 	if (size > 0) {
-		value = kzalloc(size, GFP_NOFS);
+		value = kzalloc(size, GFP_KERNEL);
 		if (!value)
 			return ERR_PTR(-ENOMEM);
 		size = __btrfs_getxattr(inode, name, value, size);
@@ -102,7 +102,7 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 
 	if (acl) {
 		size = posix_acl_xattr_size(acl->a_count);
-		value = kmalloc(size, GFP_NOFS);
+		value = kmalloc(size, GFP_KERNEL);
 		if (!value) {
 			ret = -ENOMEM;
 			goto out;
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 1fcd7b6e7564..24e8ff722730 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -494,7 +494,7 @@ static int btrfs_initxattrs(struct inode *inode,
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
-			       strlen(xattr->name) + 1, GFP_NOFS);
+			       strlen(xattr->name) + 1, GFP_KERNEL);
 		if (!name) {
 			err = -ENOMEM;
 			break;
-- 
2.6.2

