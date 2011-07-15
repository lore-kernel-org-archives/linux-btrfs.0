From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH 7/7] btrfs: don't BUG_ON allocation errors in btrfs_drop_snapshot
Date: Fri, 15 Jul 2011 12:04:46 +0900
Message-ID: <4E1FAE4E.5030508@jp.fujitsu.com>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com> <1310681702-13922-2-git-send-email-mfasheh@suse.com> <1310681702-13922-3-git-send-email-mfasheh@suse.com> <1310681702-13922-4-git-send-email-mfasheh@suse.com> <1310681702-13922-5-git-send-email-mfasheh@suse.com> <1310681702-13922-6-git-send-email-mfasheh@suse.com> <1310681702-13922-7-git-send-email-mfasheh@suse.com> <1310681702-13922-8-git-send-email-mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310681702-13922-8-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/07/15 7:15), Mark Fasheh wrote:
> In addition to properly handling allocation failure from btrfs_alloc_path, I
> also fixed up the kzalloc error handling code immediately below it.

Need not you correct the caller of btrfs_drop_snapshot()?

Thanks,
Tsutomu

> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> ---
>  fs/btrfs/extent-tree.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index aa91773..a016590 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6268,10 +6268,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>  	int level;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
>  
>  	wc = kzalloc(sizeof(*wc), GFP_NOFS);
> -	BUG_ON(!wc);
> +	if (!wc) {
> +		btrfs_free_path(path);
> +		return -ENOMEM;
> +	}
>  
>  	trans = btrfs_start_transaction(tree_root, 0);
>  	BUG_ON(IS_ERR(trans));


