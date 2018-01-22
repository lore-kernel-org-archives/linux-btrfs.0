Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeAVNds (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 08:33:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0MDVoZl023793
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:33:48 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2fngw880s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:33:48 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0MDUnX6031668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:49 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0MDUnZ9016840
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 13:30:49 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 0/4] device_list_add() peparation to add reappearing missing device
Date: Mon, 22 Jan 2018 21:29:39 +0800
Message-Id: <20180122132943.14729-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Apply on top of my patchset
   [PATCH v4 0/6] preparatory work to add device forget
 for conflict free apply. They don't actually depend on
 each other though).

v4->v5:
 @3/4: Fix null pointer dereference of device pointer in fn
 btrfs_scan_one_device() when device_list_add() fails.

v3->v4:
 @3/4: Just return device instead of PTR_ERR(ERR_PTR(device));

v2->v3:
 Fix device_list_add() fn description which was still referring to the
 previous return values.

v1->v2:
 Drop patch 5/5 for uuid_mutex optimize. That was wrong. Thanks Josef.
 In patch 3/5 make btrfs_device * as return.

Cleanup of device_list_add(), mainly in preparation to handle
reappearing missing device which its next reroll will be sent
separately.


*** BLURB HERE ***

Anand Jain (4):
  btrfs: move pr_info into device_list_add
  btrfs: set the total_devices in device_list_add()
  btrfs: get device pointer from device_list_add()
  btrfs: drop devid as device_list_add() arg

 fs/btrfs/volumes.c | 65 +++++++++++++++++++++++-------------------------------
 1 file changed, 28 insertions(+), 37 deletions(-)

-- 
2.7.0

