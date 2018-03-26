Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46412 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbeCZGcS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 02:32:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q6U0DB159096
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:32:18 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2gxumxg09j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:32:17 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q6WHqb006122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:32:17 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2Q6WHDm020018
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 06:32:17 GMT
Subject: Re: [PATCH 0/2] verify superblock checksum
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
References: <20180323125349.26893-1-anand.jain@oracle.com>
Message-ID: <490278d6-cf1d-53ca-ad96-8ec08684abd0@oracle.com>
Date: Mon, 26 Mar 2018 14:34:11 +0800
MIME-Version: 1.0
In-Reply-To: <20180323125349.26893-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Pls ignore this set as I am including these patches
  in the bigger set.

Thanks, Anand

On 03/23/2018 08:53 PM, Anand Jain wrote:
> Here are the threads/context [1] in which we read the superblock(s).
> And this patchset will make sure the superblock csum are checked
> when they are read in the respective context as show below [1].
> 
> This patchset is on top of
>    [PATCH v2.1] btrfs: check if the fsid in the primary sb and copy sb are same
> which is on top of
>    [PATCH 0/3] Preparatory to add the csum check in the scan context
> 
> [1]
> 
> A. dev delete/replace
> (its would have been better if we had just used uuid from the userland,
> reading the superblock does not make sense to me, but for legacy purpose
> we have to continue to support its ioctl args.).
> 
> btrfs_rm_device() || btrfs_dev_replace_by_ioctl()
> |_btrfs_find_device_by_devspec()
>    |_btrfs_find_device_missing_or_by_path()
>      |_btrfs_find_device_by_path()
>        |_btrfs_get_bdev_and_sb()
>          |_btrfs_read_dev_super()
>            |_btrfs_read_dev_one_super()
>              |___bread()
> 
> B. mount
> 
> btrfs_mount_root()
>   |
>   |_btrfs_parse_early_options (-o device only)
>   | |_btrfs_scan_one_device
>   |   |_btrfs_read_disk_super()
>   |     |_read_cache_page_gfp()
>   |
>   |_btrfs_scan_one_device(mount-arg-dev only)
>   | |_btrfs_read_disk_super()
>   |   |_read_cache_page_gfp()
>   |
>   |
>   |_btrfs_open_devices(fsid:all)
>   |  |_btrfs_open_one_device()
>   |    |_btrfs_get_bdev_and_sb()  <--- invalidate_bdev(fsid:all)
>   |      |_btrfs_read_dev_super()
>   |        |_btrfs_read_dev_one_super()
>   |          |___bread()
>   |
>   |_btrfs_fill_super()
>     |_btrfs_open_ctree()   <-- invalidate_bdev(latest_bdev) <-- redundant
>       |_btrfs_read_dev_super(latest_bdev only)
>       | |_btrfs_read_dev_one_super(latest_bdev only)
>       |   |___bread(latest_bdev)
>       |
>       |_btrfs_check_super_csum(latest_bdev only) [*]
>       |
>       |_btrfs_read_chunk_tree
>         |_read_one_dev()
>           |_open_seed_devices()
>             |_btrfs_open_devices(fs_devices->seed only)
> 
> C. scan/ready
> 
> scan/ready
> |_btrfs_scan_one_device(ioctl-arg-dev only)
>     |_btrfs_read_disk_super()
>       |_read_cache_page_gfp()
> 
> 
> Anand Jain (2):
>    btrfs: verify checksum when superblock is read for mount
>    btrfs: verify checksum when superblock is read for scan
> 
>   fs/btrfs/disk-io.c | 35 ++++++++++++++++++-----------------
>   fs/btrfs/disk-io.h |  1 +
>   fs/btrfs/volumes.c | 32 +++++++++++++++++++++++---------
>   3 files changed, 42 insertions(+), 26 deletions(-)
> 
