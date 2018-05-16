Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752404AbeEPCtC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 22:49:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G2k0Wd107838
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:01 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2hx29wathr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:01 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4G2n1Ob029558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:01 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4G2n19B004564
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:01 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: balance: improve kernel logs
Date: Wed, 16 May 2018 10:51:25 +0800
Message-Id: <20180516025128.9899-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel logs are very important for the forensic investigations of the
issues, these patchs make balance logs easy to review.

Anand Jain (3):
  btrfs: balance: prefix kernel logs
  btrfs: balance: add args info during start and resume
  btrfs: balance: add kernel log for end or paused

 fs/btrfs/volumes.c | 185 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 169 insertions(+), 16 deletions(-)

-- 
2.7.0

