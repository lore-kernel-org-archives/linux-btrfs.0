Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40634 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab3DIMEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2013 08:04:33 -0400
Received: by mail-pd0-f181.google.com with SMTP id y10so3766486pdj.12
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Apr 2013 05:04:32 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: fix bad extent logging
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1365195375-2911-1-git-send-email-jbacik@fusionio.com>
Date: Tue, 9 Apr 2013 20:04:27 +0800
Cc: <linux-btrfs@vger.kernel.org>
Message-Id: <99952820-CF63-4765-84E2-91A0F8F8B60D@gmail.com>
References: <1365195375-2911-1-git-send-email-jbacik@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

> A user sent me a btrfs-image of a file system that was panicing on mount during
> the log recovery.  I had originally thought these problems were from a bug in
> the free space cache code, but that was just a symptom of the problem.  The
> problem is if your application does something like this
> 
> [prealloc][prealloc][prealloc]
> 
> the internal extent maps will merge those all together into one extent map, even
> though on disk they are 3 separate extents.  So if you go to write into one of
> these ranges the extent map will be right since we use the physical extent when
> doing the write, but when we log the extents they will use the wrong sizes for
> the remainder prealloc space.  If this doesn't happen to trip up the free space
> cache (which it won't in a lot of cases) then you will get bogus entries in your
> extent tree which will screw stuff up later.  The data and such will still work,
> but everything else is broken.  This patch fixes this by not allowing extents
> that are on the modified list to be merged.  This has the side effect that we
> are no longer adding everything to the modified list all the time, which means
> we now have to call btrfs_drop_extents every time we log an extent into the
> tree.  So this allows me to drop all this speciality code I was using to get
> around calling btrfs_drop_extents.  With this patch the testcase I've created no
> longer creates a bogus file system after replaying the log.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>  

<snip>
> 			while (1) {
> 				write_lock(&em_tree->lock);
> -				err = add_extent_mapping(em_tree, hole_em);
> -				if (!err)
> -					list_move(&hole_em->list,
> -						  &em_tree->modified_extents);
> +				err = add_extent_mapping(em_tree, hole_em, 1);
> 				write_unlock(&em_tree->lock);
> 				if (err != -EEXIST)
> 					break;
> @@ -5989,7 +5977,8 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
> 		em->block_start += start_diff;
> 		em->block_len -= start_diff;
> 	}
> -	return add_extent_mapping(em_tree, em);
> +	printk(KERN_ERR "merging here for %Lu\n", em->orig_start);

	How about using something like pr_debug here.
	When i tested btrfs-next, i found it hit too much.


Thanks,
Wang
	
> +	return add_extent_mapping(em_tree, em, 0);
> }
> 
> static noinline int uncompress_inline(struct btrfs_path *path,
> @@ -6283,7 +6272,7 @@ insert:
> 
> 	err = 0;
> 	write_lock(&em_tree->lock);
> -	ret = add_extent_mapping(em_tree, em);
> +	ret = add_extent_mapping(em_tree, em, 0);
> 	/* it is possible that someone inserted the extent into the tree
> 	 * while we had the lock dropped.  It is also possible that
> 	 * an overlapping map exists in the tree
> @@ -6706,10 +6695,7 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
> 		btrfs_drop_extent_cache(inode, em->start,
> 				em->start + em->len - 1, 0);
> 		write_lock(&em_tree->lock);
> -		ret = add_extent_mapping(em_tree, em);
> -		if (!ret)
> -			list_move(&em->list,
> -				  &em_tree->modified_extents);
> +		ret = add_extent_mapping(em_tree, em, 1);
> 		write_unlock(&em_tree->lock);
> 	} while (ret == -EEXIST);

<snip>

