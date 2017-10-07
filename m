Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23233 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752468AbdJGAUB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 20:20:01 -0400
Date: Fri, 6 Oct 2017 17:15:59 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: scrub: get rid of sector_t
Message-ID: <20171007001559.GF19068@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1507292872.git.dsterba@suse.com>
 <9321364229bba40851c35fa63ba37c90ee1edf0a.1507292872.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9321364229bba40851c35fa63ba37c90ee1edf0a.1507292872.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 06, 2017 at 02:29:56PM +0200, David Sterba wrote:
> The use of sector_t is not necessry, it's just for a warning. Switch to
> u64 and rename the variable. The messages are adjusted as well.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/scrub.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index e3f6c49e5c4d..34ea2e7048c2 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -231,7 +231,7 @@ struct scrub_warning {
>  	struct btrfs_path	*path;
>  	u64			extent_item_size;
>  	const char		*errstr;
> -	sector_t		sector;
> +	u64			physical;
>  	u64			logical;
>  	struct btrfs_device	*dev;
>  };
> @@ -797,10 +797,10 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
>  	 */
>  	for (i = 0; i < ipath->fspath->elem_cnt; ++i)
>  		btrfs_warn_in_rcu(fs_info,
> -				  "%s at logical %llu on dev %s, sector %llu, root %llu, inode %llu, offset %llu, length %llu, links %u (path: %s)",
> +"%s at logical %llu on dev %s, physical %llu, root %llu, inode %llu, offset %llu, length %llu, links %u (path: %s)",
>  				  swarn->errstr, swarn->logical,
>  				  rcu_str_deref(swarn->dev->name),
> -				  (unsigned long long)swarn->sector,
> +				  swarn->physical,
>  				  root, inum, offset,
>  				  min(isize - offset, (u64)PAGE_SIZE), nlink,
>  				  (char *)(unsigned long)ipath->fspath->val[i]);
> @@ -813,7 +813,7 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
>  			  "%s at logical %llu on dev %s, sector %llu, root %llu, inode %llu, offset %llu: path resolving failed with ret=%d",
>  			  swarn->errstr, swarn->logical,
>  			  rcu_str_deref(swarn->dev->name),
> -			  (unsigned long long)swarn->sector,
> +			  swarn->physical,
>  			  root, inum, offset, ret);
>  
>  	free_ipath(ipath);
> @@ -845,7 +845,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
>  	if (!path)
>  		return;
>  
> -	swarn.sector = (sblock->pagev[0]->physical) >> 9;
> +	swarn.physical = sblock->pagev[0]->physical;
>  	swarn.logical = sblock->pagev[0]->logical;
>  	swarn.errstr = errstr;
>  	swarn.dev = NULL;
> @@ -868,10 +868,10 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
>  						      item_size, &ref_root,
>  						      &ref_level);
>  			btrfs_warn_in_rcu(fs_info,
> -				"%s at logical %llu on dev %s, sector %llu: metadata %s (level %d) in tree %llu",
> +"%s at logical %llu on dev %s, physical %llu: metadata %s (level %d) in tree %llu",
>  				errstr, swarn.logical,
>  				rcu_str_deref(dev->name),
> -				(unsigned long long)swarn.sector,
> +				swarn.physical,
>  				ref_level ? "node" : "leaf",
>  				ret < 0 ? -1 : ref_level,
>  				ret < 0 ? -1 : ref_root);

I've got used to ambiguous physical/logical, so not a problem for me.

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
