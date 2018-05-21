Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55272 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbeEUGfS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 02:35:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4L6VHaj074934
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:18 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2j29eyb4ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:18 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4L6ZHrb021438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:17 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4L6ZHY5008943
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:17 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] btrfs: balance: improve kernel logs
Date: Mon, 21 May 2018 14:37:42 +0800
Message-Id: <20180521063745.29343-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

 fs/btrfs/relocation.c |  30 +---------
 fs/btrfs/volumes.c    | 157 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h    |   1 +
 3 files changed, 158 insertions(+), 30 deletions(-)

-- 
2.7.0

