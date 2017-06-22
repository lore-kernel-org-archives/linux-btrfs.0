Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751094AbdFVNbZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 09:31:25 -0400
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 03/11] btrfs: Don't clear SGID when inheriting ACLs
Date: Thu, 22 Jun 2017 15:31:07 +0200
Message-Id: <20170622133115.16968-4-jack@suse.cz>
In-Reply-To: <20170622133115.16968-1-jack@suse.cz>
References: <20170622133115.16968-1-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
---
 fs/btrfs/acl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 247b8dfaf6e5..8d8370ddb6b2 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -78,12 +78,6 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name = XATTR_NAME_POSIX_ACL_ACCESS;
-		if (acl) {
-			ret = posix_acl_update_mode(inode, &inode->i_mode, &acl);
-			if (ret)
-				return ret;
-		}
-		ret = 0;
 		break;
 	case ACL_TYPE_DEFAULT:
 		if (!S_ISDIR(inode->i_mode))
@@ -119,6 +113,13 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 
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
2.12.3

