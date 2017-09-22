Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:41938 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVF5Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 01:57:24 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 54C12AC0129
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 14:57:18 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v2 0/3] btrfs: cleanup mount path
Message-ID: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
Date: Fri, 22 Sep 2017 14:56:49 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary:
Cleanup mount path by avoiding calling btrfs_mount() twice.
No functional change.

change to v2: split the patch into three parts.

Long Explanation:
btrfs uses mount_subtree() to mount a subvolume directly.  This function
needs a vfsmount* of device's root (/), which is a return value of
vfs_kern_mount() (therefore root has to be mounted internally anyway).

Current approach of getting root's vfsmount* in mount time is a bit tricky:
1. mount systemcall calls vfs_kern_mount() on the way
2. btrfs_mount() is called 
3. btrfs_parse_early_options() parses "subvolid=" mount option and set the
   value to subvol_objectid. Otherwise, subvol_objectid has the initial
   value of 0
4. check subvol_objectid is 5 or not. This time id is not 5, and
   btrfs_mount() returns by calling mount_subvol()
5. In mount_subvol(), original mount options are modified to contain
   "subvolid=0" in setup_root_args(). Then, vfs_kern_mount() is called with
   this new options to get root's vfsmount*
6. btrfs_mount() is called again
7. btrfs_parse_early_options() parses "subvolid=0" and set 5 (instead of 0)
   to subvol_objectid
8. check subvol_objectid is 5 or not. This time id is 5 and mount_subvol()
   is not called. btrfs_mount() finishes mounting a root
9. (in mount_subvol()) with using a return vale of vfs_kern_mount(), it
   calls mount_subtree()
10 return subvolume's dentry

As illustrated above, calling btrfs_mount() twice complicates the problem.
Callback function of mount time (btrfs_mount()) is specified in struct
file_system_type which is passed to vfs_kern_mount(). Therefore, we can
avoid this by using another file_system_type for arguments of our
vfs_kern_mount() call. There is no need of modifying mount options.

In this approach: 
1. btrfs_mount() is called
2. parse "subvolid=" opiton and set the value to subvol_objectid
3. mount device's root by calling vfs_kern_mount() with different
   file_system_type specified. Then, different callback function is called
   (mount_root()). Most of this new function is the same as the original
   btrfs_mount()
4. return by calling mount_subtree()

I think this approach is the same as nfsv4, which is the only other
filesystem using mount_subtree() currently, and easy to understand.

Most of the change is done by just reorganizing the original code of
btrfs_mount()/mount_subvol() into btrfs_mount()/mount_subvol()/mount_root()

btrfs_parse_early_options() is split into two parts to avoid "device="
option will be handled twice (though it cause no harm). setup_root_args()
is deleted as not needed anymore.

Tomohiro Misono (3):
  change btrfs_mount() to mount_root()
  split parse_early_options() in two
  introduce new btrfs_mount()

 fs/btrfs/super.c | 231 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 128 insertions(+), 103 deletions(-)

-- 
2.9.5

