Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:59035 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbbGFKt0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 06:49:26 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 6 Jul 2015 16:19:22 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id CD3BC1258056
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jul 2015 16:22:05 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t66AnERU6095268
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jul 2015 16:19:15 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t669edCr028155
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jul 2015 15:10:41 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: bo.li.liu@oracle.com
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 12/21] Btrfs: subpagesize-blocksize: Search for all ordered extents that could span across a page.
Date: Mon, 06 Jul 2015 16:19:09 +0530
Message-ID: <8890972.reN3iamvyz@localhost.localdomain>
In-Reply-To: <20150706025900.GA6105@localhost.localdomain>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com> <1662899.ajn0RKgkkt@localhost.localdomain> <20150706025900.GA6105@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 06 Jul 2015 11:17:38 Liu Bo wrote:
> On Fri, Jul 03, 2015 at 03:38:00PM +0530, Chandan Rajendra wrote:
> > On Wednesday 01 Jul 2015 22:47:10 Liu Bo wrote:
> > > On Mon, Jun 01, 2015 at 08:52:47PM +0530, Chandan Rajendra wrote:
> > > > In subpagesize-blocksize scenario it is not sufficient to search using
> > > > the
> > > > first byte of the page to make sure that there are no ordered extents
> > > > present across the page. Fix this.
> > > > 
> > > > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > > > ---
> > > > 
> > > >  fs/btrfs/extent_io.c | 3 ++-
> > > >  fs/btrfs/inode.c     | 4 ++--
> > > >  2 files changed, 4 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > > > index 14b4e05..0b017e1 100644
> > > > --- a/fs/btrfs/extent_io.c
> > > > +++ b/fs/btrfs/extent_io.c
> > > > @@ -3244,7 +3244,8 @@ static int __extent_read_full_page(struct
> > > > extent_io_tree *tree,>
> > > > 
> > > >  	while (1) {
> > > >  	
> > > >  		lock_extent(tree, start, end);
> > > > 
> > > > -		ordered = btrfs_lookup_ordered_extent(inode, start);
> > > > +		ordered = btrfs_lookup_ordered_range(inode, start,
> > > > +						PAGE_CACHE_SIZE);
> > > 
> > > A minor suggestion, it'd be better to include the new prototype in the
> > > same patch, which will be benefit to later cherry-picking or reverting.
> > 
> > Liu, The definition of btrfs_lookup_ordered_range() is already part of
> > the mainline kernel.
> 
> Ah, I didn't recognize the difference of btrfs_lookup_ordered_extent and
> btrfs_lookup_ordered_range, sorry.
> 
> > > >  		if (!ordered)
> > > >  		
> > > >  			break;
> > > >  		
> > > >  		unlock_extent(tree, start, end);
> > > > 
> > > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > > index e9bab73..8b4aaed 100644
> > > > --- a/fs/btrfs/inode.c
> > > > +++ b/fs/btrfs/inode.c
> > > > 
> > > > @@ -1976,7 +1976,7 @@ again:
> > > >  	if (PagePrivate2(page))
> > > >  	
> > > >  		goto out;
> > > > 
> > > > -	ordered = btrfs_lookup_ordered_extent(inode, page_start);
> > > > +	ordered = btrfs_lookup_ordered_range(inode, page_start,
> > > > PAGE_CACHE_SIZE);
> > > > 
> > > >  	if (ordered) {
> > > >  	
> > > >  		unlock_extent_cached(&BTRFS_I(inode)->io_tree, 
page_start,
> > > >  		
> > > >  				     page_end, &cached_state, 
GFP_NOFS);
> > > > 
> > > > @@ -8513,7 +8513,7 @@ static void btrfs_invalidatepage(struct page
> > > > *page,
> > > > unsigned int offset,>
> > > > 
> > > >  	if (!inode_evicting)
> > > >  	
> > > >  		lock_extent_bits(tree, page_start, page_end, 0,
> > 
> > &cached_state);
> > 
> > > > -	ordered = btrfs_lookup_ordered_extent(inode, page_start);
> > > > +	ordered = btrfs_lookup_ordered_range(inode, page_start,
> > > > PAGE_CACHE_SIZE);
> 
> It's possible for a page to hold two (or more) ordered extents here, a
> while loop is necessary to ensure that every ordered extent is processed
> properly.
>
Liu, Sorry, I had introduced the loop in the patch
"[RFC PATCH V11 14/21] Btrfs: subpagesize-blocksize: Explicitly Track I/O
status of blocks of an ordered extent". I will pull the loop to this patch for
the next version of that patchset. 

> Thanks,
> 
> -liubo
> 
> > > >  	if (ordered) {
> > > >  	
> > > >  		/*
> > > >  		
> > > >  		 * IO on this page will never be started, so we need

-- 
chandan

