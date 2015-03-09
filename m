Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19937 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbCIRK1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:10:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 00/26 v4] provide framework so that sysfs attributs from the fs_devices can be added
Date: Tue, 10 Mar 2015 06:38:18 +0800
Message-Id: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch set will provide a framework and help to create attributes
from the structure btrfs_fs_devices which are available even before
fs_info is created. So by moving the parent kobject super_kobj from
fs_info to btrfs_fs_devices, it will help to create attributes
from the btrfs_fs_devices as well.
    
Just to note, this does not change any of the existing btrfs sysfs
external kobject names and its attributes and not even the life
cycle of them. Changes are internal only. And to ensure the same,
this path has been tested with various device operations and,
checking and comparing the sysfs kobjects and attributes with
sysfs kobject and attributes with out this patch, and they remain
same. These test cases are added to the progs as test-btrfs-devmgt.sh,
its patch is below as well.

v3->v4:
  . reorders the patches
  . accepts Dave comment
  . needed stale device clean up, introduced patch..
	520353e Btrfs: free the stale device
  . added cleanups to the patch to support seeding in the patch..
	e311d0a Btrfs: sysfs: support seed devices in the sysfs layout v3
  . added support to show replacing target on the sysfs in the patch..
	e210d55 Btrfs: sysfs: add support to show replacing target in the sysfs

v2->v3:
  . added missing signed-off
  . Dave comment
  . there isn't v2 for individual patch, I marked individual patch v3
    where necessary
v1->v2:
  . adds fresh set of patches from 12 to 24 to support seed fsids
  on btrfs sysfs layout and the related frame work changes
  . the patches 1 to 12 has no changes from the previous submit


Anand Jain (26):
  Btrfs: sysfs: fix, btrfs_release_super_kobj() should to clean up the
    kobject data
  Btrfs: sysfs: fix, fs_info kobject_unregister has init_completion()
    twice
  Btrfs: sysfs: fix, undo sysfs device links
  Btrfs: sysfs: fix, kobject pointer clean up needed after kobject
    release
  Btrfc: sysfs: fix, check if device_dir_kobj is init before destroy
  Btrfs: sysfs: reorder the kobject creations
  Btrfs: sysfs: rename __btrfs_sysfs_remove_one to
    btrfs_sysfs_remove_fsid
  Btrfs: sysfs: introduce function btrfs_sysfs_add_fsid() to create
    sysfs fsid
  Btrfs: sysfs: let default_attrs be separate from the kset
  Btrfs: sysfs: separate device kobject and its attribute creation
  Btrfs: sysfs: move super_kobj and device_dir_kobj from fs_info to
    btrfs_fs_devices
  Btrfs: introduce btrfs_get_fs_uuids to get fs_uuids v2
  Btrfs: sysfs: add pointer to access fs_info from fs_devices v2
  Btrfs: sysfs: provide framework to remove all fsid sysfs kobject v2
  Btrfs: sysfs btrfs_kobj_add_device() pass fs_devices instead of
    fs_info
  Btrfs: sysfs btrfs_kobj_rm_device() pass fs_devices instead of fs_info
  Btrfs: sysfs: make btrfs_sysfs_add_fsid() non static
  Btrfs: sysfs: make btrfs_sysfs_add_device() non static
  Btrfs: sysfs: btrfs_sysfs_remove_fsid() make it non static
  Btrfs: sysfs: separate kobject and attribute creation
  Btrfs: sysfs: add support to add parent for fsid
  Btrfs: sysfs: don't fail seeding for the sake of sysfs kobject issue
    v2
  Btrfs: free the stale device
  Btrfs: sysfs: add support to show replacing target in the sysfs
  Btrfs: sysfs: support seed devices in the sysfs layout v3
  Btrfs: create sys/fs/btrfs/fsid when scanned instead of when mounted

 fs/btrfs/ctree.h       |   7 +-
 fs/btrfs/dev-replace.c |   7 +-
 fs/btrfs/disk-io.c     |  26 ++++-
 fs/btrfs/sysfs.c       | 266 +++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/sysfs.h       |  15 ++-
 fs/btrfs/volumes.c     |  99 +++++++++++++++---
 fs/btrfs/volumes.h     |   9 ++
 7 files changed, 345 insertions(+), 84 deletions(-)

-- 
2.0.0.153.g79dcccc

