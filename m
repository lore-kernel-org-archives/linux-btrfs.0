Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39344 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727610AbeGPPve (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 11:51:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6GFJKIq050119
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 15:23:39 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2k7a3jmxh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 15:23:39 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6GFNcqb015158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 15:23:38 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6GFNc7u008287
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 15:23:38 GMT
Subject: Re: [PATCH 0/7] Misc volume patch set part2
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
References: <20180716145812.20836-1-anand.jain@oracle.com>
Message-ID: <6a751b91-3ba1-3093-e531-8165b69b5a8a@oracle.com>
Date: Mon, 16 Jul 2018 23:27:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180716145812.20836-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/16/2018 10:58 PM, Anand Jain wrote:
> As the last set if the pull wasn't integrated due to its pending
> review corrections. Here, I have done them (not much except for adding
> comments and function renames) and so sending it again. Also
> this set clubs other independent patches which are in the mailing list.
> I am explaining the changes of the individual patches in its change list.
> And most of it still remains at v1.
> 
> This can also be pulled from:
> 
>    git@github.com:asj/btrfs-devel.git misc-next-for-kdave-16jul

Sorry please pull from use the branch 'misc-next-for-kdave-17jul' 
instead. I notice that there were some changes since my last
fast-forward. And also here, I have added the following patch
which is non function change patch.
    3696c3aaf81b btrfs: rename btrfs_parse_early_options

Thanks, Anand

> Anand Jain (7):
>    btrfs: drop uuid_mutex in btrfs_free_extra_devids()
>    btrfs: fix race between free_stale_devices and close_fs_devices
>    btrfs: do device clone using the btrfs_scan_one_device
>    btrfs: use the assigned fs_devices instead of the dereference
>    btrfs: warn for num_devices below 0
>    btrfs: add helper btrfs_num_devices() to deduce num_devices
>    btrfs: add helper function check device delete able
> 
>   fs/btrfs/volumes.c | 106 +++++++++++++++++++++++++++++++----------------------
>   1 file changed, 62 insertions(+), 44 deletions(-)
> 
