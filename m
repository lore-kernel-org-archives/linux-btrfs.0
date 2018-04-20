Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54998 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753097AbeDTRFD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 13:05:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 72734AC4F
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 17:05:01 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/7] Add ioctl to support extended inode flags
Date: Fri, 20 Apr 2018 19:02:29 +0200
Message-Id: <cover.1524242295.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset implements the existing VFS ioctls for reading extended
ioctl flags by btrfs.

There are many flags/attributes/extended/combined, the naming is
confusing, so let's recap what we have:

* generic VFS inode flags (i_flags)
  - S_* namespace
  https://elixir.bootlin.com/linux/v4.17-rc1/source/include/linux/fs.h#L1850
  - FS_IOC_GETFLAGS, FS_IOC_SETFLAGS
  - tools: lsatrr, chattr

* btrfs inode flags, on-disk format, independent of the above, with
  to/from conversions
  https://elixir.bootlin.com/linux/v4.17-rc1/source/fs/btrfs/ctree.h#L1416

* extended attributes, also called XATTR, but they're different entity,
  stored by an inode as key:value pairs
  - tools: getfattr, setfattr

* XFLAGs, another interface to the generic S_* flags, new ioctl added
  because [GS]ETFLAGS is frozen, new bits added, eg. for project quotas
  or DAX, and more that originate in XFS features
  https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/fs.h#L168
  - tools: xfs_io -c lsattr, xfs_io -c chattr

In the future, btrfs will probably get:

- nodefrag -- eg. to disable autodefrag or defrag ioctl
- nosymlinks -- for directories, prevent creating new symlinks
- dax

git://github.com/kdave/btrfs-devel dev/xflags

David Sterba (7):
  btrfs: rename btrfs_update_iflags to reflect which flags it touches
  btrfs: rename btrfs_mask_flags to reflect which flags it touches
  btrfs: rename check_flags to reflect which flags it touches
  btrfs: rename btrfs_flags_to_ioctl to reflect which flags it touches
  btrfs: add helpers for FS_XFLAG_* conversion
  btrfs: add FS_IOC_FSGETXATTR ioctl
  btrfs: add FS_IOC_FSSETXATTR ioctl

 fs/btrfs/ctree.h |   2 +-
 fs/btrfs/inode.c |   4 +-
 fs/btrfs/ioctl.c | 185 +++++++++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 170 insertions(+), 21 deletions(-)

-- 
2.16.2

