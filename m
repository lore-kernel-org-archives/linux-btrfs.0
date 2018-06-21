Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46307 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933096AbeFUNGm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 09:06:42 -0400
Date: Thu, 21 Jun 2018 15:03:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: Fix indentation
Message-ID: <20180621130350.GM24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620170333.29182-1-bart.vanassche@wdc.com>
 <20180620170333.29182-2-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620170333.29182-2-bart.vanassche@wdc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 10:03:31AM -0700, Bart Van Assche wrote:
>  		if (list_empty(&cache->dirty_list)) {
>  			list_add_tail(&cache->dirty_list,
>  				      &trans->transaction->dirty_bgs);
> -				trans->transaction->num_dirty_bgs++;
> +			trans->transaction->num_dirty_bgs++;

>  		if (!block_group_bits(block_group, flags)) {
> -		    u64 extra = BTRFS_BLOCK_GROUP_DUP |
> +			u64 extra = BTRFS_BLOCK_GROUP_DUP |
>  				BTRFS_BLOCK_GROUP_RAID1 |
>  				BTRFS_BLOCK_GROUP_RAID5 |
>  				BTRFS_BLOCK_GROUP_RAID6 |

In the two cases the indentation makes the code less readable, but

> -	 struct btrfs_ioctl_ino_lookup_args *args;
> -	 struct inode *inode;
> +	struct btrfs_ioctl_ino_lookup_args *args;
> +	struct inode *inode;

> -		 if (!dev->bdev)
> +		if (!dev->bdev)
>  			continue;

this is purely whitespace change that is not applied in general. You
mention that it's reported by smatch, that would be a reason to fix it
so the output is less noisy.
