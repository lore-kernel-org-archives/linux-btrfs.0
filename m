Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61814 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbaIKPkC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 11:40:02 -0400
Message-ID: <5411C24A.3090506@fb.com>
Date: Thu, 11 Sep 2014 11:39:54 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 12/18] Btrfs: Fix misuse of chunk mutex
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com> <1409751347-5296-12-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-12-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/03/2014 09:35 AM, Miao Xie wrote:
> There were several problems about chunk mutex usage:
> - Lock chunk mutex when updating metadata. It would cause the nested
>   deadlock because updating metadata might need allocate new chunks
>   that need acquire chunk mutex. We remove chunk mutex at this case,
>   because b-tree lock and other lock mechanism can help us.
> - ABBA deadlock occured between device_list_mutex and chunk_mutex.
>   When we update device status, we must acquire device_list_mutex at the
>   beginning, and then we might get chunk_mutex during the device status
>   update because we need allocate new chunks for metadata COW. But at
>   most place, we acquire chunk_mutex at first and then acquire device list
>   mutex. We need change the lock order.
> - Some place we needn't acquire chunk_mutex. For example we needn't get
>   chunk_mutex when we free a empty seed fs_devices structure.
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9f22398d..357f911 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> 
> @@ -2619,10 +2615,23 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
>  	map = (struct map_lookup *)em->bdev;
>  
>  	for (i = 0; i < map->num_stripes; i++) {
> -		ret = btrfs_free_dev_extent(trans, map->stripes[i].dev,
> -					    map->stripes[i].physical);
> +		device = map->stripes[i].dev;
> +		ret = btrfs_free_dev_extent(trans, device,
> +					    map->stripes[i].physical,
> +					    &dev_extent_len);
>  		BUG_ON(ret);

gcc is worried that dev_extent_len may be used uninitialized here.  The
BUG_ON makes it unlikely we'll notice dev_extent_len, but I set it to
zero in my version here.

-chris
