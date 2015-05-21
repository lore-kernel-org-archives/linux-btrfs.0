Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay101.isp.belgacom.be ([195.238.20.128]:45811 "EHLO
	mailrelay101.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbbEUPzi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 11:55:38 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1 linux-next] btrfs: remove -ENOENT from test values in btrfs_get_acl()
Date: Thu, 21 May 2015 17:55:32 +0200
Message-Id: <1432223732-19057-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_get_acl() calls __btrfs_getxattr() and checks for returned value
to assign acl. Like FIXME presumed, -ENOENT is not part of those
possible values. btrfs_search_slot() explicitly returns 1 when
the key isn't found (see function comment).

This patch also simplifies code by giving NULL value to acl by default.

Previous behavior remains the same:

mkdir d1
(remount)
getfacl d1
	system.posix_acl_access: size: ENODATA
	acl: NULL
	system.posix_acl_default size: ENODATA
	acl: NULL
setfacl -d -m o::rw d1
(remount)
getfacl d1
	system.posix_acl_access: size: ENODATA
	acl: NULL
	system.posix_acl_default size: 28
	acl not NULL
setfacl -m u:<user>:r d1
(remount)
getfacl d1
	system.posix_acl_access: size: 44
	acl: not NULL
	system.posix_acl_default: size: 28
	acl: not NULL
setfacl -k d1
(remount)
getfacl d1
	system.posix_acl_access: size: 44
	acl: not NULL
	system.posix_acl_default: size: ENODATA
	acl: NULL

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/acl.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 9a0124a..988cc52 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -33,7 +33,7 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	int size;
 	const char *name;
 	char *value = NULL;
-	struct posix_acl *acl;
+	struct posix_acl *acl = NULL;
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
@@ -53,14 +53,10 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 			return ERR_PTR(-ENOMEM);
 		size = __btrfs_getxattr(inode, name, value, size);
 	}
-	if (size > 0) {
+	if (size > 0)
 		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-	} else if (size == -ENOENT || size == -ENODATA || size == 0) {
-		/* FIXME, who returns -ENOENT?  I think nobody */
-		acl = NULL;
-	} else {
+	else if (size && size != -ENODATA)
 		acl = ERR_PTR(-EIO);
-	}
 	kfree(value);
 
 	if (!IS_ERR(acl))
-- 
2.4.1

