Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33945 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdJCP7u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 11:59:50 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93Fxn8u002544
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Oct 2017 15:59:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v93FxnDN023612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Oct 2017 15:59:49 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v93FxnXL002610
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Oct 2017 15:59:49 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
Subject: [PATCH v8 0/2] [RFC] Introduce device state 'failed'
Date: Tue,  3 Oct 2017 23:59:18 +0800
Message-Id: <20171003155920.24925-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When one device fails it has to be closed and marked as failed.
Further it needs sysfs (or some) interface to provide complete
information about the device and the volume status to the user
land from the kernel. Next when the disappeared device reappears
we need to resilver/insync depending on the RAID profile which
should be handled per RAID profile specific.

The efforts here are to fix above three missing items.

To begin with this patch brings a Write/Flush failed device to
a failed state.

Next about bringing the device back to the alloc list and verifying
its consistency and kicking off the re-silvering part that still WIP,
& feedback helps. For RAID1 a convert of single raid profile back to
all raid1 will help. For RAID56 I am backing on Luibo's recent RAID56
write hole work I am yet to look deeper on that. Next for RAID1 there
can be split brain scenario where each of the devices were mounted
independently, so to fix this I planning to set an (new) incompatible
flag if any of the device is written without the other. Now when they
are brought together then incompatible flag should be their on only
one of the device, however if incompatible flag is on both the devices
then its a split brain scenario where user intervention will be required.

On the sysfs part there are patches in the ML which was sent before,
I shall be reviving them as well.

Thanks, Anand

Anand Jain (2):
  btrfs: introduce device dynamic state transition to failed
  btrfs: check device for critical errors and mark failed

 fs/btrfs/ctree.h   |   2 +
 fs/btrfs/disk-io.c |  78 ++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  19 +++++++++-
 4 files changed, 202 insertions(+), 2 deletions(-)

-- 
2.7.0

