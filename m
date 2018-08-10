Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725746AbeHJISE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 04:18:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7A5mbCe108909
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:45 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2kn4sq5ska-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:44 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7A5nhN3011238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:44 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7A5nh8Y020179
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 05:49:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] Misc volume patch set part2
Date: Fri, 10 Aug 2018 13:53:18 +0800
Message-Id: <20180810055321.19730-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch set (2/3 and 3/3) adds helper function to deduce the num_device
(which is the number of the devices when device is mounted, this excludes
the seed device however includes the replacing target). We need to know
the num_device that actually belongs to the FSID without the replacing
target (if it exists) when we are balancing and or when we are trying to
device delete. In both of these cases, it would be wrong to consider
replacing target when reallocating the blockgroups.

This patch as such does not change any of the logic which is already in
the original code, but instead it would bring such a logic at two
locations into a single place/function. But to do that as these two
location uses either WARN_ON or BUG_ON to perform the safety catch so
the first patch does the cleanup and uses ASSERT at both of these
places. And now since these two sections of codes are identical, the 2nd
patch replaces them into a helper function.

Also though the check for num_device > 0 should actually be num_device >
1 OR instead, the check of num_device > 0 should have been after the
num_device--, since we have had already too many comments and added
confusions, I shall leave that part to be fixed at sometime later. So
that the cleanup here is a really a cleanup instead of chaning the
logic in a rough scale.

Last but not least, this patch has gone through a lot of comments on
either to use BUG or return -EINVAL for accidental fall of num_device
below 1, which I wasn't expecting so much of the concerns about
the use of BUG_ON/-EINVAL as its trivial because fundamentally a FS
can't be in the mounted state when num_device < 1.


Anand Jain (3):
  btrfs: drop uuid_mutex in btrfs_free_extra_devids()
  btrfs: assert for num_devices below 0
  btrfs: add helper btrfs_num_devices() to deduce num_devices

 fs/btrfs/volumes.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

-- 
2.7.0
