Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:42897 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdCGV6B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 16:58:01 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v27KbAVA016569
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 20:37:10 GMT
Date: Tue, 7 Mar 2017 12:34:07 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a bogus warning when converting only data or
 metadata
Message-ID: <20170307203406.GC12408@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170307054251.4361-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170307054251.4361-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 06:42:51AM +0100, Adam Borowski wrote:
> If your filesystem has, eg, data:raid0 metadata:raid1, and you run "btrfs
> balance -dconvert=raid1", the meta.target field will be uninitialized.
> That's otherwise ok, as it's unused except for this warning.
> 
> Thus, let's use the existing set of raid levels for the comparison.
> 
> As a side effect, non-convert balances will now nag about data>metadata.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> To reproduce:
> dd if=/dev/zero bs=1048576 count=1 seek=4095 of=ra
> dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rb
> mkfs.btrfs ra rb     # defaults to -draid0 -mraid1
> losetup -f ra
> losetup -f rb
> mount /dev/loop0 /mnt/vol1
> btrfs balance start -dconvert=raid1 /mnt/vol1
> 
>  fs/btrfs/volumes.c | 5 +++++
>  1 file changed, 5 insertions(+)
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3645af2749f8..c016db81ba43 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3846,6 +3846,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>  		}
>  	} while (read_seqretry(&fs_info->profiles_lock, seq));
>  
> +	/* if we're not converting, the target field is uninitialized */
> +	if (!(bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT))
> +		bctl->meta.target = fs_info->avail_metadata_alloc_bits;
> +	if (!(bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT))
> +		bctl->data.target = fs_info->avail_data_alloc_bits;

This looks good, but this also brings another side effect, @bctl would
also be kept in balance_item which will be used to resume balance in
case of crash, so it may see a different bctl->meta.target.

So would you please use local varibles for meta.target and data.target?

Thanks,

-liubo

>  	if (btrfs_get_num_tolerated_disk_barrier_failures(bctl->meta.target) <
>  		btrfs_get_num_tolerated_disk_barrier_failures(bctl->data.target)) {
>  		btrfs_warn(fs_info,
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
