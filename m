From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 3/4] Btrfs: fix wrong max_to_defrag in btrfs_defrag_file()
Date: Thu, 22 Sep 2011 12:42:04 +0200
Message-ID: <20110922104204.GV22205@twin.jikos.cz>
References: <4E608C29.10307@cn.fujitsu.com> <4E608C47.6060308@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E608C47.6060308@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2011 at 03:56:55PM +0800, Li Zefan wrote:
> It's off-by-one, and thus we may skip the last page while defragmenting.

Good catch.

> 
> An example case:
> 
>   # create /mnt/file with 2 4K file extents
>   # btrfs fi defrag /mnt/file
>   # sync
>   # filefrag /mnt/file
>   /mnt/file: 2 extents found
> 
> So it's not defragmented.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> ---
>  fs/btrfs/ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6f2b257..57aa5b7 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1046,7 +1046,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		i = range->start >> PAGE_CACHE_SHIFT;
>  	}
>  	if (!max_to_defrag)
> -		max_to_defrag = last_index - 1;
> +		max_to_defrag = last_index;
>  
>  	while (i <= last_index && defrag_count < max_to_defrag) {
>  		/*
> -- 
> 1.7.3.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
