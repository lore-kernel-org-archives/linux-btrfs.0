From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: set the i_nlink to 2 for an initial dir inode
Date: Tue, 29 Nov 2011 14:04:37 +0800
Message-ID: <4ED475F5.1090500@oracle.com>
References: <4ED33C88.8060501@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED33C88.8060501@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore this patch for now, it can cause the file system corrupted
and failed to mount again, sorry for the noise!

-Jeff
On 11/28/2011 03:47 PM, Jeff Liu wrote:

> For an initial dir inode, stat(1) show it links as 1, IMHO it should be
> 2 by default.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> ---
>  fs/btrfs/inode.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 116ab67..92b3cb9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4734,6 +4734,7 @@ static int btrfs_mkdir(struct inode *dir, struct
> dentry *dentry, int mode)
>  	inode->i_op = &btrfs_dir_inode_operations;
>  	inode->i_fop = &btrfs_dir_file_operations;
> 
> +	set_nlink(inode, 2);
>  	btrfs_i_size_write(inode, 0);
>  	err = btrfs_update_inode(trans, root, inode);
>  	if (err)


