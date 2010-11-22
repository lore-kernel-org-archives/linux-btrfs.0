From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 1/2] btrfs: Check if dest_offset is block-size aligned
 before cloning file
Date: Mon, 22 Nov 2010 11:09:34 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1011221108170.2462@cobra.newdream.net>
References: <4CE5D48A.6090009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE5D48A.6090009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 19 Nov 2010, Li Zefan wrote:
> We've done the check for src_offset and src_length, and We should
> also check dest_offset, otherwise we'll corrupt the destination
> file:
> 
>   (After cloning file1 to file2 with unaligned dest_offset)
>   # cat /mnt/file2
>   cat: /mnt/file2: Input/output error
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 463d91b..81b47bd 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1669,12 +1669,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  		olen = len = src->i_size - off;
>  	/* if we extend to eof, continue to block boundary */
>  	if (off + len == src->i_size)
> -		len = ((src->i_size + bs-1) & ~(bs-1))
> -			- off;
> +		len = ALIGN(src->i_size, bs) - off;
>  
>  	/* verify the end result is block aligned */
> -	if ((off & (bs-1)) ||
> -	    ((off + len) & (bs-1)))
> +	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs) ||
> +	    !IS_ALIGNED(destoff, bs))
>  		goto out_unlock;
>  
>  	/* do any pending delalloc/csum calc on src, one way or

Looks good.

Reviewed-by: Sage Weil <sage@newdream.net>

