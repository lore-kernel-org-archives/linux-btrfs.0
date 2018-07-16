Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53094 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbeGPPWn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 11:22:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6GErr6b032810
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:55 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2k7a3t4tq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:55 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6GEssdf001880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:54 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6GEssfA012327
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/7] Misc volume patch set part2
Date: Mon, 16 Jul 2018 22:58:05 +0800
Message-Id: <20180716145812.20836-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As the last set if the pull wasn't integrated due to its pending
review corrections. Here, I have done them (not much except for adding
comments and function renames) and so sending it again. Also
this set clubs other independent patches which are in the mailing list.
I am explaining the changes of the individual patches in its change list.
And most of it still remains at v1.

This can also be pulled from:

  git@github.com:asj/btrfs-devel.git misc-next-for-kdave-16jul

Anand Jain (7):
  btrfs: drop uuid_mutex in btrfs_free_extra_devids()
  btrfs: fix race between free_stale_devices and close_fs_devices
  btrfs: do device clone using the btrfs_scan_one_device
  btrfs: use the assigned fs_devices instead of the dereference
  btrfs: warn for num_devices below 0
  btrfs: add helper btrfs_num_devices() to deduce num_devices
  btrfs: add helper function check device delete able

 fs/btrfs/volumes.c | 106 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 44 deletions(-)

-- 
2.7.0

