Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59874 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752715AbeA3G3I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 01:29:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0U6RSrj066648
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:29:08 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2ftfrsgk8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:29:08 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0U6T7gt025168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:29:07 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0U6T7M0015255
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 06:29:07 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] Policy to balance read across mirrored devices
Date: Tue, 30 Jan 2018 14:30:18 +0800
Message-Id: <20180130063020.14850-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of RAID1 and RAID10 devices are mirror-ed, a read IO can
pick any device for reading. This choice of picking a device for
reading should be configurable. In short not one policy would
satisfy all types of workload and configs.

So before we add more policies, this patch-set makes existing
$pid policy configurable from the mount option and adds a devid
based read_mirror device policy. And keeps $pid based policy as
the default option for now. So this mount option helps to try out
different read mirror load balances.

Further we can add more policies on top of it, for example..

  mount -o read_mirror_policy=pid (current, default) [1]
  mount -o read_mirror_policy=<devid> [2]
  mount -o read_mirror_policy=lba (illustration only) [3]
  mount -o read_mirror_policy=ssd (illustration only) [4]
  mount -o read_mirror_policy=io (illustration only) [5]
  mount -o read_mirror_policy=<heuristic1> (illustration only) [6]

[1]
 Current PID based read mirror balance.

[2]
 Set the devid of the device which should be used for read. That
 means all the normal read will go to that particular device only.
 This also helps testing and gives a better control for the test
 scripts including mount context reads.

[3]
 In case of SAN storage, some storage prefers that host access the
 LUN based on the LBA so that there won't be duplications of
 caching on the storage.

[4]
 In case of mix of SSD and HD we may want to use SSD as the primary
 read device.

[5]
 If storage caching is not the bottleneck but the transport layer
 is then read load should be tuned based on the IO load.

[6]
 Or a combination of any of above as per the priority.
 Timofey should consider to base his patch on top of this.
    Btrfs: enchanse raid1/10 balance heuristic

This patch set is on top of the preparatory patch set:
  [PATCH 0/2] Preparatory to add read_mirror mount option


Anand Jain (2):
  btrfs: add mount option read_mirror_policy
  btrfs: add read_mirror_policy parameter devid

 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/super.c   | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c | 18 +++++++++++++++++-
 fs/btrfs/volumes.h |  7 +++++++
 4 files changed, 57 insertions(+), 1 deletion(-)

-- 
2.7.0

