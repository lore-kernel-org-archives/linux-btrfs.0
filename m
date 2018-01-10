Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752676AbeAJFRG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 00:17:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0A5H5gG009707
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:17:05 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2fd8bdrhee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:17:04 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0A5ESpP015830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:28 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0A5EShR015703
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:28 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/6] preparatory work to add device forget
Date: Wed, 10 Jan 2018 13:15:17 +0800
Message-Id: <20180110051523.3681-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v3->v4:
 Mainly fix as per comments from Josef.
 @3/6: rename btrfs_free_stale_device() to btrfs_free_stale_devices()
 @4/6: reorg logic, init not_found = 0; drop else part
 @5/6: added new in v4. Renames arg cur_dev to skip_dev
 @6/6: v3:5/6 is merged to v4:6/6
 checkpath error fixes.

v2->v3:
 @ 6/6:
 add btrfs_free_stale_device() fn description, suggested by Nikolay
 Fix line with longer than 80 char
 
v1->v2:
 @ 6/6:
 btrfs_device::name is null when we have missing device and
 unmounted. So we still need to check for dev->name.

We can reuse the function btrfs_free_stale_device() to add feature
to forget a scanned device or all stale devices. So this patch set
proposes following changes to it.

Anand Jain (6):
  btrfs: cleanup btrfs_free_stale_device() usage
  btrfs: no need to check for btrfs_fs_devices::seeding
  btrfs: make btrfs_free_stale_device() to iterate all stales
  btrfs: make btrfs_free_stale_device() argument optional
  btrfs: rename btrfs_free_stale_devices() arg to skip_dev
  btrfs: make btrfs_free_stale_device() to match the path

 fs/btrfs/volumes.c | 59 +++++++++++++++++++++++-------------------------------
 1 file changed, 25 insertions(+), 34 deletions(-)

-- 
2.7.0

