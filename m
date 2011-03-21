From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: check free space in block group before searching
 for a cluster
Date: Mon, 21 Mar 2011 10:39:00 +0800
Message-ID: <4D86BA44.1040004@cn.fujitsu.com>
References: <1300475786-1836-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300475786-1836-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> The free space cluster stuff is heavy duty, so there is no sense in going
> through the entire song and dance if there isn't enough space in the block group
> to begin with.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  fs/btrfs/free-space-cache.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 0282033..f631df8 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1999,6 +1999,16 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
>  		min_bytes = max(bytes, (bytes + empty_size) >> 2);
>  
>  	spin_lock(&block_group->tree_lock);
> +
> +	/*
> +	 * If we know we don't have enough space to make a cluster don't even
> +	 * bother doing all the work to try and find one.
> +	 */
> +	if (block_group->free_space < min_bytes) {
> +		spin_unlock(&block_group->tree_lock);
> +		return -ENOSPC;
> +	}
> +
>  	spin_lock(&cluster->lock);
>  
>  	/* someone already found a cluster, hooray */
