Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48110 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968467AbeE3Gzq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:55:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4U6pOZk032090
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:45 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2j9ev890f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:45 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6ti2S016819
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:44 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4U6tied017313
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:44 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] fix device_list_mutex usage and cleanups in device_list_add()
Date: Wed, 30 May 2018 14:58:15 +0800
Message-Id: <20180530065821.28385-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1/6 is a preparatory patch to add the required device_list_mutex
in device_list_add() in the patch 2/6.

Patch 3/6 updates the comments on device_list_mutex.

Patch 4/6 is just a cleanup patch no functional changes.

Patch 5/6 adds the required device_list_mutex in
btrfs_free_stale_device().

Patch 6/6 renames btrfs_free_stale_device() to free_stale_device(), no
functional changes.

Anand Jain (6):
  btrfs: do btrfs_free_stale_devices() outside of device_list_add()
  btrfs: fix device_list_add() missing device_list_mutex()
  btrfs: update device_list_mutex protected items
  btrfs: btrfs_free_stale_devices() rename local variables
  btrfs: fix btrfs_free_stale_devices() with needed locks
  btrfs: rename btrfs_free_stale_devices drop btrfs prefix

 fs/btrfs/volumes.c | 80 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 30 deletions(-)

-- 
2.7.0

