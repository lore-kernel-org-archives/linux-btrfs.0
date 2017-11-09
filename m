Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36672 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdKIPpY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 10:45:24 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA9FjNYV028470
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA9FjNon009446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:23 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA9FjNUh030733
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Nov 2017 15:45:23 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] factor __btrfs_open_devices()
Date: Thu,  9 Nov 2017 23:45:22 +0800
Message-Id: <20171109154526.23181-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is in preparation to help bring the missing device back to the
alloc list dynamically. As of now if we run 'btrfs dev scan </dev/missing>'
on a mounted FS, nothing happens, there is no code which handles this
condition. So the idea is to fix it by running through the device open
process for the reappeared missing device.

So this patch separates device open steps into a separate function so that
it can be called for a device, instead of for all the devices in the
dev_list. As this function is in the critical mount section, and to show
the src code changes as clearly as possible, I have created 4 no-functional
changes patches, which can be merged together if needed.

Anand Jain (4):
  btrfs: set fs_devices->seed directly
  btrfs: let variable required be declared inside the loop
  btrfs: move check for device generation to the last
  btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()

 fs/btrfs/volumes.c | 125 +++++++++++++++++++++++++++++------------------------
 1 file changed, 69 insertions(+), 56 deletions(-)

-- 
2.13.1

