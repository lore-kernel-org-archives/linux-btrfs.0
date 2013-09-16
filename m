Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34102 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3IPRnI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 13:43:08 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r8GHh6Pv012086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 17:43:07 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8GHh62w005413
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 17:43:06 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8GHh5IO005408
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 17:43:06 GMT
From: Guangyu Sun <guangyu.sun@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: dir_inode_operations should use btrfs_update_time also
Date: Mon, 16 Sep 2013 10:42:03 -0700
Message-Id: <1379353323-29989-1-git-send-email-guangyu.sun@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 2bc5565286121d2a77ccd728eb3484dff2035b58 (Btrfs: don't update atime on
RO subvolumes) ensures that the access time of an inode is not updated when
the inode lives in a read-only subvolume.
However, if a directory on a read-only subvolume is accessed, the atime is
updated. This results in a write operation to a read-only subvolume. I
believe that access times should never be updated on read-only subvolumes.

To reproduce:

 # mkfs.btrfs -f /dev/dm-3
 (...)
 # mount /dev/dm-3 /mnt
 # btrfs subvol create /mnt/sub
 	Create subvolume '/mnt/sub'
 # mkdir /mnt/sub/dir
 # echo "abc" > /mnt/sub/dir/file
 # btrfs subvol snapshot -r /mnt/sub /mnt/rosnap
 	Create a readonly snapshot of '/mnt/sub' in '/mnt/rosnap'
 # stat /mnt/rosnap/dir
 	File: `/mnt/rosnap/dir'
 	Size: 8         Blocks: 0          IO Block: 4096   directory
 Device: 16h/22d    Inode: 257         Links: 1
 Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
 	Access: 2013-09-11 07:21:49.389157126 -0400
 	Modify: 2013-09-11 07:22:02.330156079 -0400
 	Change: 2013-09-11 07:22:02.330156079 -0400
 # ls /mnt/rosnap/dir
 	file
 # stat /mnt/rosnap/dir
 	File: `/mnt/rosnap/dir'
 	Size: 8         Blocks: 0          IO Block: 4096   directory
 Device: 16h/22d    Inode: 257         Links: 1
 Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
 	Access: 2013-09-11 07:22:56.797151670 -0400
 	Modify: 2013-09-11 07:22:02.330156079 -0400
 	Change: 2013-09-11 07:22:02.330156079 -0400

Reported-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b7c2487..12c2755 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8660,11 +8660,13 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
+	.update_time	= btrfs_update_time,
 };
 static const struct inode_operations btrfs_dir_ro_inode_operations = {
 	.lookup		= btrfs_lookup,
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
+	.update_time	= btrfs_update_time,
 };
 
 static const struct file_operations btrfs_dir_file_operations = {
-- 
1.7.9.5

