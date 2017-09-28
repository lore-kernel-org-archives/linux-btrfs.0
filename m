Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751436AbdI1F5t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 01:57:49 -0400
Subject: Re: [PATCH 2/5] btrfs: tree-checker: Enhance btrfs_check_node output
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170928033610.16882-1-quwenruo.btrfs@gmx.com>
 <20170928033610.16882-3-quwenruo.btrfs@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <21b91100-fb34-77c2-24c2-7bf0ae381b90@suse.com>
Date: Thu, 28 Sep 2017 08:57:46 +0300
MIME-Version: 1.0
In-Reply-To: <20170928033610.16882-3-quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.09.2017 06:36, Qu Wenruo wrote:
> Use inline function to replace macro since we don't need
> stringification.
> (Macro still exist until all caller get updated)
> 
> And add more info about the error.
> 
> For nr_items error, report if it's too large or too small, and output
> valid value range.
> 
> For blk pointer, added a new alignment checker.
> 
> For key order, also output the next key to make the problem more
> obvious.
> 
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> ---
>  fs/btrfs/tree-checker.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 301243a69dea..4b615beb0ca9 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -37,6 +37,32 @@
>  		   btrfs_header_level(eb) == 0 ? "leaf" : "node",	\
>  		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
>  
> +/*
> + * Append the generic "corrupt leaf/node root=%llu block=%llu slot=%d: " to
> + * @fmt.
> + * Allowing user to customize their output.
> + */
> +__printf(4, 5)
> +static void generic_err(const struct btrfs_root *root,
> +			const struct extent_buffer *eb,
> +			int slot, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	btrfs_crit(root->fs_info,
> +		"corrupt %s root=%llu block=%llu slot=%d: %pV",
> +		btrfs_header_level(eb) == 0 ? "leaf" : "node",
> +		root->objectid, btrfs_header_bytenr(eb), slot,
> +		&vaf);
> +	va_end(args);
> +}
> +
>  static int check_extent_data_item(struct btrfs_root *root,
>  				  struct extent_buffer *leaf,
>  				  struct btrfs_key *key, int slot)
> @@ -282,8 +308,10 @@ int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
>  
>  	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(root->fs_info)) {
>  		btrfs_crit(root->fs_info,
> -			   "corrupt node: block %llu root %llu nritems %lu",
> -			   node->start, root->objectid, nr);
> +			"corrupt node: root=%llu block=%llu nritems too %s, have %lu, range [1,%u]",

It's a nit but I'd rather have consistency between formatting of error
messages. Here you begin the line with "corrupt node:" whereas when
using generic_err you won't have the ':'. I'd prefer if everything is
consistent so it's easy for people to grep.

> +			   root->objectid, node->start,
> +			   nr == 0 ? "small" : "large", nr,
> +			   BTRFS_NODEPTRS_PER_BLOCK(root->fs_info));
>  		return -EIO;
>  	}
>  
> @@ -293,13 +321,25 @@ int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
>  		btrfs_node_key_to_cpu(node, &next_key, slot + 1);
>  
>  		if (!bytenr) {
> -			CORRUPT("invalid item slot", node, root, slot);
> +			generic_err(root, node, slot,
> +			"invalid node pointer, shouldn't point to zero");
>  			ret = -EIO;
>  			goto out;
>  		}
> +		if (!IS_ALIGNED(bytenr, root->fs_info->sectorsize)) {
> +			generic_err(root, node, slot,
> +			"unaligned pointer, have %llu, should be aligned to %u",
> +				     bytenr, root->fs_info->sectorsize);
> +			ret = -EUCLEAN;
> +			goto out;
> +		}
>  
>  		if (btrfs_comp_cpu_keys(&key, &next_key) >= 0) {
> -			CORRUPT("bad key order", node, root, slot);
> +			generic_err(root, node, slot,
> +			"bad key order, current key (%llu %u %llu) next key (%llu %u %llu)",
> +				     key.objectid, key.type, key.offset,
> +				     next_key.objectid, next_key.type,
> +				     next_key.offset);
>  			ret = -EIO;
>  			goto out;
>  		}
> 
