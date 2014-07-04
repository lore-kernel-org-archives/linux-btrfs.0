Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41692 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaGDOCY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 10:02:24 -0400
Date: Fri, 4 Jul 2014 07:02:11 -0700
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <20140704140211.GG26932@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404467946-4429-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <53B645D4.1060003@cn.fujitsu.com>
Subject: Re: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 02:12:36PM +0800, Wang Shilong wrote:
> OK,  i found there is a mirror num recorded  in struct
> @extent_buffer, so it is not diffcult
> to locate the real physical address that this corrupt metadata block
> locates.
> 
> But another question is that if such problems happen, it should also
> help little, because
> usually other mirrors maybe have the same errors...
 
I understand, although at least knowing which filesystem has the
problem, whether it got auto corrected, or not, is good.

Imagine if I get 500 of those errors in syslog. Even if btrfs can auto
correct them, as an admin, I would want to know this because it means
something likely bad happened and I may want to inspect that filesystem
for damage, or the hardware for faults.
So the extra output is very useful, thank you.

> Anyway, let me see if there are any other output even dose not
> output btrfs specific info.

Thank you very much.

On Fri, Jul 04, 2014 at 05:59:06PM +0800, Wang Shilong wrote:
> Marc argued that if there are several btrfs filesystems mounted,
> while users even don't know which filesystem hit the corrupted
> errors something like generation verification failure.
> 
> Since @extent_buffer structure has a member @fs_info, let's output
> btrfs device info.

I don't know the btrfs code much, but looking at the patch, it looks
good, thank you for that.

Marc
 
> Reported-by: Marc MERLIN <marc@merlins.org>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
> Tell me if missed anything here...
> ---
>  fs/btrfs/disk-io.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 08e65e9..bd52ca0 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -351,9 +351,9 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>  		ret = 0;
>  		goto out;
>  	}
> -	printk_ratelimited("parent transid verify failed on %llu wanted %llu "
> -		       "found %llu\n",
> -		       eb->start, parent_transid, btrfs_header_generation(eb));
> +	printk_ratelimited("BTRFS (device %s): parent transid verify failed on %llu wanted %llu found %llu\n",
> +			eb->fs_info->sb->s_id, eb->start,
> +			parent_transid, btrfs_header_generation(eb));
>  	ret = 1;
>  
>  	/*
> @@ -617,15 +617,15 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  
>  	found_start = btrfs_header_bytenr(eb);
>  	if (found_start != eb->start) {
> -		printk_ratelimited(KERN_INFO "BTRFS: bad tree block start "
> +		printk_ratelimited(KERN_INFO "BTRFS (device %s): bad tree block start "
>  			       "%llu %llu\n",
> -			       found_start, eb->start);
> +			       eb->fs_info->sb->s_id, found_start, eb->start);
>  		ret = -EIO;
>  		goto err;
>  	}
>  	if (check_tree_block_fsid(root, eb)) {
> -		printk_ratelimited(KERN_INFO "BTRFS: bad fsid on block %llu\n",
> -			       eb->start);
> +		printk_ratelimited(KERN_INFO "BTRFS (device %s): bad fsid on block %llu\n",
> +			       eb->fs_info->sb->s_id, eb->start);
>  		ret = -EIO;
>  		goto err;
>  	}
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
