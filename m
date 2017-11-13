Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31831 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdKMFoA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 00:44:00 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAD5hx7r001470
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:43:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAD5hx3l025306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:43:59 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAD5hwc2025070
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:43:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] Add cli and ioctl to ignore a scanned device
Date: Mon, 13 Nov 2017 13:44:08 +0800
Message-Id: <20171113054410.24872-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1/2 is preparatory patch to get a function to delete a device
  from the list.
Patch 2/2 adds the ioctl and feature to delete a device from the
device list.

Anand Jain (2):
  btrfs: refactor btrfs_free_stale_device() to get device list delete
  btrfs: introduce feature to ignore a btrfs device

 fs/btrfs/super.c           |  4 ++
 fs/btrfs/volumes.c         | 97 +++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.h         |  2 +
 include/uapi/linux/btrfs.h |  2 +
 4 files changed, 95 insertions(+), 10 deletions(-)

-- 
2.13.1

