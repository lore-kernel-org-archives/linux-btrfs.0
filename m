From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 33/35] btrfs: handle errors when excluding super extents
Date: Fri, 23 Mar 2012 18:21:17 +0100
Message-ID: <20120323172116.GB11610@twin.jikos.cz>
References: <20120322011104.212214639@suse.com> <20120322011137.642386355@suse.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs List <linux-btrfs@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120322011137.642386355@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 21, 2012 at 09:11:37PM -0400, Jeff Mahoney wrote:
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -250,10 +250,17 @@ static int exclude_super_stripes(struct btrfs_root *root,
>  
>  	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>  		bytenr = btrfs_sb_offset(i);
> +		if (bytenr <= cache->key.objectid + cache->key.offset)
> +			break;

The condition is wrong. Exclude superblock if it's inside the block
group:

             if (cache->key.objectid + cache->key.offset <= bytenr)
                     break;
             if (bytenr < cache->key.objectid)
                     continue;

break if the remaining sb's are too far and skip to next one otherwise.

> +		logical = NULL;
>  		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
>  				       cache->key.objectid, bytenr,
>  				       0, &logical, &nr, &stripe_len);
> -		BUG_ON(ret); /* -ENOMEM */
> +		if (ret < 0) {
> +			kfree(logical);
> +			free_excluded_extents(root, cache);
> +			goto out;
> +		}
>  
>  		while (nr--) {
>  			cache->bytes_super += stripe_len;
