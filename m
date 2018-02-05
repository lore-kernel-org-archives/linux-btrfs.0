Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59946 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752738AbeBESJD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Feb 2018 13:09:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w15I2NTO063157
        for <linux-btrfs@vger.kernel.org>; Mon, 5 Feb 2018 18:09:02 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2fxv5w0247-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Feb 2018 18:09:02 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w15HxVQD031650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 5 Feb 2018 17:59:31 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w15HxVpt028276
        for <linux-btrfs@vger.kernel.org>; Mon, 5 Feb 2018 17:59:31 GMT
From: Nikita Gerasimov <nikita.gerasimov@oracle.com>
Subject: How to efficiently remove a subvolume with children located further
 than BTRFS_INO_LOOKUP_PATH_MAX?
To: linux-btrfs@vger.kernel.org
Message-ID: <1ea28071-c539-b923-e75f-dc1cf21b8414@oracle.com>
Date: Mon, 5 Feb 2018 20:59:28 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I have an issue with recursively subvolume deletion when child created further than PATH_MAX.

As I understand current algorithm is:
- Find child by BTRFS_IOC_TREE_SEARCH, which is work fine.
- Get relative path to child by BTRFS_IOC_INO_LOOKUP. (that's a problem)
- Open child fd and recursively repeat until BTRFS_IOC_TREE_SEARCH could found something.

So when relative path is not fit into BTRFS_INO_LOOKUP_PATH_MAX,
BTRFS_IOC_INO_LOOKUP return ENAMETOOLONG and zeros as btrfs_ioctl_ino_lookup_args.
The only way I can see by far is walk through parent fs tree to find objects
matching by name with BTRFS_IOC_TREE_SEARCH results and check them byfstat. It doesn't look very good in terms of performance. Is there any 
shorter way to get fd by child btrfs_root_ref?

Also btrfs-progs are fail to delete subvolumes with canonical path > PATH_MAX
because of realpath also return ENAMETOOLONG. At the same time creation by
relative path works fine.

