Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35421 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3F1RSK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 13:18:10 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 317C19A06B7
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 11:18:10 -0600 (MDT)
Date: Fri, 28 Jun 2013 13:18:07 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: make the chunk allocator completely tree lockless
Message-ID: <20130628171807.GZ4288@localhost.localdomain>
References: <1372354038-2111-1-git-send-email-jbacik@fusionio.com>
 <20130627213320.GG10265@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130627213320.GG10265@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 27, 2013 at 02:33:20PM -0700, Zach Brown wrote:
> Reviewing as requested!  It certainly looks reasonable, but I don't have
> enough history with the code to really say much more than that.
> 
> Some questions:
> 
> > @@ -8423,6 +8432,10 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
> >  					sizeof(item));
> >  		if (ret)
> >  			btrfs_abort_transaction(trans, extent_root, ret);
> > +		ret = btrfs_finish_chunk_alloc(trans, extent_root,
> > +					       key.objectid, key.offset);
> 
> Would this moved call site need to worry about the chunk mutex at all?
> 

No, we're just using the chunk_mutex to serialize the allocations.  So since all
the stuff we care about is in memory or in the commit root we only need to have
the chunk_mutex around the actuall allocation part.

> > +		if (ret)
> > +			btrfs_abort_transaction(trans, root, ret);
> 
> Did you mean to abort the root here, not the extent_root like the one
> above?

I'm not sure it matters but I'll change it for consistency sake.

> 
> > +static int contains_pending_extent(struct btrfs_trans_handle *trans,
> > +				   struct btrfs_device *device,
> > +				   u64 *start, u64 len)
> > +{
> > +	struct extent_map *em;
> > +	int ret = 0;
> > +
> > +	list_for_each_entry(em, &trans->transaction->pending_chunks, list) {
> > +		struct map_lookup *map;
> > +		int i;
> > +
> > +		map = (struct map_lookup *)em->bdev;
> > +		for (i = 0; i < map->num_stripes; i++) {
> > +			if (map->stripes[i].dev != device)
> > +				continue;
> > +			if (map->stripes[i].physical >= *start + len ||
> > +			    map->stripes[i].physical + em->orig_block_len <=
> > +			    *start)
> > +				continue;
> > +			*start = map->stripes[i].physical +
> > +				em->orig_block_len;
> > +			ret = 1;
> > +		}
> > +	}
> 
> Did you want a 'break;' there?  Is it trying to set *start to the last
> match rather than returning the first?
> 

We want the last, otherwise we'll set it to the end of the first extent we find,
go back and do all that searching again, come back here and just adjust it up
again if theres another allocation sitting there that butts up to the first
entry we found.

> > +		ret = btrfs_alloc_dev_extent(trans, device,
> > +					     chunk_root->root_key.objectid,
> > +					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
> > +					     chunk_offset, dev_offset,
> > +					     stripe_size);
> > +		if (ret)
> > +			goto out;
> 
> The old code tried to free up previous allocations when one failed, but
> it looks like this deferred alloc doesn't.  Do we care?
> 

So before we could back out of having a chunk allocation at that point because
we hadn't let go of the chunk mutex and nobody had been able to allocate from
that chunk.  With the new code if we fail here we have to abort because we could
have made allocations in our new chunk.  It is kind of a drawback, but really if
this part failed before it was likely because of -EIO which we would likely hit
somewhere else in the stack and end up aborted anyway, so no big loss I think?

> > -	index = 0;
> > -	while (index < map->num_stripes) {
> > -		index++;
> 
> > +	for (i = 0; i < map->num_stripes; i++) {
> 
> *hugs*
> 

Thanks for the review!  I'll just fix up that one inconsistency and then commit
and push to btrfs-next instead of reposting.  Thanks,

Josef
