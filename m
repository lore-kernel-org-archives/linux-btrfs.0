Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27749 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932129AbcIVBUu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 21:20:50 -0400
Date: Wed, 21 Sep 2016 18:20:40 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: memset to avoid stale content in btree node block
Message-ID: <20160922012040.GA26612@dhcp-whq-twvpn-1-vpnpool-10-159-144-8.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1473898977-29406-1-git-send-email-bo.li.liu@oracle.com>
 <20160920131636.GY16983@twin.jikos.cz>
 <20160920175741.GA3319@localhost.localdomain>
 <20160921080426.GA16983@suse.cz>
 <9a7a60cf-b856-3c03-7842-a4d232118ca2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9a7a60cf-b856-3c03-7842-a4d232118ca2@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 09:09:32AM -0400, Chris Mason wrote:
> 
> 
> On 09/21/2016 04:04 AM, David Sterba wrote:
> > On Tue, Sep 20, 2016 at 10:57:41AM -0700, Liu Bo wrote:
> > > On Tue, Sep 20, 2016 at 03:16:36PM +0200, David Sterba wrote:
> > > > On Wed, Sep 14, 2016 at 05:22:57PM -0700, Liu Bo wrote:
> > > > > During updating btree, we could push items between sibling
> > > > > nodes/leaves, for leaves data sections starts reversely from
> > > > > the end of the block while for nodes we only have key pairs
> > > > > which are stored one by one from the start of the block.
> > > > > 
> > > > > So we could do try to push key pairs from one node to the next
> > > > > node right in the tree, and after that, we update the node's
> > > > > nritems to reflect the correct end while leaving the stale
> > > > > content in the node.  One may intentionally corrupt the fs
> > > > > image and access the stale content by bumping the nritems and
> > > > > causes various crashes.
> > > > > 
> > > > > This takes the in-memory @nritems as the correct one and
> > > > > gets to memset the unused part of a btree node.
> > > > > 
> > > > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > > 
> > > > Reviewed-by: David Sterba <dsterba@suse.com>
> > > > 
> > > > > ---
> > > > >  fs/btrfs/extent_io.c | 11 +++++++++++
> > > > >  1 file changed, 11 insertions(+)
> > > > > 
> > > > > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > > > > index c2325c3..56c9dee 100644
> > > > > --- a/fs/btrfs/extent_io.c
> > > > > +++ b/fs/btrfs/extent_io.c
> > > > > @@ -3732,6 +3732,17 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
> > > > >  	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
> > > > >  		bio_flags = EXTENT_BIO_TREE_LOG;
> > > > > 
> > > > > +	/* set btree node beyond nritems with 0 to avoid stale content */
> > > > > +	if (btrfs_header_level(eb) > 0) {
> > > > 
> > > > We can do the same for leaves.
> > > 
> > > In theory, the problem also applies for leaves, but I haven't got a
> > > reproducer for leaf case.
> > > 
> > > So I'll update a v2 with leaf memset, please review that part more
> > > carefully :)
> > 
> > You can keep it a separate patch, this one is fine. I didn't expect to
> > reproduce a crash with a bogus nritems in a leaf but rather apply the
> > same on a leaf buffer. The magic formula is (please verify)
> > 
> > start = nr * sizeof(struct btrfs_disk_key);
> > end = nr ? btrfs_item_offset(eb, btrfs_item_nr(nr - 1)) : eb->len;
> > 
> 
> This is the start/end of the memset for the leaves?  Doesn't look right,
> since leaves looks like this:
> 
> item headers 0,1,2 .. N  -> [ empty space ] <- item data N, ... 2, 1, 0
> 
> The empty space is from the end of header N to the start of data N.

Right, we've already got a good helper "leaf_data_end".

Thanks,

-liubo
