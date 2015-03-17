Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20884 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbbCQJwM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 05:52:12 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH RFC] add btrfs_fs_devices and btrfs_device attribute to sysfs
Date: Tue, 17 Mar 2015 09:52:05 +0800
Message-Id: <1426557126-3133-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For review and feedback.

- Provides interface to read struct btrfs_fs_devices and btrfs_device
members.

- This applies on top of Dave integration branch plus the sysfs 
framework patch set 
      [PATCH 00/26 v4] provide framework so that sysfs attributs from the fs_devices can be added
(find it in the ML)

- here the introduced sysfs path:
     /sys/fs/btrfs/<fsid>/device/<uuid>/<attr>
  seems to be too long, having fsid is fine but uuid isn't user
  friendly, I am open to suggestion for anything better. But kindly
  think about the following before suggesting
    there is already the path /sys/fs/btrfs/<fsid>/device/sd<x>
    which points to the sysfs sd<x>, thats useless, but got in first,
    it can't be replaced. So sd<x> dir can't be used.     

- Known intermittent bugs (to be fixed before intergation)
  . kmem leak after running the device-test-suite.
  . null deref, on rcu string during show of uuid/name

Anand Jain (1):
  Btrfs: add sysfs layout to show volume info

 fs/btrfs/dev-replace.c |   5 +
 fs/btrfs/disk-io.c     |  15 +-
 fs/btrfs/sysfs.c       | 531 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/sysfs.h       |  12 +-
 fs/btrfs/volumes.c     |  43 +++-
 fs/btrfs/volumes.h     |  10 +
 6 files changed, 566 insertions(+), 50 deletions(-)

-- 
2.0.0.153.g79dcccc

