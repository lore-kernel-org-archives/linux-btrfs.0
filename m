From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs - fix memory leak on finding existing super
Date: Wed, 01 Dec 2010 09:21:02 +0800
Message-ID: <4CF5A2FE.8030205@cn.fujitsu.com>
References: <20101130133103.4661.35881.stgit@perseus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Ian Kent <ikent@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101130133103.4661.35881.stgit@perseus.themaw.net>
List-ID: <linux-btrfs.vger.kernel.org>

21:31, Ian Kent wrote:
> From: Ian Kent <raven@themaw.net>
> 
> We missed a memory deallocation in commit 450ba0ea.
> 
> If an existing super block is found at mount and there is no
> error condition then the pre-allocated tree_root and fs_info
> are no not used and are not freeded.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

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
