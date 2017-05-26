Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44353 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934332AbdEZUDE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 16:03:04 -0400
Date: Fri, 26 May 2017 13:01:11 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] Btrfs: remove BUG() in add_data_reference
Message-ID: <20170526200110.GC7859@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-6-bo.li.liu@oracle.com>
 <20170526182011.GM30842@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526182011.GM30842@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 08:20:11PM +0200, David Sterba wrote:
> On Thu, May 25, 2017 at 06:26:30PM -0600, Liu Bo wrote:
> > Now that we have a helper to report invalid value of extent inline ref
> > type, we need to quit gracefully instead of throwing out a kernel panic.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/relocation.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > index b043e200..8b984bd 100644
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -3774,7 +3774,10 @@ int add_data_references(struct reloc_control *rc,
> >  			ret = find_data_references(rc, extent_key,
> >  						   eb, dref, blocks);
> >  		} else {
> > -			BUG();
> > +			ret = -EINVAL;
> > +			WARN(1,
> > +			     "extent %llu has an invalid inline ref type\n",
> > +			     eb->start);
> 
> Would be good to extend the error message, also in the previous patch.
> Print inode number, root id and the (invalid ref) type.
> 

I've printed out the whole leaf's content in the helper
btrfs_get_extent_inline_ref_type if type is not valid, and it shows
the invalid ref type.

For inode number and root id, it's not available in this relocation
case, I'll check that in other patches.

thanks,
-liubo
> >  		}
> >  		if (ret) {
> >  			err = ret;
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
