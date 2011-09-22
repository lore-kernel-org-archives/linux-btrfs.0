From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: fix array bound checking
Date: Thu, 22 Sep 2011 12:20:03 +0200
Message-ID: <20110922102003.GR22205@twin.jikos.cz>
References: <4E65E006.8030707@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E65E006.8030707@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 06, 2011 at 04:55:34PM +0800, Li Zefan wrote:
> Otherwise we can execced the array bound of path->slots[].
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> ---
>  fs/btrfs/ctree.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 011cab3..0fe615e 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -902,9 +902,10 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  
>  	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
>  
> -	if (level < BTRFS_MAX_LEVEL - 1)
> +	if (level < BTRFS_MAX_LEVEL - 1) {
>  		parent = path->nodes[level + 1];
> -	pslot = path->slots[level + 1];
> +		pslot = path->slots[level + 1];
> +	}
>  
>  	/*
>  	 * deal with the case where there is only one pointer in the root
> @@ -1107,9 +1108,10 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>  	mid = path->nodes[level];
>  	WARN_ON(btrfs_header_generation(mid) != trans->transid);
>  
> -	if (level < BTRFS_MAX_LEVEL - 1)
> +	if (level < BTRFS_MAX_LEVEL - 1) {
>  		parent = path->nodes[level + 1];
> -	pslot = path->slots[level + 1];
> +		pslot = path->slots[level + 1];
> +	}
>  
>  	if (!parent)
>  		return 1;
> -- 
> 1.7.3.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
