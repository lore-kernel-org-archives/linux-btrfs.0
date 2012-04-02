From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: do not mount when we have a sectorsize larger than PAGE_SIZE
Date: Mon, 2 Apr 2012 14:17:24 +0200
Message-ID: <20120402121724.GD14256@twin.jikos.cz>
References: <1333366098-32341-1-git-send-email-liubo2009@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333366098-32341-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2012 at 07:28:18PM +0800, Liu Bo wrote:
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2104,6 +2104,14 @@ int open_ctree(struct super_block *sb,
>  		err = -EINVAL;
>  		goto fail_alloc;
>  	}
> +	if (btrfs_super_sectorsize(disk_super) > PAGE_CACHE_SIZE) {
> +		printk(KERN_ERR "BTRFS: couldn't mount because sectorsize(%d)"
> +		       " was larger than PAGE_SIZE(%lu)\n",

%llu

> +		       btrfs_super_sectorsize(disk_super),
> +		       (unsigned long long)PAGE_CACHE_SIZE);
> +		err = -EINVAL;
> +		goto fail_alloc;
> +	}
>  
>  	features = btrfs_super_incompat_flags(disk_super);
>  	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;

We have the opposite check a few lines below

2257         if (sectorsize < PAGE_SIZE) {
2258                 printk(KERN_WARNING "btrfs: Incompatible sector size "
2259                        "found on %s\n", sb->s_id);
2260                 goto fail_sb_buffer;
2261         }
2262

so sectorsize must be equal to PAGE_SIZE always and one check can catch
both cases.


david
