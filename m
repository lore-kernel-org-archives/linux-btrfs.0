Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27124 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbbBAIC6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 03:02:58 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 00/12] provide frame work so that sysfs attributs from the fs_devices can be added
Date: Sun,  1 Feb 2015 16:01:30 +0800
Message-Id: <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
References: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
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


Anand Jain (12):
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

 fs/btrfs/ctree.h   |   3 --
 fs/btrfs/disk-io.c |   1 -
 fs/btrfs/sysfs.c   | 133 +++++++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/volumes.c |   3 +-
 fs/btrfs/volumes.h |   6 +++
 5 files changed, 107 insertions(+), 39 deletions(-)


Anand Jain (1):
  Btrfs-progs: add regression tests for sysfs contents during btrfs
    device management

 tests/test-btrfs-devmgt.sh | 863 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 863 insertions(+)
 create mode 100755 tests/test-btrfs-devmgt.sh
-- 
1.9.1

