Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35584 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752087AbeCWMwC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 08:52:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2NCknX4027388
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:01 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2gw1vvg0s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:01 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2NCq0Qu022419
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:00 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2NCq0l9006475
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:00 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] verify superblock checksum
Date: Fri, 23 Mar 2018 20:53:47 +0800
Message-Id: <20180323125349.26893-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are the threads/context [1] in which we read the superblock(s).
And this patchset will make sure the superblock csum are checked
when they are read in the respective context as show below [1].

This patchset is on top of
  [PATCH v2.1] btrfs: check if the fsid in the primary sb and copy sb are same
which is on top of
  [PATCH 0/3] Preparatory to add the csum check in the scan context

[1]

A. dev delete/replace
(its would have been better if we had just used uuid from the userland,
reading the superblock does not make sense to me, but for legacy purpose
we have to continue to support its ioctl args.).

btrfs_rm_device() || btrfs_dev_replace_by_ioctl()
|_btrfs_find_device_by_devspec()
  |_btrfs_find_device_missing_or_by_path()
    |_btrfs_find_device_by_path()
      |_btrfs_get_bdev_and_sb()
        |_btrfs_read_dev_super()
          |_btrfs_read_dev_one_super()
            |___bread()

B. mount

btrfs_mount_root()
 |
 |_btrfs_parse_early_options (-o device only)
 | |_btrfs_scan_one_device
 |   |_btrfs_read_disk_super()
 |     |_read_cache_page_gfp()
 |
 |_btrfs_scan_one_device(mount-arg-dev only)
 | |_btrfs_read_disk_super()
 |   |_read_cache_page_gfp()
 |
 |
 |_btrfs_open_devices(fsid:all)
 |  |_btrfs_open_one_device()
 |    |_btrfs_get_bdev_and_sb()  <--- invalidate_bdev(fsid:all)
 |      |_btrfs_read_dev_super()
 |        |_btrfs_read_dev_one_super()
 |          |___bread()
 |
 |_btrfs_fill_super()
   |_btrfs_open_ctree()   <-- invalidate_bdev(latest_bdev) <-- redundant
     |_btrfs_read_dev_super(latest_bdev only)
     | |_btrfs_read_dev_one_super(latest_bdev only)
     |   |___bread(latest_bdev)
     |
     |_btrfs_check_super_csum(latest_bdev only) [*]
     |
     |_btrfs_read_chunk_tree
       |_read_one_dev()
         |_open_seed_devices()
           |_btrfs_open_devices(fs_devices->seed only)

C. scan/ready

scan/ready
|_btrfs_scan_one_device(ioctl-arg-dev only)
   |_btrfs_read_disk_super()
     |_read_cache_page_gfp()


Anand Jain (2):
  btrfs: verify checksum when superblock is read for mount
  btrfs: verify checksum when superblock is read for scan

 fs/btrfs/disk-io.c | 35 ++++++++++++++++++-----------------
 fs/btrfs/disk-io.h |  1 +
 fs/btrfs/volumes.c | 32 +++++++++++++++++++++++---------
 3 files changed, 42 insertions(+), 26 deletions(-)

-- 
2.15.0

