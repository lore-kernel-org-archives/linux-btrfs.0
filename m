Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55618 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751472AbeCUINO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 04:13:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2L8CfNn005807
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 08:13:13 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2gukp3g03s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 08:13:13 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2L8DCnI030020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 08:13:12 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2L8DCG4025034
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 08:13:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] Preparatory to add the csum check in the scan context
Date: Wed, 21 Mar 2018 16:14:52 +0800
Message-Id: <20180321081454.31560-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v2->v3:
 1/2: Keep the check %(csum_type >= ARRAY_SIZE(btrfs_csum_sizes))
      because it is inline to support future expansion, further
      btrfs-progs is already copied it.
 2/2: Drop pr_err for default error which won't be possible.

v1->v2:
  Merge 2/3 and 3/3
  Use -EUCLEAN for csum mismatch
  Move the error logging to the parent function
  Drop the struct btrfs_fsinfo as the argument for
        btrfs_check_super_csum()
  Do not make btrfs_check_super_csum() nonstatic here, it will be part
        of the patchset which will use the csum in the scan context

Anand Jain (2):
  btrfs: cleanup btrfs_check_super_csum() to check the csum_type to the
    type
  btrfs: return required error from btrfs_check_super_csum

 fs/btrfs/disk-io.c | 53 ++++++++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

-- 
2.15.0

