Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46872 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaDNNKS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 09:10:18 -0400
Date: Mon, 14 Apr 2014 16:10:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: harald@redhat.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: btrfs: allow mounting btrfs subvolumes with different ro/rw
 options
Message-ID: <20140414131010.GA12764@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Harald Hoyer,

The patch 0723a0473fb4: "btrfs: allow mounting btrfs subvolumes with
different ro/rw options" from Nov 19, 2013, leads to the following
static checker warning:

	fs/btrfs/super.c:1194 mount_subvol()
	warn: 'newargs' was already freed.

fs/btrfs/super.c
  1177  static struct dentry *mount_subvol(const char *subvol_name, int flags,
  1178                                     const char *device_name, char *data)
  1179  {
  1180          struct dentry *root;
  1181          struct vfsmount *mnt;
  1182          char *newargs;
  1183  
  1184          newargs = setup_root_args(data);
  1185          if (!newargs)
  1186                  return ERR_PTR(-ENOMEM);
  1187          mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name,
  1188                               newargs);
  1189          kfree(newargs);
                      ^^^^^^^
Freed.

  1190  
  1191          if (PTR_RET(mnt) == -EBUSY) {
  1192                  if (flags & MS_RDONLY) {
  1193                          mnt = vfs_kern_mount(&btrfs_fs_type, flags & ~MS_RDONLY, device_name,
  1194                                               newargs);
                                                     ^^^^^^^
Used if you have some security stuff enabled.

  1195                  } else {
  1196                          int r;
  1197                          mnt = vfs_kern_mount(&btrfs_fs_type, flags | MS_RDONLY, device_name,
  1198                                               newargs);
                                                     ^^^^^^^
  1199                          if (IS_ERR(mnt))
  1200                                  return ERR_CAST(mnt);
  1201  
  1202                          r = btrfs_remount(mnt->mnt_sb, &flags, NULL);
  1203                          if (r < 0) {
  1204                                  /* FIXME: release vfsmount mnt ??*/
  1205                                  return ERR_PTR(r);
  1206                          }
  1207                  }
  1208          }
  1209  

Also you forgot to Sign your patch.

regards,
dan carpenter
