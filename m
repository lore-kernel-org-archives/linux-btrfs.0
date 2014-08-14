Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54239 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaHNW2T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 18:28:19 -0400
Date: Thu, 14 Aug 2014 15:28:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org,
        jbacik@fb.com, takeuchi_satoru@jp.fujitsu.com
Subject: Re: btrfs-zero-log fails, can't mount FS
Message-ID: <20140814222818.GL27531@merlins.org>
References: <20140814160902.GA25370@merlins.org> <53ECE953.70009@gmail.com> <20140814172743.GC27531@merlins.org> <53ED321D.1040702@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53ED321D.1040702@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 06:03:09PM -0400, Chris Mason wrote:
> At least I'll get to buy you a beer this time.
 
Haha, no worries :)

> Lets just see if the log root is the only problem.  This will get you
> through btrfs-zero-log

It sure did, thanks much for the patch.
It output absolutely nothing instead of the wanted got lines it usually
spits out, and the filesystem mounted without problems.

I'll add this better btrfs-zero-log in my initrd for next time.

Would it be ok to modify btrfs-zero-log to simply remove the return -EIO
line?

Does it really matter whether it can setup the log root tree when it's being
asked to nuke the log?

Thanks,
Marc

> diff --git a/disk-io.c b/disk-io.c
> index 8db0335..d9a8e19 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -911,13 +911,13 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
>  			return -EIO;
>  	}
>  	fs_info->csum_root->track_dirty = 1;
> -
> +#if 0
>  	ret = find_and_setup_log_root(root, fs_info, sb);
>  	if (ret) {
>  		printk("Couldn't setup log root tree\n");
>  		return -EIO;
>  	}
> -
> +#endif
>  	fs_info->generation = generation;
>  	fs_info->last_trans_committed = generation;
>  	if (extent_buffer_uptodate(fs_info->extent_root->node) &&
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
