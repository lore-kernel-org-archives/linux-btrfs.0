Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31031 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755316AbdIGSYO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2017 14:24:14 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v87IODjM025928
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v87IODNT022348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v87IOCGP003192
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] kill async counters
Date: Thu,  7 Sep 2017 11:22:19 -0600
Message-Id: <20170907172222.20444-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

%async_delalloc_pages and %nr_async_submits are used to indicate that
compressed writeback actually starts its work, but since we have
already used double filemap_flush() alike, we don't need those two any
more.

%nr_async_bios was used to show congestion for writeback, but a later
change adopts bdi_write_congested() to do the same job, it's not
needed, either.

Liu Bo (3):
  Btrfs: remove nr_async_bios
  Btrfs: do not make defrag wait on async_delalloc_pages
  Btrfs: remove nr_async_submits and async_submit_draining

 fs/btrfs/ctree.h   |  3 ---
 fs/btrfs/disk-io.c | 25 -------------------------
 fs/btrfs/inode.c   | 28 ----------------------------
 fs/btrfs/ioctl.c   | 15 ---------------
 fs/btrfs/volumes.c | 14 --------------
 5 files changed, 85 deletions(-)

-- 
2.9.4

