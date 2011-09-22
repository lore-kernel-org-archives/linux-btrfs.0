From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs: fix memory leak in btrfs_defrag_file
Date: Thu, 22 Sep 2011 12:36:48 +0200
Message-ID: <20110922103648.GU22205@twin.jikos.cz>
References: <201109011633.57877.diegocg@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201109011633.57877.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 01, 2011 at 04:33:57PM +0200, Diego Calleja wrote:
> kmemleak found this:
> unreferenced object 0xffff8801b64af968 (size 512):
>   comm "btrfs-cleaner", pid 3317, jiffies 4306810886 (age 903.272s)
>   hex dump (first 32 bytes):
>     00 82 01 07 00 ea ff ff c0 83 01 07 00 ea ff ff  ................
>     80 82 01 07 00 ea ff ff c0 87 01 07 00 ea ff ff  ................
>   backtrace:
>     [<ffffffff816875cc>] kmemleak_alloc+0x5c/0xc0
>     [<ffffffff8114aec3>] kmem_cache_alloc_trace+0x163/0x240
>     [<ffffffff8127a290>] btrfs_defrag_file+0xf0/0xb20
>     [<ffffffff8125d9a5>] btrfs_run_defrag_inodes+0x165/0x210
>     [<ffffffff812479d7>] cleaner_kthread+0x177/0x190
>     [<ffffffff81075c7d>] kthread+0x8d/0xa0
>     [<ffffffff816af5f4>] kernel_thread_helper+0x4/0x10
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> "pages" is not always freed. Fix it removing the unnecesary additional return.
> 
> Signed-off-by: Diego Calleja <diegocg@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> 
> ---
>  fs/btrfs/ioctl.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Index: linux/fs/btrfs/ioctl.c
> ===================================================================
> --- linux.orig/fs/btrfs/ioctl.c
> +++ linux/fs/btrfs/ioctl.c
> @@ -1130,17 +1130,15 @@ int btrfs_defrag_file(struct inode *inod
>  	disk_super = &root->fs_info->super_copy;
>  	features = btrfs_super_incompat_flags(disk_super);
>  	if (range->compress_type == BTRFS_COMPRESS_LZO) {
>  		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
>  		btrfs_set_super_incompat_flags(disk_super, features);
>  	}
>  
> -	if (!file)
> -		kfree(ra);
> -	return defrag_count;
> +	ret = defrag_count;
>  
>  out_ra:
>  	if (!file)
>  		kfree(ra);
>  	kfree(pages);
>  	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
