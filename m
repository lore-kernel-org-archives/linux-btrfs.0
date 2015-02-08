Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40555 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbbBIH6F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:58:05 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 00/24 V2] provide frame work so that sysfs attributs from the fs_devices can be added
Date: Mon,  9 Feb 2015 07:56:01 +0800
Message-Id: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
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

v1->v2:
  . adds fresh set of patches from 12 to 24 to support seed fsids
  on btrfs sysfs layout and the related frame work changes
  . the patches 1 to 12 has no changes from the previous submit

Anand Jain (24):
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
  Btrfs: sysfs: add pointer to access fs_info from fs_devices
  Btrfs: introduce btrfs_get_fs_uuids
  Btrfs: sysfs: provide framework to remove all fsid kobject
  Btrfs: sysfs btrfs_kobj_add_device() pass fs_devices instead of
    fs_info
  Btrfs: sysfs btrfs_kobj_rm_device() pass fs_devices instead of fs_info
  Btrfs: sysfs: make btrfs_sysfs_add_fsid() non static
  Btrfs: sysfs: make btrfs_sysfs_add_device() non static
  Btrfs: sysfs: btrfs_sysfs_remove_fsid() make it non static
  Btrfs: sysfs: separate kobject and attribute creation
  Btrfs: sysfs: add support to add parent for fsid
  Btrfs: sysfs: don't fail seeding for the sake of sysfs kobject issue
  Btrfs: sysfs: support seed devices in the sysfs layout
  Btrfs: sysfs: add check if super kobject is already initialized

 fs/btrfs/ctree.h       |   3 -
 fs/btrfs/dev-replace.c |   4 +-
 fs/btrfs/disk-io.c     |  19 +++++-
 fs/btrfs/sysfs.c       | 180 ++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/sysfs.h       |  12 ++--
 fs/btrfs/volumes.c     |  46 +++++++++++--
 fs/btrfs/volumes.h     |   7 ++
 7 files changed, 214 insertions(+), 57 deletions(-)

-- 
2.0.0.153.g79dcccc

