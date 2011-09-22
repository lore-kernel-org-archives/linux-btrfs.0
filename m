From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 2/4] Btrfs: use i_size_read() in btrfs_defrag_file()
Date: Thu, 22 Sep 2011 12:58:17 +0200
Message-ID: <20110922105817.GW22205@twin.jikos.cz>
References: <4E608C29.10307@cn.fujitsu.com> <4E608C37.90908@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E608C37.90908@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2011 at 03:56:39PM +0800, Li Zefan wrote:
> Don't use inode->i_size directly, since we're not holding i_mutex.
> 
> This also fixes another bug, that i_size can change after it's checked
> against 0 and then (i_size - 1) can be negative.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> ---
>  fs/btrfs/ioctl.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 31fe6d4..6f2b257 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -972,6 +972,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  	struct btrfs_super_block *disk_super;
>  	struct file_ra_state *ra = NULL;
>  	unsigned long last_index;
> +	u64 isize = i_size_read(inode);
>  	u64 features;
>  	u64 last_len = 0;
>  	u64 skip = 0;
> @@ -997,7 +998,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  			compress_type = range->compress_type;
>  	}
>  
> -	if (inode->i_size == 0)
> +	if (isize == 0)
>  		return 0;
>  
>  	/*
> @@ -1022,10 +1023,10 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  
>  	/* find the last page to defrag */
>  	if (range->start + range->len > range->start) {
> -		last_index = min_t(u64, inode->i_size - 1,
> +		last_index = min_t(u64, isize - 1,
>  			 range->start + range->len - 1) >> PAGE_CACHE_SHIFT;
>  	} else {
> -		last_index = (inode->i_size - 1) >> PAGE_CACHE_SHIFT;
> +		last_index = (isize - 1) >> PAGE_CACHE_SHIFT;
>  	}
>  
>  	if (newer_than) {
> -- 
> 1.7.3.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
