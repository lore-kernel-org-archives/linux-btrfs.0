Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42405 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751182AbeEPIbL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 04:31:11 -0400
Subject: Re: [PATCH] btrfs: Skip some btrfs_cross_ref_exist() check in nocow
 path
To: Ethan Lien <ethanlien@synology.com>, linux-btrfs@vger.kernel.org
References: <20180516082854.29254-1-ethanlien@synology.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1fa48d67-813e-c909-93a8-830fc1c3391f@suse.com>
Date: Wed, 16 May 2018 11:31:09 +0300
MIME-Version: 1.0
In-Reply-To: <20180516082854.29254-1-ethanlien@synology.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.05.2018 11:28, Ethan Lien wrote:
> In nocow path, we check if the extent is snapshotted in
> btrfs_cross_ref_exist(). We can do the similar check earlier and avoid
> unnecessary search into extent tree.
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>

If this is supposed to be a performance improvement do you have any
measurements that prove that this is indeed the case?



> ---
>  fs/btrfs/inode.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d241285a0d2a..96927f2ccd4b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1373,6 +1373,9 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  			    btrfs_file_extent_encryption(leaf, fi) ||
>  			    btrfs_file_extent_other_encoding(leaf, fi))
>  				goto out_check;
> +			if (btrfs_file_extent_generation(leaf, fi) <=
> +			    btrfs_root_last_snapshot(&root->root_item))
> +				goto out_check;
>  			if (extent_type == BTRFS_FILE_EXTENT_REG && !force)
>  				goto out_check;
>  			if (btrfs_extent_readonly(fs_info, disk_bytenr))
> @@ -7368,6 +7371,10 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
>  	    btrfs_file_extent_other_encoding(leaf, fi))
>  		goto out;
>  
> +	if (btrfs_file_extent_generation(leaf, fi) <=
> +	    btrfs_root_last_snapshot(&root->root_item))
> +		goto out;
> +
>  	backref_offset = btrfs_file_extent_offset(leaf, fi);
>  
>  	if (orig_start) {
> 
