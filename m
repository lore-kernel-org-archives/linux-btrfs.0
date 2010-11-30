From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] btrfs - fix memory leak on finding existing super
Date: Tue, 30 Nov 2010 21:44:33 +0800
Message-ID: <1291124673.2959.0.camel@perseus.themaw.net>
References: <20101130133103.4661.35881.stgit@perseus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Josef Bacik <josef@redhat.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101130133103.4661.35881.stgit@perseus.themaw.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2010-11-30 at 21:31 +0800, Ian Kent wrote:
> From: Ian Kent <raven@themaw.net>
> 
> We missed a memory deallocation in commit 450ba0ea.
> 
> If an existing super block is found at mount and there is no
> error condition then the pre-allocated tree_root and fs_info
> are no not used and are not freeded.

It's hard to believe that spelling looked OK to me before posting, ;)

> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
> 
>  fs/btrfs/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 47bf67c..f5cca1b 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -654,6 +654,8 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>  		}
>  
>  		btrfs_close_devices(fs_devices);
> +		kfree(fs_info);
> +		kfree(tree_root);
>  	} else {
>  		char b[BDEVNAME_SIZE];
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


