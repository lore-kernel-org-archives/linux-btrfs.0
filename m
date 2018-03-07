Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47475 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751116AbeCGH52 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 02:57:28 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4.4 1/2] btrfs: Don't clear SGID when inheriting ACLs
Date: Wed,  7 Mar 2018 09:57:23 +0200
Message-Id: <1520409444-24654-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
set, DIR1 is expected to have SGID bit set (and owning group equal to
the owning group of 'DIR0'). However when 'DIR0' also has some default
ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
'DIR1' to get cleared if user is not member of the owning group.

Fix the problem by moving posix_acl_update_mode() out of
__btrfs_set_acl() into btrfs_set_acl(). That way the function will not be
called when inheriting ACLs which is what we want as it prevents SGID
bit clearing and the mode has been properly set by posix_acl_create()
anyway.

Fixes: 073931017b49d9458aa351605b43a7e34598caef
CC: stable@vger.kernel.org
CC: linux-btrfs@vger.kernel.org
CC: David Sterba <dsterba@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/acl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index fb3e64d37cb4..233bbc8789e0 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -82,12 +82,6 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name = POSIX_ACL_XATTR_ACCESS;
-		if (acl) {
-			ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
-			if (ret)
-				return ret;
-		}
-		ret = 0;
 		break;
 	case ACL_TYPE_DEFAULT:
 		if (!S_ISDIR(inode->i_mode))
@@ -123,6 +117,13 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 
 int btrfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
+	int ret;
+
+	if (type == ACL_TYPE_ACCESS && acl) {
+		ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+		if (ret)
+			return ret;
+	}
 	return __btrfs_set_acl(NULL, inode, acl, type);
 }
 
-- 
2.7.4

