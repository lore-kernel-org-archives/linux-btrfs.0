From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [patch 08/35] btrfs: Remove set bits return from clear_extent_bit
Date: Thu, 22 Mar 2012 10:03:50 +0800
Message-ID: <4F6A8886.40702@cn.fujitsu.com>
References: <20120322011104.212214639@suse.com> <20120322011134.102248113@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs List <linux-btrfs@vger.kernel.org>,
	David Sterba <dsterba@suse.com>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120322011134.102248113@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/22/2012 09:11 AM, Jeff Mahoney wrote:
> There is only one caller of clear_extent_bit that checks the return value
> and it only checks if it's negative. Since there are no users of the
> returned bits functionality of clear_extent_bit, stop returning it
> and avoid complicating error handling.
> 

A similar one from Li:
http://www.spinics.net/lists/linux-btrfs/msg15458.html

thanks,
liubo

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent_io.c |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 601f23b..a4a7a18 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -462,8 +462,7 @@ void extent_io_tree_panic(struct extent_io_tree *tree, int err)
>   *
>   * the range [start, end] is inclusive.
>   *
> - * This takes the tree lock, and returns < 0 on error, > 0 if any of the
> - * bits were already set, or zero if none of the bits were already set.
> + * This takes the tree lock, and returns 0 on success and < 0 on error.
>   */
>  int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  		     int bits, int wake, int delete,
> @@ -477,7 +476,6 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  	struct rb_node *node;
>  	u64 last_end;
>  	int err;
> -	int set = 0;
>  	int clear = 0;
>  
>  	if (delete)
> @@ -562,7 +560,7 @@ hit_next:
>  		if (err)
>  			goto out;
>  		if (state->end <= end) {
> -			set |= clear_state_bit(tree, state, &bits, wake);
> +			clear_state_bit(tree, state, &bits, wake);
>  			if (last_end == (u64)-1)
>  				goto out;
>  			start = last_end + 1;
> @@ -585,13 +583,13 @@ hit_next:
>  		if (wake)
>  			wake_up(&state->wq);
>  
> -		set |= clear_state_bit(tree, prealloc, &bits, wake);
> +		clear_state_bit(tree, prealloc, &bits, wake);
>  
>  		prealloc = NULL;
>  		goto out;
>  	}
>  
> -	set |= clear_state_bit(tree, state, &bits, wake);
> +	clear_state_bit(tree, state, &bits, wake);
>  next:
>  	if (last_end == (u64)-1)
>  		goto out;
> @@ -608,7 +606,7 @@ out:
>  	if (prealloc)
>  		free_extent_state(prealloc);
>  
> -	return set;
> +	return 0;
>  
>  search_again:
>  	if (start > end)

