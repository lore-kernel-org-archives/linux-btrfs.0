Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757198AbcK3PcU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 10:32:20 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AEABBABC3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 15:32:18 +0000 (UTC)
Date: Wed, 30 Nov 2016 16:32:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs-progs: Fix extents after finding all errors
Message-ID: <20161130153215.GQ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161110150147.19766-1-rgoldwyn@suse.de>
 <20161110150147.19766-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161110150147.19766-2-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2016 at 09:01:47AM -0600, Goldwyn Rodrigues wrote:
> Simplifying the logic of fixing.
> 
> Calling fixup_extent_ref() after encountering every error causes
> more error messages after the extent is fixed. In case of multiple errors,
> this is confusing because the error message is displayed after the fix
> message and it works on stale data. It is best to show all errors and
> then fix the extents.
> 
> Set a variable and call fixup_extent_ref() if it is set. err is not used,
> so cleared it.

Sounds ok, more comments below.

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  cmds-check.c | 75 +++++++++++++++++++-----------------------------------------
>  1 file changed, 24 insertions(+), 51 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 779870a..8fa0b38 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -8994,6 +8994,9 @@ out:
>  			ret = err;
>  	}
>  
> +	if (!ret)
> +		fprintf(stderr, "Repaired extent references for %llu\n", (unsigned long long)rec->start);

Line too long, please stick to ~80 chars, here it's easy to break line
after string.

> +
>  	btrfs_release_path(&path);
>  	return ret;
>  }
> @@ -9051,7 +9054,11 @@ static int fixup_extent_flags(struct btrfs_fs_info *fs_info,
>  	btrfs_set_extent_flags(path.nodes[0], ei, flags);
>  	btrfs_mark_buffer_dirty(path.nodes[0]);
>  	btrfs_release_path(&path);
> -	return btrfs_commit_transaction(trans, root);
> +	ret = btrfs_commit_transaction(trans, root);
> +	if (!ret)
> +		fprintf(stderr, "Repaired extent flags for %llu\n", (unsigned long long)rec->start);
> +
> +	return ret;
>  }
>  
>  /* right now we only prune from the extent allocation tree */
> @@ -9178,11 +9185,8 @@ static int check_extent_refs(struct btrfs_root *root,
>  {
>  	struct extent_record *rec;
>  	struct cache_extent *cache;
> -	int err = 0;
>  	int ret = 0;
> -	int fixed = 0;
>  	int had_dups = 0;
> -	int recorded = 0;
>  
>  	if (repair) {
>  		/*
> @@ -9251,9 +9255,8 @@ static int check_extent_refs(struct btrfs_root *root,
>  
>  	while(1) {
>  		int cur_err = 0;
> +		int fix = 0;
>  
> -		fixed = 0;
> -		recorded = 0;
>  		cache = search_cache_extent(extent_cache, 0);
>  		if (!cache)
>  			break;
> @@ -9261,7 +9264,6 @@ static int check_extent_refs(struct btrfs_root *root,
>  		if (rec->num_duplicates) {
>  			fprintf(stderr, "extent item %llu has multiple extent "
>  				"items\n", (unsigned long long)rec->start);
> -			err = 1;
>  			cur_err = 1;
>  		}
>  
> @@ -9272,57 +9274,33 @@ static int check_extent_refs(struct btrfs_root *root,
>  			fprintf(stderr, "extent item %llu, found %llu\n",
>  				(unsigned long long)rec->extent_item_refs,
>  				(unsigned long long)rec->refs);
> -			ret = record_orphan_data_extents(root->fs_info, rec);
> -			if (ret < 0)
> +			fix = record_orphan_data_extents(root->fs_info, rec);
> +			if (fix < 0)
>  				goto repair_abort;

I think ret has to be set to fix here as well (in some way, eg. not
using fix for a return value), otherwise the repair_abort label will not
thake the same code path as before.

> -			if (ret == 0) {
> -				recorded = 1;
> -			} else {
> -				/*
> -				 * we can't use the extent to repair file
> -				 * extent, let the fallback method handle it.
> -				 */
> -				if (!fixed && repair) {
> -					ret = fixup_extent_refs(
> -							root->fs_info,
> -							extent_cache, rec);
> -					if (ret)
> -						goto repair_abort;
> -					fixed = 1;
> -				}
> -			}
> -			err = 1;
