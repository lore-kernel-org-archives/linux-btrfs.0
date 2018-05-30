Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935202AbeE3GN1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:13:27 -0400
Subject: Re: [PATCH] btrfs: set device state reappearing missing device
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1527576609-9347-1-git-send-email-gujx@cn.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <768a1c25-98c8-da46-11b3-845e15d191a6@oracle.com>
Date: Wed, 30 May 2018 14:16:00 +0800
MIME-Version: 1.0
In-Reply-To: <1527576609-9347-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 05/29/2018 02:50 PM, Gu Jinxiang wrote:
> From: Gu JinXiang <gujx@cn.fujitsu.com>
> 
> patch for commit 921518924084
> ("btrfs: handle dynamically reappearing missing device").
---
v4:
::
. No need to set in_fs_metadata flag as its already set on missing device
---

 > Since BTRFS_DEV_STATE_IN_FS_METADATA will be clear in
 > btrfs_open_one_device,

  Though v4 change log comment is right. But missed the point that
  btrfs_open_one_device() clears it. My bad. Thanks for the catch.

-Anand

> and when alloc a new chunk in
> __btrfs_alloc_chunk, device with BTRFS_DEV_STATE_IN_FS_METADATA
> not be set will be skipped, so it can not alloc chunk correctly.
> 
> And from the source logic, BTRFS_DEV_STATE_IN_FS_METADATA should
> be also set when reapearing a missing device.
> 
> And with this patch, xfstests-dev/tests/btrfs/154 should run
> successfully.
> 
> Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
> ---
>   fs/btrfs/volumes.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8699080ef505..bf8a41b2847e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -849,6 +849,8 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>   
>   			fs_devices->missing_devices--;
>   			clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
> +			set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
> +					&device->dev_state);
>   
>   			if (test_bit(BTRFS_DEV_STATE_WRITEABLE,
>   				     &device->dev_state) &&
> 
