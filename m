Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21012 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGYGtH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 02:49:07 -0400
Message-ID: <53D1FEAE.6070600@oracle.com>
Date: Fri, 25 Jul 2014 14:52:30 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs.btrfs: round all device sizes to sectorsize
References: <53D1DCB4.8090409@redhat.com>
In-Reply-To: <53D1DCB4.8090409@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/25/2014 12:27 PM, Eric Sandeen wrote:
> make_btrfs() rounds down the first device size to a multiple of sectorsize:
>
> 	num_bytes = (num_bytes / sectorsize) * sectorsize;
>
> but subsequent device adds don't.
>
> This seems a bit odd & inconsistent, and it makes xfstest btrfs/011
> _notrun(), because it explicitly checks that devices are the same size.
>
> I don't know that there is anything inherently wrong with having
> a few device bytes extend past the last block, but to be consistent,
> it seems like btrfs_add_to_fsid() should round the size in the same
> way.
>
> And now btrfs/011 runs more consistently; the test devices don't
> have to be sectorsize multiples in order for all mkfs'd device
> sizes to match.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> ideally this might go into btrfs_device_size(), but we don't have
> the chosen sector size anywhere near there...
>
> diff --git a/utils.c b/utils.c
> index e130849..4d7ee35 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -554,7 +554,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>   	device->sector_size = sectorsize;
>   	device->fd = fd;
>   	device->writeable = 1;
> -	device->total_bytes = block_count;
> +	device->total_bytes = (block_count / sectorsize) * sectorsize;
>   	device->bytes_used = 0;
>   	device->total_ios = 0;
>   	device->dev_root = root->fs_info->dev_root;


its better to do this at the function btrfs_prepare_device() itself,
so that it would include first and the rest added.
or
we need to apply this on the block_count instead, as we do add
that to the total_bytes.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
