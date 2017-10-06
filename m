Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36130 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbdJFPWq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 11:22:46 -0400
Subject: Re: [PATCH 1/3] btrfs: scrub: get rid of sector_t
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1507292872.git.dsterba@suse.com>
 <9321364229bba40851c35fa63ba37c90ee1edf0a.1507292872.git.dsterba@suse.com>
Cc: bo.li.liu@oracle.com
From: Edmund Nadolski <enadolski@suse.de>
Message-ID: <6c8e69c0-6abf-acc9-9ea5-687f33a50726@suse.de>
Date: Fri, 6 Oct 2017 09:22:42 -0600
MIME-Version: 1.0
In-Reply-To: <9321364229bba40851c35fa63ba37c90ee1edf0a.1507292872.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/06/2017 06:29 AM, David Sterba wrote:
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

Just a thought, 'physical' alone seems a bit ambiguous, so
a comment to add context would help clarify.


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

This still says 'sector' here but was changed for the other print strings.


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

Dropping the '>> 9', so this is a semantic change in addition to the rename?


Thx,
Ed
