Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54326 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbeCZGih (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 02:38:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q6HRUc063318
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:38:36 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2gxufag1sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:38:36 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q6cYvB022584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:38:35 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q6cY5X031663
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:38:34 GMT
Subject: Re: [PATCH v3 0/2] Preparatory to add the csum check in the scan
 context
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
References: <20180320095310.6355-1-anand.jain@oracle.com>
 <20180321081454.31560-1-anand.jain@oracle.com>
Message-ID: <59fb1970-7bcd-c5f0-43f6-e7d5adb3b07d@oracle.com>
Date: Mon, 26 Mar 2018 14:40:28 +0800
MIME-Version: 1.0
In-Reply-To: <20180321081454.31560-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Pls, ignore this bunch as I have included this with other cleanups.

Thanks, Anand


On 03/21/2018 04:14 PM, Anand Jain wrote:
> v2->v3:
>   1/2: Keep the check %(csum_type >= ARRAY_SIZE(btrfs_csum_sizes))
>        because it is inline to support future expansion, further
>        btrfs-progs is already copied it.
>   2/2: Drop pr_err for default error which won't be possible.
> 
> v1->v2:
>    Merge 2/3 and 3/3
>    Use -EUCLEAN for csum mismatch
>    Move the error logging to the parent function
>    Drop the struct btrfs_fsinfo as the argument for
>          btrfs_check_super_csum()
>    Do not make btrfs_check_super_csum() nonstatic here, it will be part
>          of the patchset which will use the csum in the scan context
> 
> Anand Jain (2):
>    btrfs: cleanup btrfs_check_super_csum() to check the csum_type to the
>      type
>    btrfs: return required error from btrfs_check_super_csum
> 
>   fs/btrfs/disk-io.c | 53 ++++++++++++++++++++++++++---------------------------
>   1 file changed, 26 insertions(+), 27 deletions(-)
> 
