From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH 05/12] btrfs: remove useless mutex lock/unlock sequences
Date: Mon, 25 Apr 2011 15:25:58 +0900
Message-ID: <4DB513F6.6040503@jp.fujitsu.com>
References: <cover.1303398927.git.dsterba@suse.cz> <b5fefb09811c22cd101a44ac753293af942087fc.1303398927.git.dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@Oracle.COM>
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <b5fefb09811c22cd101a44ac753293af942087fc.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/04/22 18:41), David Sterba wrote:
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/extent-tree.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 31f33ba..c97ceab 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -756,8 +756,6 @@ again:
>  
>  			btrfs_release_path(root->fs_info->extent_root, path);
>  
> -			mutex_lock(&head->mutex);
> -			mutex_unlock(&head->mutex);
>  			btrfs_put_delayed_ref(&head->node);
>  			goto again;

This code tests whether the mutex_lock can be acquired, and when the
mutex_lock can be taken, it try again.
So I think that it is not a meaningless code.

Thanks,
Tsutomu

>  		}
> @@ -2297,8 +2295,6 @@ again:
>  				atomic_inc(&ref->refs);
>  
>  				spin_unlock(&delayed_refs->lock);
> -				mutex_lock(&head->mutex);
> -				mutex_unlock(&head->mutex);
>  
>  				btrfs_put_delayed_ref(ref);
>  				cond_resched();
> @@ -2363,8 +2359,6 @@ static noinline int check_delayed_ref(struct btrfs_trans_handle *trans,
>  
>  		btrfs_release_path(root->fs_info->extent_root, path);
>  
> -		mutex_lock(&head->mutex);
> -		mutex_unlock(&head->mutex);
>  		btrfs_put_delayed_ref(&head->node);
>  		return -EAGAIN;
>  	}

