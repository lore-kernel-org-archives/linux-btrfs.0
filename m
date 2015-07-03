Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55520 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbbGCKI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 06:08:58 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 3 Jul 2015 20:08:56 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 99B0F2BB0040
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2015 20:08:51 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t63A8he761603918
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jul 2015 20:08:51 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t63A8I48029267
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jul 2015 20:08:19 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: bo.li.liu@oracle.com
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 12/21] Btrfs: subpagesize-blocksize: Search for all ordered extents that could span across a page.
Date: Fri, 03 Jul 2015 15:38 +0530
Message-ID: <1662899.ajn0RKgkkt@localhost.localdomain>
In-Reply-To: <20150701144709.GE7847@localhost.localdomain>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com> <1433172176-8742-13-git-send-email-chandan@linux.vnet.ibm.com> <20150701144709.GE7847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 01 Jul 2015 22:47:10 Liu Bo wrote:
> On Mon, Jun 01, 2015 at 08:52:47PM +0530, Chandan Rajendra wrote:
> > In subpagesize-blocksize scenario it is not sufficient to search using the
> > first byte of the page to make sure that there are no ordered extents
> > present across the page. Fix this.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > 
> >  fs/btrfs/extent_io.c | 3 ++-
> >  fs/btrfs/inode.c     | 4 ++--
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 14b4e05..0b017e1 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -3244,7 +3244,8 @@ static int __extent_read_full_page(struct
> > extent_io_tree *tree,> 
> >  	while (1) {
> >  	
> >  		lock_extent(tree, start, end);
> > 
> > -		ordered = btrfs_lookup_ordered_extent(inode, start);
> > +		ordered = btrfs_lookup_ordered_range(inode, start,
> > +						PAGE_CACHE_SIZE);
> 
> A minor suggestion, it'd be better to include the new prototype in the
> same patch, which will be benefit to later cherry-picking or reverting.
> 

Liu, The definition of btrfs_lookup_ordered_range() is already part of
the mainline kernel.

> 
> >  		if (!ordered)
> >  		
> >  			break;
> >  		
> >  		unlock_extent(tree, start, end);
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index e9bab73..8b4aaed 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > 
> > @@ -1976,7 +1976,7 @@ again:
> >  	if (PagePrivate2(page))
> >  	
> >  		goto out;
> > 
> > -	ordered = btrfs_lookup_ordered_extent(inode, page_start);
> > +	ordered = btrfs_lookup_ordered_range(inode, page_start,
> > PAGE_CACHE_SIZE);
> > 
> >  	if (ordered) {
> >  	
> >  		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
> >  		
> >  				     page_end, &cached_state, GFP_NOFS);
> > 
> > @@ -8513,7 +8513,7 @@ static void btrfs_invalidatepage(struct page *page,
> > unsigned int offset,> 
> >  	if (!inode_evicting)
> >  	
> >  		lock_extent_bits(tree, page_start, page_end, 0, 
&cached_state);
> > 
> > -	ordered = btrfs_lookup_ordered_extent(inode, page_start);
> > +	ordered = btrfs_lookup_ordered_range(inode, page_start,
> > PAGE_CACHE_SIZE);
> > 
> >  	if (ordered) {
> >  	
> >  		/*
> >  		
> >  		 * IO on this page will never be started, so we need

-- 
chandan

