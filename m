Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53703 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab3BEBaI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 20:30:08 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 5E0E37C035E
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Feb 2013 18:23:19 -0700 (MST)
Date: Mon, 4 Feb 2013 20:23:16 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: experimental raid5/6 code in git
Message-ID: <20130205012316.GB28437@shiny>
References: <20130202160212.GB4694@shiny>
 <51102B40.6000207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51102B40.6000207@zytor.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 04, 2013 at 02:42:24PM -0700, H. Peter Anvin wrote:
> @@ -1389,6 +1392,14 @@ int btrfs_rm_device(struct btrfs_root *root, char
> *device_path)
>  	}
>  	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
> 
> +	if ((all_avail & (BTRFS_BLOCK_GROUP_RAID5 |
> +			  BTRFS_BLOCK_GROUP_RAID6) && num_devices <= 3)) {
> +		printk(KERN_ERR "btrfs: unable to go below three devices "
> +		       "on raid5 or raid6\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
>  		printk(KERN_ERR "btrfs: unable to go below four devices "
>  		       "on raid10\n");
> @@ -1403,6 +1414,21 @@ int btrfs_rm_device(struct btrfs_root *root, char
> *device_path)
>  		goto out;
>  	}
> 
> +	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
> +	    root->fs_info->fs_devices->rw_devices <= 2) {
> +		printk(KERN_ERR "btrfs: unable to go below two "
> +		       "devices on raid5\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
> +	    root->fs_info->fs_devices->rw_devices <= 3) {
> +		printk(KERN_ERR "btrfs: unable to go below three "
> +		       "devices on raid6\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	if (strcmp(device_path, "missing") == 0) {
>  		struct list_head *devices;
>  		struct btrfs_device *tmp;
> 
> 
> This seems inconsistent?

Whoops, missed that one.  Thanks!

-chris

