Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17665 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdKFIgO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 03:36:14 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA68aDH1001865
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA68aCxC030899
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:13 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA68aCJW005196
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Nov 2017 08:36:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/8] Misc device cleanup patches: part1
Date: Mon,  6 Nov 2017 16:36:11 +0800
Message-Id: <20171106083618.7617-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A miscellaneous device management related cleanup patches. The core
objective of this and upcoming patches is to able to have a clear
clarity on mutex usages and remove redundant codes. And few good
to have fixes.

Anand Jain (7):
  btrfs: optimize use of volume_mutex in btrfs_ioctl_resize()
  btrfs: move user provided string checks outside of volume_mutex
  btrfs: use i_size_read() instead of open code
  btrfs: rename btrfs_add_device to btrfs_add_dev_item
  btrfs: btrfs_rm_device() does not need uuid_mutex
  btrfs: move volume_mutex into btrfs_init_new_device()
  btrfs: rename btrfs_init_new_device() to btrfs_add_device()

 fs/btrfs/ioctl.c   | 64 +++++++++++++++++++++++++++---------------------------
 fs/btrfs/volumes.c | 20 ++++++++++-------
 fs/btrfs/volumes.h |  2 +-
 3 files changed, 45 insertions(+), 41 deletions(-)

-- 
2.13.1

