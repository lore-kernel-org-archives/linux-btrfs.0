Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbcEDN3x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 09:29:53 -0400
Date: Wed, 4 May 2016 15:29:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com, sterba@suse.com
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
Message-ID: <20160504132935.GU29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 02, 2016 at 11:15:50AM -0700, Liu Bo wrote:
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
> +	if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {

Similar to total_bytes (sum of device->total_bytes), bytes_used is sum
of of all device->used_bytes, which in turn is sum of all block group
sizes on the device.

> +		printk(KERN_ERR "BTRFS: bytes_used is too small %llu\n",
> +		       btrfs_super_bytes_used(sb));
> +		ret = -EINVAL;
> +	}
> +	if (btrfs_super_stripesize(sb) != 4096) {

This is too strict. The stripesize is unused, but we not force it to be
4k, a multiple of nodesize/sectorsize should be enough.

> +		printk(KERN_ERR "BTRFS: invalid stripesize %u\n",
> +		       btrfs_super_stripesize(sb));
> +		ret = -EINVAL;
> +	}
>  	if (btrfs_super_num_devices(sb) > (1UL << 31))
>  		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
>  				btrfs_super_num_devices(sb));
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
