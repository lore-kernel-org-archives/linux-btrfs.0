Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754115AbeBGOhv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 09:37:51 -0500
Date: Wed, 7 Feb 2018 15:35:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, ralphgauges@googlemail.com
Subject: Re: [PATCH] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
Message-ID: <20180207143536.GB3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180207091825.10144-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180207091825.10144-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 07, 2018 at 05:18:25PM +0800, Qu Wenruo wrote:
> Strangely, we have level check in btrfs_print_tree() while we don't have
> the same check in read_node_slot().
> 
> That's to say, for the following corruption, btrfs_search_slot() or
> btrfs_next_leaf() can return invalid leaf:
> 
> Parent eb:
>   node XXXXXX level 1
>               ^^^^^^^
>               Child should be leaf (level 0)
>   ...
>   key (XXX XXX XXX) block YYYYYY
> 
> Child eb:
>   leaf YYYYYY level 1
>               ^^^^^^^
>               Something went wrong now
> 
> And for the corrupted leaf returned, later caller can be screwed up
> easily.
> 
> Although the root cause (powerloss, but still something wrong breaking
> metadata CoW of btrfs) is still unknown, at least enhance btrfs-progs to
> avoid SEGV.
> 
> Reported-by: Ralph Gauges <ralphgauges@googlemail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  ctree.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/ctree.c b/ctree.c
> index 4fc33b14000a..ddb1e9cc6d37 100644
> --- a/ctree.c
> +++ b/ctree.c
> @@ -22,6 +22,7 @@
>  #include "repair.h"
>  #include "internal.h"
>  #include "sizes.h"
> +#include "messages.h"
>  
>  static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
>  		      *root, struct btrfs_path *path, int level);
> @@ -640,7 +641,9 @@ static int bin_search(struct extent_buffer *eb, struct btrfs_key *key,
>  struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
>  				   struct extent_buffer *parent, int slot)
>  {
> +	struct extent_buffer *ret;
>  	int level = btrfs_header_level(parent);
> +
>  	if (slot < 0)
>  		return NULL;
>  	if (slot >= btrfs_header_nritems(parent))
> @@ -649,8 +652,16 @@ struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
>  	if (level == 0)
>  		return NULL;
>  
> -	return read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
> +	ret = read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),

The result of read_tree_block should be checked before use, by
extent_buffer_uptodate, null check or IS_ERR at least (depending on the
context of use).

>  		       btrfs_node_ptr_generation(parent, slot));
> +	if (btrfs_header_level(ret) != level - 1) {
> +		error("child eb corrupted: parent bytenr=%llu item=%d parent level=%d child level=%d",
> +		      btrfs_header_bytenr(parent), slot,
> +		      btrfs_header_level(parent), btrfs_header_level(ret));
> +		free_extent_buffer(ret);
> +		return ERR_PTR(-EIO);
> +	}
> +	return ret;
>  }
>  
>  static int balance_level(struct btrfs_trans_handle *trans,
> -- 
> 2.16.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
