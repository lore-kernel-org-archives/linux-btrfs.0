Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([125.16.236.7]:44104 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbcD0FY2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 01:24:28 -0400
Received: from localhost
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 27 Apr 2016 10:54:25 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay08.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3R5OMD427918416
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 10:54:22 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3R5OJRp003026
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 10:54:21 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com,
        chandan@mykolab.com, Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH V18 01/18] Btrfs: subpage-blocksize: Fix whole page read.
Date: Wed, 27 Apr 2016 10:54:13 +0530
Message-ID: <2431208.c5R5KJEcxa@localhost.localdomain>
In-Reply-To: <63a690f0-20c4-f816-d9ff-0550306a97a1@fb.com>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com> <1461677237-7703-2-git-send-email-chandan@linux.vnet.ibm.com> <63a690f0-20c4-f816-d9ff-0550306a97a1@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 26 Apr 2016 11:51:22 Josef Bacik wrote:
> > +int set_page_extent_mapped(struct page *page)
> > 
> >  {
> > 
> > +	struct btrfs_page_private *pg_private;
> > +
> > 
> >  	if (!PagePrivate(page)) {
> > 
> > +		pg_private = kzalloc(sizeof(*pg_private), GFP_NOFS);
> > +		if (!pg_private)
> > +			return -ENOMEM;
> 
> So I would like to avoid the per-page allocation in the case that
> sectorsize == pagesize.  Also this is going to be pretty heavily used,
> so a separate slab should be used.

Ok. I will revise this patch and other dependent patches to determine the
block states (dirty, uptodate, etc) from either page flags (for sectorsize ==
pagesize) or from the per-page bitmap (for sectorsize < pagesize).

> 
> In fact, couldn't we just use the extent io tree to deal with this?  It
> would be kind of heavy handed to have to look up in the io tree for
> every sub page range I suppose, but we could probably avoid doing it in
> most cases and only in the case that we know we're only doing the sub
> page IO.  Thanks,
>

Commit 1edbb734b4e010974c41d2859d22a43d04f5f1cf (Btrfs: reduce CPU usage in
the extent_state tree) dropped support for tracking block states using extent
io tree citing performance reasons. The initial versions of subpage-blocksize
patchset did bring back this feature. However during Btrfs BoF meetup during
2015 Vault conference, we decided to go with the per-page bitmap to track the
block states.

-- 
chandan

