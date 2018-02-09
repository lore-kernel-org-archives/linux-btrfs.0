Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35196 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750920AbeBIIJP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Feb 2018 03:09:15 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 14B3FADE4
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Feb 2018 08:09:14 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs-progs: ctree: Add extra level check for
 read_node_slot()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180209074428.29187-1-wqu@suse.com>
 <20180209074428.29187-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f3a7a7a3-1fbb-714a-e857-00d606310b95@suse.com>
Date: Fri, 9 Feb 2018 10:09:10 +0200
MIME-Version: 1.0
In-Reply-To: <20180209074428.29187-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.02.2018 09:44, Qu Wenruo wrote:
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
> changlog:
> v2:
>   Check if the extent buffer is up-to-date before checking its level to
>   avoid possible NULL pointer access.
> ---
>  ctree.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)

That was sent separately so I'd assume it was in the wrong dir ;)

> 
> diff --git a/ctree.c b/ctree.c
> index 4fc33b14000a..430805e3043f 100644
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
> @@ -649,8 +652,19 @@ struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
>  	if (level == 0)
>  		return NULL;
>  
> -	return read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
> +	ret = read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
>  		       btrfs_node_ptr_generation(parent, slot));
> +	if (!extent_buffer_uptodate(ret))
> +		return ERR_PTR(-EIO);
> +
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
> 
