From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix memory leaks in btrfs_new_inode()
Date: Mon, 11 Apr 2011 10:23:05 +0800
Message-ID: <4DA26609.5060000@cn.fujitsu.com>
References: <1302316207-30806-1-git-send-email-yoshinori.sano@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Yoshinori Sano <yoshinori.sano@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302316207-30806-1-git-send-email-yoshinori.sano@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yoshinori Sano wrote:
> This patch fixes memory leaks in btrfs_new_inode().
> 
> Signed-off-by: Yoshinori Sano <yoshinori.sano@gmail.com>
> ---
>  fs/btrfs/inode.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index aa116dc..d8c93c1 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4536,14 +4536,17 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  		return ERR_PTR(-ENOMEM);
>  
>  	inode = new_inode(root->fs_info->sb);
> -	if (!inode)
> +	if (!inode) {
> +		btrfs_free_path(path);
>  		return ERR_PTR(-ENOMEM);
> +	}
>  
>  	if (dir) {
>  		trace_btrfs_inode_request(dir);
>  
>  		ret = btrfs_set_inode_index(dir, index);
>  		if (ret) {
> +			btrfs_free_path(path);
>  			iput(inode);
>  			return ERR_PTR(ret);
>  		}

It would be better to avoid multiple returns here:

fail_free_path:
	btrfs_free_path(path);
fail_put_inode:
	iput(inode);
fail:
	...
