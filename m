From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 2/2] Btrfs: don't change inode flag of the dest clone file
Date: Thu, 15 Sep 2011 13:43:37 +0200
Message-ID: <20110915114336.GE22205@twin.jikos.cz>
References: <4E703AC1.5060205@cn.fujitsu.com> <4E703AD0.2060202@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Sage Weil <sage@newdream.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E703AD0.2060202@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2011 at 01:25:36PM +0800, Li Zefan wrote:
> The dst file will have the same inode flags with dst file after
> file clone, and I think it's unexpected.
> 
> For example, the dst file will suddenly become immutable after
> getting some share of data with src file, if the src is immutable.

Good catch! (I did not find any further direct assignment of two inode
flags.)

> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

IMNSHO should go to stable.


david

> ---
>  fs/btrfs/ioctl.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index dc82bbb..a401514 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2434,7 +2434,6 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  			if (endoff > inode->i_size)
>  				btrfs_i_size_write(inode, endoff);
>  
> -			BTRFS_I(inode)->flags = BTRFS_I(src)->flags;
>  			ret = btrfs_update_inode(trans, root, inode);
>  			BUG_ON(ret);
>  			btrfs_end_transaction(trans, root);
> -- 1.7.3.1 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
