Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752177AbeC3AQv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 20:16:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2U04RiP007752
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:16:50 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2h1abwr21p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:16:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2U07aaX012516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:36 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2U07aBj018368
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:36 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/7] Superblock read and verify cleanups
Date: Fri, 30 Mar 2018 08:09:16 +0800
Message-Id: <20180330000924.11148-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v3->v4:
 Update changelog and signoff.
 Reintroduce explicit check for '-EUCLEAN'
  at Patch 2/8 and 5/8.

v2->v3:
 Squash
  4/8 btrfs: make btrfs_check_super_csum() non static
 to
  6/8 btrfs: verify superblock checksum during scan
 As in the individual patch mentioned
 
v1->v2:
 Various changes suggested by Nicokay. Thanks. For specific changes
 pls ref to the patch.

Patch 1-4/8 are preparatory patches adds cleanups and nonstatic requisites.

Patch 5/8 makes sure that all copies of the superblock have the same fsid
when we scan the device.

Patch 6/8 verifies superblock csum when we read it in the scan context.

Patch 7/8 fixes a bug that we weren't verifying the superblock csum for
the non-latest_bdev.

And 8/8 patch drops the redundant invalidate_bdev() call during mount.

There is a btrfs-progs patch which is a kind of related, as its found that
we weren't wiping the non-overwritten superblock, so it could cause
confusion during the superblock recovery process. So the patch btrfs-progs
1/1 adds code to wipe superblock if we aren't overwriting it.

Now since kernel patch 5/8 checks if all the superblock copies are
pointing to the same fsid on the disk, so the scan will fail if without
the above 1/1 btrfs-progs, as in the example below [1]. However the simple
workaround is to wipe the superblock manually [2] or apply the btrfs-progs
patch below.

[1]
 mkfs.btrfs -qf /dev/sdb <-- 1T disk
 mkfs.btrfs -b 256M  /dev/sdb
 ERROR: device scan failed on /dev/sdb

[2]
 dd if=/dev/zero of=<dev> seek=274877906944 ibs=1 obs=1 count4K

Unfortunately, the error messages should have been failed to register
[3] device into the kernel to be more appropriate to the error.

[3]
        ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
        if (ret < 0) {
                error("device scan failed on '%s': %m", fname);
                ret = -errno;
        }

Patches 1-7/8 were sent independently before. And  I found few more things
to fix alongs the line, and since they are related, so I am sending these
all together. Also, as there are minor changes, like in pr_err strings,
and splitting the unrelated changes into a separate patch, so though I am
thankful for the received reviewed-by, I couldn't include them here. Sorry.

Finally, here I am including the function relations [4] so that it will help
to review the code. And this flow is before these patches were applied.

[4]
In the long term, I suggest deprecating ioctl args which pass device path
(where possible), like in delete-device/replace. And
btrfs_read_dev_one_super() should replace btrfs_read_disk_super()

delete-device/replace:
btrfs_rm_device() || btrfs_dev_replace_by_ioctl()
|_btrfs_find_device_by_devspec()
  |_btrfs_find_device_missing_or_by_path()
    |_btrfs_find_device_by_path()
      |_btrfs_get_bdev_and_sb()
        |_btrfs_read_dev_super()
          |_btrfs_read_dev_one_super()
            |___bread()

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
     | |_read_one_dev()
     |   |_open_seed_devices()
     |     |_btrfs_open_devices(fs_devices->seed only)

scan/ready
|
|_btrfs_scan_one_device(ioctl-arg-dev only)
   |_btrfs_read_disk_super()
     |_read_cache_page_gfp()


Anand Jain (7):
  btrfs: cleanup btrfs_check_super_csum() for better code flow
  btrfs: return required error from btrfs_check_super_csum
  btrfs: cleanup btrfs_read_disk_super() to return std error
  btrfs: check if the fsid in the primary sb and copy sb are same
  btrfs: verify superblock checksum during scan
  btrfs: verify checksum for all devices in mount context
  btrfs: drop the redundant invalidate_bdev()

 fs/btrfs/disk-io.c | 72 ++++++++++++++++++++++++++----------------------------
 fs/btrfs/disk-io.h |  1 +
 fs/btrfs/volumes.c | 72 ++++++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 92 insertions(+), 53 deletions(-)

Anand Jain (1):
  btrfs-progs: wipe copies of the stale superblock beyond -b size

 utils.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)
-- 
2.7.0

