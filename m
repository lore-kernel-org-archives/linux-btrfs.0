From: David Sterba <dave@jikos.cz>
Subject: Re: Crash in io_ctl_drop_pages after mount with csum errors
Date: Fri, 6 Jan 2012 16:55:18 +0100
Message-ID: <20120106155518.GR7322@twin.jikos.cz>
References: <20120105164919.GP7322@twin.jikos.cz> <4F06A027.3060908@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F06A027.3060908@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 06, 2012 at 03:17:59PM +0800, Li Zefan wrote:
> > [ 1499.946409] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> > [ 1499.946437] IP: [<ffffffffa0456dd7>] io_ctl_drop_pages+0x37/0x70 [btrfs]
> 
> 0x01 is weired, don't know how it occured. Nevertheless we need this fix:
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index ec23d43..81771ca 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -319,9 +319,11 @@ static void io_ctl_drop_pages(struct io_ctl *io_ctl)
>  	io_ctl_unmap_page(io_ctl);
>  
>  	for (i = 0; i < io_ctl->num_pages; i++) {
> -		ClearPageChecked(io_ctl->pages[i]);
> -		unlock_page(io_ctl->pages[i]);
> -		page_cache_release(io_ctl->pages[i]);
> +		if (io_ctl->pages[i]) {
> +			ClearPageChecked(io_ctl->pages[i]);
> +			unlock_page(io_ctl->pages[i]);
> +			page_cache_release(io_ctl->pages[i]);
> +		}
>  	}
>  }

mount did not crash with this fix, though anything that touches files
causes the crash. umount is still stuck the same way as before. I'll not
touch the partitions in case you have patches to test.


david
