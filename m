Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab3DDPf7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Apr 2013 11:35:59 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r34FZxcN022591
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Apr 2013 11:35:59 -0400
Message-ID: <515D9DDE.5040306@redhat.com>
Date: Thu, 04 Apr 2013 10:35:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jan Safranek <jsafrane@redhat.com>
Subject: [PATCH] btrfs: close any open devices if btrfs_mount fails
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This:

   # mkfs.btrfs /dev/sdb{1,2} ; wipefs -a /dev/sdb1; mount /dev/sdb2 /mnt/test

would lead to a blkdev open/close mismatch when the mount fails, and
a permanently busy (opened O_EXCL) sdb2:

   # wipefs -a /dev/sdb2
   wipefs: error: /dev/sdb2: probing initialization failed: Device or resource busy

It's because btrfs_open_devices() may open some devices, and still
return failure.  So the error unwinding needs to close any open
devices in fs_devices before returning.

Reported-by: Jan Safranek <jsafrane@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note, __btrfs_open_devices is weird; it seems to return success or
failure based on the outcome of the result of the last call
to btrfs_get_bdev_and_sb().  But that's a different bug...

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f6b8859..60c67fa 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1125,7 +1125,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 
 	error = btrfs_open_devices(fs_devices, mode, fs_type);
 	if (error)
-		goto error_fs_info;
+		goto error_close_devices;
 
 	if (!(flags & MS_RDONLY) && fs_devices->rw_devices == 0) {
 		error = -EACCES;
@@ -1161,7 +1161,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	return root;
 
 error_close_devices:
-	btrfs_close_devices(fs_devices);
+	if (fs_devices->opened)
+		btrfs_close_devices(fs_devices);
 error_fs_info:
 	free_fs_info(fs_info);
 	return ERR_PTR(error);

