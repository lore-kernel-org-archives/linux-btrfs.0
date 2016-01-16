Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20096 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161362AbcAPAyT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 19:54:19 -0500
Date: Fri, 15 Jan 2016 16:54:04 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: copy the certain type of item if min_type equals
 to max_type
Message-ID: <20160116005404.GA30062@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1452891148-7738-1-git-send-email-bo.li.liu@oracle.com>
 <20160115211841.GO422@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160115211841.GO422@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 15, 2016 at 09:18:41PM +0000, Hugo Mills wrote:
> On Fri, Jan 15, 2016 at 12:52:28PM -0800, Liu Bo wrote:
> > Some tools in btrfs-progs utilize ioctl 'BTRFS_IOC_TREE_SEARCH' and
> > ioctl 'BTRFS_IOC_TREE_SEARCH_V2' to look up metadata btree for what
> > they want, and several tools in fact only look for one certain type,
> > where they set a certain value for both 'sk->min_type' and 'sk->max_type'.
> > 
> > For example,
> > if we want to get the information of block groups, the current btrfs
> > searches extent_tree and returns not only block groups's items, but also
> > EXTENT_ITEM's items which could cost a large amount of user's buffer,
> > and tools then needs to read the buffer and spends several loops to
> > pick up what they want.
> > 
> > This lets the above two ioctl only return the certain type of items
> > that tools wants.
> 
>    This changes the semantics of the ioctl in a subtle and
> incompatible way.
> 
>    The keyspace used by btrfs trees can be viewed in two different and
> semantically incompatible ways. A key is an (Ob, T, Of) tuple. The
> first way of looking at this is as a one-dimensional keyspace, ordered
> lexically, as Ob+T+Of. This is what btrfs uses internally, and it's
> the way that the TREE_SEARCH ioctl works. A search simply returns a
> linear subset of the keys between the minimum and the maximum.
> 
>    The other view of the keyspace, which is more useful in some
> circumstances, is of a 3-dimensional keyspace, with the obvious
> lattice-like ordering, where K1 <= K2 iff Ob1 <= Ob2 and T1 <= T2 and
> Of1 <= Of2. This offers a very different interpretation of searching,
> where you are carving out a rectangular block of the 3-dimensional
> keyspace. This is the behaviour you're trying to impose on the search
> ioctl for a specific special case of search.
> 
>    I would argue that if you want to have the second form of search
> (and it's a useful one, certainly), you should implement an
> alternative search ioctl, rather than trying to retrofit that
> behaviour on something with very different, already well-defined
> semantics.
> 
>    In other words, this change makes for an awkward and confusing
> interface, and I think it shouldn't be done this way.

OK, I also realize that we can do sk->min_type++ in some places, where
we will get wrong results.

Please ignore it.

Thanks,

-liubo

> 
>    Hugo.
> 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/ioctl.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index da94138..f795423 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -1911,6 +1911,10 @@ static noinline int key_in_sk(struct btrfs_key *key,
> >  	struct btrfs_key test;
> >  	int ret;
> >  
> > +	/* All we want is this type of key. */
> > +	if (sk->min_type == sk->max_type && key->type != sk->min_type)
> > +		return 0;
> > +
> >  	test.objectid = sk->min_objectid;
> >  	test.type = sk->min_type;
> >  	test.offset = sk->min_offset;
> 
> -- 
> Hugo Mills             | "He's a nutcase, you know. There's no getting away
> hugo@... carfax.org.uk | from it -- he'll end up with a knighthood"
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                         Lexy, The League of Gentlemen


