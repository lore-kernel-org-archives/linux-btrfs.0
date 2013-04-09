Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:39819 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3DINJT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2013 09:09:19 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1A7119A0692
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Apr 2013 07:09:19 -0600 (MDT)
Date: Tue, 9 Apr 2013 09:09:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Wang Shilong <wangshilong1991@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix bad extent logging
Message-ID: <20130409130916.GE2010@localhost.localdomain>
References: <1365195375-2911-1-git-send-email-jbacik@fusionio.com>
 <99952820-CF63-4765-84E2-91A0F8F8B60D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <99952820-CF63-4765-84E2-91A0F8F8B60D@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 09, 2013 at 06:04:27AM -0600, Wang Shilong wrote:
> Hello Josef,
> 
> > A user sent me a btrfs-image of a file system that was panicing on mount during
> > the log recovery.  I had originally thought these problems were from a bug in
> > the free space cache code, but that was just a symptom of the problem.  The
> > problem is if your application does something like this
> > 
> > [prealloc][prealloc][prealloc]
> > 
> > the internal extent maps will merge those all together into one extent map, even
> > though on disk they are 3 separate extents.  So if you go to write into one of
> > these ranges the extent map will be right since we use the physical extent when
> > doing the write, but when we log the extents they will use the wrong sizes for
> > the remainder prealloc space.  If this doesn't happen to trip up the free space
> > cache (which it won't in a lot of cases) then you will get bogus entries in your
> > extent tree which will screw stuff up later.  The data and such will still work,
> > but everything else is broken.  This patch fixes this by not allowing extents
> > that are on the modified list to be merged.  This has the side effect that we
> > are no longer adding everything to the modified list all the time, which means
> > we now have to call btrfs_drop_extents every time we log an extent into the
> > tree.  So this allows me to drop all this speciality code I was using to get
> > around calling btrfs_drop_extents.  With this patch the testcase I've created no
> > longer creates a bogus file system after replaying the log.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> >  
> 
> <snip>
> > 			while (1) {
> > 				write_lock(&em_tree->lock);
> > -				err = add_extent_mapping(em_tree, hole_em);
> > -				if (!err)
> > -					list_move(&hole_em->list,
> > -						  &em_tree->modified_extents);
> > +				err = add_extent_mapping(em_tree, hole_em, 1);
> > 				write_unlock(&em_tree->lock);
> > 				if (err != -EEXIST)
> > 					break;
> > @@ -5989,7 +5977,8 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
> > 		em->block_start += start_diff;
> > 		em->block_len -= start_diff;
> > 	}
> > -	return add_extent_mapping(em_tree, em);
> > +	printk(KERN_ERR "merging here for %Lu\n", em->orig_start);
> 
> 	How about using something like pr_debug here.
> 	When i tested btrfs-next, i found it hit too much.
>

That was just me forgetting to delete that printk, I'll fix it up, sorry,

Josef 
