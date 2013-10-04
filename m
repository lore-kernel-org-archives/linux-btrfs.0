Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:46899 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3JDWAa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Oct 2013 18:00:30 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Fri, 4 Oct 2013 16:00:29 -0600
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 5B24C6E8047
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Oct 2013 18:00:26 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22036.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r94M0RvV7405912
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Oct 2013 22:00:27 GMT
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r94M0Qtu029518
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Oct 2013 18:00:27 -0400
Subject: Re: [PATCH] Btrfs: Simplify the logic in alloc_extent_buffer() for
 existing extent buffer case
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: Zach Brown <zab@redhat.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
In-Reply-To: <20131004213814.GC25712@lenny.home.zabbo.net>
References: <1380916529.22521.122.camel@chandra-dt.ibm.com>
	 <20131004213814.GC25712@lenny.home.zabbo.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Oct 2013 17:00:26 -0500
Message-ID: <1380924026.22521.141.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2013-10-04 at 14:38 -0700, Zach Brown wrote:

Thanks for the review Zach.

> On Fri, Oct 04, 2013 at 02:55:29PM -0500, Chandra Seetharaman wrote:
> > alloc_extent_buffer() uses radix_tree_lookup() when radix_tree_insert() fails
> > with EEXIST. That part of the code is very similar to the code in
> > find_extent_buffer(). This patch replaces radix_tree_lookup() and surrounding
> > code in alloc_extent_buffer() with find_extent_buffer().
> > 
> > While at it, this patch also changes the other usage of radix_tree_lookup() in
> > alloc_extent_buffer() with find_extent_buffer() to reduce redundancy.
> > 
> > Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index c09a40d..50345fb 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -4451,6 +4451,23 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb)
> >  	}
> >  }
> >  
> > +struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
> > +					 u64 start, unsigned long len)
> 
> len isn't used.

Thought about removing the unused argument. But didn't know all the
history behind why it was there in the first place. So, didn't bother
it.

You think I should remove it.
 
> 
> > @@ -4530,24 +4543,17 @@ again:
> >  
> >  	spin_lock(&tree->buffer_lock);
> >  	ret = radix_tree_insert(&tree->buffer, start >> PAGE_CACHE_SHIFT, eb);
> > +	spin_unlock(&tree->buffer_lock);
> > +	radix_tree_preload_end();
> >  	if (ret == -EEXIST) {
> > -		exists = radix_tree_lookup(&tree->buffer,
> > -						start >> PAGE_CACHE_SHIFT);
> > -		if (!atomic_inc_not_zero(&exists->refs)) {
> > -			spin_unlock(&tree->buffer_lock);
> > -			radix_tree_preload_end();
> > -			exists = NULL;
> > +		exists = find_extent_buffer(tree, start, len);
> 
> Is it safe to do the lookup under rcu instead of under the spinlock?

Yes. it is fine.

eb->refs is what is used to make sure the buffer remains in the tree. eb
will be removed from the tree only if eb->refs is zero.
find_extent_buffer() will return NULL if refs is already zero. 

Besides, prior to this patch, there are other two instances of
radix_tree_lookup() (one in find_extent_buffer() and another in
alloc_extent_buffer()) which uses only rcu protection. 

> The commit message should mention the difference.

How does this commit message sound:
---------------
alloc_extent_buffer() uses radix_tree_lookup() when radix_tree_insert() fails
with EEXIST. That part of the code is very similar to the code in
find_extent_buffer(). This patch replaces radix_tree_lookup() and
surrounding code in alloc_extent_buffer() with find_extent_buffer().

Note that radix_tree_lookup() does not need to be protected by
tree->buffer_lock. It is protected by eb->refs.

While at it, this patch also changes the other usage of
radix_tree_lookup() in alloc_extent_buffer() with find_extent_buffer()
to reduce redundancy.
---------------

> 
> - z
> 


