Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55605 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754839AbdLODwM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 22:52:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF3q1AJ185597
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:52:11 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2ev6fp01x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:52:11 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3l8Nx029192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:09 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3l8Km021861
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:08 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] preparatory work to add device forget
Date: Fri, 15 Dec 2017 11:47:33 +0800
Message-Id: <20171215034739.26090-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can reuse the function btrfs_free_stale_device() to add feature
to forget a scanned device or all stale devices. So this patch set
proposes following changes to it.

Anand Jain (6):
  btrfs: cleanup btrfs_free_stale_device() usage
  btrfs: no need to check for btrfs_fs_devices::seeding
  btrfs: make btrfs_free_stale_device() to delete all stales
  btrfs: make btrfs_free_stale_device() argument optional
  btrfs: make btrfs_free_stale_device() to search given path
  btrfs: cleanup to make btrfs_free_stale_device() readable

 fs/btrfs/volumes.c | 50 +++++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

-- 
2.7.0

