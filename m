Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38620 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933737AbcECBDD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 21:03:03 -0400
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
CC: <vegard.nossum@oracle.com>, <sterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9fa04dd7-13c4-6c24-dddc-4521eccea65c@cn.fujitsu.com>
Date: Tue, 3 May 2016 09:02:56 +0800
MIME-Version: 1.0
In-Reply-To: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Liu Bo wrote on 2016/05/02 11:15 -0700:
> This adds valid checks for super_total_bytes, super_bytes_used and
> super_stripesize.
>
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 4e47849..988d03f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4120,6 +4120,20 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>  	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
>  	 * done later
>  	 */
> +	if (btrfs_super_total_bytes(sb) == 0) {
> +		printk(KERN_ERR "BTRFS: total bytes is zero\n");
> +		ret = -EINVAL;
> +	}

Would it be better if using "6 * nodesize"?

I'd like to use a precious low limit on total bytes, but we don't have 
such value, so 6 nodesize would be good.

Thanks,
Qu

> +	if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
> +		printk(KERN_ERR "BTRFS: bytes_used is too small %llu\n",
> +		       btrfs_super_bytes_used(sb));
> +		ret = -EINVAL;
> +	}
> +	if (btrfs_super_stripesize(sb) != 4096) {
> +		printk(KERN_ERR "BTRFS: invalid stripesize %u\n",
> +		       btrfs_super_stripesize(sb));
> +		ret = -EINVAL;
> +	}
>  	if (btrfs_super_num_devices(sb) > (1UL << 31))
>  		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
>  				btrfs_super_num_devices(sb));
>


