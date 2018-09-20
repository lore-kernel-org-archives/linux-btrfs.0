Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727029AbeITWqY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 18:46:24 -0400
Date: Thu, 20 Sep 2018 19:01:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v8 4/6] Btrfs: prevent ioctls from interfering with a
 swap file
Message-ID: <20180920170157.GB5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1537419652.git.osandov@fb.com>
 <fa7d168bea119d8c2432833c16103eafcf02130f.1537419652.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fa7d168bea119d8c2432833c16103eafcf02130f.1537419652.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2018 at 10:02:15PM -0700, Omar Sandoval wrote:
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -414,6 +414,14 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  	if (ret)
>  		return ret;
>  
> +	if (btrfs_pinned_by_swapfile(fs_info, src_device)) {
> +		btrfs_info_in_rcu(fs_info,
> +				  "cannot replace device %s (devid %llu) due to active swapfile",

Please un-indent the messages so they fit under 80 columns, the
arguments can stay aligned as before.

> +				  btrfs_dev_name(src_device),
> +				  src_device->devid);
> +		return -ETXTBSY;

I think all the error messages before returning ETXTBUSY or EINVAL
should be btrfs_error or btrfs_warning. The info level can be filtered
out and easily lost in the logs. If there's user intention to activate
the swap it needs to be resolved.

> +	}
> +
>  	ret = btrfs_init_dev_replace_tgtdev(fs_info, tgtdev_name,
>  					    src_device, &tgt_device);
>  	if (ret)
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3626,10 +3634,15 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>  
>  		ret = btrfs_relocate_chunk(fs_info, found_key.offset);
>  		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
> -		if (ret && ret != -ENOSPC)
> -			goto error;
>  		if (ret == -ENOSPC) {
>  			enospc_errors++;
> +		} else if (ret == -ETXTBSY) {
> +			btrfs_info(fs_info,
> +				   "skipping relocation of block group %llu due to active swapfile",

I wonder if this should be visible even on the info level, ie. so it
could be debug. The swap file can be long lived, the balance could be
run several times during that period.

> +				   found_key.offset);
> +			ret = 0;
> +		} else if (ret) {
> +			goto error;
>  		} else {
>  			spin_lock(&fs_info->balance_lock);
>  			bctl->stat.completed++;
