From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: truncate pages from clone ioctl target range
Date: Tue, 9 Aug 2011 22:12:36 +0200
Message-ID: <20110809201236.GC20461@twin.jikos.cz>
References: <1312916441-23662-1-git-send-email-sage@newdream.net>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312916441-23662-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

just a readability issue:

On Tue, Aug 09, 2011 at 12:00:41PM -0700, Sage Weil wrote:
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2243,6 +2243,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  		btrfs_wait_ordered_range(src, off, len);
>  	}
>  
> +	/* truncate page cache pages from target inode range */
> +	truncate_inode_pages_range(&inode->i_data, off,
> +			      ((off+len+PAGE_CACHE_SIZE-1)&PAGE_CACHE_MASK)-1);

                               ALIGN(off + len, PAGE_CACHE_SIZE) - 1)

I'll give it some testing too :) thanks for catching this!

david

> +
>  	/* clone data */
>  	key.objectid = btrfs_ino(src);
>  	key.type = BTRFS_EXTENT_DATA_KEY;
> -- 
