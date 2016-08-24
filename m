Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42461 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbcHXA0R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 20:26:17 -0400
Date: Tue, 23 Aug 2016 17:26:07 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: check btree node's nritems
Message-ID: <20160824002607.GB2613@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1470254248-24041-1-git-send-email-bo.li.liu@oracle.com>
 <20160816165000.GR30795@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160816165000.GR30795@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 16, 2016 at 06:50:00PM +0200, David Sterba wrote:
> On Wed, Aug 03, 2016 at 12:57:28PM -0700, Liu Bo wrote:
> > When btree node (level = 1) has nritems which equals to zero,
> > we can end up with panic due to insert_ptr()'s
> > 
> > BUG_ON(slot > nritems);
> > 
> > where slot is 1 and nritems is 0, as copy_for_split() calls
> > insert_ptr(.., path->slots[1] + 1, ...);
> > 
> > A invalid value results in the whole mess, this adds the check
> > for btree's node nritems so that we stop reading block when
> > when something is wrong.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/disk-io.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 37d1780..a5a22be 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -612,6 +612,20 @@ static noinline int check_leaf(struct btrfs_root *root,
> >  	return 0;
> >  }
> >  
> > +static noinline int check_node(struct btrfs_root *root,
> > +			       struct extent_buffer *node)
> > +{
> > +	unsigned long nr = btrfs_header_nritems(node);
> > +
> > +	if (nr <= 0 || nr >= BTRFS_NODEPTRS_PER_BLOCK(root)) {
> 
> nr is unsigned, so it's just  "== 0"
> 
> and the BTRFS_NODEPTRS_PER_BLOCK value is inclusive, which should
> explain Holger's findings.
> 
> 493 * sizeof (btrfs_key_ptr) + sizeof (btrfs_header) + slack = nodesize
> 
> 493 * 33 + 101 + slack = 16k (the closest value)
> 
> gives slack = 14 (smaller than sizeof (btrfs_key_ptr))

Oh, right, I made a mistake when getting the assumption from insert_ptr(), it should be nr > BTRFS_NODEPTRS_PER_BLOCK(root).

Thanks,

-liubo
