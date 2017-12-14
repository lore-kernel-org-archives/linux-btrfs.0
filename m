Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:60201 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdLNIYB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 03:24:01 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id D5DD2AC00FE
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:23:55 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 3976EBD67D0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:23:55 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v4 0/4] btrfs: cleanup mount path
Message-ID: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Date: Thu, 14 Dec 2017 17:23:33 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary:
Cleanup mount path by avoiding calling btrfs_mount() twice.
No functional changes. See below for longer explanation.

Changelog:
v4: 
  - Rebased to v4.15-rc3
      - Change MS_* flags to SB_* flags
      - Change GFP_NOFS to GFP_KERNEL
    - Use if statements instead of switch in parse_early_options() 
    - Name change (mount_root -> btrfs_mount_root) and add some comments

v3:
  Reorganized patches again into four and added comments to the source.
  Each patch can be applied and compiled while maintaining functionality.
  The first one is the preparation and the second one is the main part.
  The last two are small celanups.

v2:
  Split the patch into three parts.

Tomohiro Misono (4):
  btrfs: add btrfs_mount_root() and new file_system_type
  btrfs: cleanup btrfs_mount() using btrfs_mount_root()
  btrfs: split parse_early_options() in two
  btrfs: remove unused setup_root_args()

 fs/btrfs/super.c | 261 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 155 insertions(+), 106 deletions(-)

====================
Background Explanation:
btrfs uses mount_subtree() to mount a subvolume directly.  This function
needs a vfsmount* of device's root (/), which is a return value of
vfs_kern_mount() (therefore root has to be mounted internally anyway).

Current approach of getting root's vfsmount* in mount time is a bit tricky:
0. VFS layer calls vfs_kern_mount() with registered file_system_type
   (for btrfs, btrfs_fs_type). btrfs_mount() is called on the way.
1. btrfs_parse_early_options() parses "subvolid=" mount option and set the
   value to subvol_objectid. Otherwise, subvol_objectid has the initial
	 value of 0
2. check subvol_objectid is 5 or not. This time id is not 5, and
   btrfs_mount() returns by calling mount_subvol()
3. In mount_subvol(), original mount options are modified to contain
   "subvolid=0" in setup_root_args(). Then, vfs_kern_mount() is called with
	 btrfs_fs_type and new options
4. btrfs_mount() is called again
5. btrfs_parse_early_options() parses "subvolid=0" and set 5 (instead of 0)
   to subvol_objectid
6. check subvol_objectid is 5 or not. This time id is 5 and mount_subvol()
   is not called. btrfs_mount() finishes mounting a root
7. (in mount_subvol()) with using a return vale of vfs_kern_mount(), it
   calls mount_subtree()
8 return subvolume's dentry

As illustrated above, calling btrfs_mount() twice complicates the problem.
We can use another file_system_type (which has different callback
fucntion to mount root) for arguments of our vfs_kern_mount() call.

In this approach: 
1. parse subvol id related options for later use in mount_subvol()
2. mount device's root by calling vfs_kern_mount() with
   different file_system_type
3. return by calling mount_subvol()

I think this approach is the same as nfsv4, which is the only other
filesystem using mount_subtree() currently, and easy to understand.

Most of the change is done by just reorganizing the original code of
btrfs_mount()/mount_subvol() into btrfs_mount()/mount_subvol()/
btrfs_mount_root()

btrfs_parse_early_options() is split into two parts to avoid "device="
option will be handled twice (though it cause no harm). setup_root_args()
is deleted as not needed anymore.

-- 
2.13.6

