Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50295 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754246AbcITR5u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 13:57:50 -0400
Date: Tue, 20 Sep 2016 10:57:41 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: memset to avoid stale content in btree node block
Message-ID: <20160920175741.GA3319@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1473898977-29406-1-git-send-email-bo.li.liu@oracle.com>
 <20160920131636.GY16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160920131636.GY16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 03:16:36PM +0200, David Sterba wrote:
> On Wed, Sep 14, 2016 at 05:22:57PM -0700, Liu Bo wrote:
> > During updating btree, we could push items between sibling
> > nodes/leaves, for leaves data sections starts reversely from
> > the end of the block while for nodes we only have key pairs
> > which are stored one by one from the start of the block.
> > 
> > So we could do try to push key pairs from one node to the next
> > node right in the tree, and after that, we update the node's
> > nritems to reflect the correct end while leaving the stale
> > content in the node.  One may intentionally corrupt the fs
> > image and access the stale content by bumping the nritems and
> > causes various crashes.
> > 
> > This takes the in-memory @nritems as the correct one and
> > gets to memset the unused part of a btree node.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
> > ---
> >  fs/btrfs/extent_io.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index c2325c3..56c9dee 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -3732,6 +3732,17 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
> >  	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
> >  		bio_flags = EXTENT_BIO_TREE_LOG;
> >  
> > +	/* set btree node beyond nritems with 0 to avoid stale content */
> > +	if (btrfs_header_level(eb) > 0) {
> 
> We can do the same for leaves.

In theory, the problem also applies for leaves, but I haven't got a
reproducer for leaf case.

So I'll update a v2 with leaf memset, please review that part more
carefully :)

Thanks,

-liubo
