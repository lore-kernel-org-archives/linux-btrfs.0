Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725729AbeGREm4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 00:42:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6I3xIFn031969
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 04:07:05 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2k7a3ju8q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 04:07:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6I474fW013106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 04:07:05 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6I4749a000868
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 04:07:04 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PULL] uuid_mutex fixes and cleanups part2
Date: Wed, 18 Jul 2018 12:10:24 +0800
Message-Id: <20180718041024.9089-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These patches we sent independently before and are in the mailing list.
They have been tested successfully using the xfstests. The cyclical
lockdep warning aren't due to these set of patches and they (2) can be
ignored as they are harmless because the threads involved are
ioctl/commit and mount thread which lockdep thinks is warn-able can't
co-exist in the same time space. So this set is ready to be pulled in.
Thanks.

  git@github.com:asj/btrfs-devel.git misc-next-jul18

1/7 has been discussed and reviewed at length, which is drop the
unnecessary uuid_mutex in the btrfs_free_extra_devids().

2/7 fixes the race which syzbot reported.

3/7 as when we sprout we hijack the seed fs_devices, we are bringing
back the seed fs_devices using the clone_fs_devices() instead we could
use our btrfs_scan_one_device() which makes the sprout-ing operation
much cleaner.

4-7/7 are a simple cleanup patches.

Anand Jain (7):
1. btrfs: drop uuid_mutex in btrfs_free_extra_devids()
2. btrfs: fix race between free_stale_devices and close_fs_devices
3. btrfs: do device clone using the btrfs_scan_one_device
4. btrfs: use the assigned fs_devices instead of the dereference
5. btrfs: warn for num_devices below 0
6. btrfs: add helper btrfs_num_devices() to deduce num_devices
7. btrfs: add helper function check device delete able

 fs/btrfs/volumes.c | 106 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 44 deletions(-)

-- 
2.7.0

