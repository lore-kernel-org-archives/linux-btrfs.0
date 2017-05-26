Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41163 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937249AbdEZTx7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 15:53:59 -0400
Date: Fri, 26 May 2017 12:52:06 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] Btrfs: remove BUG() in print_extent_item
Message-ID: <20170526195206.GB7859@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-5-bo.li.liu@oracle.com>
 <20170526181822.GL30842@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526181822.GL30842@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 08:18:22PM +0200, David Sterba wrote:
> On Thu, May 25, 2017 at 06:26:29PM -0600, Liu Bo wrote:
> > btrfs_print_leaf() is used in btrfs_get_extent_inline_ref_type, so
> > here we really want to print the invalid value of ref type instead of
> > causing a kernel panic.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/print-tree.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
> > index fcae61e..4448be6 100644
> > --- a/fs/btrfs/print-tree.c
> > +++ b/fs/btrfs/print-tree.c
> > @@ -63,6 +63,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
> >  	u32 item_size = btrfs_item_size_nr(eb, slot);
> >  	u64 flags;
> >  	u64 offset;
> > +	int is_data;
> >  
> >  	if (item_size < sizeof(*ei)) {
> >  #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
> > @@ -98,6 +99,8 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
> >  		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
> >  	}
> >  
> > +	is_data = !!(flags & BTRFS_EXTENT_FLAG_DATA);
> > +
> >  	ptr = (unsigned long)iref;
> >  	end = (unsigned long)ei + item_size;
> >  	while (ptr < end) {
> > @@ -121,7 +124,10 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
> >  			       offset, btrfs_shared_data_ref_count(eb, sref));
> >  			break;
> >  		default:
> > -			BUG();
> > +			btrfs_err(eb->fs_info,
> > +				  "extent %llu has invalid ref type %d\n",
> > +				  eb->start, type);
> > +			return;
> 
> I don't see is_data used anywhere, also not in the followup patches.
> Please use a bool type in case it's valid here.
>

Good catch, I should remove is_data since it uses the original
btrfs_extent_inline_ref_type directly, will update it.

thanks,
-liubo


> >  		}
> >  		ptr += btrfs_extent_inline_ref_size(type);
> >  	}
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
