Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbeCZGda (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 02:33:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q6I1HY170500
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:33:29 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2gxufa81d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:33:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q6XSWT017663
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:33:28 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2Q6XSog020482
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:33:28 GMT
Subject: Re: [PATCH v2] handle SB beyond blockcount mkfs.btrfs
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
References: <20180322130141.19894-1-anand.jain@oracle.com>
Message-ID: <669e5acf-cf0d-55c0-2b1b-35ed49559aef@oracle.com>
Date: Mon, 26 Mar 2018 14:35:22 +0800
MIME-Version: 1.0
In-Reply-To: <20180322130141.19894-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Pls ignore this set as I am including these patches
  along with other related changes.

Thanks, Anand


On 03/22/2018 09:01 PM, Anand Jain wrote:
> v2->v1:
>   progs: update change log
>   Adds kernel check if there is a mismatch in the FSID
>     between primary and copy SB
> 
> The kernel patch here checks if all the SB copies are of the
> same fsid.
> 
> The btrfs-progs patch zeros SB if found beyond blockcount.
> mkfs.btrfs -b <blockcount>
> 
> ** CAVEAT **
> On the systems with only the below kernel patch but without the
> btrfs-progs patch below, it shall return the btrfs scan error
> as shown in the example below.
> 
> mkfs.btrfs -fq /dev/sdc
> mkfs.btrfs -fq -b1G /dev/sdc
> ERROR: device scan failed on '/dev/sdc': Invalid argument
> 
> The above error says, mkfs is fine but failed to register/scan
> the device into the kernel. As the kernel now reports an error
> if there is inconsistency in the SB fsid. To overcome this error
> user can apply the btrfs-progs patch OR use dd it zero the stale
> SB manually.
> 
> Anand Jain (1):
>    btrfs: check if the fsid in the primary sb and copy sb are same
> 
>   fs/btrfs/volumes.c | 43 ++++++++++++++++++++++++++++++++-----------
>   1 file changed, 32 insertions(+), 11 deletions(-)
> 
>    btrfs-progs: wipe stale sb copy beyond -b size
> 
>   utils.c | 35 +++++++++++++++++++++++++++++++++++
>   1 file changed, 35 insertions(+)
> 
