Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53920 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751870AbeDLC1h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2QmCC042275
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:36 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2h6pn4srr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RZBX003737
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:36 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RZcH006827
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:35 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/15] Review uuid_mutex usage
Date: Thu, 12 Apr 2018 10:29:23 +0800
Message-Id: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

uuid_mutex lock is not a per-fs lock but a global lock. The main aim of
this patch-set is to critically review the usage of this lock, and delete
the unnecessary once. By doing this we improve the concurrency of
device operations across multiple btrfs filesystems is in the system.

patch 1: Was sent before, I am including it here, as its about uuid_mutex.

patch 2-9: Are cleanup and or preparatory patches.

patch 10-14: Drops the uuid_mutex and makes sure there is enough lock,
as discussed in the patch change log.

patch 15: A generic cleanup patch around functions in the same context.

These patches are on top of
  https://github.com/kdave/btrfs-devel.git remove-volume-mutex
And it will be a good idea to go along with the kill-volume-mutex patches.

This is tested with xfstests and there are no _new_ regression. And I am
trying to understand the old regressions, and notice that they are
inconsistent.

Anand Jain (15):
  btrfs: optimize move uuid_mutex closer to the critical section
  btrfs: rename struct btrfs_fs_devices::list
  btrfs: cleanup __btrfs_open_devices() drop head pointer
  btrfs: rename __btrfs_close_devices to close_fs_devices
  btrfs: rename __btrfs_open_devices to open_fs_devices
  btrfs: cleanup find_device() drop list_head pointer
  btrfs: cleanup btrfs_rm_device() promote fs_devices pointer
  btrfs: cleanup btrfs_rm_device() use cur_devices
  btrfs: uuid_mutex in read_chunk_tree, add a comment
  btrfs: drop uuid_mutex in btrfs_free_extra_devids()
  btrfs: drop uuid_mutex in btrfs_open_devices()
  btrfs: drop uuid_mutex in close_fs_devices()
  btrfs: drop uuid_mutex in btrfs_dev_replace_finishing()
  btrfs: drop uuid_mutex in btrfs_destroy_dev_replace_tgtdev()
  btrfs: cleanup btrfs_destroy_dev_replace_tgtdev() localize
    btrfs_fs_devices

 fs/btrfs/dev-replace.c |   3 --
 fs/btrfs/sysfs.c       |   2 +-
 fs/btrfs/volumes.c     | 113 ++++++++++++++++++++++++-------------------------
 fs/btrfs/volumes.h     |   2 +-
 4 files changed, 58 insertions(+), 62 deletions(-)

-- 
2.7.0
