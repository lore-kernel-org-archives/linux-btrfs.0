Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27786 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034290AbcIZSCW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 14:02:22 -0400
Date: Mon, 26 Sep 2016 11:07:35 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: memset to avoid stale content in btree leaf
Message-ID: <20160926180735.GA23858@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1474663484-23245-1-git-send-email-bo.li.liu@oracle.com>
 <20160926165444.GD16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160926165444.GD16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2016 at 06:54:44PM +0200, David Sterba wrote:
> On Fri, Sep 23, 2016 at 01:44:44PM -0700, Liu Bo wrote:
> > @@ -3732,15 +3734,21 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
> >  	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
> >  		bio_flags = EXTENT_BIO_TREE_LOG;
> >  
> > -	/* set btree node beyond nritems with 0 to avoid stale content */
> > +	/* set btree blocks beyond nritems with 0 to avoid stale content. */
> > +	nritems = btrfs_header_nritems(eb);
> >  	if (btrfs_header_level(eb) > 0) {
> > -		u32 nritems;
> > -		unsigned long end;
> > -
> > -		nritems = btrfs_header_nritems(eb);
> >  		end = btrfs_node_key_ptr_offset(nritems);
> >  
> >  		memset_extent_buffer(eb, 0, end, eb->len - end);
> > +	} else {
> > +		/*
> > +		 * leaf:
> > +		 * header 0 1 2 .. N ... data_N .. data_2 data_1 data_0
> > +		 */
> > +		start = btrfs_item_nr_offset(nritems);
> 
> So, AFAICS this also works for empty root nodes (nritems == 0). It's
> hidden in leaf_data_end that actually looks at nritems and decides.
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

Yeah, you're right, case (nritems == 0) has already been taken care in this patch.

Thanks a lot for reviewing it.

Thanks,

-liubo
> 
> > +		end = btrfs_leaf_data(eb) +
> > +		      leaf_data_end(fs_info->tree_root, eb);
> > +		memset_extent_buffer(eb, 0, start, end - start);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
