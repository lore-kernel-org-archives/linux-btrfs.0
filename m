Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755259AbeCHOFF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:05:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 59320AE07
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:05:03 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs-progs: free-space-cache: Enhance free space
 cache free space check
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180308070231.28876-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4fa56a5c-dfa4-048f-936e-9a36c997a33e@suse.com>
Date: Thu, 8 Mar 2018 16:05:02 +0200
MIME-Version: 1.0
In-Reply-To: <20180308070231.28876-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.03.2018 09:02, Qu Wenruo wrote:
> When we found free space difference between free space cache and block
> group item, we just discard this free space cache.
> 
> Normally such difference is caused by btrfs_reserve_extent() called by
> delalloc which is out of a transaction.
> And since all btrfs_release_extent() is called with a transaction, under
> heavy race free space cache can have less free space than block group
> item.
> 
> Normally kernel will detect such difference and just discard that cache.
> 
> However we must be more careful if free space cache has more free space
> cache, and if that happens, paried with above race one invalid free
> space cache can be loaded into kernel.
> 
> So if we find any free space cache who has more free space then block
> group item, we report it as an error other than ignoring it.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> v2:
>   Fix the timming of free space output.
> ---
>  check/main.c       |  4 +++-
>  free-space-cache.c | 32 ++++++++++++++++++++++++--------
>  2 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 97baae583f04..bc31f7e32061 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -5339,7 +5339,9 @@ static int check_space_cache(struct btrfs_root *root)
>  			error += ret;
>  		} else {
>  			ret = load_free_space_cache(root->fs_info, cache);
> -			if (!ret)
> +			if (ret < 0)
> +				error++;
> +			if (ret <= 0)
>  				continue;
>  		}
>  
> diff --git a/free-space-cache.c b/free-space-cache.c
> index f933f9f1cf3f..9b83a71ca59a 100644
> --- a/free-space-cache.c
> +++ b/free-space-cache.c
> @@ -438,7 +438,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
>  	struct btrfs_path *path;
>  	u64 used = btrfs_block_group_used(&block_group->item);
>  	int ret = 0;
> -	int matched;
> +	u64 bg_free;
> +	s64 diff;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
> @@ -448,18 +449,33 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
>  				      block_group->key.objectid);
>  	btrfs_free_path(path);
>  
> -	matched = (ctl->free_space == (block_group->key.offset - used -
> -				       block_group->bytes_super));
> -	if (ret == 1 && !matched) {
> -		__btrfs_remove_free_space_cache(ctl);
> +	bg_free = block_group->key.offset - used - block_group->bytes_super;
> +	diff = ctl->free_space - bg_free;
> +	if (ret == 1 && diff) {
>  		fprintf(stderr,
> -		       "block group %llu has wrong amount of free space\n",
> -		       block_group->key.objectid);
> +		       "block group %llu has wrong amount of free space, free space cache has %llu block group has %llu\n",nit: Always put units when printing numbers. In this case we are talking
about bytes.
> +		       block_group->key.objectid, ctl->free_space, bg_free);
> +		__btrfs_remove_free_space_cache(ctl);
> +		/*
> +		 * Due to btrfs_reserve_extent() can happen out of > +		 * transaction, but all btrfs_release_extent() happens inside
> +		 * a transaction, so under heavy race it's possible that free
> +		 * space cache has less free space, and both kernel just discard
> +		 * such cache. But if we find some case where free space cache
> +		 * has more free space, this means under certain case such
> +		 * cache can be loaded and cause double allocate.
> +		 *
> +		 * Detect such possibility here.
> +		 */
> +		if (diff > 0)
> +			error(
> +"free space cache has more free space than block group item, this could leads to serious corruption, please contact btrfs developers");

I'm not entirely happy with this message. So they will post to the
mailing list saying something along the lines of "I got this message
what do I do no, please help".  Better to output actionable data so that
the user can post it immediately.

>  		ret = -1;
>  	}
>  
>  	if (ret < 0) {
> -		ret = 0;
> +		if (diff <= 0)
> +			ret = 0;
>  
>  		fprintf(stderr,
>  		       "failed to load free space cache for block group %llu\n",
> 
