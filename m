From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: check return value of kmalloc()
Date: Tue, 19 Apr 2011 13:12:40 +0200
Message-ID: <20110419111240.GV31675@twin.jikos.cz>
References: <201104190527.AA00014@T-ITOH1.jp.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201104190527.AA00014@T-ITOH1.jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there are more unchecked kmallocs, in inode.c:btrfs_add_delayed_iput()

2030        delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);

and in extent-tree.c:relocate_one_extent()

7992        new_extents = kmalloc(sizeof(*new_extents),
7993                                                 GFP_NOFS);

the value is checked later, new_extents is passed to get_new_locations
and there it's checked, but no other callers pass potential NULL and the
check fits here and can be dropped from get_new_locations; there's a
little chance that get_new_locations will be able to succesfully
allocate the same data a jiffy later.

IMO the check can be safely added here and get_new_locations cleaned up
later.

Feel free to fold the changes into your patch.

I did not find any more unchecked allocatinos.


dave


On Tue, Apr 19, 2011 at 02:27:08PM +0900, Tsutomu Itoh wrote:
> The check on the return value of kmalloc() in inode.c is added.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  fs/btrfs/inode.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a4157cf..c718d27 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -953,6 +953,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>  			 1, 0, NULL, GFP_NOFS);
>  	while (start < end) {
>  		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
> +		BUG_ON(!async_cow);
>  		async_cow->inode = inode;
>  		async_cow->root = root;
>  		async_cow->locked_page = locked_page;
> @@ -5001,6 +5002,8 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>  	inline_size = btrfs_file_extent_inline_item_len(leaf,
>  					btrfs_item_nr(leaf, path->slots[0]));
>  	tmp = kmalloc(inline_size, GFP_NOFS);
> +	if (!tmp)
> +		return -ENOMEM;
>  	ptr = btrfs_file_extent_inline_start(item);
>  
>  	read_extent_buffer(leaf, tmp, ptr, inline_size);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
