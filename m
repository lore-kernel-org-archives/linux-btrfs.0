Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52705 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeEPPNr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 11:13:47 -0400
Date: Wed, 16 May 2018 17:11:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Ethan Lien <ethanlien@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Skip some btrfs_cross_ref_exist() check in nocow
 path
Message-ID: <20180516151105.GC6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180516082854.29254-1-ethanlien@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180516082854.29254-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2018 at 04:28:54PM +0800, Ethan Lien wrote:
> In nocow path, we check if the extent is snapshotted in
> btrfs_cross_ref_exist(). We can do the similar check earlier and avoid
> unnecessary search into extent tree.
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>
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

Please add some brief comment why we're taking a shortcut here, thanks.
