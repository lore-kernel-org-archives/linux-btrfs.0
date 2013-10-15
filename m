Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52856 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab3JORo7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 13:44:59 -0400
Received: by mail-wi0-f176.google.com with SMTP id l12so5480792wiv.3
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 10:44:58 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix incorrect inode acl reset
Date: Tue, 15 Oct 2013 18:44:00 +0100
Message-Id: <1381859040-11211-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a directory has a default ACL and a subdirectory is created
under that directory, btrfs_init_acl() is called when the
subdirectory's inode is created to initialize the inode's ACL
(inherited from the parent directory) but it was clearing the ACL
from the inode after setting it if posix_acl_create() returned
success, instead of clearing it only if it returned an error.

To reproduce this issue:

$ mkfs.btrfs -f /dev/loop0
$ mount /dev/loop0 /mnt
$ mkdir /mnt/acl
$ setfacl -d --set u::rwx,g::rwx,o::- /mnt/acl
$ getfacl /mnt/acl
user::rwx
group::rwx
other::r-x
default:user::rwx
default:group::rwx
default:other::---

$ mkdir /mnt/acl/dir1
$ getfacl /mnt/acl/dir1
user::rwx
group::rwx
other::---

After unmounting and mounting again the filesystem, fgetacl returned the
expected ACL:

$ umount /mnt/acl
$ mount /dev/loop0 /mnt
$ getfacl /mnt/acl/dir1
user::rwx
group::rwx
other::---
default:user::rwx
default:group::rwx
default:other::---

Meaning that the underlying xattr was persisted.

Reported-by: Giuseppe Fierro <giuseppe@fierro.org>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index e15d2b0..0890c83 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -229,7 +229,7 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 		if (ret > 0) {
 			/* we need an acl */
 			ret = btrfs_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
-		} else {
+		} else if (ret < 0) {
 			cache_no_acl(inode);
 		}
 	} else {
-- 
1.7.9.5

