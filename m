From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 12/27] BKL: Remove BKL from btrfs
Date: Mon, 2 Nov 2009 07:13:08 -0500
Message-ID: <20091102121308.GB882@think>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
 <1257156307-24175-13-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Yan Zheng <zheng.yan@oracle.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
To: Jan Blunck <jblunck@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1257156307-24175-13-git-send-email-jblunck@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 02, 2009 at 11:04:52AM +0100, Jan Blunck wrote:
> BKL is only used in get_sb. It is safe to remove it.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Acked-by: Chris Mason <chris.mason@oracle.com>

Thanks!

-chris

> ---
>  fs/btrfs/super.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index e5cd2cf..752a546 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -480,17 +480,13 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>  	fmode_t mode = FMODE_READ;
>  	int error = 0;
>  
> -	lock_kernel();
> -
>  	if (!(flags & MS_RDONLY))
>  		mode |= FMODE_WRITE;
>  
>  	error = btrfs_parse_early_options(data, mode, fs_type,
>  					  &subvol_name, &fs_devices);
> -	if (error) {
> -		unlock_kernel();
> +	if (error)
>  		return error;
> -	}
>  
>  	error = btrfs_scan_one_device(dev_name, mode, fs_type, &fs_devices);
>  	if (error)
> @@ -559,7 +555,6 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>  	mnt->mnt_root = root;
>  
>  	kfree(subvol_name);
> -	unlock_kernel();
>  	return 0;
>  
>  error_s:
> @@ -568,7 +563,6 @@ error_close_devices:
>  	btrfs_close_devices(fs_devices);
>  error_free_subvol_name:
>  	kfree(subvol_name);
> -	unlock_kernel();
>  	return error;
>  }
>  
> -- 
> 1.6.4.2
> 
