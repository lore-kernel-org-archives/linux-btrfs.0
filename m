From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 1/2] Btrfs: don't make a file partly checksummed through file clone
Date: Thu, 15 Sep 2011 13:16:38 +0200
Message-ID: <20110915111638.GD22205@twin.jikos.cz>
References: <4E703AC1.5060205@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Sage Weil <sage@newdream.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E703AC1.5060205@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2011 at 01:25:21PM +0800, Li Zefan wrote:
> It's because part of the file is checksummed and the other part is not,
> and then btrfs will complain checksum is not found when we read the file.
> 
> Disallow file clone if src and dst file have different checksum flag,
> so we ensure a file is completely checksummed or unchecksummed.

Your fix prevents the bug, but I don't think it's good to let file clone
fail without any other message. ret is set to -EINVAL at the time of
'goto out_fput', which is fine, but the user has no clue what happened
or how to fix it.

The nodatasum status is recorded in inode flags and remains like that
regardless of the 'mount -o nodatasum', persistent and de facto
unchangable (unless the file is created again with the opposite nodatasum
mount). Even more, the user has no way to find out nodatasum flag of
any inode/file (the corresponding FS_NODATASUM_FL is not there).

My suggestion how to fix this:
1. add FS_NODATASUM_FL file flag and code to set/get via setflags ioctl
2. [this patch to skip cloning in case of nodatasum flag mismatch]
3. ... add a printk why it failed

The user then has at least option to drop/add the nodatasum flag for one of
the. Unfortunatelly this makes file cloning less straightforward.


david


> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 970977a..dc82bbb 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2177,6 +2177,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  	if (!(src_file->f_mode & FMODE_READ))
>  		goto out_fput;
>  
> +	/* don't make the dst file partly checksummed */
> +	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
> +	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
> +		goto out_fput;
> +
>  	ret = -EISDIR;
>  	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
>  		goto out_fput;
> -- 1.7.3.1 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
