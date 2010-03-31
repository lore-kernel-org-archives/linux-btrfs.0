From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 05/18] btrfs: Take num_copies out of loop for
 btree_read_extent_buffer_pages()
Date: Tue, 30 Mar 2010 20:23:27 -0400
Message-ID: <20100331002327.GT13190@think>
References: <4BAB5759.7010903@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BAB5759.7010903@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 25, 2010 at 08:30:17PM +0800, Miao Xie wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> num_copies's value is not changed in this function,
> and it is not necessary to calculate its value multi-times.

It is true that we don't need to calculate this multiple times, but with
the existing code the calculation is only done when there is an IO
error.

We could use a check for num_copies == 0 before calling the calc
function.

-chris

> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/disk-io.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 11d0ad3..79d9196 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -301,7 +301,8 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>  {
>  	struct extent_io_tree *io_tree;
>  	int ret;
> -	int num_copies = 0;
> +	int num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
> +					  eb->start, eb->len);
>  	int mirror_num = 0;
>  
>  	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
> @@ -312,8 +313,6 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>  		    !verify_parent_transid(io_tree, eb, parent_transid))
>  			return ret;
>  
> -		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
> -					      eb->start, eb->len);
>  		if (num_copies == 1)
>  			return ret;
>  
> -- 
> 1.6.5.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
