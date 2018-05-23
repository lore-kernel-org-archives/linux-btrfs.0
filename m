Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55800 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753872AbeEWGcj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 02:32:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4N6PMjA017405
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 06:32:39 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2j4nh7afgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 06:32:38 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4N6WbUH017439
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 06:32:38 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4N6WbLL014647
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 06:32:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/3] btrfs: balance: improve kernel logs
Date: Wed, 23 May 2018 14:35:05 +0800
Message-Id: <20180523063508.18695-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v3->v4:
 Pls ref to individual patches.

Based on misc-next.

v2->v3:
  Inspried by describe_relocation(), improves it, makes it a helper
  function and use it to log the balance operations.

Kernel logs are very important for the forensic investigations of the
issues, these patchs make balance logs easy to review.

Anand Jain (3):
  btrfs: add helper function describe_block_group()
  btrfs: balance: add args info during start and resume
  btrfs: balance: add kernel log for end or paused

 fs/btrfs/relocation.c |  30 ++---------
 fs/btrfs/volumes.c    | 146 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h    |   1 +
 3 files changed, 147 insertions(+), 30 deletions(-)

-- 
2.7.0

