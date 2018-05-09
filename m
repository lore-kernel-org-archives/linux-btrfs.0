Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34317 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934630AbeEIN5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:57:06 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 0/8] Add ioctl to support extended inode flags
Date: Wed,  9 May 2018 15:54:24 +0200
Message-Id: <cover.1525873677.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Changes for v2:
 - dropped renaming of variable from patch "btrfs: rename
   btrfs_flags_to_ioctl to reflect which flags it touches"
 - fixed the error handling in "btrfs: add FS_IOC_FSSETXATTR ioctl"
 - new patch to unify naming of some local variables


I'm about to add this patchset to the main queue for 4.18, unless there
are objections.


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

David Sterba (8):
  btrfs: rename btrfs_update_iflags to reflect which flags it touches
  btrfs: rename btrfs_mask_flags to reflect which flags it touches
  btrfs: rename check_flags to reflect which flags it touches
  btrfs: rename btrfs_flags_to_ioctl to reflect which flags it touches
  btrfs: add helpers for FS_XFLAG_* conversion
  btrfs: add FS_IOC_FSGETXATTR ioctl
  btrfs: add FS_IOC_FSSETXATTR ioctl
  btrfs: unify naming of flags variables for SETFLAGS and XFLAGS

 fs/btrfs/ctree.h |   2 +-
 fs/btrfs/inode.c |   4 +-
 fs/btrfs/ioctl.c | 271 ++++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 213 insertions(+), 64 deletions(-)

-- 
2.16.2

