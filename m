From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 02:14:05 +0200
Message-ID: <4BF1DBCD.7060208@gmail.com>
References: <4BF18525.8080904@gmail.com> <20100517193652.GC8635@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100517193652.GC8635@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 17/05/10 21:36, Chris Mason wrote:
> 
> That should be a zero second window, we try to force things to disk
> during renames.
> 
> Could you please try this patch:
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index c9f1020..9370a71 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -806,7 +806,7 @@ int btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
>  	 * if this file hasn't been changed since the last transaction
>  	 * commit, we can safely return without doing anything
>  	 */
> -	if (last_mod < root->fs_info->last_trans_committed)
> +	if (0 && last_mod < root->fs_info->last_trans_committed)


Ok, I upgraded to 2.6.34 final and switched to defconfig.
I only did the rename test ( i.e. no overwrite ), the window is now
1.1s, both with vanilla and with the patch.

Jakob

