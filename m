Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33036 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751724AbeCTXbb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 19:31:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2KNNw2M026360
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 23:31:30 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2gubxfg0ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 23:31:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2KNVTlX019358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 23:31:29 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2KNVT9B007187
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 23:31:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] Preparatory to add the csum check in the scan context
Date: Wed, 21 Mar 2018 07:33:14 +0800
Message-Id: <20180320233316.20653-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

 fs/btrfs/disk-io.c | 57 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

-- 
2.15.0

