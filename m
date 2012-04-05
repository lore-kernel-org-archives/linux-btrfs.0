From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 1/2] Btrfs: make clear_extent_bit() always return 0 on success
Date: Thu, 5 Apr 2012 18:52:09 +0200
Message-ID: <20120405165209.GG14256@twin.jikos.cz>
References: <4F5DB640.3010102@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	chris.mason@oracle.com
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F5DB640.3010102@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 12, 2012 at 04:39:28PM +0800, Li Zefan wrote:
> Currently it returns a set of bits that were cleared, but this return
> value is not used at all.
> 
> Moreover it doesn't seem to be useful, because we may clear the bits
> of a few extent_states, but only the cleared bits of last one is
> returned.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/extent_io.c |   19 +++++++------------
>  1 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index a55fbe6..c968c95 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -394,18 +394,16 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
>  
>  /*
>   * utility function to clear some bits in an extent state struct.
> - * it will optionally wake up any one waiting on this state (wake == 1), or
> - * forcibly remove the state from the tree (delete == 1).
> + * it will optionally wake up any one waiting on this state (wake == 1)
>   *
>   * If no bits are set on the state struct after clearing things, the
>   * struct is freed and removed from the tree
>   */
> -static int clear_state_bit(struct extent_io_tree *tree,
> +static void clear_state_bit(struct extent_io_tree *tree,
>  			    struct extent_state *state,
>  			    int *bits, int wake)
>  {
>  	int bits_to_clear = *bits & ~EXTENT_CTLBITS;
> -	int ret = state->state & bits_to_clear;
>  
>  	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
>  		u64 range = state->end - state->start + 1;
> @@ -427,7 +425,6 @@ static int clear_state_bit(struct extent_io_tree *tree,
>  	} else {
>  		merge_state(tree, state);
>  	}
> -	return ret;
>  }
>  
>  static struct extent_state *

The above part of the patch still applies and with only subject change
to something like

  Btrfs: retrurn void from clear_state_bit

is a rc2 material. So, Li, if you're ok with this change I'm adding it
(with the 2/2 patch) to my local queue of rc patches for Chris.


david

(the rest of the patch was done within the error handling series)

> @@ -449,8 +446,7 @@ alloc_extent_state_atomic(struct extent_state *prealloc)
>   *
>   * the range [start, end] is inclusive.
>   *
> - * This takes the tree lock, and returns < 0 on error, > 0 if any of the
> - * bits were already set, or zero if none of the bits were already set.
> + * This takes the tree lock, and returns < 0 on error.
>   */
>  int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  		     int bits, int wake, int delete,
> @@ -464,7 +460,6 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  	struct rb_node *node;
>  	u64 last_end;
>  	int err;
> -	int set = 0;
>  	int clear = 0;
>  
>  	if (delete)
> @@ -547,7 +542,7 @@ hit_next:
>  		if (err)
>  			goto out;
>  		if (state->end <= end) {
> -			set |= clear_state_bit(tree, state, &bits, wake);
> +			clear_state_bit(tree, state, &bits, wake);
>  			if (last_end == (u64)-1)
>  				goto out;
>  			start = last_end + 1;
> @@ -568,13 +563,13 @@ hit_next:
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
> @@ -591,7 +586,7 @@ out:
>  	if (prealloc)
>  		free_extent_state(prealloc);
>  
> -	return set;
> +	return 0;
>  
>  search_again:
>  	if (start > end)
> -- 1.7.3.1 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
