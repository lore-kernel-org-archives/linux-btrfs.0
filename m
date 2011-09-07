From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: calc file extent num_bytes correctly in file clone
Date: Wed, 7 Sep 2011 14:23:58 +0200
Message-ID: <20110907122357.GB22205@twin.jikos.cz>
References: <4E54967C.5020205@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Sage Weil <sage@newdream.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E54967C.5020205@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

minor, typos in comments s/substract/subtract/

On Wed, Aug 24, 2011 at 02:13:16PM +0800, Li Zefan wrote:
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 660a6c8..3351b1b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2331,14 +2331,21 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  
>  			if (type == BTRFS_FILE_EXTENT_REG ||
>  			    type == BTRFS_FILE_EXTENT_PREALLOC) {
> +				/*
> +				 *    a  | --- range to clone ---|  b
> +				 * | ------------- extent ------------- |
> +				 */
> +
> +				/* substract range b */
...

> +				if (key.offset + datal > off + len)
> +					datal = off + len - key.offset;
> +
> +				/* substract range a */
...

>  				if (off > key.offset) {
>  					datao += off - key.offset;
>  					datal -= off - key.offset;
>  				}
>  
> -				if (key.offset + datal > off + len)
> -					datal = off + len - key.offset;
> -
>  				ret = btrfs_drop_extents(trans, inode,
>  							 new_key.offset,
>  							 new_key.offset + datal,
