Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49044 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754949AbeCVM7z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 08:59:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2MCgox0026045
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 12:59:54 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2gvcr0g2gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 12:59:54 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2MCxrCj004792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 12:59:54 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2MCxrkA009450
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 12:59:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] handle SB beyond blockcount mkfs.btrfs
Date: Thu, 22 Mar 2018 21:01:39 +0800
Message-Id: <20180322130141.19894-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v2->v1:
 progs: update change log
 Adds kernel check if there is a mismatch in the FSID
   between primary and copy SB

The kernel patch here checks if all the SB copies are of the
same fsid.

The btrfs-progs patch zeros SB if found beyond blockcount.
mkfs.btrfs -b <blockcount>

** CAVEAT **
On the systems with only the below kernel patch but without the
btrfs-progs patch below, it shall return the btrfs scan error
as shown in the example below.

mkfs.btrfs -fq /dev/sdc
mkfs.btrfs -fq -b1G /dev/sdc
ERROR: device scan failed on '/dev/sdc': Invalid argument

The above error says, mkfs is fine but failed to register/scan
the device into the kernel. As the kernel now reports an error
if there is inconsistency in the SB fsid. To overcome this error
user can apply the btrfs-progs patch OR use dd it zero the stale
SB manually.

Anand Jain (1):
  btrfs: check if the fsid in the primary sb and copy sb are same

 fs/btrfs/volumes.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

  btrfs-progs: wipe stale sb copy beyond -b size

 utils.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

-- 
2.7.0

